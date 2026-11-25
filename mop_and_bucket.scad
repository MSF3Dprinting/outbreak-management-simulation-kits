// mop_and_bucket.scad - cleaning mop and bucket (design_brief.md 4.11), two parts:
//   part = "bucket": open bucket dia 20 at the base, dia 24 at the rim, 18 high, 2.0 wall,
//                    4 mm floor with a slot for the mop head (14.5 x 3.7 x 3 at the shared
//                    clearances), two rim lugs 4 wide reaching 2.4 out; bbox 28.8 x 24 x 18
//   part = "mop":    flat part 52 x 14 x 3.4: 3.4 mm handle, 14 x 12 head with three 1.6 mm
//                    fringe notches; prints lying flat, stands in the bucket slot
// Single colour each.   Export: openscad -o mop_bucket.stl -D 'part="bucket"' mop_and_bucket.scad
//                               openscad -o mop.stl        -D 'part="mop"'    mop_and_bucket.scad
include <common.scad>
use <bucket_lib.scad>

part = "bucket";

// bucket
d_bottom   = 20;
d_top      = 24;
height     = 18;
wall       = 2.0;
floor_t    = 4;
slot_depth = 3;
lug_w      = 4;
lug_h      = 3;
lug_out    = min_handled;    // 2.4
// mop
mop_len     = 52;            // along x
mop_t       = 3.4;           // part thickness and handle width
head        = [12, 14];      // along the handle, across
notch_w     = min_gap;       // 1.6
notch_depth = 5;
notches     = 3;

mop_slot_l = head[1] + slot_end_clearance;   // 14.5, from common.scad
mop_slot_w = mop_t + slot_clearance;         // 3.7
strand     = (head[1] - notches * notch_w) / (notches + 1);   // 2.3 between notches

module mop_bucket() band_colour(1) {
    difference() {
        bucket(d_bottom, d_top, height, wall = wall, floor_t = floor_t, cb = chamfer_bottom);
        slot_cut(top = floor_t, l = mop_slot_l, w = mop_slot_w, d = slot_depth);
    }
    for (a = [0, 180]) rotate([0, 0, a]) bucket_lug(d_top / 2, height, w = lug_w, out = lug_out, h = lug_h);
}

module mop_2d() difference() {
    union() {
        translate([0, -head[1] / 2]) square(head);
        translate([head[0] - 1, -mop_t / 2]) square([mop_len - head[0] + 1, mop_t]);
    }
    for (i = [0 : notches - 1])
        translate([-1, -head[1] / 2 + strand + i * (strand + notch_w)]) square([notch_depth + 1, notch_w]);
}

module mop() band_colour(1) extrude_chamfered(mop_t) mop_2d();

if (part == "bucket") mop_bucket();
else if (part == "mop") mop();
else assert(false, str("part = \"", part, "\": use \"bucket\" or \"mop\""));
