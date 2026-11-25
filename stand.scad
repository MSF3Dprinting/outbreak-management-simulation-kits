// stand.scad - universal stand (design_brief.md 4.15): holds any part with the
// standard 30 x 8 x 2.0 mm tab upright. Single colour, prints flat on its base.
// Part 60 x 26 x 10 mm, slot 30.5 x 2.3 mm, 8 mm deep on a 2 mm floor.
include <common.scad>

size           = stand_size;         // [60, 26, 10]
clearance      = slot_clearance;     // shared fit values from common.scad, 0.3 and 0.5
end_clearance  = slot_end_clearance; // until the stage 1 test print sets them
slot_length    = tab_l + end_clearance;   // 30.5
slot_depth     = slot_d;             // 8, leaves the 2 mm floor
entry_chamfer  = slot_chamfer;       // 0.4
top_chamfer    = stand_chamfer_top;  // 1.0
bottom_chamfer = chamfer_bottom;     // 0.4

module stand() {
    band_colour(1) difference() {
        chamfered_box(size, cb = bottom_chamfer, ct = top_chamfer);
        slot_cut(top = size[2], l = slot_length, w = tab_t + clearance, d = slot_depth, entry = entry_chamfer);
    }
}

stand();
