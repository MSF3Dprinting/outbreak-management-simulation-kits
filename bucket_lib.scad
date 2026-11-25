// bucket_lib.scad - bucket shapes shared by the hand washing point (design_brief.md 4.9)
// and the mop bucket (4.11); the waste bin (4.7) uses the closed form too.
// Load from a model with:  use <bucket_lib.scad>
// The modules read their shared values from common.scad themselves.
include <common.scad>

function bucket_r(rb, rt, h, z) = rb + (rt - rb) * z / h;   // outer radius at height z

// Body of revolution, base on z = 0, centred on the z axis.
//   d_bottom, d_top   outer diameters at the base and at height h; different values taper
//   wall, floor_t     > 0: open bucket with this wall and floor; 0: solid body
//   lid_h, lip        > 0: closed top with a lid lid_h high, overhanging by lip on a 45 deg underside
//   cb                bottom chamfer; 0 when the bucket stands on another part
//   ct                top chamfer of the lid or of a solid body; an open rim gets none
module bucket(d_bottom, d_top, h, wall = 0, floor_t = 0, lid_h = 0, lip = 0, cb = chamfer_bottom, ct = 0) {
    rb = d_bottom / 2;
    rt = d_top / 2;
    base = concat([[0, 0]], cb > 0 ? [[rb - cb, 0], [rb, cb]] : [[rb, 0]]);
    top = lid_h > 0 ?
              concat([[rt, h]], lip > 0 ? [[rt + lip, h + lip]] : [],
                     ct > 0 ? [[rt + lip, h + lid_h - ct], [rt + lip - ct, h + lid_h]] : [[rt + lip, h + lid_h]],
                     [[0, h + lid_h]]) :
          wall > 0 ?
              [[rt, h], [rt - wall, h], [bucket_r(rb, rt, h, floor_t) - wall, floor_t], [0, floor_t]] :
          ct > 0 ?
              [[rt, h - ct], [rt - ct, h], [0, h]] :
              [[rt, h], [0, h]];
    rotate_extrude() polygon(concat(base, top));
}

// Lug on the outside wall at +x: w wide, reaching out beyond the wall, h high with its top at
// z_top, underside at 45 deg. r_wall is the outer radius at z_top; the lug continues inset
// into the wall (and further down at 45 deg) so it merges with a tapered wall.
module bucket_lug(r_wall, z_top, w = 4, out = min_handled, h = 3, inset = 1)
    rotate([90, 0, 0]) linear_extrude(height = w, center = true)
        polygon([[r_wall - inset, z_top - h - out - inset], [r_wall + out, z_top - h],
                 [r_wall + out, z_top], [r_wall - inset, z_top]]);
