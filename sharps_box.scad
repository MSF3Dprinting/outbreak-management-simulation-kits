// sharps_box.scad - sharps safety box (design_brief.md 4.8). About the size of the hand rub
// bottle: 16 x 14 x 28. Body 26 high, the top tapers at 45 deg to a 12 x 10 face at 28 with a
// dia 6 opening 3 deep (2 mm wall to the edge). Single colour, yellow, prints upright.
// Export: openscad -o sharps_box.stl sharps_box.scad
include <common.scad>

length        = 16;
width         = 14;
body_h        = 26;
height        = 28;       // top face; the taper is (height - body_h) deep at 45 deg
opening_d     = 6;
opening_depth = 3;

module sharps_box() {
    t = height - body_h;
    band_colour(1) difference() {
        ring_stack([[length / 2 - chamfer_bottom, width / 2 - chamfer_bottom, 0],
                    [length / 2, width / 2, chamfer_bottom],
                    [length / 2, width / 2, body_h],
                    [length / 2 - t, width / 2 - t, height]]);
        translate([0, 0, height - opening_depth]) cylinder(d = opening_d, h = opening_depth + 1);
    }
}

sharps_box();
