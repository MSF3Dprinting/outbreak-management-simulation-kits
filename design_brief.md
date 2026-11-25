# Tabletop Simulation Training Set – 3D Printing Design Brief

**Version:** 1.10 · **Date:** 25 November 2026

**Source:** 3D printing material list – 28 line items, 328 pieces

**Status:** all 28 items modelled, checked and packaged (`tabletop_simulation_set.zip`); first round of feedback folded in; the stage 1 test print is still to be done

**Project files:** `design_brief.md` (this brief), `STATUS.md` (handover between stages), `stage_prompts.md` (prompt for starting each stage)

**Next step:** print `test_coupon.stl`, `test_slots.stl` and one `stand.stl`, set the slot clearances in `common.scad` from the result, then print the set (see `README.md`)

## Revision notes

**v1.10** – The dedicated patient equipment card keeps its shape: 50 × 50 mm, flat on the table, no tab and no stand. Only the wording is added, in the same two-sided way as the room labels and the signs: PATIENT / EQUIPMENT raised on the front, ÉQUIPEMENT / PATIENT engraved and mirrored on the back, the three pictograms on both sides. To make room for two lines of text the pictograms are 15 mm instead of 20; the blood pressure machine and the thermometer were redrawn with 1.6 mm strokes so that every stroke is still at least 1.2 mm at that size. (v1.9 had turned the card into a 70 × 56 mm standing sign, which was not what was asked.)

**v1.8** – Two corrections. The black sheet of the empty bed is a separate part (`bed_sheet.scad`), not a colour band: moulded into the bed it would need a colour change in a Z band the boards also occupy, so on a single-extruder printer the boards would come out black there too. The bed is now one colour and the sheet is laid on the mattress, where it also works on a numbered bed. In `design_objects.pdf` the French-side previews of the five room labels drew their engraved text 24 mm below the plate, outside the part, because the preview overlay was not moved onto the sign face with the rest of the content; the parts themselves were correct.

**v1.7** – Third round of feedback (`3D_printing_material_list_with_new_suggestions.docx`). Room labels now stand in the universal stand like the precaution signs, so they take the sign plate: 60 × 48 mm face plus the tab, no frame, 24 mm pictogram, text size 5. Three items added: an empty bed with a black sheet and no number (4.1), an antibiotic vial in five colours (4.17) and a dedicated-patient-equipment card (4.18). Quantities and colours follow the new list: standard beds silver or grey, hand washing point white, mop and bucket light blue, 20 brown patients of each kind plus 12 blue, 12 red and 12 green of each to mark suspect, probable or confirmed and contact, 10 alcohol hand rub bottles. Screen and blood culture bottle are not on the new list but stay in the set at their previous quantities, as asked.

**v1.6** – The bed legs stay inside the 80 × 40 footprint: the four corners keep the full outline and the sides between them are set in 1.5 mm instead, flaring back out at 45°. The frame groove moves up to 6.5 mm, above the legs.

**v1.5** – Room labels are 90 × 70 mm, the long side across as before. The extra width lets the room name go to text size 7 and the pictogram to 34 mm. (v1.4 had the tile the wrong way round, 70 × 90.)

**v1.3** – Second round of feedback. The beds have imitated legs: a block at each corner stands 1.5 mm proud of the body, so a bed is 83 × 43 mm over the legs and still prints upright without support. Isolation beds are numbered I-1 to I-6. The sharps box is about the size of the hand rub bottle, 16 × 14 × 28 mm.

**v1.2** – Sharps boxes are printed yellow. Filament list added to `README.md`: seven Prusament PLA colours and the transparent tokens, from the sliced STLs.

**v1.1** – First round of feedback (French toilet corrected to TOILETTES PATIENT in the second pass). Only the small trolley is needed, so the set has 6 of it and the large version stays in the model as an option. The room labels, precaution signs and staff figures are now two-sided: English on the front, raised in the second colour as before, and French on the back, engraved and mirrored, so one part serves an English and a French speaking mission. The figure nameplate is 15 mm tall (two engraved lines fit), so a figure is 60 × 83 mm. 55 STLs.

**v1.0** – All nine stages complete: 22 model files, 56 STLs, `export_all.sh`, `README.md`. The modelling decisions recorded in `STATUS.md` are folded into sections 2–4 as "Modelled:" notes; the plan in section 5 is kept as the record. Main changes from v0.5: text widths are estimated from a character table in `common.scad`; the bottom chamfer of flat parts rounds convex corners by 0.4 mm and same-colour relief is inset 0.6 mm; the staff figure body is 27.2 mm wide; the hand rub pump head is reached by a 45° flare; trolley wheels are discs sunk into the table; figure clothing, pictograms and signs are described as drawn. The slot clearance and the 0.6 mm colour coverage remain to be confirmed by the stage 1 test print.

**v0.5** – Stage 1 delivered (`common.scad`, `check_part.py`, `stand.scad`, `test_coupon.scad`). Sizes and text of the stage 1 parts approved on the render; text metrics and all label widths confirmed in OpenSCAD 2021.01. Slot clearance made a shared parameter for every model with a slot: `slot_clearance` (width, 0.3 mm) and `slot_end_clearance` (length, 0.5 mm) in `common.scad`, to be set once from the stage 1 test print. No printer is available at present, so the print is deferred and stage 2 proceeds with these values; the mop bucket slot (4.11) now follows the same parameters.

**v0.4** – Brief moved to Markdown. Section 5 now names every file each stage attaches and produces; the stage prompts are in `stage_prompts.md`, and `STATUS.md` has been created. The stage 1 test print now tests slot widths, because the tab thickness is fixed by the base band. Stages with several variants show one combined preview image.

**v0.3** – Different scales for small and large items confirmed. Isolation beds numbered I1–I6. Figures one-sided. Pictograms added to room labels. Screen height set to bed height + 10 mm. Hand washing point changed to a bucket-with-tap station. Trolley in two versions. Spelling PAEDIATRICIAN, so the nameplate, stand and signs are 60 mm wide. Implementation plan added.

**v0.2** – Base 2.0 mm with 0.6 mm colour bands. Bed number on the footboard. One item per model. Blood culture bottle as a base silhouette plus an offset blood layer. Colours set by filament. Mixed genders.

## 1. Purpose

This brief defines every item on the material list before modelling starts. For each item it gives the size, shape, colour bands and colour-change heights, print orientation, OpenSCAD parameters, and what changed from the list and why. Label widths were measured with the OpenSCAD font, so the proposed sizes are known to fit. Section 5 splits the modelling into stages.

## 2. Design basis (all items)

**Process:** FDM, single extruder, 0.4 mm nozzle, 0.2 mm layer height. Every part fits a 200 × 200 mm bed and prints without supports.

**Material:** PLA by default. The items are non-clinical and are not disinfected, so raised text and relief details are acceptable. Transparent parts in clear PETG. A part stays in one material family through its colour changes, because PLA and PETG do not bond reliably to each other.

**Minimum sizes:** walls, plates and freestanding features at least 1.6 mm. Base of every flat part at least 2.0 mm. Features that stick out and get handled (needle, tap, mop handle, trolley handle) at least 2.4 mm in both directions. Necks and limbs of silhouettes at least 3 mm wide. Gaps in outlines at least 1.6 mm.

**Raised details:** text and lines in a colour band have strokes of at least 1.0 mm and are 0.6 mm high. The stroke minimum is a deliberate exception to the 1.6 mm wall rule, because a detail on a solid base is not a wall.

**Text:** Liberation Sans Bold (bundled with OpenSCAD), capitals only, OpenSCAD text size 5 or larger. Measured in OpenSCAD 2021.01: capital height ≈ 0.955 × size and stroke ≈ 0.2 × size, so size 5 gives 4.8 mm capitals with 1.0 mm strokes. All strings are parameters; other scripts need a font that supports them.

**Modelled:** OpenSCAD 2021.01 has no `textmetrics()`, so `common.scad` estimates string widths from a table of per-character advance and ink widths measured in OpenSCAD 2021.01 (`text_width()`); the estimate never reads narrow, but up to 2 mm wide on strings with the kerned pairs AT, TA or PA. `label_2d()` draws a string and stops the render when the estimate exceeds the space given. All label widths in this brief were verified by rendering and match within 0.1 mm.

**Pictograms:** simple filled shapes in the raised band, with strokes and openings of at least 1.2 mm. No cross symbols, which are easily confused with the protected red cross emblem.

**Handling:** every part is at least 12 mm across in its narrowest horizontal direction and at least 20 mm in its longest direction.

**Overhangs and edges:** no overhang beyond 45° from vertical and no bridges. Bottom edges chamfered 0.4 mm against elephant's foot; exposed top edges softened with a 0.6–1.0 mm chamfer.

**Modelled:** on flat parts the bottom chamfer is made by a minkowski cone (`extrude_chamfered`), which rounds the convex corners of the Band 1 outline by 0.4 mm; a raised feature flush with the outline gets the same rounding (`frame_2d`), and other raised features stay at least 0.6 mm inside the outline. Flat parts have no top chamfer. Thin open rims (bucket, basin, trolley tray) are not chamfered. Boxes and cylinders are built as exact polyhedra (`ring_stack`, `chamfered_box`, `chamfered_cylinder`).

**Orientation:** flat parts print face-up with the back on the bed. Upright parts print standing, as they are used. Where colour has to change along the height of a standing object (staff figures, signs), the part prints flat and stands in a separate stand.

**Colour bands:** at most three colours per part. A band is a range of print layers in one colour; colours change only between layers, as manual colour changes set in the slicer. Every colour after a change is at least 0.6 mm (3 layers), on a base of at least 2.0 mm. A detail is either raised into a higher band or shown as an opening in a band that reveals the colour below. Colours are set by the filament at print time. On the first test print, check a light colour on a dark base (for example a white coat on brown): at 0.6 mm it can look slightly tinted, and band heights are parameters if an adjustment is needed.

**Modelled:** each upper band starts 0.01 mm inside the band below (`band_overlap`), so every STL is one solid; the printed geometry is unchanged. A same-colour relief (neonate wrap, adult dress) is a raised region inset 0.6 mm from the outline.

**Standard bands for flat parts:** Band 1 (base) Z 0–2.0 mm (10 layers), full outline. Band 2 Z 2.0–2.6 mm (3 layers). Band 3 Z 2.6–3.2 mm (3 layers). All flat items use these heights, so copies of different items can share a plate and one colour-change plan.

**Setting a colour change:** insert the change on the first layer above the boundary, for example the layer shown as 2.20 mm for a 2.0 mm boundary in PrusaSlicer-type slicers. Colour-banded parts must be sliced at 0.2 mm so boundaries fall on layer lines.

**Scale:** small and large items use different scales so every item handles well. Beds, patients, staff and screens are about 1:25 (bed 80 × 40 mm ≈ 2 × 1 m). Equipment is enlarged where true scale would be too small to handle. Consumables (hand rub, sharps box, syringe, blood culture bottle) are oversized tokens.

**Two-sided parts:** the room labels (4.4), precaution signs (4.16) and staff figures (4.14) carry the English wording on the front and the French on the back, and are turned over to change language. Only the front can carry raised detail in a second colour, because the back is the face on the print bed. The back is therefore engraved: the cut narrows by one layer per layer (45°, `engrave_cut` in `common.scad`), so nothing is printed over air, and a stroke of width w closes at w/2 deep. Back text is mirrored, at least 1.0 mm in stroke, and a pictogram appears as a 1.2 mm outline rather than a filled shape. Each model takes `language="en"` (default) or `"fr"`, which swaps the two sides, so a mission that reads mainly French can print the French side raised and coloured.

**Stand and tab:** one universal stand (4.15) for every standing flat part. Every standing part carries the same tab: 30 × 8 mm, Band 1 only (2.0 mm thick).

**Slot clearances:** every slot in the set (the stand, the slot test block and the mop bucket) takes its clearance from two shared parameters in `common.scad`: `slot_clearance`, the slot width minus the thickness of the part it holds (0.3 mm), and `slot_end_clearance`, the slot length minus the length of the part (0.5 mm). One test print sets both for all models; until a printer is available, these values stand.

**OpenSCAD structure:** each model produces a single item; copies are made before printing. `common.scad` holds the shared values (bands, tab and slot, font, minimum sizes, clearances, bed dimensions) and helpers. One parametric file per item family, with variants selected by parameter. Each colour band is its own module, so the model previews in colour. Plain OpenSCAD without external libraries, in syntax that runs on OpenSCAD 2021.01 and newer. One STL per variant, as binary STL with its size and colour-change heights written in the 80-byte header; `export_all.sh` exports all 56 and can run `check_part.py` on each.

**Quantities:** the quantities in this brief are the number of copies to make.

## 3. Summary of items

Z is the height where the colour changes, measured from the print bed. "None" means a single-colour print.

| Item | Qty | Listed | Proposed (mm) | Colours | Print / changes at Z (mm) |
|---|---|---|---|---|---|
| 4.1 Hospital bed, standard (1–20) | 40 | 8 × 4 cm | 80 × 40 × 20.6 | 2 | Upright / 20.0 |
| 4.1 Hospital bed, isolation (I-1–I-6) | 12 | 8 × 4 cm | 80 × 40 × 20.6 | 2 | Upright / 20.0 |
| 4.1 Hospital bed, empty (no number) | 6 | 8 × 4 cm | 80 × 40 × 20.0 | 1 | Upright / none |
| 4.1 Black sheet for an empty bed | 6 | – | 66 × 38 × 2.0 | 1 | Flat / none |
| 4.2 Patient, neonate | 56 | 1/3 of bed | 30 × 15 × 2.6 | 1 | Flat / none |
| 4.3 Patient, female adult | 56 | ¾ of bed | 60 × 22 × 2.6 | 1 | Flat / none |
| 4.4 Room labels (5 names) | 12 | 5 × 5 cm | 60 × 56 × 2.6 | 2 | Flat / 2.0; stands in the stand; French engraved on the back |
| 4.5 Trolley, small | 6 | 2 × 3 cm | 30 × 20 × 26 | 1 | Upright / none |
| 4.6 Screen | 20 | Bed + 1 cm | 80 long × 30.6 high, feet 20 deep | 2 | Upright / 4.0 and 26.6 |
| 4.7 Waste bin, blue | 8 | 1 × 1.5 cm | Ø18 × 24 (19 × 21.5 × 24 with lid and pedal) | 1 | Upright / none |
| 4.7 Waste bin, red | 8 | 1 × 1.5 cm | Ø18 × 24 | 1 | Upright / none |
| 4.8 Sharps box | 8 | 0.5 × 1 cm | 16 × 14 × 28 | 1 | Upright / none |
| 4.9 Hand washing point (bucket with tap) | 10 | 2 × 2 cm | 28 × 36 × 40 | 1 | Upright / none |
| 4.10 Alcohol hand rub bottle | 10 | 0.5 × 0.5 cm | Ø14 × 28 | 2 | Upright / 22.0 |
| 4.11 Mop and bucket | 12 | 1 × 1.5 cm | Bucket Ø24 × 18 (28.8 over the lugs); mop 52 × 14 × 3.4 | 1 each | Upright and flat / none |
| 4.12 Syringe with needle | 20 | 0.5 × 0.5 cm | 46 × 14 × 2.6 | 1 | Flat / none |
| 4.13 Blood culture bottle | 20 | 0.5 × 0.5 cm | 32 × 14 × 2.6 | 2 | Flat / 2.0 |
| 4.14 Staff figures (6 roles) | 16 | ¾ of bed | 60 × 83 × 3.2 (body 60 tall, 27.2 wide) | 3 | Flat / 2.0 and 2.6; French engraved on the back |
| 4.15 Universal stand (new) | 58 | – | 60 × 26 × 10 | 1 | Flat / none |
| 4.16 Precaution signs (3 types) | 30 | 2 × 2 cm | 60 × 56 × 2.6 | 2 | Flat / 2.0; French engraved on the back |
| 4.17 Antibiotic vial (5 colours) | 30 | – | Ø12 × 20 | 1 | Upright / none |
| 4.18 Patient equipment card | 10 | 5 × 5 cm | 50 × 50 × 2.6 | 2 | Flat / 2.0; French engraved on the back |

## 4. Item briefs

### 4.1 Hospital beds – standard and isolation

**Represents:** ward bed with head and foot boards. One design: standard and isolation beds differ only in filament colour and number.

**Quantity:** standard 40 (numbers 1–20, two sets); isolation 12 (numbers I-1 to I-6, two sets); empty 6 (no number); 27 variants.

**Size:** listed 8 × 4 cm. Proposed 80 × 40 mm footprint (unchanged), 20.6 mm high. Nothing stands out past the footprint.

**Shape:** solid bed block with the mattress top at 8 mm. Footboard 10 mm thick and headboard 3 mm thick, both with their tops at 20 mm. The headboard may be lower but never higher, because nothing may rise above the numbered footboard. The clear mattress length between the boards is 67 mm, so the 60 mm adult patient lies on it. Optional 1 mm V-groove (45° flanks) around the sides at 6.5 mm, above the legs, to separate frame and mattress.

**Legs:** imitated, not open, and inside the footprint. Each of the four corners keeps the full outline up to 5 mm over a block 9 mm along the bed and 7 mm across; the sides between the corners are set in 1.5 mm from the bed plate to 3.5 mm and flare back out to the full outline at 45° by 5 mm. The corners then read as legs with a recessed skirt between them, nothing projects past 80 × 40 mm, and no face points downward, so the bed still prints upright without support. A real open frame would need bridges.

**Bed number:** raised 0.6 mm on the top face of the footboard. Text size 7: capitals 6.7 mm, strokes 1.4 mm. Widest labels: "I-4" is 10.5 mm, "20" is 10.0 mm. Reads upright when viewed from the foot end.

**Colour bands:** bed body in one colour, number in a second. One change at Z 20.0 mm; the number (20.0–20.6 mm) is the only geometry above it. Standard beds are printed silver or grey, isolation beds yellow.

**Empty bed:** `bed_label = ""` gives a bed with no number, in a single colour, for a bed whose patient has died; the part is 80 × 40 × 20.0 mm. 6 of them.

**Black sheet:** a separate part, `bed_sheet.scad`, 66 × 38 × 2.0 mm, printed flat in black and laid on the mattress between the head and foot boards, where the boards hold it in place. It is not a colour band: the mattress surface lies at Z 8.0 and the boards run from there to Z 20, so a sheet moulded into the bed would share its Z band with the boards and a single-extruder printer would give the boards a black line too. As a loose part it also drops onto a numbered bed, so any bed can be marked empty. 6 of them.

**Modelled:** foot end at +x. Groove on by default. 0.6 mm chamfer on the mattress side edges and the board tops, leaving an 8.8 mm flat on the footboard for the 6.7 mm capitals (an assert in `bed.scad` guards this). `export_beds.sh` exports the 26 variants.

**Printing:** upright on its base.

**OpenSCAD parameters:** `bed_label` ("1" to "20", "I-1" to "I-6"), text size, board heights and thicknesses, groove and legs on/off, leg size, height and inset.

**Changed from list:** height defined; I- prefix on isolation beds; imitated legs added within the footprint. The number is on the footboard because on the mattress it would need two colour changes: the boards rise above the mattress and would pick up a band of the number colour.

### 4.2 Patient – neonate

**Represents:** newborn lying in a bed or with its mother, seen from above.

**Quantity:** 56: 20 brown, and 12 each in blue, red and green.

**Size:** listed 1/3 of bed (≈ 27 mm). Proposed 30 × 15 mm, 2.6 mm thick.

**Shape:** swaddled baby: round head about 11 mm and a wrapped oval body. Base 2.0 mm; the wrap is raised 0.6 mm in the same colour and the face stays at base level. No feature narrower than 3 mm.

**Modelled:** head at x = 0. The wrap is inset 0.6 mm from the outline, with a 1.2 mm V-shaped fold opening toward the head; the face is a Ø7.4 base-level disc inside a 1.2 mm raised ring.

**Colour bands:** single colour. Brown is an unaffected patient; blue, red and green mark suspect, probable or confirmed, and contact — the colour replaces the stickers the group used before, and the group decides which colour means what.

**Printing:** flat.

**OpenSCAD parameters:** length, width, head size, wrap relief on/off.

**Changed from list:** length 27 → 30 mm; thickness defined.

### 4.3 Patient – female adult

**Represents:** adult woman lying in bed, seen from above.

**Quantity:** 56: 20 brown, and 12 each in blue, red and green.

**Size:** listed ¾ of bed. Proposed 60 × 22 mm, 2.6 mm thick.

**Shape:** female pictogram: head about 10 mm with a hair or bun outline, arms along the body, dress shape, legs. Neck at least 5 mm, limbs at least 3 mm, gaps at least 1.6 mm. Base 2.0 mm; the dress is raised 0.6 mm in the same colour to give the outline depth.

**Modelled:** head at x = 0, feet at x = 60. Bun Ø5 at the crown; a 1.2 mm raised hair ring around a base-level face; arms 3.2 mm wide with a 1.8 mm gap, joining the dress at the hands; legs 3.8 mm wide with a 1.6 mm gap; dress with a round neckline, inset 0.6 mm.

**Colour bands:** single colour. Brown is an unaffected patient; blue, red and green mark suspect, probable or confirmed, and contact — the colour replaces the stickers the group used before, and the group decides which colour means what.

**Printing:** flat.

**OpenSCAD parameters:** length, width, relief on/off.

**Changed from list:** width and thickness defined.

### 4.4 Room labels

**Represents:** markers placed on the table to show where each room is. Not to scale.

**Quantity:** 12: sluice room 2, nurse station 4, consultation room 2, patient toilet 2, shower room 2.

**Size:** listed 5 × 5 cm. Proposed the precaution-sign plate: a 60 × 48 mm face with the standard 30 × 8 mm tab below it, 60 × 56 mm in all, 2.6 mm thick.

**Shape:** base plate 2.0 mm, no frame, as on a precaution sign. Raised 0.6 mm in Band 2: a 24 × 24 mm pictogram at the top and two lines of text below it: SLUICE / ROOM, NURSE / STATION, CONSULTATION / ROOM, PATIENT / TOILET, SHOWER / ROOM. Text size 5: capitals 4.8 mm, strokes 1.0 mm. The pictogram, a 3 mm gap and the two text lines, 2.6 mm apart, take 39.2 of the 48 mm face, leaving about 4.4 mm above and below. The label stands in the universal stand (4.15), so a room marker and a precaution sign are the same size on the table.

**Pictograms:** sluice room – bedpan with a downward arrow. Nurse station – person behind a desk. Consultation room – stethoscope. Patient toilet – toilet bowl, side view. Shower room – shower head with falling drops.

**Modelled:** all pictograms are filled shapes drawn in a 20 × 20 mm box with 1.2 mm minimum strokes and gaps in `pictogram_lib.scad`, scaled by `pictogram_2d()` for the 24 mm signs. As drawn: a bedpan trough with a handle under a downward arrow; head and shoulders behind a desk on two legs; a stethoscope with ear tubes continuing from the arch, a tube and a chest piece; a toilet side view with cistern, lid, seat, sloped bowl and pedestal; a shower head on a pipe with eight drops. Layout: pictogram 20, gap 3, lines at 5.5 with a 2.6 mm line gap, 5.3 mm above and below (`plate_rows()`, shared with the signs).

**Colour bands:** tile in one colour; pictogram, text and frame in a second. One change at Z 2.0 mm.

**Printing:** flat.

**Back:** the same rows engraved and mirrored, with the pictogram as a 1.2 mm outline and the room name in French at size 5: SALLE / VIDOIR, SALLE DE / SOINS, SALLE DE / CONSULTATION, TOILETTES / PATIENT, DOUCHE. Turn the tile over to change language.

**OpenSCAD parameters:** `room` ("sluice", "nurse_station", "consultation", "patient_toilet", "shower"; selects the text lines and pictogram), `language` ("en" or "fr"), text size, face size, frame width (0 by default; 1.6 draws a border).

**Changed from list:** 50 × 50 → the 60 × 48 mm sign face plus a tab, so the label stands (v1.7 feedback). The border frame is dropped: at 60 mm wide the frame would leave 52.8 mm for the text, and CONSULTATION needs 51.7 mm at size 5, which is the smallest size with 1.0 mm strokes. Without the frame it has 56 mm to use and the vertical margins stay at 4.4 mm.

### 4.5 Trolley

**Represents:** procedure or dressing trolley. The large version carries tokens.

**Quantity:** 6, all the small version. The model still makes the large one (`version="large"`), which is not part of the set.

**Size:** listed 2 × 3 cm. Small: 30 × 20 mm footprint (as listed), 26 mm high including the handle. Large: 52 × 34 mm footprint, 30 mm high including the handle.

**Shape:** solid body (small 20 mm, large 24 mm high) with a tray recess on top, 1.6 mm deep. Rim 1.6 mm, widened to 2.4 mm at the handle end, where a 2.4 mm push handle plate rises 6 mm. The large tray is 48.0 × 30.8 mm inside and holds a syringe (46 × 14 mm) and a blood culture bottle (32 × 14 mm) side by side. The bottom 5 mm is set in by 1.2 mm with a 45° step, so the body looks raised on wheels. Four wheels embossed on the long sides, touching the table: Ø6 mm small, Ø8 mm large. Optional drawer lines as 45° V-grooves.

**Modelled:** each wheel is a disc sunk into the table by 0.35 of its radius, so it has a flat bottom on the bed and no face beyond 42° from vertical (a full disc would overhang on its underside). Drawer lines on by default (large two, small one). The 1.6 mm tray rim keeps square edges. Handle at +x.

**Colour bands:** single colour.

**Printing:** upright.

**OpenSCAD parameters:** `version` ("small", "large"), or free length, width and height; handle on/off; wheel diameter; drawer lines on/off.

**Changed from list:** height and details defined. Only the small version is printed (v1.1 feedback); with the large one dropped, the syringe and blood culture bottle tokens are not carried on a tray. No open shelves or separate legs, which would need bridges.

### 4.6 Screen

**Represents:** mobile privacy screen beside a bed.

**Quantity:** 20.

**Size:** listed "1 cm bigger than the bed", read as height. Proposed 30.6 mm high (bed height 20.6 mm + 10 mm), 80 mm long (bed length), 3.2 mm thick, feet 20 mm deep.

**Shape:** straight panel standing on its whole bottom edge (a gap underneath would need a bridge). Curtain 2.4 mm thick; top rail, bottom rail and end posts 3.2 mm, with a 45° step where the top rail widens. Two feet 20 × 3.2 × 3 mm across the panel at the ends. Height and length are taken from the bed values in `common.scad`.

**Colour bands:** Z 0–4.0 mm feet and bottom rail, 4.0–26.6 mm curtain, 26.6–30.6 mm top rail. Changes at 4.0 and 26.6 mm. The end posts follow the same bands.

**Modelled:** the curtain sits on the wider bottom rail as an upward 0.4 mm ledge; the top rail widens from the curtain at 45°, with the step above the posts filled; top rail edges chamfered 0.6 mm.

**Printing:** upright. A brim is optional for the thin walls.

**OpenSCAD parameters:** height above bed, length, curtain and frame thickness, foot length, rail heights.

**Changed from list:** dimensions defined; "bigger than the bed" read as height.

### 4.7 Waste bins – blue and red

**Represents:** pedal bins for two waste streams.

**Quantity:** 8 blue, 8 red.

**Size:** listed 1 × 1.5 cm. Proposed Ø18 × 24 mm.

**Shape:** round body 21 mm high, closed top. Lid 3 mm with a 0.5 mm lip (45° underneath). Foot pedal 7 × 3 × 2 mm at the front, standing on the table.

**Modelled:** the lid (Ø19) and the pedal make the part 19 × 21.5 × 24 mm. The pedal is 2 mm high as listed, below the 2.4 mm minimum for handled protrusions; it is a stub on the bed (`pedal_size` is a parameter). The body uses `bucket()` from `bucket_lib.scad`.

**Colour bands:** single colour; one design for both bins.

**Printing:** upright.

**OpenSCAD parameters:** diameter, height, lid lip, pedal on/off.

**Changed from list:** 10 × 15 → 18 × 24 mm for handling.

### 4.8 Sharps box

**Represents:** sharps safety box.

**Quantity:** 8.

**Size:** listed 0.5 × 1 cm. Proposed 16 × 14 × 28 mm, about the size of the hand rub bottle (Ø14 × 28 mm).

**Shape:** box body 26 mm high. The top tapers inward at 45° to a 12 × 10 mm top face with a Ø6 mm opening, 3 mm deep (2 mm wall to the edge).

**Colour bands:** single colour, yellow, as sharps safety boxes are.

**Printing:** upright.

**OpenSCAD parameters:** length, width, height, opening diameter.

**Changed from list:** 5 × 10 → 16 × 14 × 28 mm, matched to the hand rub bottle so the two consumables are the same size on the table.

### 4.9 Hand washing point – bucket with tap

**Represents:** field hand washing station: a water bucket with a tap on a stand, and a basin that catches the water.

**Quantity:** 10.

**Size:** listed 2 × 2 cm. Proposed 28 × 36 mm footprint, 40 mm high.

**Shape:** base plate 28 × 36 mm, 2.0 mm thick. Stand 20 × 20 mm at the back of the plate, up to 24 mm, with a pointed-arch opening from front to back (12 mm wide, vertical sides to 14 mm, 45° roof to 20 mm), so it reads as two 4 mm legs and a top bar. Water bucket Ø20 × 14 mm on the stand, lid 2 mm with a 0.5 mm lip (45° underneath). Tap near the bottom of the bucket: 3 × 3 mm spout reaching 5 mm forward, its underside a 45° wedge back to the bucket, with a 2.4 mm handle block on top. Catch basin Ø14 × 6 mm with a 1.6 mm wall, on the plate in front of the stand, with the spout tip over it.

**Modelled:** front is −y. The stand is 1 mm forward of the back edge so the Ø21 lid stays within the plate; the basin sits 0.2 mm in front of the stand with the spout tip 2 mm inside its rim; parts standing on the plate or stand reach 0.5 mm into it. Plate top edges chamfered 0.6 mm.

**Colour bands:** single colour, white.

**Printing:** upright.

**OpenSCAD parameters:** base size, stand height, arch size, bucket diameter and height, tap height and reach, basin size.

**Changed from list:** 20 × 20 → 28 × 36 mm footprint, height defined; bucket-with-tap station instead of a sink. The stand is a block with an arch rather than a table on separate legs, which would need bridges.

### 4.10 Alcohol hand rub bottle

**Represents:** pump bottle of alcohol hand rub at the point of care.

**Quantity:** 10.

**Size:** listed 0.5 × 0.5 cm. Proposed Ø14 × 28 mm.

**Shape:** round body to 18 mm; 45° shoulder to a Ø6 mm neck at 22 mm; pump head Ø8 mm up to 28 mm; short 3 × 3 mm spout with a 45° underside.

**Modelled:** the Ø8 head is reached from the Ø6 neck by a 45° flare (neck 22–24, flare 24–25, head 25–28), because a step would be a 1 mm bridge. The spout reaches 3 mm forward, to the body radius; its 45° wedge runs back into the body.

**Colour bands:** body and shoulder in one colour, neck and pump in a second (listed white/light blue). One change at Z 22.0 mm.

**Printing:** upright.

**OpenSCAD parameters:** diameter, body height, pump height, change height.

**Changed from list:** 5 × 5 → Ø14 × 28 mm.

### 4.11 Mop and bucket

**Represents:** cleaning mop standing in a bucket.

**Quantity:** 12 sets, each a bucket and a mop.

**Size:** listed 1 × 1.5 cm. Proposed bucket Ø24 mm top, Ø20 mm bottom, 18 mm high; mop 52 × 14 × 3.4 mm.

**Shape:** bucket: open, 2.0 mm wall, 4 mm floor with a slot for the mop head (head size plus the shared slot clearances from `common.scad`: 14.5 × 3.7 mm at the defaults, 3 mm deep) that holds the mop upright, and two small side lugs with 45° undersides. Mop: flat part with a 3.4 mm wide handle and a 14 × 12 mm head with fringe notches at least 1.6 mm wide. The handle stands about 35 mm above the rim.

**Modelled:** lugs 4 mm wide × 3 mm high, reaching 2.4 mm out at the rim (bucket 28.8 mm over the lugs); 1 mm floor under the slot. Mop along x with three notches 1.6 × 5 mm and 2.3 mm strands; the bottom chamfer narrows the first layer of each strand to 1.5 mm.

**Colour bands:** separate parts, each in a single colour, light blue.

**Printing:** bucket upright, mop flat.

**OpenSCAD parameters:** `part` ("bucket", "mop"), bucket diameters and height, wall and floor thickness, slot clearances (from `common.scad`), mop length.

**Changed from list:** the mop is a separate part printed lying down. Printed upright, the handle would be a thin column with layer lines across it and would snap.

### 4.12 Syringe with needle

**Represents:** syringe with needle. Token, not to scale.

**Quantity:** 20.

**Size:** listed 0.5 × 0.5 cm. Proposed 46 × 14 mm, 2.6 mm thick.

**Shape:** flat silhouette, in line: thumb press, plunger rod 4 mm wide, finger flange 14 mm, barrel 9 × 22 mm, hub, needle 2.4 mm wide × 9 mm with a rounded tip. The whole outline is 2.6 mm thick (base 2.0 mm + 0.6 mm), so the needle meets the 2.4 mm handling minimum. Barrel marks are 0.6 mm deep grooves.

**Modelled:** one 2.6 mm extrusion (a single colour needs no band) with five 1.2 × 5 mm grooves 0.6 mm deep across the barrel; plunger end at x = 0.

**Colour bands:** single colour (clear PETG).

**Printing:** flat.

**OpenSCAD parameters:** overall length, barrel width, needle length and width, marks on/off.

**Changed from list:** 5 × 5 → 46 × 14 mm; needle 2.4 mm wide so it survives handling.

### 4.13 Blood culture bottle

**Represents:** blood culture bottle half filled with blood. Token, not to scale.

**Quantity:** 20.

**Size:** listed 0.5 × 0.5 cm. Proposed 32 × 14 mm, 2.6 mm thick.

**Shape:** Band 1 (base, 0–2.0 mm) is the full bottle silhouette: body 14 × 21 mm with rounded bottom corners, 45° shoulder to an 8 mm neck, cap 10 × 6 mm. Band 2 (2.0–2.6 mm) is the blood, filling the lower half of the body and offset 1.6 mm from the edges, so the bottle silhouette stays visible around it.

**Modelled:** the blood is the body outline inset 1.6 mm, cut at half the body length (`fill` parameter); bottle bottom at x = 0.

**Colour bands:** bottle and blood in separate colours (listed clear and red, both PETG). One change at Z 2.0 mm.

**Printing:** flat.

**OpenSCAD parameters:** size, fill level, edge offset.

**Changed from list:** 5 × 5 → 32 × 14 mm. The red half is a top layer rather than a split along the bottle, which manual colour changes cannot do in a flat part.

### 4.14 Staff figures

The six roles share one layout, so a single parametric model produces one figure per role. Each figure prints flat as one part and stands in the universal stand (4.15). Figures are one-sided. Genders not given on the list were assigned to give a mix: PMR and nurse lead male, lab manager female.

**Represents:** staff and a caretaker standing in the ward.

**Quantity:** 16: male doctor 2, PMR 2, lab manager 2, nurse lead 2, female paediatrician 2, caretaker 6.

**Size:** listed ¾ of bed. Proposed body 60 mm tall; whole part 60 × 80 mm, 3.2 mm thick.

**Layout:** from the top: body (60 mm tall, 27.2 mm wide), nameplate 60 × 15 mm under the feet, tab 30 × 8 mm under the nameplate, so the part is 60 × 83 mm. Standing, the nameplate rests on the stand and the tab is hidden in the slot. The nameplate is 15 mm tall so that a two-line French label fits on the back.

**Shape:** pictogram style: head about 11 mm, neck at least 5 mm wide, arms and legs at least 3 mm wide, gaps at least 1.6 mm. Arms stay close to the body and join it at hand level, so no limb is a loose cantilever.

**Modelled:** torso 18 mm with 3.0 mm arms beside it and 1.6 mm gaps, joined at shoulder and hand, which makes the body 27.2 mm wide (the earlier 26 mm cannot hold with these values, and the PMR vest needs the 18 mm front). Male hair is a cap 1 mm proud of the head down to the ears; the female head sits 0.7 mm lower under a Ø5 bun; the caretaker has her own outline: long dress to the nameplate, no neck, headscarf Ø13.6 around a Ø9.6 base-level face, draped to the shoulders. Clothing is inset 0.6 mm from the outline; a coat to the knees closes the leg gap above the knees in the outline. Female coats end at mid-thigh so the skirt shows below. The PMR vest runs from the hips to the shoulders with a round neckline and armholes, "MSF" at chest height on a 16.8 mm front. Nurse scrubs have a V neck, short sleeves, trousers to the ankles and a 1.2 mm base-colour line at the hem of the top. The stethoscope is a 1.2 mm U below the neckline with a tube to one side and a Ø3.2 chest piece, all on the coat.

**Colour bands:** Band 1 (base, 0–2.0 mm): whole outline, face, hands and anything not covered by clothing, plus the tab. Band 2 (2.0–2.6 mm): clothing and the whole nameplate. Band 3 (2.6–3.2 mm): label text, stethoscope, logo. Changes at 2.0 and 2.6 mm. The back is plain base colour.

**Label:** capitals, text size 5 (capitals 4.8 mm, strokes 1.0 mm), one line, centred. The nameplate is sized for the longest label, PAEDIATRICIAN (51.3 mm), leaving 4.3 mm on each side. The label cannot go on the chest, because the torso is about 18 mm wide.

**Back:** the role in French, engraved and mirrored on the nameplate at size 5, on one line or two: MÉDECIN, PMR, RESPONSABLE / LABORATOIRE, DIRECTEUR / DES SOINS, PÉDIATRE, AIDANT. "Responsable/Manageur laboratoire" and "Directeur/trice des soins" are shortened because they do not fit 60 mm.

**Printing:** flat. Figures printed with the same three filaments can share a plate and the same two changes.

**OpenSCAD parameters:** `role` (values in the table below), label text, text size, clothing regions, body height, nameplate size, tab size.

**Changed from list:** labels on a one-line nameplate sized for the longest label; stand specified; thickness and bands fixed; spelling PAEDIATRICIAN.

| Role | Qty | `role` | Silhouette | Band 2 – clothing | Band 3 – details | Label (width at size 5) |
|---|---|---|---|---|---|---|
| Male doctor | 2 | male_doctor | Male: short hair, trousers | White coat, short sleeves, to the knees | Stethoscope, label | MD (9.9 mm) |
| PMR | 2 | pmr | Male: short hair, trousers | MSF vest, sleeveless | "MSF" on the vest (13.7 mm wide, needs a vest front of at least 16 mm), label | PMR (14.6 mm) |
| Lab manager | 2 | lab_manager | Female: hair bun, skirt below the coat | White coat, long sleeves to the wrists | Label | LAB MANAGER (50.4 mm) |
| Nurse lead | 2 | nurse_lead | Male: short hair, trousers | Nurse scrubs, top and trousers | Label | NURSE LEAD (43.4 mm) |
| Female paediatrician | 2 | paediatrician | Female: hair bun, skirt below the coat | White coat, short sleeves | Stethoscope, label | PAEDIATRICIAN (51.3 mm, longest) |
| Caretaker | 6 | caretaker | Female: long dress, headscarf framing the face | Dress and headscarf | Label | CARETAKER (41.8 mm) |

### 4.15 Universal stand

**Represents:** base that holds any part with the standard tab upright.

**Quantity:** 58 (16 figures, 30 precaution signs and 12 room labels).

**Size:** not on the list, which asks for a separate stand. Proposed 60 × 26 × 10 mm.

**Shape:** solid block, the same width as the nameplates and signs. Centred slot 30.5 × 2.3 mm, 8 mm deep (2 mm floor), for the 2.0 mm tab with 0.3 mm clearance, with a 0.4 mm entry chamfer. 1 mm chamfer on the top edges. The 8 mm deep slot limits wobble to about 2°.

**Colour bands:** single colour.

**Printing:** flat on its base.

**OpenSCAD parameters:** size, slot length, width and depth, clearances (`slot_clearance` 0.3 mm and `slot_end_clearance` 0.5 mm from `common.scad`; set from the stage 1 test print once a printer is available).

**Changed from list:** new part; one design for figures and signs.

### 4.16 Precaution signs – contact, droplet, airborne

**Represents:** transmission-based precaution signs placed at isolation beds.

**Quantity:** 10 of each type.

**Size:** listed 2 × 2 cm. Proposed sign face 60 × 48 mm plus tab (part 60 × 56 mm), 2.6 mm thick. In the stand, the top of the sign is about 58 mm above the table.

**Shape:** base plate 2.0 mm with a pictogram and two lines of text raised 0.6 mm in Band 2. Pictogram about 24 × 24 mm at the top: glove for contact, surgical mask for droplet, respirator for airborne. Line 1 at text size 6 (capitals 5.7 mm, strokes 1.2 mm): CONTACT 38.9 mm, DROPLET 38.4 mm, AIRBORNE 43.0 mm wide. Line 2 at size 5: PRECAUTIONS 48.7 mm wide. Standard tab below.

**Modelled:** the sign uses the room label layout without a frame (`plate_content_2d`): pictogram 24, gap 3, line gap 2.6, 3.9 mm above and below. Pictograms: a glove with cuff, four fingers and a thumb; a surgical mask as a pleated rectangle with an ear loop standing off each side; a respirator as a cup mask with two head straps on each side. Part 60 × 56 × 2.6 mm.

**Colour bands:** plate in one colour; pictogram and text in a second. One change at Z 2.0 mm.

**Printing:** flat; stands in the universal stand.

**Back:** engraved and mirrored, with the pictogram as a 1.2 mm outline and both lines at size 5, in French word order: PRÉCAUTIONS / CONTACT, PRÉCAUTIONS / GOUTTELETTES, PRÉCAUTIONS / AIR.

**OpenSCAD parameters:** `type` ("contact", "droplet", "airborne"; selects line 1 and the pictogram), `language` ("en" or "fr"), text sizes.

**Changed from list:** 20 × 20 → 60 × 48 mm. At 20 mm wide, PRECAUTIONS would be under 2 mm tall with 0.4 mm strokes, which is neither printable nor readable. Width matched to the stand.

### 4.17 Antibiotic vial

**Represents:** a container of antibiotics on the table. The colour is the code: the group decides what each of the five means, so the part carries no text.

**Quantity:** 30 — six in each of five colours.

**Size:** not listed. Proposed Ø12 × 20 mm, which is the handling minimum (12 mm across, 20 mm long) and sits a step below the alcohol hand rub bottle.

**Shape:** straight body to 15 mm, a 45° shoulder to a Ø8 mm crimp cap, 0.4 mm bottom and 0.6 mm top chamfer. No overhang, no bridge.

**Colour bands:** single colour.

**Printing:** upright.

**OpenSCAD parameters:** diameter, height, body height, cap diameter, top chamfer.

**Changed from list:** new item (v1.7 feedback). The five colours are chosen from the set's own filaments so no extra spool is needed: white, blue, red, yellow and green.

### 4.18 Patient equipment card

**Represents:** a card placed at a bed to show the bed has its own blood pressure machine, thermometer and stethoscope. It lies flat on the table; it is not a standing sign and has no tab.

**Quantity:** 10.

**Size:** listed 5 × 5 cm. Proposed 50 × 50 × 2.6 mm.

**Shape:** base card 2.0 mm, no frame. Raised 0.6 mm in Band 2: three 15 × 15 mm pictograms, the blood pressure machine and the thermometer side by side at the top and the stethoscope centred below, then PATIENT and EQUIPMENT at size 5, 2 mm below the pictograms and 2 mm apart, leaving about 2.2 mm clear top and bottom.

**Pictograms:** blood pressure machine – aneroid gauge with a needle over a cuff. Thermometer – tilted clinical thermometer with a bulb and three scale marks. Stethoscope – the consultation-room pictogram reused. The first two are drawn with 1.6 mm strokes, not the 1.2 mm minimum, so that at 15 mm every stroke is still 1.2 mm or more; the stethoscope's thinnest stroke is 1.6 mm already.

**Colour bands:** card in one colour, pictograms and text in a second. One change at Z 2.0 mm.

**Printing:** flat.

**Back:** the same rows engraved and mirrored, with the three pictograms as 1.2 mm outlines and ÉQUIPEMENT / PATIENT at size 5. Turn the card over to change language.

**OpenSCAD parameters:** `language` ("en" or "fr"), card size, pictogram size and spacing, text size, row gaps.

**Changed from list:** new item (v1.7 feedback); the wording and the French back added in v1.10. The card was briefly made into a standing sign in v1.9 and changed back: it is a card that lies on the table, and only the text was wanted.

## 5. Implementation plan

All nine stages were completed in September 2026; the plan is kept as the record of how the files came about. Deliverables per stage are as listed, except that `beds_stl.zip` (stage 3) is superseded by the `stl/` folder of the final package.

The modelling is split into nine stages. Each stage is sized to fit in one conversation, including a round of revisions, and ends at a review gate. Load is the expected share of one conversation: Low is a small part, Medium about half, High most of it, so nothing should be added to a High stage. The prompt for each stage is in `stage_prompts.md`.

### 5.1 Project files

All files live in one project folder. Download every file a stage produces, and the updated `STATUS.md`, into that folder.

| File | Created in | Purpose |
|---|---|---|
| `design_brief.md` | Briefing | This brief, the single source of truth for the design |
| `STATUS.md` | Briefing | One-page handover, updated at the end of every stage |
| `stage_prompts.md` | Briefing | Prompt for starting each stage; used by you, not attached to stages |
| `common.scad` | Stage 1 | Shared values and helpers, included by every model |
| `check_part.py` | Stage 1 | Checks an STL: bounding box, band heights, overhangs |
| `stand.scad` | Stage 1 | Universal stand |
| `test_coupon.scad` | Stage 1 | Band and text coupon (`part="coupon"`) and slot-width test block (`part="slots"`) |
| `bucket_lib.scad` | Stage 2 | Bucket shape shared by the hand washing point and the mop bucket |
| `waste_bin.scad`, `sharps_box.scad`, `hand_rub_bottle.scad`, `hand_washing_point.scad`, `mop_and_bucket.scad` | Stage 2 | Upright equipment |
| `bed.scad`, `export_beds.sh`, `screen.scad`, `trolley.scad` | Stage 3 | Furniture and the export of the 26 bed variants |
| `neonate.scad`, `adult_patient.scad`, `syringe.scad`, `blood_culture_bottle.scad` | Stage 4 | Patients and tokens |
| `figure.scad` | Stages 5–6 | Staff figures, all roles |
| `pictogram_lib.scad` | Stages 7–8 | Plate layout and pictograms shared by room labels and signs |
| `room_label.scad` | Stage 7 | Room labels |
| `sign.scad` | Stage 8 | Precaution signs |
| `export_all.sh`, `README.md`, `tabletop_simulation_set.zip` | Stage 9 | Export of all STLs, print table, final package |

### 5.2 Rules for context size and token use

**One stage per conversation:** start every stage in a new conversation with its prompt from `stage_prompts.md`, and end it at the review gate.

**Attachments:** attach exactly the files listed for the stage in 5.3. Never attach STLs or images.

**Read selectively:** read section 2, the item sections named in the prompt, sections 5.2–5.4 and `STATUS.md`, not the whole brief.

**Handover:** `STATUS.md` stays one page: stage table, file list, values confirmed by test prints, deviations from the brief, open issues and the next step.

**Shared values:** only in `common.scad`. Models include it and never copy its values.

**Brief changes:** changes found while modelling were recorded in `STATUS.md` and folded into this brief in stage 9 as the "Modelled:" notes.

**Checks by script:** run `check_part.py` on every STL instead of rendering extra images. A few lines of text cost far fewer tokens than an image.

**Images:** one colour preview per item; stages with several items or variants show them in one combined image.

**Editing:** make targeted edits to files instead of rewriting them, and do not paste whole files into the chat.

**Compact geometry:** silhouettes and pictograms as short point lists at 0.1 mm precision, mirrored where symmetric.

**Sandbox:** every conversation starts with an empty sandbox; install OpenSCAD there to render, export and check.

### 5.3 Stages

| # | Scope | Brief sections | Attach | Produces | Review gate | Load |
|---|---|---|---|---|---|---|
| 1 | Foundation: shared values and helpers, universal stand, test coupon, check script | 2, 4.15 | `design_brief.md`, `STATUS.md` | `common.scad`, `check_part.py`, `stand.scad`, `test_coupon.scad`; `stand.stl`, `test_coupon.stl`, `test_slots.stl` | Print coupon, slot block and one stand; confirm slot clearance and 0.6 mm colour coverage. Deferred (no printer); sizes and text approved on the render, stage 2 proceeds with the default clearances | Medium |
| 2 | Upright equipment | 4.7–4.11 | `design_brief.md`, `STATUS.md`, `common.scad`, `check_part.py` | `bucket_lib.scad`, `waste_bin.scad`, `sharps_box.scad`, `hand_rub_bottle.scad`, `hand_washing_point.scad`, `mop_and_bucket.scad`; `waste_bin.stl`, `sharps_box.stl`, `hand_rub_bottle.stl`, `hand_washing_point.stl`, `mop_bucket.stl`, `mop.stl` | Shape review | Medium |
| 3 | Furniture | 4.1, 4.5, 4.6 | `design_brief.md`, `STATUS.md`, `common.scad`, `check_part.py` | `bed.scad`, `export_beds.sh`, `screen.scad`, `trolley.scad`; `beds_stl.zip` (`bed_01.stl`–`bed_20.stl`, `bed_I-1.stl`–`bed_I-6.stl`), `screen.stl`, `trolley_small.stl`, `trolley_large.stl` | Number legibility and proportions | Medium |
| 4 | Patients and tokens | 4.2, 4.3, 4.12, 4.13 | `design_brief.md`, `STATUS.md`, `common.scad`, `check_part.py` | `neonate.scad`, `adult_patient.scad`, `syringe.scad`, `blood_culture_bottle.scad`; `neonate.stl`, `adult_patient.stl`, `syringe.stl`, `blood_culture_bottle.stl` | Silhouette review | Medium |
| 5 | Staff figures A: layout, male and female silhouettes, male doctor | 4.14 | `design_brief.md`, `STATUS.md`, `common.scad`, `check_part.py` | `figure.scad`; `figure_male_doctor.stl` | Figure style approved before the other roles | High |
| 6 | Staff figures B: the other five roles | 4.14 | `design_brief.md`, `STATUS.md`, `common.scad`, `check_part.py`, `figure.scad` | `figure.scad` (updated); `figure_pmr.stl`, `figure_lab_manager.stl`, `figure_nurse_lead.stl`, `figure_paediatrician.stl`, `figure_caretaker.stl` | Role review | Medium to High |
| 7 | Room labels: plate layout and five pictograms | 4.4, 4.16 | `design_brief.md`, `STATUS.md`, `common.scad`, `check_part.py` | `pictogram_lib.scad`, `room_label.scad`; `room_sluice.stl`, `room_nurse_station.stl`, `room_consultation.stl`, `room_patient_toilet.stl`, `room_shower.stl` | Pictogram style approved; it is reused for the signs | High |
| 8 | Precaution signs: three pictograms, standard tab | 4.16 | `design_brief.md`, `STATUS.md`, `common.scad`, `check_part.py`, `pictogram_lib.scad` | `pictogram_lib.scad` (updated), `sign.scad`; `sign_contact.stl`, `sign_droplet.stl`, `sign_airborne.stl` | Wording and pictogram review | Medium |
| 9 | Final package | 3, 5 | `design_brief.md`, `STATUS.md`, `check_part.py`, and one zip of all `.scad` and `.sh` files | `export_all.sh`, `README.md`, `design_brief.md` (v1.0), `tabletop_simulation_set.zip` | Final review | Medium |

### 5.4 Checks in every stage

**Render:** full render without errors; one STL per item or variant.

**Size:** bounding box matches the brief within 0.1 mm.

**Bands:** colour-change heights on 0.2 mm steps; base at least 2.0 mm; each colour at least 0.6 mm.

**Overhangs:** no downward-facing surface beyond 45° from vertical, except on the bed plane.

**Minimum sizes:** walls at least 1.6 mm, handled protrusions at least 2.4 mm, text strokes at least 1.0 mm, set from `common.scad` values and spot-checked on the preview.

**Text:** every string fits its plate or nameplate with the margins in this brief.
