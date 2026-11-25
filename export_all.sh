#!/usr/bin/env bash
# export_all.sh - exports every STL of the tabletop simulation training set into stl/ as binary
# STL with the size and colour-change note in the 80-byte header, then optionally checks them.
# Usage:  ./export_all.sh [path-to-openscad]        export all 59 STLs (about a minute)
#         ./export_all.sh --check [path-to-openscad] export, then run check_part.py on each with
#                                                    its expected size (needs python3 and numpy)
# Run in the project folder (needs common.scad and the model files). OpenSCAD 2021.01 or newer
# with the Liberation Sans font available; on Linux install fonts-liberation.
set -euo pipefail
CHECK=0
if [ "${1:-}" = "--check" ]; then CHECK=1; shift; fi
OPENSCAD=${1:-openscad}
OUT=stl
mkdir -p "$OUT"
: > export_all.log

# name | source | -D definition (may be empty) | expected size LxWxH | header note
parts=(
  "stand|stand.scad||60x26x10|single colour; 0.2 mm layers; print flat on its base"
  "test_coupon|test_coupon.scad|part=\"coupon\"|70x58x3.2|colour changes at Z 2.0 and 2.6 mm; 0.2 mm layers"
  "test_slots|test_coupon.scad|part=\"slots\"|52x30x10.6|single colour; slots 0.2/0.3/0.4 mm front to back"
  "waste_bin|waste_bin.scad||19x21.5x24|single colour (blue or red filament); 0.2 mm layers"
  "sharps_box|sharps_box.scad||16x14x28|single colour, yellow; 0.2 mm layers"
  "hand_rub_bottle|hand_rub_bottle.scad||14x14x28|colour change at Z 22.0 mm; 0.2 mm layers"
  "hand_washing_point|hand_washing_point.scad||28x36x40|single colour; 0.2 mm layers; front is -y"
  "mop_bucket|mop_and_bucket.scad|part=\"bucket\"|28.8x24x18|single colour; slot 14.5x3.7x3 in the floor"
  "mop|mop_and_bucket.scad|part=\"mop\"|52x14x3.4|single colour; 0.2 mm layers; prints flat"
  "screen|screen.scad||80x20x30.6|colour changes at Z 4.0 and 26.6 mm; 0.2 mm layers; brim optional"
  "trolley_small|trolley.scad|version=\"small\"|30x20x26|single colour; 0.2 mm layers; handle at +x"
  "neonate|neonate.scad||30x15x2.6|single colour, wrap raised 0.6; 0.2 mm layers; prints flat"
  "adult_patient|adult_patient.scad||60x22x2.6|single colour, dress raised 0.6; 0.2 mm layers; flat"
  "syringe|syringe.scad||46x14x2.6|single colour (clear PETG); 0.2 mm layers; prints flat"
  "bed_sheet|bed_sheet.scad||66x38x2|single colour, black; lies on the mattress of an empty bed"
  "antibiotic_vial|antibiotic_vial.scad||12x12x20|single colour, one of five; 0.2 mm layers"
  "equipment_card|equipment_card.scad||50x50x2.6|change at Z 2.0 mm; French engraved on the back; prints flat"
  "blood_culture_bottle|blood_culture_bottle.scad||32x14x2.6|colour change at Z 2.0 mm (blood, red PETG); flat"
)
for role in male_doctor pmr lab_manager nurse_lead paediatrician caretaker; do
    parts+=("figure_$role|figure.scad|role=\"$role\"|60x83x3.2|changes at Z 2.0 and 2.6 mm; French engraved on the back; flat")
done
for room in sluice nurse_station consultation patient_toilet shower; do
    parts+=("room_$room|room_label.scad|room=\"$room\"|60x56x2.6|change at Z 2.0 mm; French engraved on the back; flat, tab below")
done
for type in contact droplet airborne; do
    parts+=("sign_$type|sign.scad|type=\"$type\"|60x56x2.6|change at Z 2.0 mm; French engraved on the back; flat, tab below")
done
for label in $(seq 1 20) I-1 I-2 I-3 I-4 I-5 I-6; do
    case $label in [0-9]) name=bed_0$label ;; *) name=bed_$label ;; esac
    parts+=("$name|bed.scad|bed_label=\"$label\"|80x40x20.6|colour change at Z 20.0 mm (number); 0.2 mm layers")
done
parts+=("bed_empty|bed.scad|bed_label=\"\"|80x40x20|no number, single colour; the black sheet is a separate part")

n=0
for p in "${parts[@]}"; do
    IFS='|' read -r name src def size note <<< "$p"
    if [ -n "$def" ]; then
        "$OPENSCAD" -o "$OUT/$name.stl" --export-format binstl -D "$def" "$src" >> export_all.log 2>&1
    else
        "$OPENSCAD" -o "$OUT/$name.stl" --export-format binstl "$src" >> export_all.log 2>&1
    fi
    printf '%-80.80s' "$name ${size}mm; $note" | dd of="$OUT/$name.stl" bs=80 count=1 conv=notrunc status=none
    n=$((n + 1)); printf '%s ' "$name"
done
echo
if grep -qi "warning\|error" export_all.log; then echo "OpenSCAD reported problems, see export_all.log"; exit 1; fi
echo "$n STLs exported to $OUT/"

if [ $CHECK = 1 ]; then
    fail=0
    for p in "${parts[@]}"; do
        IFS='|' read -r name src def size note <<< "$p"
        # the two-sided parts carry the other language engraved into the bed face
        case $name in room_*|sign_*|figure_*|equipment_card) extra="--engraved 0.6" ;; *) extra="" ;; esac
        if python3 check_part.py "$OUT/$name.stl" --expect "$size" $extra > /dev/null; then echo "ok    $name"; else echo "CHECK $name"; fail=1; fi
    done
    [ $fail = 0 ] && echo "all $n STLs pass check_part.py" || { echo "some STLs need attention"; exit 1; }
fi
