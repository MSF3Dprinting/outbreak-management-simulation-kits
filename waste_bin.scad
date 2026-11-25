// waste_bin.scad - pedal waste bin (design_brief.md 4.7). One design for the blue and the red
// bin; the filament sets the colour. Body dia 18 x 21, lid 3 with a 0.5 lip, foot pedal
// 7 x 3 x 2 at the front on the table. Part 19 x 21.5 x 24 (lid dia 19, pedal 3 forward).
// Single colour, prints upright.   Export: openscad -o waste_bin.stl waste_bin.scad
include <common.scad>
use <bucket_lib.scad>

diameter    = 18;
body_h      = 21;
lid_h       = 3;
lip         = 0.5;
pedal       = true;
pedal_size  = [7, 3, 2];    // width, reach beyond the body, height (brief values)
pedal_root  = 2;            // reach into the body
top_chamfer = chamfer_top;   // 0.8

module waste_bin() {
    band_colour(1) {
        bucket(diameter, diameter, body_h, lid_h = lid_h, lip = lip, cb = chamfer_bottom, ct = top_chamfer);
        if (pedal)
            translate([0, -diameter / 2 - pedal_size[1] + (pedal_size[1] + pedal_root) / 2, 0])
                chamfered_box([pedal_size[0], pedal_size[1] + pedal_root, pedal_size[2]], cb = chamfer_bottom, ct = 0.4);
    }
}

waste_bin();
