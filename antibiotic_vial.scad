// antibiotic_vial.scad - antibiotic container (design_brief.md 4.17): a small drug vial standing
// on the table. 30 in five colours, six of each; the colour is the code and the group decides
// what each one means, so the part carries no text. Ø12 x 20 mm: body to 15, 45 deg shoulder to
// a Ø8 crimp cap, 0.4 mm bottom and 0.6 mm top chamfer. Single colour, prints upright.
// Export: openscad -o antibiotic_vial.stl antibiotic_vial.scad
include <common.scad>

diameter    = 12;               // body; at or above the 12 mm handling minimum
height      = 20;
body_h      = 15;               // top of the straight body, where the shoulder starts
cap_d       = 8;
shoulder_h  = (diameter - cap_d) / 2;   // 2, so the shoulder is at 45 deg
top_chamfer = 0.6;

module antibiotic_vial() {
    r = diameter / 2; rc = cap_d / 2; cb = chamfer_bottom;
    band_colour(1) rotate_extrude()
        polygon([[0, 0], [r - cb, 0], [r, cb], [r, body_h], [rc, body_h + shoulder_h],
                 [rc, height - top_chamfer], [rc - top_chamfer, height], [0, height]]);
}

antibiotic_vial();
