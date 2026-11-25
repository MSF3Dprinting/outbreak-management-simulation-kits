# Tabletop simulation training set – 3D printed parts

Parametric OpenSCAD models of the 3D printing material list for tabletop simulation training:
beds, patients, staff figures, equipment, room labels and precaution signs. 28 line items,
408 pieces on the list plus 58 universal stands – 466 printed parts from 59 STL files.
Design decisions are in `design_brief.md` (v1.0); the project record is in `STATUS.md`.

All parts print on a 200 × 200 mm bed with a 0.4 mm nozzle at 0.2 mm layers, without supports.
Colours come from the filament: multi-colour parts use manual colour changes between layers,
set in the slicer at the heights in the print table.

## Requirements

- Slicing only: any slicer that supports a colour change at a given layer (PrusaSlicer, Cura, …).
- Regenerating: OpenSCAD 2021.01 or newer, with the Liberation Sans font available (bundled with
  OpenSCAD on Windows and macOS; `fonts-liberation` on Linux). Without it OpenSCAD substitutes a
  font and every label width changes.
- Checking: Python 3 with numpy for `check_part.py`.

## Files

| File | Purpose |
|---|---|
| `design_brief.md` | The design: every item's size, shape, colour bands and parameters (v1.10) |
| `STATUS.md` | Project record: stages, files, values confirmed by test prints, open issues |
| `README.md` | This file |
| `common.scad` | Shared values and helpers; every model includes it. Slot clearances live here |
| `bucket_lib.scad`, `pictogram_lib.scad` | Shared bucket shapes; plate layout and the ten pictograms (loaded with `use`) |
| `stand.scad`, `test_coupon.scad` | Universal stand; stage 1 test coupon (`part="coupon"`) and slot test block (`part="slots"`) |
| `waste_bin.scad`, `sharps_box.scad`, `hand_rub_bottle.scad`, `hand_washing_point.scad`, `mop_and_bucket.scad` | Upright equipment (`part="bucket"` / `"mop"`) |
| `bed.scad`, `bed_sheet.scad`, `screen.scad`, `trolley.scad` | Furniture (`bed_label="1"`…`"20"`, `"I-1"`…`"I-6"`, or `""` for an empty bed; the trolley is printed as `version="small"`) |
| `neonate.scad`, `adult_patient.scad`, `syringe.scad`, `blood_culture_bottle.scad`, `antibiotic_vial.scad` | Patients and tokens |
| `figure.scad` | Staff figures (`role="male_doctor"`, `"pmr"`, `"lab_manager"`, `"nurse_lead"`, `"paediatrician"`, `"caretaker"`) |
| `room_label.scad`, `sign.scad`, `equipment_card.scad` | Room labels (`room=…`), precaution signs (`type="contact"` / `"droplet"` / `"airborne"`) and the patient equipment card |
| `export_all.sh` | Exports all 59 STLs into `stl/`; `--check` runs the checker on each |
| `export_beds.sh` | Exports the 26 numbered beds and the empty bed into `beds_stl/` and `beds_stl.zip` |
| `check_part.py` | Checks an STL: bounding box, heights of flat faces (band boundaries), overhangs beyond 45° |
| `design_objects.pdf` | One-table overview of all 34 design objects: picture, name, description, quantity and number of colours |
| `make_design_objects_pdf.py` | Renders `thumbs/` and rebuilds `design_objects.pdf` (needs reportlab and pillow) |
| `thumbs/` | The preview images used in the PDF |
| `stl/` | The 59 STL files, binary, with size and colour-change note in the 80-byte header |

## Regenerating and checking

    ./export_all.sh                 # all STLs into stl/  (about a minute)
    ./export_all.sh --check         # export, then check every STL against its expected size
    ./export_beds.sh                # the 26 beds only, plus beds_stl.zip
    openscad -o stl/bed_07.stl --export-format binstl -D 'bed_label="7"' bed.scad     # one part
    openscad -o sign_contact_fr.stl --export-format binstl -D 'type="contact"' -D 'language="fr"' sign.scad
    python3 check_part.py stl/screen.stl --expect 80x20x30.6                          # one check
    python3 make_design_objects_pdf.py            # re-render the previews and rebuild the PDF
    python3 make_design_objects_pdf.py --skip-thumbs   # rebuild the PDF from the existing previews

Both scripts take the path to the OpenSCAD binary as an argument if it is not on the PATH.
Every model is parametric: the values at the top of each file are the parameters listed in the
brief, and the shared values (bands, tab and slot, font, minimum sizes, bed size) are in
`common.scad` only.

## Two languages on one part

The room labels, the precaution signs, the patient equipment card and the staff figures carry the English wording on the front,
raised in the second colour, and the French on the back, engraved and mirrored: turn the part over to
change language. The back is engraved rather than coloured because only the face away from the print
bed can carry raised detail. Each of those models also takes `language="fr"`, which swaps the sides, so
a mission that works mainly in French can print the French wording raised and coloured instead (the
command above shows how). The French wording is listed in `design_objects.pdf`.

`design_objects.pdf` is the plain overview to hand to anyone choosing parts; the print table below is the
working list for the slicer, with the colour-change heights.

## Print table

Copies are the numbers on the material list (`design_brief.md` section 3). Z is the height of
the colour change measured from the bed; in the slicer, put the change on the first layer
above it (2.2 for 2.0, 2.8 for 2.6, 4.2 for 4.0, 20.2 for 20.0, 22.2 for 22.0, 26.8 for 26.6).
PLA unless stated; "flat" parts print face-up, on their back.

| Item | STL | Copies | Print | Colours and changes at Z (mm) |
|---|---|---|---|---|
| Hospital bed, standard 1–20 | `bed_01`…`bed_20` | 40 (2 of each) | Upright | 2: body silver or grey; number from 20.0 |
| Hospital bed, isolation I-1–I-6 | `bed_I-1`…`bed_I-6` | 12 (2 of each) | Upright | 2: body; number from 20.0 – other body colour than the standard beds |
| Hospital bed, empty (no number) | `bed_empty` | 6 | Upright | 1 |
| Black sheet for an empty bed | `bed_sheet` | 6 | Flat | 1, black — laid on the mattress, fits any bed |
| Patient, neonate | `neonate` | 56 | Flat | 1 — 20 brown, 12 blue, 12 red, 12 green |
| Patient, female adult | `adult_patient` | 56 | Flat | 1 — 20 brown, 12 blue, 12 red, 12 green |
| Room labels | `room_sluice` 2, `room_nurse_station` 4, `room_consultation` 2, `room_patient_toilet` 2, `room_shower` 2 | 12 | Flat, stands in the stand | 2: plate; pictogram and text from 2.0. French engraved on the back |
| Trolley | `trolley_small` | 6 | Upright | 1 |
| Screen | `screen` | 20 | Upright, brim optional | 3: feet and bottom rail; curtain from 4.0; top rail from 26.6 |
| Waste bin, blue | `waste_bin` | 8 | Upright | 1, blue |
| Waste bin, red | `waste_bin` | 8 | Upright | 1, red |
| Sharps box | `sharps_box` | 8 | Upright | 1, yellow |
| Hand washing point | `hand_washing_point` | 10 | Upright | 1, white |
| Alcohol hand rub bottle | `hand_rub_bottle` | 10 | Upright | 2: body (white); neck and pump from 22.0 (light blue) |
| Mop and bucket | `mop_bucket`, `mop` | 12 of each | Bucket upright, mop flat | 1 each, light blue |
| Syringe with needle | `syringe` | 20 | Flat | 1, clear PETG |
| Blood culture bottle | `blood_culture_bottle` | 20 | Flat | 2, PETG: bottle clear; blood red from 2.0 |
| Staff figures | `figure_male_doctor` 2, `figure_pmr` 2, `figure_lab_manager` 2, `figure_nurse_lead` 2, `figure_paediatrician` 2, `figure_caretaker` 6 | 16 | Flat | 3: base (skin, hair, trousers or skirt, tab); clothing and nameplate from 2.0 (white for coats); label and details from 2.6. French engraved on the back |
| Universal stand | `stand` | 58 | Flat on its base | 1 |
| Precaution signs | `sign_contact` 10, `sign_droplet` 10, `sign_airborne` 10 | 30 | Flat | 2: plate; pictogram and text from 2.0. French engraved on the back |
| Antibiotic vial | `antibiotic_vial` | 30 | Upright | 1 — six each in white, blue, red, yellow and green |
| Patient equipment card | `equipment_card` | 10 | Flat | 2: card; pictograms and text from 2.0. French engraved on the back |
| Test prints (stage 1) | `test_coupon`, `test_slots` (with one `stand`) | 1 each | Flat | coupon 3: changes at 2.0 and 2.6 |

Flat parts with the same colour plan share a plate and one set of colour changes: all figures
printed with the same three filaments need only the changes at 2.2 and 2.8; labels, signs and the
blood culture bottle share the change at 2.2.

The figures and signs stand in the universal stand: the 30 × 8 mm tab goes into the slot and the
nameplate or sign face rests on the stand. Print the standard bed number colour and the
isolation bed colour as the group's convention requires; the models are identical apart from the
number.

## Filament

Sliced from the STLs in this package with PrusaSlicer (0.2 mm layers, 0.4 mm nozzle, 2 perimeters,
15 % gyroid infill, no supports). Colours other than the ones the brief fixes (blue and red bins,
white and light blue hand rub, white coats, yellow sharps boxes, transparent tokens) are a proposal.

| Prusament PLA | Prints | Filament | Buy |
|---|---|---|---|
| Gravity Grey | 40 standard beds, 58 stands, 6 empty beds, 20 screen frames, 6 trolleys | 1 477 g | 2 × 1 kg |
| Vanilla White | 30 sign plates, 10 hand washing points, 12 room-label plates, 10 equipment cards, 10 hand-rub bodies, 6 vials, 6 white coats | 660 g | 1 × 1 kg |
| Azure Blue | 20 screen curtains, 12 mop-and-bucket sets, 24 blue patients, 8 blue bins, 6 vials, 10 hand-rub pumps, 2 nurse scrubs | 289 g | 1 × 1 kg |
| Pineapple Yellow | 12 isolation beds, 8 sharps boxes, 6 vials | 275 g | 1 × 1 kg |
| Mystic Brown | 16 figure bases, 20 neonates, 20 adults | 188 g | 1 × 1 kg |
| Lipstick Red | 24 red patients, 8 red bins, 6 vials, 6 caretaker dresses, 2 MSF vests | 114 g | 1 × 1 kg |
| Jet Black | 6 bed sheets, all text and numbers, all pictograms | 92 g | 1 × 1 kg |
| Grass Green | 24 green patients, 6 vials | 63 g | 1 × 1 kg |

PLA total 3 142 g; add about 10 % for purge at colour changes and failed parts, so roughly 3.4 kg. Green is new: the blue, red and green patients replace the stickers used to mark suspect, probable or confirmed and contact. The five vial colours are taken from this list, so they need no extra spool.

The syringes and blood culture bottles are the only transparent parts: 36 g and 24 g clear plus 2 g
red. Neither is on the November material list; both stay in the set at 20 each, as asked. There is no clear Prusament PLA, so either print them in Prusament PETG Clear and PETG Carmine
Red as the brief specifies, or, to keep the whole set in one material, in Prusament PLA Natural
(milky translucent) with the Lipstick Red above. A part must not mix PLA and PETG across its colour
change.

## Values still to confirm by a test print

Print `test_coupon.stl` (three filaments, changes on the 2.2 and 2.8 mm layers), `test_slots.stl`
and one `stand.stl`. Stand the coupon in each of the three slots (0.2, 0.3, 0.4 mm clearance) and
check whether the 0.6 mm colour bands cover a dark base. Then set `slot_clearance` (and, if the
tab is tight lengthwise, `slot_end_clearance`) in `common.scad` and re-export the stands and the
mop bucket with `export_all.sh`. The models were checked in OpenSCAD only; no part had been
printed when this package was made.
