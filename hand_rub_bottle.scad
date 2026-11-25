// hand_rub_bottle.scad - pump bottle of alcohol hand rub (design_brief.md 4.10). Dia 14 x 28:
// body to 18, 45 deg shoulder to a dia 6 neck at 22, pump head dia 8 to 28 reached by a
// 45 deg flare from the neck, 3 x 3 spout with a 45 deg underside reaching to the body
// radius. Two colours: body and shoulder, then neck and pump; change at Z 22.0.
// Prints upright.   Export: openscad -o hand_rub_bottle.stl hand_rub_bottle.scad
include <common.scad>

diameter    = 14;
body_h      = 18;
neck_d      = 6;
change_z    = 22;        // top of the shoulder, colour change
neck_h      = 2;         // straight neck above the change, before the flare to the head
head_d      = 8;
height      = 28;
spout       = 3;         // spout section (width and height) and reach beyond the head
top_chamfer = 0.6;

r  = diameter / 2;
rn = neck_d / 2;
rh = head_d / 2;
fn = 60;                 // same segment count for both bands, so they meet exactly at the change

// Band 1: body and shoulder, Z 0-22
module bottle_body() rotate_extrude($fn = fn)
    polygon([[0, 0], [r - chamfer_bottom, 0], [r, chamfer_bottom], [r, body_h], [rn, change_z], [0, change_z]]);

// Band 2: neck, flare, pump head and spout, Z 22-28
module bottle_pump() {
    rotate_extrude($fn = fn)
        polygon([[0, change_z], [rn, change_z], [rn, change_z + neck_h], [rh, change_z + neck_h + rh - rn],
                 [rh, height - top_chamfer], [rh - top_chamfer, height], [0, height]]);
    // spout in the y-z plane, extruded 'spout' wide in x; the 45 deg underside runs back into the body
    rotate([90, 0, 90]) linear_extrude(height = spout, center = true)
        polygon([[-rh - spout, height - spout], [-rh - spout, height], [1, height], [1, height - spout - rh - spout - 1]]);
}

module hand_rub_bottle() {
    band_colour(1) bottle_body();
    band_colour(2) bottle_pump();
}

hand_rub_bottle();
