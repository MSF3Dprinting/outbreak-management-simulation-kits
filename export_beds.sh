#!/usr/bin/env bash
# export_beds.sh - exports the 27 bed variants of bed.scad (bed_01..bed_20, bed_I-1..bed_I-6
# and bed_empty) as binary STL with the colour-change note in the header, zipped as beds_stl.zip.
# Usage: ./export_beds.sh [path-to-openscad]     run in the project folder; needs bed.scad, common.scad
set -euo pipefail
OPENSCAD=${1:-openscad}
OUT=beds_stl
mkdir -p "$OUT"
: > export_beds.log
for label in $(seq 1 20) I-1 I-2 I-3 I-4 I-5 I-6 EMPTY; do
    note="80x40x20.6 mm; colour change at Z 20.0 mm (number); 0.2 mm layers"
    case $label in
        [0-9]) name=bed_0$label ;;
        EMPTY) name=bed_empty; label=""
               note="80x40x20 mm; no number, single colour; sheet is a separate part" ;;
        *) name=bed_$label ;;
    esac
    "$OPENSCAD" -o "$OUT/$name.stl" --export-format binstl -D "bed_label=\"$label\"" bed.scad >> export_beds.log 2>&1
    printf '%-80.80s' "$name $note" \
        | dd of="$OUT/$name.stl" bs=80 count=1 conv=notrunc status=none
    printf '%s ' "$name"
done
echo
if grep -qi "warning\|error" export_beds.log; then echo "OpenSCAD reported problems, see export_beds.log"; exit 1; fi
rm -f beds_stl.zip
if command -v zip > /dev/null; then (cd "$OUT" && zip -q ../beds_stl.zip bed_*.stl)
else python3 -m zipfile -c beds_stl.zip "$OUT"/bed_*.stl; fi
echo "27 beds in $OUT/ and beds_stl.zip"
