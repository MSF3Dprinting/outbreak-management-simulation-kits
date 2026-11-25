// screen.scad - mobile privacy screen (design_brief.md 4.6). Straight panel 80 long (bed length)
// and 30.6 high (bed height + 10), both from common.scad; curtain 2.4 thick between 3.2 end
// posts, bottom rail 3.2 x 4, top rail 3.2 x 4 widening from the curtain at 45 deg, two feet
// 3.2 x 20 x 3 across the ends. Three colours: feet and bottom rail Z 0-4, curtain 4-26.6,
// top rail 26.6-30.6; the posts follow the bands. Prints upright, brim optional.
// Export: openscad -o screen.stl screen.scad
include <common.scad>

height_above_bed = 10;
height        = bed_h + height_above_bed;   // 30.6
length        = bed_l;                      // 80
curtain_t     = 2.4;
frame_t       = 3.2;                        // rails and end posts
bottom_rail_h = 4;
top_rail_h    = 4;
foot_l        = 20;
foot_h        = 3;
top_chamfer   = 0.6;

top_rail_z = height - top_rail_h;           // 26.6, second colour change
post_x     = (length - frame_t) / 2;        // post centres

// Band 1: bottom rail and feet, Z 0-4
module screen_base() band_colour(1) {
    l = length / 2; t = frame_t / 2; cb = chamfer_bottom;
    ring_stack([[l - cb, t - cb, 0], [l, t, cb], [l, t, bottom_rail_h]]);
    for (x = [-post_x, post_x]) translate([x, 0, 0]) chamfered_box([frame_t, foot_l, foot_h], cb = cb, ct = top_chamfer);
}

// Band 2: curtain and posts, Z 4-26.6
module screen_curtain() band_at(2, bottom_rail_h, top_rail_z - bottom_rail_h) {
    square([length - 2 * frame_t, curtain_t], center = true);
    for (x = [-post_x, post_x]) translate([x, 0]) square([frame_t, frame_t], center = true);
}

// Band 3: top rail, Z 26.6-30.6; its underside widens from the curtain to the frame at 45 deg
module screen_top_rail() band_colour(3) {
    l = length / 2; t = frame_t / 2; c = curtain_t / 2; step = t - c; ov = band_overlap;
    // the overlap into the curtain tapers in by ov, so no face is coplanar with the curtain
    ring_stack([[l - ov, c - ov, top_rail_z - ov], [l, c, top_rail_z], [l, t, top_rail_z + step],
                [l, t, height - top_chamfer], [l - top_chamfer, t - top_chamfer, height]]);
    for (x = [-post_x, post_x])                    // fills the widening step above the posts
        translate([x, 0, 0]) ring_stack([[t - ov, t - ov, top_rail_z - ov], [t, t, top_rail_z], [t, t, top_rail_z + step]]);
}

module screen() { screen_base(); screen_curtain(); screen_top_rail(); }

screen();
