// test_coupon.scad - stage 1 test prints.
//   part = "coupon": flat three-band coupon, plate 70 x 50 like a room label, plus the
//                    standard tab; part 70 x 58 x 3.2 mm, colour changes at Z 2.0 and 2.6
//   part = "slots":  block 52 x 30 x 10 mm with three 8 mm deep slots for the 2.0 mm tab
//                    at 0.2, 0.3 and 0.4 mm clearance, each labelled in raised text
//                    (0.6 mm, so the part is 10.6 mm high); single colour
// Export: openscad -o test_coupon.stl -D 'part="coupon"' test_coupon.scad
//         openscad -o test_slots.stl  -D 'part="slots"'  test_coupon.scad
include <common.scad>

part = "coupon";

// ---- coupon ------------------------------------------------------------------
// Band 1: plate and tab. Band 2 (raised 0.6): 1.6 mm frame, text rows, coverage patch
// with a 1.2 mm opening, a 1.2 mm bar, nameplate 60 x 12. Band 3: nameplate text.
// Rows from the top: "20 I-4" at size 7 (bed numbers) with the patch and bar on its
// right, AIRBORNE at size 6 (sign line 1), SHOWER at the room label size,
// PAEDIATRICIAN at size 5 on the nameplate (figure label).
plate    = [70, 50];
frame_w  = min_wall;
inner    = [plate[0] - 2 * frame_w, plate[1] - 2 * frame_w];
row_gap  = 3.5;                        // between rows
edge_gap = 3.0;                        // to the frame
patch    = [24, 8];                    // Band 2 coverage patch
opening  = [picto_min, 5];             // opening in the patch, Band 1 shows through
bar      = [picto_min, 8];             // raised bar at the pictogram stroke minimum
row1 = ["20 I-4", text_size_bed];
row2 = ["AIRBORNE", text_size_sign];
row3 = ["SHOWER", text_size_room];
plate_text_max = inner[0] - 2 * text_margin;

// vertical layout, from the bottom of the inner area upwards
np_yc  = -inner[1] / 2 + edge_gap + nameplate_size[1] / 2;
row3_c = np_yc + nameplate_size[1] / 2 + row_gap + cap_height(row3[1]) / 2;
row2_c = row3_c + cap_height(row3[1]) / 2 + row_gap + cap_height(row2[1]) / 2;
row1_c = row2_c + cap_height(row2[1]) / 2 + row_gap + cap_height(row1[1]) / 2;

module coupon_band1() {
    square(plate, center = true);
    translate([0, -plate[1] / 2]) tab_2d();
}

module coupon_band2() {
    frame_2d(plate, frame_w);
    translate([-inner[0] / 2 + edge_gap, row1_c]) label_2d(row1[0], row1[1], max_w = 30, halign = "left");
    translate([2, row1_c]) difference() {
        translate([0, -patch[1] / 2]) square(patch);
        translate([(patch[0] - opening[0]) / 2, -opening[1] / 2]) square(opening);
    }
    translate([inner[0] / 2 - edge_gap - bar[0], row1_c - bar[1] / 2]) square(bar);
    translate([0, row2_c]) label_2d(row2[0], row2[1], max_w = plate_text_max);
    translate([0, row3_c]) label_2d(row3[0], row3[1], max_w = plate_text_max);
    translate([0, np_yc]) square(nameplate_size, center = true);
}

module coupon_band3()
    translate([0, np_yc]) label_2d("PAEDIATRICIAN", text_size, max_w = nameplate_size[0] - 2 * text_margin);

module coupon() {
    band1() coupon_band1();
    band2() coupon_band2();
    band3() coupon_band3();
}

// ---- slot test block -----------------------------------------------------------
block      = [52, 30, slot_d + slot_floor];   // 52 x 30 x 10, same floor and chamfers as the stand;
                                              // raised labels bring the part to 10.6
clearances = [0.2, 0.3, 0.4];                 // front to back
pitch      = 8;                               // slot spacing
slot_x     = -4;                              // slot centre; leaves room for the label at the right
label_x    = 18.5;

module slot_block() {
    band_colour(1) {
        difference() {
            chamfered_box(block, cb = chamfer_bottom, ct = stand_chamfer_top);
            for (i = [0 : len(clearances) - 1])
                translate([slot_x, (i - (len(clearances) - 1) / 2) * pitch, 0])
                    slot_cut(top = block[2], w = tab_t + clearances[i]);
        }
        for (i = [0 : len(clearances) - 1])
            translate([label_x, (i - (len(clearances) - 1) / 2) * pitch, block[2]])
                linear_extrude(height = detail_h) label_2d(str(clearances[i]), text_size);
    }
}

// ---- part selection -----------------------------------------------------------
if (part == "coupon") coupon();
else if (part == "slots") slot_block();
else assert(false, str("part = \"", part, "\": use \"coupon\" or \"slots\""));
