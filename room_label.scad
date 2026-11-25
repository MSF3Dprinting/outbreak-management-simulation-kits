// room_label.scad - room labels (design_brief.md 4.4): markers showing where each room is.
// Two-sided, so one label serves an English and a French speaking mission: the front carries the
// pictogram and the room name raised in a second colour, the back the other language engraved
// (mirrored, so it reads when the tile is turned over). Face 60 x 48 plus the standard tab
// (part 60 x 56 x 2.6), the same plate as a precaution sign, so a room label stands in the
// universal stand. Prints flat, one colour change at Z 2.0.
// room     = "sluice" | "nurse_station" | "consultation" | "patient_toilet" | "shower"
// language = "en" (English on the front, French engraved on the back) or "fr" (the other way round)
// Export: openscad -o room_sluice.stl -D 'room="sluice"' room_label.scad  (one STL per room)
include <common.scad>
use <pictogram_lib.scad>

room      = "sluice";
language  = "en";
face      = [60, 48];          // same as a precaution sign; the tab hangs below it
frame_w   = 0;                 // 1.6 draws a border frame; 0 keeps the sign format, which is
                               // what the room name needs at this width
size      = text_size_room;    // 5: capitals 4.8, strokes 1.0
size_back = text_size_room;    // engraved at the same size; 1.0 mm strokes close at 0.5 deep
picto     = 24;                // pictogram box
gap       = 3;                 // pictogram to line 1
line_gap  = 2.6;               // line 1 to line 2

rooms = ["sluice", "nurse_station", "consultation", "patient_toilet", "shower"];
en1   = ["SLUICE", "NURSE", "CONSULTATION", "PATIENT", "SHOWER"];
en2   = ["ROOM", "STATION", "ROOM", "TOILET", "ROOM"];
fr1   = ["SALLE", "SALLE DE", "SALLE DE", "TOILETTES", "DOUCHE"];
fr2   = ["VIDOIR", "SOINS", "CONSULTATION", "PATIENT", ""];
function room_index(r, i = 0) = i >= len(rooms) ? undef : rooms[i] == r ? i : room_index(r, i + 1);
function front1(i) = language == "fr" ? fr1[i] : en1[i];
function front2(i) = language == "fr" ? fr2[i] : en2[i];
function back1(i)  = language == "fr" ? en1[i] : fr1[i];
function back2(i)  = language == "fr" ? en2[i] : fr2[i];

// The engraved content of the back, as a 2D shape in part coordinates, not mirrored.
module room_label_back_2d(r = room) {
    i = room_index(r);
    plate_back_2d(r, face, picto, gap, back1(i), size_back, line_gap, back2(i), size_back,
                  inner = [face[0] - 2 * frame_w, face[1] - 2 * frame_w]);
}

module room_label(r = room) {
    i = room_index(r);
    assert(!is_undef(i), str("unknown room \"", r, "\"; use one of ", rooms));
    difference() {
        band1() { translate([0, face[1] / 2]) square(face, center = true); tab_2d(); }
        translate([0, face[1] / 2]) mirror([1, 0, 0]) engrave_cut() room_label_back_2d(r);
    }
    band2() translate([0, face[1] / 2])
        plate_content_2d(r, face, frame_w, picto, gap, front1(i), size, line_gap, front2(i), size);
}

room_label();
