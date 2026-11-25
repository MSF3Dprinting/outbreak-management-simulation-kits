# STATUS – Tabletop simulation training set

**Updated:** 13 November 2026 · **Brief:** `design_brief.md` v1.10 · **Next:** test print, then production printing

## Stages

| # | Stage | Status | Review gate |
|---|---|---|---|
| 1 | Foundation, stand, test coupon | Done – sizes and text approved on the render; test print deferred (no printer) | Test print |
| 2 | Upright equipment | Done | Shape review |
| 3 | Furniture | Done | Number legibility and proportions |
| 4 | Patients and tokens | Done | Silhouette review |
| 5 | Staff figures A (layout, male doctor) | Done – approved | Figure style |
| 6 | Staff figures B (five roles) | Done | Role review |
| 7 | Room labels | Done – approved (stethoscope corrected) | Pictogram style |
| 8 | Precaution signs | Done | Wording and pictograms |
| 9 | Final package | Done | Final review |
| – | Feedback round 1 (trolley, English/French) | Done – sent for review as `design_objects.pdf` | French wording and the flagged questions |

## Files in the project folder

| File | Created in | State |
|---|---|---|
| `design_brief.md` | Briefing | v1.1: modelling decisions as "Modelled:" notes; feedback round 1 folded in |
| `STATUS.md`, `README.md` | Briefing, stage 9 | This record; the README has the file list, regeneration steps and the print table |
| `stage_prompts.md` | Briefing | Kept by Silvestr; not part of the package |
| `common.scad`, `check_part.py` | Stage 1 | Shared values and helpers (`slot_clearance` 0.3 / `slot_end_clearance` 0.5 for every slot); STL checker (`--expect LxWxH`, needs numpy) |
| `stand.scad`, `test_coupon.scad` | Stage 1 | Universal stand; test coupon (`part="coupon"` / `"slots"`) |
| `bucket_lib.scad`, `waste_bin.scad`, `sharps_box.scad`, `hand_rub_bottle.scad`, `hand_washing_point.scad`, `mop_and_bucket.scad` | Stage 2 | Upright equipment |
| `bed.scad`, `export_beds.sh`, `screen.scad`, `trolley.scad` | Stage 3 | Furniture; the script exports the 26 beds and `beds_stl.zip` |
| `neonate.scad`, `adult_patient.scad`, `syringe.scad`, `blood_culture_bottle.scad` | Stage 4 | Patients and tokens |
| `figure.scad` | Stages 5–6 | Six staff roles |
| `pictogram_lib.scad`, `room_label.scad`, `sign.scad` | Stages 7–8 | Layout, ten pictograms, room labels, signs; two-sided, `language="en"` / `"fr"`; room labels on the sign plate since v1.7 |
| `antibiotic_vial.scad`, `equipment_card.scad`, `bed_sheet.scad` | Feedback 3–4 | Antibiotic vial Ø12 × 20 in five colours; dedicated-equipment card 50 × 50 |
| `export_all.sh` | Stage 9 | Exports all 59 STLs to `stl/` with header notes; `--check` runs the checker on each, with `--engraved 0.6` on the two-sided parts |
| `design_objects.pdf`, `make_design_objects_pdf.py`, `thumbs/` | Stage 9 | Overview PDF of the 30 design objects (picture, name, description, quantity, number of colours), 4 pages A4, and the script that rebuilds it from the models |
| `stl/` (59 STLs), `tabletop_simulation_set.zip` | Stage 9 | Package: all `.scad`, `.sh`, `.py`, `.md` files, the STLs, the PDF and its previews |

Stage 9 checks: every `.scad` includes `common.scad` and none reassigns or copies its values (one name clash in `hand_washing_point.scad` and one literal in `waste_bin.scad` fixed, geometry unchanged). `export_all.sh --check`: 59 STLs exported with OpenSCAD 2021.01, no warnings, every one a single solid, all sizes exact, band faces on layer boundaries, no overhangs beyond 45°.

## Values confirmed by test prints

| Value | Brief | Confirmed |
|---|---|---|
| Slot clearances (`slot_clearance` / `slot_end_clearance`) | 0.3 / 0.5 mm | Not yet – no printer was available. Stand the coupon in each slot of `test_slots.stl`, set both once in `common.scad`, re-export stands and mop bucket |
| Colour band thickness over a dark base | 0.6 mm | Not yet – print `test_coupon.stl` with a light Band 2 on a dark base |

Measured in OpenSCAD 2021.01 (renders): capitals 0.955 × size, strokes 0.20 × size; all label widths in the brief match within 0.1 mm.

## Feedback round 1 (14 September 2026)

Trolley: only the small version is printed, 6 of them; the large one stays in the model as an option, so the syringe and bottle tokens are no longer carried on a tray. Room labels, signs and figures are two-sided: English raised on the front, French engraved and mirrored on the back (`engrave_cut` in `common.scad`, 45° stepped cut, nothing printed over air); `language="fr"` swaps the sides. Figure nameplate 15 mm, part 60 × 83. The French toilet label was corrected to TOILETTES PATIENT. Sent as `design_objects.pdf` (table plus a page of the French sides, no commentary). Still to confirm, kept here rather than in the PDF: the French wording itself; RESPONSABLE / LABORATOIRE and DIRECTEUR / DES SOINS are shortened because "Responsable/Manageur laboratoire" and "Directeur/trice des soins" do not fit 60 mm; the plates read MD and PAEDIATRICIAN while the list gives "Medical Doctor" and "Pediatrician".

## Feedback round 4 (25 November 2026)

Wording added to the patient equipment card, two-sided in the style of the room labels and signs: PATIENT / EQUIPMENT raised on the front, ÉQUIPEMENT / PATIENT engraved and mirrored on the back, three pictograms on both sides. The card keeps its shape — 50 × 50 flat, no tab, no stand. Pictograms 20 → 15 mm to make room for the text; the blood pressure machine and thermometer were redrawn with 1.6 mm strokes so nothing falls under the 1.2 mm minimum at that size. First attempt turned the card into a 70 × 56 standing sign, which was wrong and has been undone: stands stay at 58. 466 printed parts, 3 142 g of PLA. No other object touched.

## Corrections after feedback 3 (13 November 2026)

Two faults found by the advisor. (1) The empty bed's black sheet was a colour band at Z 8.0–8.6, a Z range the head and foot boards also occupy, so a single-extruder printer would have printed a black line across the boards; it is now a separate part, `bed_sheet.scad` 66 × 38 × 2.0, laid on the mattress, and the bed is one colour. The sheet drops onto a numbered bed as well. (2) In `design_objects.pdf` the French-side previews of the five room labels drew the engraved text 24 mm low, outside the plate: the preview overlay had not been moved onto the sign face when the labels took the sign plate. Parts were correct; only the preview was wrong. 59 STLs, 466 printed parts, 3 136 g of PLA.

## Feedback round 3 (13 November 2026)

From `3D_printing_material_list_with_new_suggestions.docx`. Room labels stand in the universal stand like the precaution signs, so they take the sign plate (60 × 48 face + tab, no frame, 24 mm pictogram, text size 5) — half the filament of the 90 × 70 tile. New: empty bed (`bed_label=""`, black sheet at Z 8.0, no number, 6 off), antibiotic vial Ø12 × 20 in five colours (30), dedicated-equipment card 50 × 50 with BP machine, thermometer and stethoscope pictograms (10). Quantity and colour changes: standard beds silver or grey, hand washing point white, mop and bucket light blue, patients 20 brown + 12 each blue/red/green, hand rub 26 → 10, stands 46 → 58. Screen and blood culture bottle are absent from the new list but kept at 20 each on the user's instruction. 58 STLs, 460 printed parts, 3 105 g of PLA across 8 colours (green is new) plus 62 g PETG.

## Feedback round 2 (16 September 2026)

Beds have imitated legs inside the footprint: the four corners keep the full outline up to 5 mm and the sides between them are set in 1.5 mm, flaring back at 45°; the groove moves to 6.5 mm. Still 80 × 40 × 20.6 and upright without support. Isolation beds numbered I-1 to I-6, so the files are `bed_I-1.stl` to `bed_I-6.stl`. Sharps box resized to the hand rub bottle, 16 × 14 × 28. Room labels enlarged to 90 × 70 mm, long side across (34 mm pictogram, text size 7); the coupon samples the room size with a shorter string. Brief v1.3; all 55 STLs re-exported and checked, filament re-sliced, PDF rebuilt.

## Filament (16 September 2026)

Sharps boxes are yellow (brief v1.2). Filament list in `README.md`, sliced from the STLs: Gravity Grey 1 477 g, Vanilla White 660 g, Azure Blue 289 g, Pineapple Yellow 275 g, Mystic Brown 188 g, Lipstick Red 114 g, Jet Black 92 g, Grass Green 63 g — 3 142 g of PLA, about 3 kg with purge and failures, 8 spools. Transparent tokens 36 g + 26 g: PETG Clear and Carmine Red as in the brief, or PLA Natural (milky, not clear) to keep the set in one material.

## Deviations from the brief

All folded into `design_brief.md` v1.1 ("Modelled:" notes in sections 2–4 and the revision note). The main ones: character-table width estimate; 0.4 mm corner rounding from the chamfer method and 0.6 mm relief inset; 0.01 mm band overlap; hand rub pump head by a 45° flare; hand washing stand 1 mm forward; waste bin pedal 2 mm high as listed; mop bucket lugs; bed chamfers; trolley wheels sunk into the table; figure body 27.2 mm wide; clothing, pictogram and sign drawings as built.

## Open issues

- Both test-print values above.
- Liberation Sans Bold must be available where the models render (bundled on Windows and macOS; `fonts-liberation` on Linux), or OpenSCAD substitutes a font and every width changes.
- `check_part.py` ignores faces under 0.05 mm² (below a nozzle footprint) and reports how many it skipped.

## Next step

Second round of feedback on `design_objects.pdf`, in particular the French wording. Then print `test_coupon.stl`, `test_slots.stl` and one `stand.stl`, set the slot clearances in `common.scad` from the result, run `./export_all.sh --check`, and print the set from `stl/` following the print table in `README.md`.
