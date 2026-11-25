// hand_washing_point.scad - field hand washing station (design_brief.md 4.9): water bucket
// with a tap on an arched stand, catch basin in front. Base plate 28 x 36 x 2, stand
// 20 x 20 to Z 24 with a pointed arch (12 wide, sides to 14, roof to 20), bucket dia 20 x 14
// with a 2 mm lid and 0.5 lip (top at 40), tap 3 x 3 reaching 5 forward with a 45 deg wedge
// underneath and a 2.4 handle, basin dia 14 x 6 with a 1.6 wall. Front is -y.
// Single colour, prints upright.   Export: openscad -o hand_washing_point.stl hand_washing_point.scad
include <common.scad>
use <bucket_lib.scad>

base        = [28, 36];
plate_t     = 2;
plate_top_chamfer = 0.6;
hw_stand    = [20, 20];   // this station's own stand, not the universal stand
stand_top   = 24;
stand_back  = 1;            // stand set 1 mm from the back edge so the lid lip stays on the plate
arch_w      = 12;
arch_side   = 14;           // top of the vertical sides
arch_apex   = 20;           // 45 deg roof meets here; top bar 20-24
bucket_d    = 20;
bucket_h    = 14;
lid_h       = 2;
lip         = 0.5;
lid_chamfer = 0.6;
tap_z       = 26;           // underside of the spout
tap         = 3;            // spout section
tap_reach   = 5;
handle      = min_handled;  // 2.4 mm handle block on the spout
basin_d     = 14;
basin_h     = 6;
basin_wall  = min_wall;
basin_floor = min_wall;   // 1.6
basin_gap   = 0.2;          // between basin and stand
root        = 0.5;          // parts standing on the plate or stand reach this far into it

stand_y = base[1] / 2 - stand_back - hw_stand[1] / 2;    // 7, stand centre
front_y = stand_y - hw_stand[1] / 2;                     // -3, front face of stand and bucket
basin_y = front_y - basin_gap - basin_d / 2;               // -10.2

module stand() difference() {
    translate([-hw_stand[0] / 2, stand_y - hw_stand[1] / 2, plate_t - root])
        cube([hw_stand[0], hw_stand[1], stand_top - plate_t + root]);
    // pointed arch through the stand, front to back, floor on the plate
    translate([0, stand_y, 0]) rotate([90, 0, 0]) linear_extrude(height = hw_stand[1] + 2, center = true)
        polygon([[-arch_w / 2, plate_t], [arch_w / 2, plate_t], [arch_w / 2, arch_side], [0, arch_apex], [-arch_w / 2, arch_side]]);
}

module tap() {
    tip = front_y - tap_reach;
    rotate([90, 0, 90]) linear_extrude(height = tap, center = true)
        polygon([[tip, tap_z], [tip, tap_z + tap], [front_y + 2, tap_z + tap], [front_y + 2, tap_z - tap_reach - 2]]);
    translate([-handle / 2, front_y - handle - 1, tap_z + tap]) cube([handle, handle, handle]);
}

module basin() translate([0, basin_y, plate_t - root]) rotate_extrude()
    polygon([[0, 0], [basin_d / 2, 0], [basin_d / 2, basin_h + root], [basin_d / 2 - basin_wall, basin_h + root],
             [basin_d / 2 - basin_wall, basin_floor + root], [0, basin_floor + root]]);

module hand_washing_point() band_colour(1) {
    chamfered_box([base[0], base[1], plate_t], cb = chamfer_bottom, ct = plate_top_chamfer);
    stand();
    translate([0, stand_y, stand_top - root])
        bucket(bucket_d, bucket_d, bucket_h + root, lid_h = lid_h, lip = lip, cb = 0, ct = lid_chamfer);
    tap();
    basin();
}

hand_washing_point();
