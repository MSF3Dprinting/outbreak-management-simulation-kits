// bed.scad - hospital bed (design_brief.md 4.1). One design for the standard beds 1-20 and the
// isolation beds I-1 to I-6; filament colour and number differ. 80 x 40 x 20.6: mattress top at 8,
// footboard 10 thick (+x end) and headboard 3 thick (-x end) with tops at 20, the number raised
// 0.6 on the footboard top and reading upright from the foot end. Optional 1 mm V-groove around
// the sides at 6.5 (frame/mattress line). Imitated legs: the four corners keep the full outline up
// to 5, and the sides between them are set in 1.5 and flare back out at 45 deg, so nothing sticks
// out past the 80 x 40 footprint and the bed still prints upright without support. Two colours:
// body, then the number; change at Z 20.0.
// An empty bed (bed_label="") carries no number and is a single colour. The black sheet that
// marks it as stripped is a separate part, bed_sheet.scad, laid on the mattress between the
// boards: on a single-extruder printer a sheet moulded into the bed would need a colour change
// in a Z band the boards also occupy, so the boards would come out black there too.
// Prints upright.   Export: openscad -o bed_20.stl -D 'bed_label="20"' bed.scad  (see export_beds.sh)
include <common.scad>

bed_label    = "1";             // "1".."20", "I-1".."I-6", or "" for an empty bed
length       = bed_l;           // 80, from common.scad
width        = bed_w;           // 40
mattress_z   = 8;               // mattress top
board_z      = 20;              // top of the footboard; the number sits on it
head_z       = board_z;         // headboard top: may be lower, never higher
foot_t       = 10;              // footboard thickness
head_t       = 3;               // headboard thickness
groove       = true;            // V-groove around the sides, above the legs
groove_z     = 6.5;
groove_w     = 1;               // opening; 0.5 deep, 45 deg flanks
legs         = true;            // imitated legs at the four corners
leg_l        = 9;               // along the bed
leg_w        = 7;               // across the bed
leg_h        = 5;               // top of the legs, where the set-in sides flare back out
leg_inset    = 1.5;             // how far the sides between the legs are set in
edge_chamfer = 0.6;             // exposed top edges: mattress sides, board tops
label_size   = text_size_bed;   // 7: capitals 6.7, strokes 1.4

// One corner leg: a block on the full outline of the bed, standing on the bed plate up to leg_h,
// where the body above takes over. The sides between the legs are set in by bed_body, so a leg
// reads as a leg without anything sticking out past the footprint. No downward face, no support.
module bed_leg(sx, sy) {
    lx = leg_l / 2; ly = leg_w / 2; cb = chamfer_bottom;
    translate([sx * (length / 2 - leg_l / 2), sy * (width / 2 - leg_w / 2), 0])
        ring_stack([[lx - cb, ly - cb, 0], [lx, ly, cb], [lx, ly, leg_h]]);
}

module bed_body() {
    l = length / 2; w = width / 2; cb = chamfer_bottom; g = groove_w / 2; root = edge_chamfer;
    ins = legs ? leg_inset : 0;
    // block up to the mattress top: sides set in between the legs, then the groove, then a
    // chamfer on the mattress edges
    ring_stack(concat([[l - ins - cb, w - ins - cb, 0], [l - ins, w - ins, cb]],
                      ins > 0 ? [[l - ins, w - ins, leg_h - ins], [l, w, leg_h]] : [],
                      groove ? [[l, w, groove_z - g], [l - g, w - g, groove_z], [l, w, groove_z + g]] : [],
                      [[l, w, mattress_z - root], [l - root, w - root, mattress_z]]));
    // boards, rooted into the block so they fill the mattress-edge chamfer under them
    translate([l - foot_t / 2, 0, mattress_z - root])
        chamfered_box([foot_t, width, board_z - mattress_z + root], cb = 0, ct = edge_chamfer);
    translate([-l + head_t / 2, 0, mattress_z - root])
        chamfered_box([head_t, width, head_z - mattress_z + root], cb = 0, ct = edge_chamfer);
    if (legs) for (sx = [-1, 1], sy = [-1, 1]) bed_leg(sx, sy);
}

// Number on the footboard top: text x runs along +y, text up points to -x (the head end),
// so it reads upright from the foot end.
module bed_number(label) {
    assert(cap_height(label_size) + 1 <= foot_t - 2 * edge_chamfer,
           str("number ", label, " is taller than the footboard top is thick"));
    band_at(2, board_z, detail_h) translate([length / 2 - foot_t / 2, 0]) rotate(90)
        label_2d(label, label_size, max_w = width - 2 * edge_chamfer - 2 * text_margin);
}

module bed(label = bed_label) {
    band_colour(1) bed_body();
    if (len(label) > 0) bed_number(label);
}

bed();
