// common.scad - tabletop simulation training set: shared values and helpers
// Source: design_brief.md v0.4, section 2. Every model starts with
//     include <common.scad>
// and uses these names; it never copies the values.
// Plain OpenSCAD without libraries, OpenSCAD 2021.01 or newer. Units: mm.

// ------------------------------------------------------------------ process
layer_h      = 0.2;        // layer height; colour changes lie on multiples of it
nozzle_d     = 0.4;
build_x      = 200;        // print bed
build_y      = 200;
overhang_max = 45;         // degrees from vertical; no bridges
$fa = 6;                   // curve resolution of cylinders and arcs
$fs = 0.5;

// ------------------------------------------------- colour bands of flat parts
band1_h     = 2.0;                  // Band 1, base: Z 0-2.0, 10 layers, full outline
band2_h     = 0.6;                  // Band 2: Z 2.0-2.6, 3 layers
band3_h     = 0.6;                  // Band 3: Z 2.6-3.2, 3 layers
band2_z     = band1_h;              // 2.0, first colour change
band3_z     = band1_h + band2_h;    // 2.6, second colour change
band_top    = band3_z + band3_h;    // 3.2, top of a three-band part
band_min_h  = 0.6;                  // every colour after a change
base_min    = 2.0;                  // base of every flat part
max_colours = 3;                    // per part
detail_h    = 0.6;                  // raised text and lines
// Slicer: put each change on the first layer above the boundary (2.2 for 2.0).
// Preview colours only; the filament sets the real colour.
band_colours = ["#b4b4b4", "#2e86de", "#f0a020"];

// ------------------------------------------------------------ minimum sizes
min_wall        = 1.6;     // walls, plates, freestanding features
min_handled     = 2.4;     // handled protrusions, in both directions
min_limb        = 3.0;     // limbs of silhouettes
min_neck        = 5.0;     // necks of silhouettes
min_gap         = 1.6;     // gaps in outlines
min_stroke      = 1.0;     // raised text and lines: a detail on a solid base, not a wall
picto_min       = 1.2;     // pictogram strokes and openings
part_min_narrow = 12;      // handling: narrowest horizontal direction
part_min_long   = 20;      // handling: longest direction

// -------------------------------------------------------------------- edges
chamfer_bottom = 0.4;      // every bottom edge, against elephant's foot
chamfer_top    = 0.8;      // exposed top edges, 0.6-1.0 allowed
chamfer_fn     = 12;       // facets of the chamfer cone under outlines
groove_angle   = 45;       // V-groove flanks

// --------------------------------------------------------------------- text
text_font      = "Liberation Sans:style=Bold";  // bundled with OpenSCAD; Linux: fonts-liberation
text_size      = 5;        // default and minimum: figure labels, PRECAUTIONS line
text_size_room = 5;        // room labels on the sign plate; CONSULTATION is the widest, 51.7 mm
text_size_sign = 6;        // precaution signs, line 1
text_size_bed  = 7;        // bed numbers
text_fn        = 24;       // segments of curved glyph parts
text_margin    = 2.0;      // least clear space between text and an edge or frame
cap_ratio      = 0.955;    // capital height / size, measured in OpenSCAD 2021.01
stroke_ratio   = 0.20;     // stroke width / size, measured in OpenSCAD 2021.01
function cap_height(size = text_size)   = cap_ratio * size;
function stroke_width(size = text_size) = stroke_ratio * size;

// Width estimate. OpenSCAD 2021.01 has no textmetrics(), so this uses advance
// and ink widths per character at size 1, measured in OpenSCAD 2021.01, plus a
// pad of 0.05 x size. It ignores kerning: strings with AT, TA or PA read up to
// 2 mm wider than the print at size 5; all others within 0.3 mm.
text_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .-/:\u00c9\u00c8\u00c0\u00d4\u00db\u00c7";   // French accented capitals at the end
text_adv = [0.980, 0.980, 0.980, 0.980, 0.905, 0.829, 1.055, 0.980, 0.377, 0.754, 0.980, 0.829, 1.130, 0.980, 1.055, 0.905, 1.055, 0.980, 0.905, 0.829, 0.980, 0.905, 1.280, 0.905, 0.905, 0.829, 0.754, 0.754, 0.754, 0.754, 0.754, 0.754, 0.754, 0.754, 0.754, 0.754, 0.377, 0.377, 0.452, 0.377, 0.452, 0.905, 0.905, 0.980, 1.055, 0.980, 0.980];
text_ink = [0.932, 0.847, 0.908, 0.852, 0.779, 0.705, 0.937, 0.817, 0.200, 0.656, 0.897, 0.713, 0.971, 0.817, 0.965, 0.786, 0.965, 0.882, 0.832, 0.818, 0.835, 0.907, 1.308, 0.902, 0.880, 0.767, 0.660, 0.646, 0.669, 0.690, 0.744, 0.691, 0.671, 0.652, 0.686, 0.673, 0.000, 0.196, 0.353, 0.359, 0.195, 0.779, 0.779, 0.932, 0.965, 0.835, 0.908];
text_pad = 0.05;

function sum(v) = len(v) == 0 ? 0 : [for (x = v) 1] * v;
function char_index(c) = let(i = search(c, text_chars)) (len(i) == 0 || is_list(i[0])) ? undef : i[0];
function char_adv(c) = let(i = char_index(c)) text_adv[is_undef(i) ? char_index("M") : i];
function char_ink(c) = let(i = char_index(c)) text_ink[is_undef(i) ? char_index("M") : i];
function text_width(s, size = text_size) = len(s) == 0 ? 0 :
    size * (sum([for (i = [0 : len(s) - 1]) char_adv(s[i])])
            - (char_adv(s[0]) - char_ink(s[0])) / 2
            - (char_adv(s[len(s) - 1]) - char_ink(s[len(s) - 1])) / 2 + text_pad);
function text_known(s) = len(s) == 0 || len([for (i = [0 : len(s) - 1]) if (is_undef(char_index(s[i]))) 1]) == 0;

// Text as a 2D shape; stops the render if the estimate is wider than max_w.
module label_2d(s, size = text_size, max_w = undef, halign = "center", valign = "center") {
    w = text_width(s, size);
    if (!text_known(s)) echo(str("label_2d: \"", s, "\" has characters outside the width table"));
    if (!is_undef(max_w))
        assert(w <= max_w, str("\"", s, "\" at size ", size, " is about ", w, " mm wide, more than ", max_w, " mm"));
    text(s, size = size, font = text_font, halign = halign, valign = valign, $fn = text_fn);
}

// ------------------------------------------------------------- tab and slot
// Every slot in the set (stand, slot test block, mop bucket) takes its clearance from
// the two values below, so one test print sets the fit of all models. Brief values;
// not yet confirmed by a print (no printer available at stage 1).
slot_clearance     = 0.3;              // slot width minus the thickness of the part it holds
slot_end_clearance = 0.5;              // slot length minus the length of the part it holds
tab_l = 30;                            // standard tab 30 x 8, Band 1 only (2.0 thick)
tab_h = 8;
tab_t = band1_h;
slot_l       = tab_l + slot_end_clearance;   // 30.5
slot_w       = tab_t + slot_clearance; // 2.3
slot_d       = tab_h;                  // 8 deep
slot_floor   = 2.0;
slot_chamfer = 0.4;                    // entry chamfer
stand_size   = [60, 26, slot_d + slot_floor];   // universal stand 60 x 26 x 10
stand_chamfer_top = 1.0;
nameplate_size = [60, 15];             // figure nameplate, two engraved lines fit; signs are 60 wide too

// Tab as a 2D shape hanging below y = 0, centred on x; union it into the Band 1 outline.
module tab_2d() translate([-tab_l / 2, -tab_h]) square([tab_l, tab_h]);

// ---------------------------------------------- engraving on the back face
// Two-sided flat parts carry the second language on the back, engraved: the back is the bed
// face, so the detail is cut into it, not raised. The cut narrows by one layer height per layer
// (a 45 deg stepped V), so nothing is printed over air; a stroke of width w closes at w/2 deep.
// Children are 2D shapes in part coordinates; mirror them so the back reads the right way round.
engrave_depth = 0.6;
module engrave_cut(depth = engrave_depth, lh = layer_h)
    for (i = [0 : depth / lh - 1])
        translate([0, 0, i * lh]) linear_extrude(height = lh + 0.002) offset(delta = -i * lh) children();

// Outline of a 2D shape, w wide, for engraving a pictogram on the back.
module outline_2d(w = picto_min) difference() { children(); offset(delta = -w) children(); }

// Negative shape of a slot with its entry chamfer, centred on x and y, open at z = top.
module slot_cut(top, l = slot_l, w = slot_w, d = slot_d, entry = slot_chamfer)
    ring_stack([[l / 2, w / 2, top - d], [l / 2, w / 2, top - entry],
                [l / 2 + entry, w / 2 + entry, top], [l / 2 + entry, w / 2 + entry, top + 1]]);

// ------------------------------------------------- bed values shared by items
bed_l = 80;                            // hospital bed footprint and height; the screen uses these
bed_w = 40;
bed_h = 20.6;

// ------------------------------------------------------------------ helpers
// Solid from stacked rectangular rings [half_x, half_y, z], bottom to top (exact polyhedron).
module ring_stack(rings) {
    n = len(rings);
    pts = [for (r = rings) each [[-r[0], -r[1], r[2]], [r[0], -r[1], r[2]], [r[0], r[1], r[2]], [-r[0], r[1], r[2]]]];
    sides = [for (i = [0 : n - 2], j = [0 : 3])
             [4 * i + j, 4 * (i + 1) + j, 4 * (i + 1) + (j + 1) % 4, 4 * i + (j + 1) % 4]];
    polyhedron(points = pts, faces = concat([[0, 1, 2, 3]], sides, [[4 * n - 1, 4 * n - 2, 4 * n - 3, 4 * n - 4]]));
}

// Box with 45 degree chamfers on the bottom (cb) and top (ct) edges, base on z = 0.
module chamfered_box(size, cb = chamfer_bottom, ct = chamfer_top, center = true) {
    x = size[0]; y = size[1]; z = size[2];
    translate(center ? [0, 0, 0] : [x / 2, y / 2, 0])
        ring_stack(concat(cb > 0 ? [[x / 2 - cb, y / 2 - cb, 0]] : [],
                          [[x / 2, y / 2, cb], [x / 2, y / 2, z - ct]],
                          ct > 0 ? [[x / 2 - ct, y / 2 - ct, z]] : []));
}

// Cylinder with 45 degree chamfers, base on z = 0, centred.
module chamfered_cylinder(d, h, cb = chamfer_bottom, ct = chamfer_top) {
    r = d / 2;
    rotate_extrude() polygon(concat([[0, 0]], cb > 0 ? [[r - cb, 0], [r, cb]] : [[r, 0]],
                                    ct > 0 ? [[r, h - ct], [r - ct, h]] : [[r, h]], [[0, h]]));
}

// Extrude a 2D outline to height h with a 45 degree chamfer of cb on the bottom edge.
// Convex corners of the outline come out rounded by cb (chamfer_fn facets).
module extrude_chamfered(h, cb = chamfer_bottom) {
    if (cb <= 0) linear_extrude(height = h) children();
    else minkowski() {
        linear_extrude(height = h - cb) offset(delta = -cb) children();
        cylinder(h = cb, r1 = 0, r2 = cb, $fn = chamfer_fn);
    }
}

// Colour bands of a flat part, each from 2D children; band 1 gets the bottom chamfer.
// Upper bands start band_overlap inside the band below, so the export is one solid
// (exactly touching faces can miss each other by a rounding error).
band_overlap = 0.01;
module band1(chamfer = chamfer_bottom) color(band_colours[0]) extrude_chamfered(band1_h, chamfer) children();
module band2() band_at(2, band2_z, band2_h) children();
module band3() band_at(3, band3_z, band3_h) children();
// A band at any height (bed number at Z 20.0-20.6), from 2D children.
module band_at(n, z0, h) color(band_colours[n - 1])
    translate([0, 0, z0 - band_overlap]) linear_extrude(height = h + band_overlap) children();
// 3D geometry in the colour of band n; upright single-colour parts use band 1.
module band_colour(n) color(band_colours[n - 1]) children();

// 2D helpers
// A raised frame flush with a plate edge gets the plate's rounded corners (r = chamfer_bottom,
// chamfer_fn facets), so it sits exactly on the chamfered Band 1 outline.
module frame_2d(size, w = min_wall, r = chamfer_bottom)
    difference() { rounded_rect_2d(size, r); square([size[0] - 2 * w, size[1] - 2 * w], center = true); }
module rounded_rect_2d(size, r, fn = chamfer_fn) {
    if (r <= 0) square(size, center = true);
    else offset(r = r, $fn = fn) offset(delta = -r) square(size, center = true);
}
