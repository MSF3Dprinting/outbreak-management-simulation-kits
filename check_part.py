#!/usr/bin/env python3
"""check_part.py - checks an STL against the print rules of design_brief.md (section 5.4).

usage: python3 check_part.py PART.stl [MORE.stl ...] [--layer 0.2] [--tol 0.5]
                             [--expect LxWxH] [--min-area 0.05] [--engraved DEPTH]

For each file it prints
  * the header text of the STL (the colour-change note written at export)
  * the bounding box, size and extents; compared with --expect (0.1 mm) when given
  * the Z heights of upward-facing flat faces with their area - the band
    boundaries and tops - flagged when a height is not on a layer boundary
  * the lowest of those above the bed, which is the base thickness of a flat part
  * downward-facing faces steeper than 45 deg from vertical (a bridge is 90 deg)
    that are not on the bed plane, grouped by angle
With --engraved DEPTH, downward faces below that height are counted as the stepped roof of
text engraved into the bed face and reported separately: each step is one layer high, so the
cut is self-supporting, but the steps themselves are horizontal faces.
Exit status 1 when an overhang is found or the size differs from --expect.
Reads binary and ASCII STL. Needs numpy.
"""
import argparse
import struct
import sys

import numpy as np


def load_stl(path):
    """Return (triangles as [n, 3, 3] float64, header text)."""
    data = open(path, 'rb').read()
    if len(data) >= 84:
        n = struct.unpack('<I', data[80:84])[0]
        if 84 + 50 * n == len(data):
            rec = np.frombuffer(data[84:], dtype=np.dtype([('n', '<f4', (3,)), ('v', '<f4', (3, 3)), ('a', '<u2')]))
            header = data[:80].decode('latin-1').rstrip('\x00 ')
            return rec['v'].astype(np.float64), header
    text = data.decode('latin-1')
    lines = text.splitlines()
    verts = [tuple(float(t) for t in ln.split()[1:4]) for ln in lines if ln.strip().startswith('vertex')]
    if not verts or len(verts) % 3:
        raise ValueError('%s: not an STL file' % path)
    return np.array(verts).reshape(-1, 3, 3), lines[0].strip()


def check(path, layer, tol, expect, min_area, engraved=0.0, bed_eps=0.02):
    tris, header = load_stl(path)
    v0, v1, v2 = tris[:, 0], tris[:, 1], tris[:, 2]
    cr = np.cross(v1 - v0, v2 - v0)
    a2 = np.linalg.norm(cr, axis=1)
    keep = a2 > 1e-12                       # drop degenerate triangles
    tris, cr, a2 = tris[keep], cr[keep], a2[keep]
    nrm = cr / a2[:, None]
    area = a2 / 2
    if np.einsum('ij,ij->i', tris[:, 0], np.cross(tris[:, 1], tris[:, 2])).sum() < 0:
        nrm = -nrm                          # inverted winding: use outward normals anyway
        print('  WARNING: triangle winding is inverted (negative volume)')
    lo = tris.reshape(-1, 3).min(0)
    hi = tris.reshape(-1, 3).max(0)
    size = hi - lo
    ok = True

    print(path)
    print('  header: %s' % header)
    print('  size %.2f x %.2f x %.2f mm  (x %.2f..%.2f  y %.2f..%.2f  z %.2f..%.2f)  %d triangles'
          % (size[0], size[1], size[2], lo[0], hi[0], lo[1], hi[1], lo[2], hi[2], len(tris)))
    if expect:
        diff = [abs(s - e) for s, e in zip(size, expect)]
        if max(diff) <= 0.1:
            print('  size matches %s within 0.1 mm' % 'x'.join('%g' % e for e in expect))
        else:
            ok = False
            print('  SIZE DIFFERS from %s by %.2f / %.2f / %.2f mm'
                  % ('x'.join('%g' % e for e in expect), diff[0], diff[1], diff[2]))

    # upward-facing flat faces, grouped by height
    z = tris[:, :, 2]
    up = (nrm[:, 2] > 0.9999) & (np.ptp(z, axis=1) < 1e-3)
    flat = {}
    for zz, ar in zip(np.round(z[up].mean(1), 2), area[up]):
        flat[zz] = flat.get(zz, 0.0) + ar
    flat = {k: v for k, v in flat.items() if v >= min_area}
    print('  upward flat faces (band boundaries and tops):')
    for zz in sorted(flat):
        on_grid = abs(zz / layer - round(zz / layer)) < 0.01
        print('    z = %6.2f mm  %9.1f mm2%s' % (zz, flat[zz], '' if on_grid else '  NOT on a %g mm layer boundary' % layer))
    above = [zz for zz in flat if zz > bed_eps]
    if above:
        print('  lowest upward face above the bed: %.2f mm' % min(above))

    # downward-facing faces beyond 45 deg from vertical, off the bed plane
    ang = np.degrees(np.arcsin(np.clip(-nrm[:, 2], 0, 1)))
    on_bed = z.max(1) < lo[2] + bed_eps
    down = (nrm[:, 2] < 0) & (ang > 45 + tol) & ~on_bed
    eng = down & (z.max(1) <= engraved + 1e-6) if engraved > 0 else np.zeros(len(tris), bool)
    if eng.any():
        print('  engraving into the bed face: %d step faces, %.1f mm2 in total, below z = %.2f mm'
              % (eng.sum(), area[eng].sum(), engraved))
    bad = down & ~eng & (area >= min_area)
    tiny = (down & ~eng & (area < min_area)).sum()
    if tiny:
        print('  (%d overhanging faces under %g mm2 ignored: slivers below a nozzle footprint)' % (tiny, min_area))
    if not bad.any():
        print('  overhangs beyond %g deg from vertical off the bed plane: none' % 45)
    else:
        ok = False
        groups = {}
        for a, ar, zr in zip(np.round(ang[bad]), area[bad], z[bad]):
            g = groups.setdefault(a, [0, 0.0, 1e9, -1e9])
            g[0] += 1
            g[1] += ar
            g[2] = min(g[2], zr.min())
            g[3] = max(g[3], zr.max())
        print('  OVERHANGS beyond 45 deg from vertical: %d faces, %.1f mm2 in total'
              % (bad.sum(), area[bad].sum()))
        for a in sorted(groups):
            c, ar, z0, z1 = groups[a]
            print('    %3.0f deg: %4d faces  %8.2f mm2  z %.2f..%.2f' % (a, c, ar, z0, z1))
        worst = np.argmax(np.where(bad, area, -1))
        cen = tris[worst].mean(0)
        print('    largest at x %.1f y %.1f z %.2f (%.0f deg, %.2f mm2)' % (cen[0], cen[1], cen[2], ang[worst], area[worst]))
    return ok


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('stl', nargs='+')
    ap.add_argument('--layer', type=float, default=0.2, help='layer height, mm (0.2)')
    ap.add_argument('--tol', type=float, default=0.5, help='overhang tolerance, deg (0.5)')
    ap.add_argument('--expect', help='expected size LxWxH in mm, e.g. 60x26x10')
    ap.add_argument('--min-area', type=float, default=0.05, help='ignore faces smaller than this, mm2 (0.05)')
    ap.add_argument('--engraved', type=float, default=0.0, help='depth of engraving cut into the bed face, mm')
    args = ap.parse_args()
    expect = [float(t) for t in args.expect.lower().split('x')] if args.expect else None
    all_ok = True
    for path in args.stl:
        all_ok &= check(path, args.layer, args.tol, expect, args.min_area, args.engraved)
    print('OK' if all_ok else 'CHECK')
    sys.exit(0 if all_ok else 1)


if __name__ == '__main__':
    main()
