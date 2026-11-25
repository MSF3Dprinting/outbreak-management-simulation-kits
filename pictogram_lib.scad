// pictogram_lib.scad - plate layout shared by the room labels (design_brief.md 4.4) and the
// precaution signs (4.16), and the pictograms as 2D modules.  Load with
//     use <pictogram_lib.scad>
// Pictograms are simple filled shapes drawn in a 20 x 20 box centred on the origin, strokes
// and openings 1.2 mm or more (picto_min); pictogram_2d() scales one to any size >= 20.
// No cross symbols (easily confused with the protected red cross emblem).
include <common.scad>

picto_box = 20;                  // design size of every pictogram

// Vertical layout of a plate: pictogram above two text lines, centred in an inner area
// inner_h tall (plate minus frame, or the sign face). Returns the y of the pictogram centre
// and of the two text line centres, relative to the middle of the inner area.
function plate_rows(inner_h, picto, gap, size1, line_gap, size2) =
    let(c1 = cap_height(size1), c2 = cap_height(size2),
        top = (picto + gap + c1 + line_gap + c2) / 2)
    [top - picto / 2, top - picto - gap - c1 / 2, top - picto - gap - c1 - line_gap - c2 / 2];

// Plate content in Band 2: pictogram, two text lines, optional frame. `inner` is the area the
// rows are centred in; `frame` draws frame_2d(plate, frame_w) when frame_w > 0.
module plate_content_2d(name, plate, frame_w, picto, gap, line1, size1, line_gap, line2, size2, inner = undef) {
    inn = is_undef(inner) ? [plate[0] - 2 * frame_w, plate[1] - 2 * frame_w] : inner;
    rows = plate_rows(inn[1], picto, gap, size1, line_gap, size2);
    max_w = inn[0] - 2 * text_margin;
    if (frame_w > 0) frame_2d(plate, frame_w);
    translate([0, rows[0]]) pictogram_2d(name, picto);
    translate([0, rows[1]]) label_2d(line1, size1, max_w = max_w);
    translate([0, rows[2]]) label_2d(line2, size2, max_w = max_w);
}

// Pictogram as an outline w wide, for engraving on the back of a two-sided part.
module pictogram_outline_2d(name, size = picto_box, w = picto_min)
    outline_2d(w) pictogram_2d(name, size);

// Back of a two-sided plate: the same rows with the pictogram as an outline and the text of the
// other language, to be mirrored and engraved. line2 may be empty.
module plate_back_2d(name, plate, picto, gap, line1, size1, line_gap, line2, size2, inner = undef) {
    inn = is_undef(inner) ? plate : inner;
    rows = plate_rows(inn[1], picto, gap, size1, line_gap, size2);
    max_w = inn[0] - 2 * text_margin;
    translate([0, rows[0]]) pictogram_outline_2d(name, picto);
    translate([0, rows[1]]) label_2d(line1, size1, max_w = max_w);
    if (len(line2) > 0) translate([0, rows[2]]) label_2d(line2, size2, max_w = max_w);
}

module pictogram_2d(name, size = picto_box) scale(size / picto_box) {
    if (name == "sluice") picto_sluice_2d();
    else if (name == "nurse_station") picto_nurse_station_2d();
    else if (name == "consultation") picto_consultation_2d();
    else if (name == "patient_toilet") picto_patient_toilet_2d();
    else if (name == "shower") picto_shower_2d();
    else if (name == "glove") picto_glove_2d();
    else if (name == "surgical_mask") picto_surgical_mask_2d();
    else if (name == "respirator") picto_respirator_2d();
    else if (name == "bp_machine") picto_bp_machine_2d();
    else if (name == "thermometer") picto_thermometer_2d();
    else assert(false, str("no pictogram \"", name, "\""));
}

// stroke helper: line of width w between two points, round ends
module line_2d(a, b, w = picto_min) hull() { translate(a) circle(d = w); translate(b) circle(d = w); }

// Sluice room: bedpan with a downward arrow above it
module picto_sluice_2d() {
    hull() { for (x = [-5, 5]) translate([x, -3.5]) circle(r = 2.5); translate([-7.5, -3]) square([15, 2]); }   // pan
    translate([7, -2.6]) square([3, 1.6]);                                                                    // handle
    translate([-0.8, 4]) square([1.6, 5.5]);                                                                  // arrow shaft
    polygon([[-3.5, 4], [3.5, 4], [0, 0.5]]);                                                                 // arrow head
}

// Nurse station: person behind a desk
module picto_nurse_station_2d() {
    translate([-9, -3]) square([18, 2.4]);                                                   // desk top
    for (x = [-8.8, 7.2]) translate([x, -8.5]) square([1.6, 5.5]);                            // legs
    hull() { for (x = [-3.2, 3.2]) translate([x, 1.4]) circle(r = 1.6); translate([-4.8, -0.2]) square([9.6, 0.5]); }  // shoulders
    translate([0, 6.8]) circle(d = 4.5);                                                     // head
}

// Consultation room: stethoscope
module picto_consultation_2d() {
    difference() {                                                                           // U tube
        translate([-1.5, 2.5]) circle(r = 5);
        translate([-1.5, 2.5]) circle(r = 5 - 1.6);
        translate([-7, 2.5]) square([11, 6]);
    }
    for (s = [-1, 1]) {                                                                      // ear tubes from the arch
        line_2d([-1.5 + s * 4.2, 2.5], [-1.5 + s * 5.3, 6.3], 1.6);                          //   ends, splayed outward
        translate([-1.5 + s * 5.5, 7.2]) circle(d = 2.2);                                    // ear tips
    }
    line_2d([-1.5, -2.5], [3.5, -6], 1.6);                                                   // tube to the chest piece
    translate([4.8, -6.6]) circle(r = 2.6);                                                  // chest piece
}

// Patient toilet: toilet bowl, side view - cistern with lid, seat, bowl with a sloped front, pedestal
module picto_patient_toilet_2d() {
    translate([-9, -2]) square([4.5, 9]);                                                    // cistern
    translate([-9.8, 7]) square([6, 1.6]);                                                   // lid
    translate([-6, 1]) square([15.5, 2.4]);                                                  // seat
    polygon([[-5, 1.5], [8.5, 1.5], [8.5, -1], [5.5, -4.5], [1, -6], [-5, -6]]);              // bowl
    translate([-4.5, -9.5]) square([6.5, 4]);                                                // pedestal
}

// Shower room: shower head with falling drops
module picto_shower_2d() {
    translate([-0.8, 6]) square([1.6, 4]);                                                   // pipe
    polygon([[-6.5, 3.5], [6.5, 3.5], [4, 6.5], [-4, 6.5]]);                                 // head
    for (p = [[-4.6, 0.6], [-1.5, -0.8], [1.5, 0.6], [4.6, -0.8], [-3.1, -4.2], [0, -5.6], [3.1, -4.2], [-1.5, -9]])
        translate(p) circle(r = 1);                                                          // drops
}

// ---- precaution signs (4.16) --------------------------------------------------------------
// Contact: glove - palm with cuff, four fingers (1.9 wide, 1.2 gaps) and a thumb
module picto_glove_2d() {
    hull() { for (x = [-3.6, 3.6]) translate([x, 1.6]) circle(r = 2); translate([-5.6, -4.5]) square([11.2, 6]); }  // palm
    translate([-4.8, -9.5]) square([9.6, 5.5]);                                              // cuff
    for (i = [0 : 3]) let(x = -4.65 + i * 3.1, h = [6.5, 8.5, 8, 6.5][i])                    // fingers
        hull() { translate([x - 0.95, 2]) square([1.9, 1]); translate([x, h - 0.95]) circle(r = 0.95); }
    hull() { translate([4.5, -3]) circle(r = 1.3); translate([8.3, 0.8]) circle(r = 1.3); } // thumb
}

// Droplet: surgical mask - pleated rectangle with an ear loop standing off each side
module picto_surgical_mask_2d() {
    difference() {
        rounded_rect_2d([11, 7.5], 0.8, 16);                                                 // mask
        for (y = [-1.5, 1.5]) translate([-4.1, y - 0.6]) square([8.2, 1.2]);                 // pleat lines
    }
    for (s = [-1, 1]) difference() {                                                         // ear loops
        translate([s * 6.5, 0]) circle(r = 3.5);
        translate([s * 6.5, 0]) circle(r = 3.5 - 1.2);
        translate([s * 6.5 - (s > 0 ? 7 : 0), -4]) square([7, 8]);
    }
}

// Airborne: respirator - cup mask with two head straps on each side
module picto_respirator_2d() {
    hull() { translate([-7, 1.5]) square([14, 3]); translate([0, -2.5]) circle(r = 5.5); }   // cup
    for (s = [-1, 1]) { line_2d([s * 6.5, 3.5], [s * 9.4, 6]); line_2d([s * 5.2, -4.5], [s * 9.4, -7.5]); }  // straps
}

// ---- dedicated patient equipment (4.18) ----------------------------------------------------
// Blood pressure machine: aneroid gauge with a needle, over a cuff. Strokes are 1.6 mm, not the
// 1.2 mm minimum, so they stay above it on the equipment card, where the pictogram is 15 mm.
module picto_bp_machine_2d() {
    difference() {                                                                           // gauge
        translate([0, 4.5]) circle(r = 4.8);
        translate([0, 4.5]) circle(r = 4.8 - 1.6);
    }
    line_2d([0, 4.5], [2.4, 6.9], 1.6);                                                      // needle
    line_2d([0, 0.2], [0, -3], 1.6);                                                         // tube
    rounded_rect_2d_at([0, -6], [15, 6], 1.5);                                               // cuff
}

// Clinical thermometer, tilted as the symbol is usually drawn: bulb, stem and three scale marks.
// Marks 1.6 mm wide, 1.6 mm apart, for the same reason as the gauge above.
module picto_thermometer_2d() rotate(22) {
    translate([0, -6.5]) circle(r = 3.4);                                                    // bulb
    hull() { translate([0, -4.5]) circle(d = 3.8); translate([0, 8.6]) circle(d = 3.8); }    // stem
    for (y = [0, 3.2, 6.4]) line_2d([2.2, y], [5.4, y], 1.6);                                // scale
}

// rounded_rect_2d centred on a point
module rounded_rect_2d_at(c, size, r) translate(c) rounded_rect_2d(size, r);
