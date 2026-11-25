// equipment_card.scad - dedicated patient equipment card (design_brief.md 4.18): a 50 x 50 mm
// card placed at a bed to show that the bed has its own blood pressure machine, thermometer and
// stethoscope. It lies flat on the table; it is not a standing sign and has no tab.
// Two-sided in the same way as the room labels and the signs: PATIENT / EQUIPMENT raised on the
// front, EQUIPEMENT / PATIENT engraved and mirrored on the back, the three pictograms on both
// sides. Band 1 (0-2.0) the card, Band 2 (2.0-2.6) pictograms and text. One change at Z 2.0.
// The pictograms are 15 mm, not the 20 mm they are drawn at, because the two lines of text need
// the height; at 15 mm every stroke is still 1.2 mm or more.
// language = "en" (English on the front) or "fr" (French on the front)
// Export: openscad -o equipment_card.stl equipment_card.scad
include <common.scad>
use <pictogram_lib.scad>

language  = "en";
card      = [50, 50];
picto     = 15;                 // pictogram box on the card
picto_gap = 2;                  // between the two rows and the two pictograms of the top row
gap       = 2;                  // pictogram block to line 1
line_gap  = 2;                  // line 1 to line 2
size      = text_size;          // 5: capitals 4.8, strokes 1.0
size_back = text_size;          // engraved at the same size; 1.0 mm strokes close at 0.5 deep

pictos = ["bp_machine", "thermometer", "consultation"];   // BP machine, thermometer, stethoscope
en1    = "PATIENT";
en2    = "EQUIPMENT";
fr1    = "ÉQUIPEMENT";
fr2    = "PATIENT";

block_h = 2 * picto + picto_gap;            // 32, two rows of pictograms
col_x   = (picto + picto_gap) / 2;          // 8.5, centres of the top row

// Two pictograms above, one below, filled for the front or outlined for the engraved back.
module picto_block_2d(outlined = false) {
    for (i = [0 : 2]) {
        pos = i < 2 ? [(i == 0 ? -1 : 1) * col_x, (picto + picto_gap) / 2]
                    : [0, -(picto + picto_gap) / 2];
        translate(pos)
            if (outlined) pictogram_outline_2d(pictos[i], picto);
            else pictogram_2d(pictos[i], picto);
    }
}

// Rows of the card, laid out by plate_rows() as on the labels and signs, with the pictogram
// block standing in for the single pictogram.
module content_2d(line1, line2, s, outlined = false) {
    rows = plate_rows(card[1], block_h, gap, s, line_gap, s);
    max_w = card[0] - 2 * text_margin;
    translate([0, rows[0]]) picto_block_2d(outlined);
    translate([0, rows[1]]) label_2d(line1, s, max_w = max_w);
    translate([0, rows[2]]) label_2d(line2, s, max_w = max_w);
}

// The engraved content of the back, as a 2D shape in card coordinates, not mirrored.
module equipment_card_back_2d() {
    en = language != "fr";
    content_2d(en ? fr1 : en1, en ? fr2 : en2, size_back, outlined = true);
}

module equipment_card() {
    en = language != "fr";
    difference() {
        band1() square(card, center = true);
        mirror([1, 0, 0]) engrave_cut() equipment_card_back_2d();
    }
    band2() content_2d(en ? en1 : fr1, en ? en2 : fr2, size);
}

equipment_card();
