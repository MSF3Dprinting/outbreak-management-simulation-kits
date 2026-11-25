// figure.scad - staff figures (design_brief.md 4.14). One parametric model; `role` selects the
// silhouette, clothing, details and label. Part 60 x 80 x 3.2, printed flat, stands in the
// universal stand: body 60 tall (y 12-72), nameplate 60 x 12 (y 0-12), standard tab below (y -8-0).
// Band 1 (Z 0-2.0): the outline - skin, hair, trousers or skirt, tab. Band 2 (2.0-2.6): clothing
// and the nameplate, inset 0.6 from the outline. Band 3 (2.6-3.2): label, stethoscope, logo.
// Colour changes at Z 2.0 and 2.6. The back carries the role in the other language, engraved and
// mirrored, so one figure serves an English and a French speaking mission. Body: head dia 11, neck 5, torso 18,
// arms 3.0 beside it with a 1.6 gap, joined at shoulder and hand (27.2 wide), legs 5.7 / 4.
// Roles: male_doctor (white coat, short sleeves, to the knees, stethoscope), pmr (MSF vest,
// sleeveless, "MSF" on the chest), lab_manager (female, white coat with long sleeves, skirt
// below), nurse_lead (scrubs top and trousers), paediatrician (female, white coat with short
// sleeves, stethoscope), caretaker (long dress with long sleeves, headscarf framing the face).
// Export: openscad -o figure_pmr.stl -D 'role="pmr"' figure.scad   (one STL per role)
include <common.scad>

role       = "male_doctor";
label      = undef;              // overrides the role's label
label_size = text_size;          // 5: capitals 4.8, strokes 1.0
label_gap  = 1.2;                // between the two lines of a French label
body_h     = 60;
nameplate  = nameplate_size;     // [60, 12]
inset      = 0.6;                // clothing edge inside the outline
line_w     = picto_min;          // 1.2: stethoscope tube and drawn lines

// ---- roles ----------------------------------------------------------------------------
roles   = ["male_doctor", "pmr", "lab_manager", "nurse_lead", "paediatrician", "caretaker"];
labels  = ["MD", "PMR", "LAB MANAGER", "NURSE LEAD", "PAEDIATRICIAN", "CARETAKER"];
// French, engraved on the back; two lines where one would not fit the 60 mm nameplate
labels_fr1 = ["M\u00c9DECIN", "PMR", "RESPONSABLE", "DIRECTEUR", "P\u00c9DIATRE", "AIDANT"];
labels_fr2 = ["", "", "LABORATOIRE", "DES SOINS", "", ""];
silhouettes = ["male", "male", "female", "male", "female", "caretaker"];
coats   = [true, false, false, false, false, false];   // a coat to the knees closes the leg gap above them
function role_index(r, i = 0) = i >= len(roles) ? undef : roles[i] == r ? i : role_index(r, i + 1);
function role_label(r)  = is_undef(label) ? labels[role_index(r)] : label;
function role_label_fr(r, line = 1) = (line == 1 ? labels_fr1 : labels_fr2)[role_index(r)];
function role_gender(r) = silhouettes[role_index(r)];
function role_coat(r)   = coats[role_index(r)];

// ---- layout (absolute y; the stand top is y = 0) ----------------------------------------
y0        = 12;                  // body coordinates: the feet stand on y = 12
body_lift = nameplate[1] - y0;   // 3: lift onto the 15 mm nameplate, so the part is 83 tall
top       = y0 + body_h;         // 72 in body coordinates
head_r    = 5.5;                 // head dia 11
hair_r    = 6.5;                 // male short hair: cap 1 mm proud of the head, down to the ears
bun_r     = 2.5;
male_head_c   = top - hair_r;    // 65.5
female_head_c = top - 7.2;       // 64.8: the bun rises 1.7 above the head
bun_c         = top - bun_r;     // 69.5
torso_hw  = 9;
arm_w     = min_limb;            // 3.0
arm_x0    = torso_hw + min_gap;  // 10.6, inner edge of the arm
arm_x1    = arm_x0 + arm_w;      // 13.6, outer edge; body 27.2 wide
gap_y     = [41.5, 53.5];        // arm-torso gap; hands join below, shoulders above
neck_y    = 58.5;                // shoulder line
knee_y    = 26;
coat_f_y  = 32;                  // female coat hem: the skirt shows below it
sleeve_short_y = 50;             // short sleeves end here; long sleeves at the wrist, gap_y[0]
scarf_r   = 6.8;                 // caretaker headscarf around the head
scarf_c   = top - scarf_r;       // 65.2
face_r    = 4.8;                 // face inside the scarf, at base level

// half outlines (x >= 0) from the crotch on the axis to the neck top on the axis, 0.1 mm;
// mirrored() closes them. Legs 5.7 (male) / 4.0 (female) wide with a 1.6 mm gap.
male_half   = [[0, 33], [0.8, 32], [0.8, y0], [8.5, y0], [8.5, 14], [7.2, 15.5], [9, 35], [9, 37],
               [arm_x1, 37], [arm_x1, 55.5], [12.6, 57.5], [10.5, neck_y], [2.5, neck_y], [2.5, 62.5], [0, 62.5]];
female_half = [[0, 28], [0.8, 27], [0.8, y0], [6, y0], [6, 14], [4.8, 15.5], [4.8, knee_y], [12.5, knee_y],
               [9.8, 37], [arm_x1, 37], [arm_x1, 55.5], [12.6, 57.5], [10.5, neck_y], [2.5, neck_y], [2.5, 62.5], [0, 62.5]];
caretaker_half = [[0, y0], [12.5, y0], [9.8, 37], [arm_x1, 37], [arm_x1, 55.5], [12.6, 57.5], [10.5, neck_y],
                  [9.5, neck_y], [scarf_r, scarf_c], [0, scarf_c]];   // long dress to the hem, scarf drape to the shoulders
function mirrored(half) = concat(half, [for (i = [len(half) - 1 : -1 : 0]) if (half[i][0] != 0) [-half[i][0], half[i][1]]]);

module male_head_2d() {
    translate([0, male_head_c]) circle(r = head_r);
    intersection() {
        translate([0, male_head_c]) circle(r = hair_r);
        translate([-hair_r, male_head_c - 1]) square([2 * hair_r, hair_r + 1]);
    }
}
module female_head_2d() {
    translate([0, female_head_c]) circle(r = head_r);
    translate([0, bun_c]) circle(r = bun_r);
}
module scarf_outline_2d() {
    translate([0, scarf_c]) circle(r = scarf_r);
    polygon([[-9.5, neck_y], [9.5, neck_y], [scarf_r, scarf_c], [-scarf_r, scarf_c]]);
}
module torso_2d(half) difference() {
    polygon(mirrored(half));
    for (s = [-1, 1]) translate([s > 0 ? torso_hw : -arm_x0, gap_y[0]]) square([min_gap, gap_y[1] - gap_y[0]]);
}
module body_2d(g, coat = false) {
    if (g == "male") {
        torso_2d(male_half); male_head_2d();
        if (coat) translate([-0.8, knee_y - 0.5]) square([1.6, 34 - knee_y]);   // coat panel between the legs
    } else if (g == "female") { torso_2d(female_half); female_head_2d(); }
    else { torso_2d(caretaker_half); scarf_outline_2d(); }
}
module plate_and_tab_2d() {
    translate([0, nameplate[1] / 2]) square(nameplate, center = true);
    tab_2d();
}
module outline_2d(g, coat = false) {
    plate_and_tab_2d();
    translate([0, body_lift]) body_2d(g, coat);
}
module nameplate_2d() translate([0, nameplate[1] / 2]) rounded_rect_2d(nameplate, chamfer_bottom);

// ---- clothing and details per role (2D) ---------------------------------------------------
// White coat: the body between the hem and the shoulder line, inset, with a round neckline;
// the arms are bare below sleeve_y (short sleeves) or below the wrist (long sleeves).
module coat_2d(g, hem_y = knee_y, sleeve_y = sleeve_short_y) difference() {
    offset(delta = -inset) intersection() { body_2d(g, hem_y <= knee_y); translate([-20, hem_y]) square([40, neck_y - hem_y]); }
    translate([0, neck_y + 0.5]) circle(r = 4);
    for (s = [-1, 1]) translate([s > 0 ? torso_hw : -20, 0]) square([20 - torso_hw, sleeve_y]);
}
// Sleeveless vest on the torso, hips to shoulders, with a round neckline and armholes.
module vest_2d() difference() {
    offset(delta = -inset) intersection() { body_2d("male"); translate([-torso_hw, 37]) square([2 * torso_hw, neck_y - 37]); }
    translate([0, neck_y + 0.5]) circle(r = 4);
    for (s = [-1, 1]) translate([s * 9.5, 55.5]) circle(r = 3.2);
}
// Scrubs: top with short sleeves and a V neck, trousers to the ankles, a 1.2 mm line at the hem of the top.
module scrubs_2d() difference() {
    offset(delta = -inset) intersection() { body_2d("male"); translate([-20, 15]) square([40, neck_y - 15]); }
    polygon([[-3.5, neck_y + 1], [3.5, neck_y + 1], [0, 54]]);
    for (s = [-1, 1]) translate([s > 0 ? torso_hw : -20, 0]) square([20 - torso_hw, sleeve_short_y]);
    translate([-20, 36]) square([40, line_w]);
}
// Long dress with long sleeves, hem on the nameplate; headscarf ring around the face, draped to the shoulders.
module dress_2d() difference() {
    offset(delta = -inset) intersection() { body_2d("caretaker"); translate([-20, y0]) square([40, neck_y - y0]); }
    for (s = [-1, 1]) translate([s > 0 ? torso_hw : -20, 0]) square([20 - torso_hw, gap_y[0]]);
}
module scarf_2d() difference() {
    offset(delta = -inset) scarf_outline_2d();
    translate([0, scarf_c]) circle(r = face_r);
}
// Stethoscope: 1.2 mm U tube below the neckline, a tube hanging to one side and a dia 3.2
// chest piece, all on the coat.
module stethoscope_2d() {
    difference() {
        translate([0, 55]) circle(r = 5);
        translate([0, 55]) circle(r = 5 - line_w);
        translate([-6, 55]) square([12, 6]);
    }
    hull() { translate([0, 50.4]) circle(d = line_w); translate([2.8, 47.4]) circle(d = line_w); }
    translate([3.4, 46.2]) circle(d = 3.2);
}

module clothing_2d(r) {
    if (r == "male_doctor") coat_2d("male");
    else if (r == "pmr") vest_2d();
    else if (r == "lab_manager") coat_2d("female", coat_f_y, gap_y[0]);
    else if (r == "nurse_lead") scrubs_2d();
    else if (r == "paediatrician") coat_2d("female", coat_f_y);
    else if (r == "caretaker") { dress_2d(); scarf_2d(); }
}
module details_2d(r) {
    if (r == "male_doctor" || r == "paediatrician") stethoscope_2d();
    if (r == "pmr") translate([0, 47]) label_2d("MSF", label_size, max_w = 2 * (torso_hw - inset) - 2);
}

// ---- part -----------------------------------------------------------------------------------
// The engraved content of the back: the role in French, one or two lines on the nameplate.
module figure_back_2d(r = role) {
    l2 = role_label_fr(r, 2);
    max_w = nameplate[0] - 2 * text_margin;
    dy = len(l2) > 0 ? (cap_height(label_size) + label_gap) / 2 : 0;
    translate([0, nameplate[1] / 2 + dy]) label_2d(role_label_fr(r, 1), label_size, max_w = max_w);
    if (len(l2) > 0)
        translate([0, nameplate[1] / 2 - dy]) label_2d(l2, label_size, max_w = max_w);
}

module figure(r = role) {
    assert(!is_undef(role_index(r)), str("unknown role \"", r, "\"; use one of ", roles));
    difference() {
        band1() outline_2d(role_gender(r), role_coat(r));
        mirror([1, 0, 0]) engrave_cut() figure_back_2d(r);
    }
    band2() { nameplate_2d(); translate([0, body_lift]) clothing_2d(r); }
    band3() {
        translate([0, body_lift]) details_2d(r);
        translate([0, nameplate[1] / 2]) label_2d(role_label(r), label_size, max_w = nameplate[0] - 2 * text_margin);
    }
}
// Base silhouette without clothing or label, for style previews only.
module base_silhouette(g = "female") { band1() outline_2d(g); band2() nameplate_2d(); }

figure();
