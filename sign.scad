// sign.scad - transmission-based precaution signs (design_brief.md 4.16), placed at isolation
// beds in the universal stand. Two-sided: the front carries the pictogram and the wording raised
// in a second colour, the back the other language engraved (mirrored), so the same sign serves an
// English and a French speaking mission and both sides of the table can read it.
// Face 60 x 48 plus the standard tab (part 60 x 56 x 2.6), flat, one colour change at Z 2.0.
// type     = "contact" (glove) | "droplet" (surgical mask) | "airborne" (respirator)
// language = "en" (English on the front) or "fr" (French on the front)
// Export: openscad -o sign_contact.stl -D 'type="contact"' sign.scad  (one STL per type)
include <common.scad>
use <pictogram_lib.scad>

type       = "contact";
language   = "en";
face       = [60, 48];
picto      = 24;
gap        = 3;                 // pictogram to line 1
line_gap   = 2.6;               // line 1 to line 2
size1      = text_size_sign;    // 6: capitals 5.7, strokes 1.2
size2      = text_size;         // 5
size_back  = text_size;         // engraved at size 5; 1.0 mm strokes close at 0.5 deep

types  = ["contact", "droplet", "airborne"];
pictos = ["glove", "surgical_mask", "respirator"];
en1    = ["CONTACT", "DROPLET", "AIRBORNE"];        // English: keyword then PRECAUTIONS
en2    = "PRECAUTIONS";
fr1    = "PR\u00c9CAUTIONS";                         // French: PRECAUTIONS then the keyword
fr2    = ["CONTACT", "GOUTTELETTES", "AIR"];
function type_index(t, i = 0) = i >= len(types) ? undef : types[i] == t ? i : type_index(t, i + 1);

// The engraved content of the back, as a 2D shape centred on the sign face, not mirrored.
module sign_back_2d(t = type) {
    i = type_index(t);
    en = language != "fr";
    plate_back_2d(pictos[i], face, picto, gap,
                  en ? fr1 : en1[i], size_back, line_gap, en ? fr2[i] : en2, size_back);
}

module sign(t = type) {
    i = type_index(t);
    assert(!is_undef(i), str("unknown type \"", t, "\"; use one of ", types));
    en = language != "fr";
    difference() {
        band1() { translate([0, face[1] / 2]) square(face, center = true); tab_2d(); }
        translate([0, face[1] / 2]) mirror([1, 0, 0]) engrave_cut() sign_back_2d(t);
    }
    band2() translate([0, face[1] / 2])
        plate_content_2d(pictos[i], face, 0, picto, gap,
                         en ? en1[i] : fr1, en ? size1 : size2, line_gap,
                         en ? en2 : fr2[i], en ? size2 : size1);
}

sign();
