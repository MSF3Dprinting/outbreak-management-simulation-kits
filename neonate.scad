// neonate.scad - newborn patient, seen from above (design_brief.md 4.2). Swaddled baby
// 30 x 15 x 2.6: round head dia 11 and a wrapped oval body; base 2.0 with the wrap raised
// 0.6 in the same colour, inset 0.6 from the outline; the face stays at base level, and a
// V-shaped fold in the wrap opens toward the head. Single colour, prints flat, head at x = 0.
// Export: openscad -o neonate.stl neonate.scad
include <common.scad>

length     = 30;
width      = 15;
head_d     = 11;
face_d     = 7.4;               // at base level inside the head; wrap ring around it 1.2 wide
relief     = true;              // raised wrap
wrap_inset = 0.6;               // wrap edge inside the outline
fold       = true;              // fold lines in the wrap, at the pictogram minimum width
fold_w     = picto_min;         // 1.2
relief_colour = "#8c8c8c";      // preview only: same filament, raised

module neonate_2d() {
    translate([head_d / 2, 0]) circle(d = head_d);
    translate([length - (length - head_d + 2) / 2, 0]) scale([(length - head_d + 2) / width, 1]) circle(d = width);
}

module wrap_2d() difference() {
    offset(delta = -wrap_inset) neonate_2d();
    translate([head_d / 2, 0]) circle(d = face_d);
    if (fold) for (s = [-1, 1]) hull() {              // fold line from the shoulder to the chest
        translate([head_d + 1, s * (width / 2 - 1.5)]) circle(d = fold_w);
        translate([head_d + 7, 0]) circle(d = fold_w);
    }
}

module neonate() {
    band1() neonate_2d();
    if (relief) color(relief_colour) band_at(1, band2_z, band2_h) wrap_2d();
}

neonate();
