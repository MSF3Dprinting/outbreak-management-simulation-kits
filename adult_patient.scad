// adult_patient.scad - adult woman lying in bed, seen from above (design_brief.md 4.3).
// Female pictogram 60 x 22 x 2.6: head dia 10 with a bun, neck 5 wide, dress, arms 3.2 wide
// along the body joining it at the hands, legs 3.8 wide with a 1.6 gap. Base 2.0 with the
// dress, a hair ring around the face and the bun raised 0.6 in the same colour, inset 0.6
// from the outline; the face stays at base level.
// Single colour, prints flat, head at x = 0, feet at x = 60.
// Export: openscad -o adult_patient.stl adult_patient.scad
include <common.scad>

length  = 60;
width   = 22;
relief  = true;
inset   = 0.6;                  // relief edge inside the outline
head_d  = 10;
bun_d   = 5;
neck_w  = min_neck;             // 5
relief_colour = "#8c8c8c";      // preview only: same filament, raised

// half outlines (y >= 0), mirrored; 0.1 mm precision
dress = [[15, 3.5], [16.5, 6], [28, 5.4], [44, 10], [44, 0]];
arm   = [[16.5, 7.8], [17.5, 11], [33.5, 11], [34.5, 8.5], [34.5, 5], [30, 5], [30, 7.8]];
leg   = [[43, 0.8], [60, 0.8], [60, 4.6], [43, 4.6]];

function mirrored(half) = concat(half, [for (i = [len(half) - 1 : -1 : 0]) [half[i][0], -half[i][1]]]);

module dress_2d() polygon(mirrored(dress));

module adult_2d() {
    translate([bun_d / 2, 0]) circle(d = bun_d);                    // bun at the crown
    translate([bun_d / 2 + head_d / 2, 0]) circle(d = head_d);      // head, x 2.5-12.5
    translate([12, -neck_w / 2]) square([3.5, neck_w]);             // neck
    dress_2d();
    for (s = [-1, 1]) scale([1, s]) { polygon(arm); polygon(leg); }
}

module relief_2d() {
    difference() {                                                   // dress with a round neckline
        offset(delta = -inset) dress_2d();
        translate([14.5, 0]) circle(r = 3.5);
    }
    difference() {                                                   // hair: ring 1.2 wide around the face
        translate([bun_d / 2 + head_d / 2, 0]) circle(d = head_d - 2 * inset);
        translate([bun_d / 2 + head_d / 2, 0]) circle(d = head_d - 2 * inset - 2 * picto_min);
    }
    translate([bun_d / 2, 0]) circle(d = bun_d - 2 * inset);         // bun
}

module adult_patient() {
    band1() adult_2d();
    if (relief) color(relief_colour) band_at(1, band2_z, band2_h) relief_2d();
}

adult_patient();
