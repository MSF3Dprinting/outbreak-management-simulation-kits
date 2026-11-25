// blood_culture_bottle.scad - blood culture bottle half filled with blood, token
// (design_brief.md 4.13). Flat 32 x 14 x 2.6 along x: Band 1 (0-2.0) is the bottle
// silhouette - body 14 x 21 with rounded bottom corners, 45 deg shoulder to an 8 mm neck,
// cap 10 x 6; Band 2 (2.0-2.6) is the blood filling the lower half of the body, 1.6 mm
// inside the edges. Two colours (clear, then red PETG), change at Z 2.0. Prints flat.
// Export: openscad -o blood_culture_bottle.stl blood_culture_bottle.scad
include <common.scad>

body        = [21, 14];         // along x, across
corner_r    = 2;                // bottom corners
neck_w      = 8;
neck_l      = 2;
cap         = [6, 10];
fill        = 0.5;              // share of the body length filled with blood
edge_offset = min_wall;         // 1.6: blood kept inside the silhouette

shoulder_l = (body[1] - neck_w) / 2;                 // 3, 45 deg
length     = body[0] + shoulder_l + neck_l + cap[0]; // 32

module body_2d() hull() {
    for (s = [-1, 1]) translate([corner_r, s * (body[1] / 2 - corner_r)]) circle(r = corner_r);
    translate([corner_r, -body[1] / 2]) square([body[0] - corner_r, body[1]]);
}

module bottle_2d() {
    body_2d();
    bx = body[0];
    polygon([[bx - 0.5, body[1] / 2], [bx + shoulder_l, neck_w / 2], [bx + shoulder_l, -neck_w / 2], [bx - 0.5, -body[1] / 2]]);
    translate([bx + shoulder_l - 0.5, -neck_w / 2]) square([neck_l + 1, neck_w]);
    translate([bx + shoulder_l + neck_l, -cap[1] / 2]) square(cap);
}

module blood_2d() intersection() {
    offset(delta = -edge_offset) body_2d();
    translate([-1, -body[1]]) square([1 + body[0] * fill, 2 * body[1]]);
}

module blood_culture_bottle() {
    band1() bottle_2d();
    band2() blood_2d();
}

blood_culture_bottle();
