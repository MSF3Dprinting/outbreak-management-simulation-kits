#!/usr/bin/env python3
"""make_design_objects_pdf.py - renders one preview per design object and builds
design_objects.pdf: a table of name, description, quantity, colours and picture.

usage: python3 make_design_objects_pdf.py [--skip-thumbs] [--openscad PATH]

Run in the project folder. Needs OpenSCAD 2021.01+ (with the Liberation Sans font) for the
previews, and Python packages reportlab and pillow. On a headless Linux machine the previews
need a display; the script uses xvfb-run when it finds it. --skip-thumbs reuses thumbs/.
Descriptions, quantities and colour changes come from design_brief.md sections 3 and 4.
"""
import argparse
import os
import shutil
import subprocess
import sys

THUMBS = "thumbs"
OUT = "design_objects.pdf"

# key | scene (OpenSCAD source, models loaded from the project folder) | camera rotation x, z | tall preview
SCENES = [
    ("bed_standard", 'use <bed.scad>\nbed("20");', 55, 125, False),
    ("bed_isolation", 'use <bed.scad>\nbed("I-4");', 55, 125, False),
    ("neonate", 'use <neonate.scad>\nneonate();', 35, 10, False),
    ("adult_patient", 'use <adult_patient.scad>\nadult_patient();', 35, 10, False),
    ("room_sluice", 'use <room_label.scad>\nroom_label("sluice");', 30, 0, False),
    ("room_nurse_station", 'use <room_label.scad>\nroom_label("nurse_station");', 30, 0, False),
    ("room_consultation", 'use <room_label.scad>\nroom_label("consultation");', 30, 0, False),
    ("room_patient_toilet", 'use <room_label.scad>\nroom_label("patient_toilet");', 30, 0, False),
    ("room_shower", 'use <room_label.scad>\nroom_label("shower");', 30, 0, False),
    ("trolley_small", 'use <trolley.scad>\ntrolley("small");', 55, 30, False),
    ("screen", 'use <screen.scad>\nscreen();', 55, 25, False),
    ("waste_bin_blue", 'use <waste_bin.scad>\ncolor("#2f6fd6") waste_bin();', 55, 30, True),
    ("waste_bin_red", 'use <waste_bin.scad>\ncolor("#d23c3c") waste_bin();', 55, 30, True),
    ("sharps_box", 'use <sharps_box.scad>\nsharps_box();', 55, 30, False),
    ("hand_washing_point", 'use <hand_washing_point.scad>\nhand_washing_point();', 60, 25, True),
    ("hand_rub_bottle", 'use <hand_rub_bottle.scad>\nhand_rub_bottle();', 60, 25, True),
    ("mop_and_bucket", 'use <mop_and_bucket.scad>\nmop_bucket();\ntranslate([0, 0, 1]) rotate([0, 0, 90]) rotate([0, -90, 0]) translate([0, 0, -1.7]) mop();\ntranslate([30, 0, 0]) mop();', 55, 30, False),
    ("syringe", 'use <syringe.scad>\nsyringe();', 35, 10, False),
    ("blood_culture_bottle", 'use <blood_culture_bottle.scad>\nblood_culture_bottle();', 35, 10, False),
    ("figure_male_doctor", 'use <figure.scad>\nfigure("male_doctor");', 30, 0, True),
    ("figure_pmr", 'use <figure.scad>\nfigure("pmr");', 30, 0, True),
    ("figure_lab_manager", 'use <figure.scad>\nfigure("lab_manager");', 30, 0, True),
    ("figure_nurse_lead", 'use <figure.scad>\nfigure("nurse_lead");', 30, 0, True),
    ("figure_paediatrician", 'use <figure.scad>\nfigure("paediatrician");', 30, 0, True),
    ("figure_caretaker", 'use <figure.scad>\nfigure("caretaker");', 30, 0, True),
    ("bed_empty", 'use <bed.scad>\nuse <bed_sheet.scad>\nbed("");\n'
                   'color("#3a3a3a") translate([-3.5, 0, 8]) bed_sheet();', 55, 125, False),
    ("bed_sheet", 'use <bed_sheet.scad>\nbed_sheet();', 45, 15, False),
    ("antibiotic_vial", 'use <antibiotic_vial.scad>\nantibiotic_vial();', 60, 25, True),
    ("equipment_card", 'use <equipment_card.scad>\nequipment_card();', 25, 0, False),
    ("stand", 'use <stand.scad>\nstand();', 55, 30, False),
    ("sign_contact", 'use <sign.scad>\nsign("contact");', 30, 0, False),
    ("sign_droplet", 'use <sign.scad>\nsign("droplet");', 30, 0, False),
    ("sign_airborne", 'use <sign.scad>\nsign("airborne");', 30, 0, False),
]

# The back of every two-sided part, seen flat after turning the part over. The engraving is only
# about 0.5 mm deep and would not show in a picture, so these previews fill it in dark grey.
BACKS = [("room_sluice", "Sluice room", "SALLE VIDOIR"), ("room_nurse_station", "Nurse station", "SALLE DE SOINS"),
         ("room_consultation", "Consultation room", "SALLE DE CONSULTATION"),
         ("room_patient_toilet", "Patient toilet", "TOILETTES PATIENT"), ("room_shower", "Shower room", "DOUCHE"),
         ("sign_contact", "Contact precautions", "PR\u00c9CAUTIONS CONTACT"),
         ("sign_droplet", "Droplet precautions", "PR\u00c9CAUTIONS GOUTTELETTES"),
         ("sign_airborne", "Airborne precautions", "PR\u00c9CAUTIONS AIR"),
         ("equipment_card", "Patient equipment", "\u00c9QUIPEMENT PATIENT"),
         ("figure_male_doctor", "Medical doctor", "M\u00c9DECIN"), ("figure_pmr", "PMR", "PMR"),
         ("figure_lab_manager", "Lab manager", "RESPONSABLE LABORATOIRE"),
         ("figure_nurse_lead", "Nurse lead", "DIRECTEUR DES SOINS"),
         ("figure_paediatrician", "Paediatrician", "P\u00c9DIATRE"), ("figure_caretaker", "Caretaker", "AIDANT")]

for _key, _, _ in BACKS:
    if _key.startswith("room_"):
        _r = _key[5:]
        _scene = ('use <room_label.scad>\ntranslate([0, 0, 2.6]) rotate([0, 180, 0]) room_label("%s");\n'
                  'color("#4a4a4a") translate([0, 24, 2.6]) linear_extrude(0.05) room_label_back_2d("%s");' % (_r, _r))
        SCENES.append((_key + "_back", _scene, 0, 0, False))
    elif _key == "equipment_card":
        _scene = ('use <equipment_card.scad>\ntranslate([0, 0, 2.6]) rotate([0, 180, 0]) equipment_card();\n'
                  'color("#4a4a4a") translate([0, 0, 2.6]) linear_extrude(0.05) equipment_card_back_2d();')
        SCENES.append((_key + "_back", _scene, 0, 0, False))
    elif _key.startswith("sign_"):
        _t = _key[5:]
        _scene = ('use <sign.scad>\ntranslate([0, 0, 2.6]) rotate([0, 180, 0]) sign("%s");\n'
                  'color("#4a4a4a") translate([0, 24, 2.6]) linear_extrude(0.05) sign_back_2d("%s");' % (_t, _t))
        SCENES.append((_key + "_back", _scene, 0, 0, False))
    else:
        _f = _key[7:]
        _scene = ('use <figure.scad>\ntranslate([0, 0, 3.2]) rotate([0, 180, 0]) figure("%s");\n'
                  'color("#4a4a4a") translate([0, 0, 3.2]) linear_extrude(0.05) figure_back_2d("%s");' % (_f, _f))
        SCENES.append((_key + "_back", _scene, 0, 0, True))

# Colours: the number of filament colours the part needs, in plain words. The heights of the
# colour changes are in the STL headers, in README.md and in design_brief.md, not in this table.
ONE = "1 colour"
TWO = "2 colours"
THREE = "3 colours"

# key | name | description | quantity | colours
ITEMS = [
    ("bed_standard", "Hospital bed, standard 1-20",
     "Ward bed with head and foot boards, imitated legs at the four corners and the bed number raised on the footboard; 80 &#215; 40 &#215; 20.6 mm (about 1:25), silver or grey. Numbers 1 to 20, one STL each.",
     "40<br/>(2 of each number)", TWO),
    ("bed_isolation", "Hospital bed, isolation I-1 to I-6",
     "The same bed with the numbers I-1 to I-6, printed in a different body colour to mark the isolation beds.",
     "12<br/>(2 of each number)", TWO),
    ("bed_empty", "Hospital bed, empty",
     "The same bed with no number, for a bed whose patient has died; 80 &#215; 40 &#215; 20.0 mm. The black sheet is the separate part below, laid on the mattress.",
     "6", ONE),
    ("bed_sheet", "Black sheet for an empty bed",
     "Loose panel laid on the mattress between the head and foot boards to mark a bed whose patient has died; 66 &#215; 38 &#215; 2.0 mm. Printed on its own in black so the bed itself stays one colour on a single-extruder printer. It drops onto any bed, numbered or not.",
     "6", ONE),
    ("neonate", "Patient, neonate",
     "Newborn, swaddled, seen from above; lies in a bed or with its mother; 30 &#215; 15 &#215; 2.6 mm. The wrap is raised 0.6 mm in the same colour and the face stays at base level. Brown is an unaffected patient; blue, red and green replace the stickers used to mark suspect, probable or confirmed, and contact.",
     "56<br/>(20 brown,<br/>12 each blue,<br/>red and green)", "1 colour"),
    ("adult_patient", "Patient, female adult",
     "Adult woman lying in bed, seen from above; 60 &#215; 22 &#215; 2.6 mm, fits the 67 mm mattress between the boards. Dress, hair and bun raised 0.6 mm in the same colour. Brown, blue, red and green as for the neonate.",
     "56<br/>(20 brown,<br/>12 each blue,<br/>red and green)", "1 colour"),
    ("room_sluice", "Room label - sluice room",
     "Table marker showing where the sluice room is; bedpan with a downward arrow; face 60 &#215; 48 mm plus the tab, so it stands in the universal stand like a precaution sign. French on the back: SALLE VIDOIR.", "2", TWO),
    ("room_nurse_station", "Room label - nurse station",
     "Table marker; person behind a desk; face 60 &#215; 48 mm plus the tab, so it stands in the universal stand like a precaution sign. French on the back: SALLE DE SOINS.", "4", TWO),
    ("room_consultation", "Room label - consultation room",
     "Table marker; stethoscope; face 60 &#215; 48 mm plus the tab, so it stands in the universal stand like a precaution sign. French on the back: SALLE DE CONSULTATION.", "2", TWO),
    ("room_patient_toilet", "Room label - patient toilet",
     "Table marker; toilet bowl, side view; face 60 &#215; 48 mm plus the tab, so it stands in the universal stand like a precaution sign. French on the back: TOILETTES PATIENT.", "2", TWO),
    ("room_shower", "Room label - shower room",
     "Table marker; shower head with falling drops; face 60 &#215; 48 mm plus the tab, so it stands in the universal stand like a precaution sign. French on the back: DOUCHE.", "2", TWO),
    ("trolley_small", "Trolley",
     "Procedure or dressing trolley with a tray recess, push handle, drawer lines and four wheels; 30 &#215; 20 &#215; 26 mm.",
     "6", ONE),
    ("screen", "Screen",
     "Mobile privacy screen beside a bed: bed length, 10 mm taller than the bed, standing on two feet; 80 &#215; 20 &#215; 30.6 mm. A brim is optional for the thin walls.",
     "20", THREE),
    ("waste_bin_blue", "Waste bin, blue",
     "Pedal bin for one waste stream, with a lid lip and a foot pedal; &#216;18 &#215; 24 mm (19 &#215; 21.5 &#215; 24 mm overall).",
     "8", ONE + ": blue"),
    ("waste_bin_red", "Waste bin, red", "The same bin for the other waste stream.", "8", ONE + ": red"),
    ("sharps_box", "Sharps box",
     "Sharps safety box; the top tapers at 45&#176; to a small face with a &#216;6 mm opening; 16 &#215; 14 &#215; 28 mm, about the size of the hand rub bottle.",
     "8", ONE + ": yellow"),
    ("hand_washing_point", "Hand washing point",
     "Field hand washing station: water bucket with a tap on an arched stand, and a basin that catches the water; 28 &#215; 36 &#215; 40 mm.",
     "10", ONE + ": white"),
    ("hand_rub_bottle", "Alcohol hand rub bottle",
     "Pump bottle of alcohol hand rub at the point of care; &#216;14 &#215; 28 mm.",
     "10", TWO),
    ("mop_and_bucket", "Mop and bucket",
     "Cleaning mop standing in an open bucket; two parts: bucket &#216;24 &#215; 18 mm with a slot in the floor, and a mop 52 &#215; 14 &#215; 3.4 mm printed lying flat and stood in the slot.",
     "12 sets<br/>(12 buckets,<br/>12 mops)", ONE + " each: light blue"),
    ("syringe", "Syringe with needle",
     "Syringe token, not to scale, with barrel marks as grooves; 46 &#215; 14 &#215; 2.6 mm.", "20", ONE + ": clear PETG"),
    ("blood_culture_bottle", "Blood culture bottle",
     "Bottle half filled with blood, token, not to scale; 32 &#215; 14 &#215; 2.6 mm.",
     "20", TWO + ": clear and red PETG"),
    ("figure_male_doctor", "Staff figure - male doctor",
     "White coat with short sleeves and a stethoscope, label MD; M&#201;DECIN on the back. Every figure is 60 &#215; 83 &#215; 3.2 mm (body 60 mm tall), prints flat and stands in the universal stand.",
     "2", THREE),
    ("figure_pmr", "Staff figure - PMR",
     "Sleeveless MSF vest with &#8220;MSF&#8221; on the chest, label PMR; PMR on the back.", "2", THREE),
    ("figure_lab_manager", "Staff figure - lab manager",
     "Female figure, white coat with long sleeves, skirt showing below the coat, label LAB MANAGER; RESPONSABLE LABORATOIRE on the back.",
     "2", THREE),
    ("figure_nurse_lead", "Staff figure - nurse lead",
     "Nurse scrubs, top and trousers, label NURSE LEAD; DIRECTEUR DES SOINS on the back.", "2", THREE),
    ("figure_paediatrician", "Staff figure - paediatrician",
     "Female figure, white coat with short sleeves and a stethoscope, skirt below the coat, label PAEDIATRICIAN; P&#201;DIATRE on the back.",
     "2", THREE),
    ("figure_caretaker", "Staff figure - caretaker",
     "Long dress with long sleeves and a headscarf framing the face, label CARETAKER; AIDANT on the back.",
     "6", THREE),
    ("stand", "Universal stand",
     "Base that holds any figure, room label or sign upright by its 30 &#215; 8 mm tab; 60 &#215; 26 &#215; 10 mm. One design for all of them.",
     "58<br/>(16 figures,<br/>30 signs,<br/>12 room labels)", ONE),
    ("antibiotic_vial", "Antibiotic vial",
     "Container of antibiotics standing on the table; &#216;12 &#215; 20 mm. The colour is the code \u2014 six vials in each of five colours, and the group decides what each colour means, so the vial carries no text.",
     "30<br/>(6 each in white,<br/>blue, red, yellow<br/>and green)", ONE),
    ("equipment_card", "Patient equipment card",
     "Card laid at a bed to show the bed has its own blood pressure machine, thermometer and stethoscope; three pictograms over PATIENT EQUIPMENT on a 50 &#215; 50 &#215; 2.6 mm card. French on the back: &#201;QUIPEMENT PATIENT.",
     "10", TWO),
    ("sign_contact", "Precaution sign - contact",
     "Precaution sign placed at an isolation bed; glove pictogram, CONTACT PRECAUTIONS; French on the back: PR&#201;CAUTIONS CONTACT. Face 60 &#215; 48 mm plus the tab, stands in the universal stand.",
     "10", TWO),
    ("sign_droplet", "Precaution sign - droplet",
     "Surgical mask pictogram, DROPLET PRECAUTIONS; French on the back: PR&#201;CAUTIONS GOUTTELETTES. Face 60 &#215; 48 mm plus the tab.", "10", TWO),
    ("sign_airborne", "Precaution sign - airborne",
     "Respirator pictogram, AIRBORNE PRECAUTIONS; French on the back: PR&#201;CAUTIONS AIR. Face 60 &#215; 48 mm plus the tab.", "10", TWO),
]


def render_thumbs(openscad):
    from PIL import Image, ImageChops
    os.makedirs(THUMBS, exist_ok=True)
    prefix = ["xvfb-run", "-a"] if (shutil.which("xvfb-run") and not os.environ.get("DISPLAY")) else []
    for key, scene, rx, rz, _ in SCENES:
        open("_thumb.scad", "w").write(scene + "\n")
        cmd = prefix + [openscad, "--preview", "-o", "_thumb.png", "--imgsize=1000,800", "--viewall", "--autocenter",
                        "--camera=0,0,0,%d,0,%d,0" % (rx, rz), "--projection=p", "--colorscheme=Tomorrow", "_thumb.scad"]
        r = subprocess.run(cmd, capture_output=True, text=True)
        if r.returncode or not os.path.exists("_thumb.png"):
            sys.exit("preview failed for %s:\n%s" % (key, r.stderr.strip()))
        im = Image.open("_thumb.png").convert("RGB")
        box = ImageChops.difference(im, Image.new("RGB", im.size, im.getpixel((5, 5)))).getbbox()
        pad = 25
        im.crop((max(0, box[0] - pad), max(0, box[1] - pad),
                 min(im.width, box[2] + pad), min(im.height, box[3] + pad))).save(os.path.join(THUMBS, key + ".png"))
        print(key, end=" ", flush=True)
    for f in ("_thumb.scad", "_thumb.png"):
        if os.path.exists(f):
            os.remove(f)
    print("\n%d previews in %s/" % (len(SCENES), THUMBS))


def build_pdf():
    from PIL import Image
    from reportlab.lib import colors
    from reportlab.lib.pagesizes import A4
    from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
    from reportlab.lib.units import mm
    from reportlab.platypus import Image as RLImage, PageBreak, Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle

    st = getSampleStyleSheet()
    body = ParagraphStyle("body", parent=st["Normal"], fontName="Helvetica", fontSize=8.5, leading=10.5)
    bold = ParagraphStyle("bold", parent=body, fontName="Helvetica-Bold")
    head = ParagraphStyle("head", parent=body, fontName="Helvetica-Bold", fontSize=9, textColor=colors.white)
    title = ParagraphStyle("title", parent=st["Title"], fontName="Helvetica-Bold", fontSize=16, leading=20,
                           alignment=0, spaceAfter=4)
    tall = {key for key, _, _, _, t in SCENES if t}

    def picture(key):
        path = os.path.join(THUMBS, key + ".png")
        w, h = Image.open(path).size
        s = min(40 * mm / w, (38 * mm if key in tall else 28 * mm) / h)
        return RLImage(path, width=w * s, height=h * s)

    data = [[Paragraph(t, head) for t in ("Picture", "Name", "Description", "Quantity", "Colours")]]
    for key, name, desc, qty, col in ITEMS:
        data.append([picture(key), Paragraph(name, bold), Paragraph(desc, body), Paragraph(qty, body), Paragraph(col, body)])

    table = Table(data, colWidths=[44 * mm, 32 * mm, 62 * mm, 20 * mm, 32 * mm], repeatRows=1)
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#3a4a5a")),
        ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
        ("ALIGN", (0, 1), (0, -1), "CENTER"),
        ("GRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#9a9a9a")),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor("#f2f4f6")]),
        ("TOPPADDING", (0, 0), (-1, -1), 4), ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
        ("LEFTPADDING", (0, 0), (-1, -1), 4), ("RIGHTPADDING", (0, 0), (-1, -1), 4),
    ]))

    def footer(canvas, doc):
        canvas.saveState()
        canvas.setFont("Helvetica", 8)
        canvas.setFillColor(colors.HexColor("#666666"))
        canvas.drawString(12 * mm, 8 * mm, "Tabletop simulation training set - design objects")
        canvas.drawRightString(A4[0] - 12 * mm, 8 * mm, "Page %d" % doc.page)
        canvas.restoreState()

    doc = SimpleDocTemplate(OUT, pagesize=A4, leftMargin=10 * mm, rightMargin=10 * mm, topMargin=12 * mm,
                            bottomMargin=14 * mm, title="Tabletop simulation training set - design objects",
                            author="MSF 3D Printing for All")
    # appendix: the French side, engraved on the back of the labels, signs and figures
    cap = ParagraphStyle("cap", parent=body, alignment=1)
    heading = ParagraphStyle("heading", parent=title, fontSize=13, leading=17, spaceBefore=0, spaceAfter=2)
    cells = []
    for key, name, french in BACKS:
        w, h = Image.open(os.path.join(THUMBS, key + "_back.png")).size
        sc = min(52 * mm / w, 34 * mm / h)
        cells.append([RLImage(os.path.join(THUMBS, key + "_back.png"), width=w * sc, height=h * sc),
                      Paragraph("<b>%s</b><br/>%s" % (name, french), cap)])
    grid, row = [], []
    for c in cells:
        row.append(c)
        if len(row) == 3:
            grid.append([x[0] for x in row]); grid.append([x[1] for x in row]); row = []
    if row:
        while len(row) < 3:
            row.append(["", ""])
        grid.append([x[0] for x in row]); grid.append([x[1] for x in row])
    back_table = Table(grid, colWidths=[62 * mm] * 3)
    back_table.setStyle(TableStyle([
        ("VALIGN", (0, 0), (-1, -1), "MIDDLE"), ("ALIGN", (0, 0), (-1, -1), "CENTER"),
        ("TOPPADDING", (0, 0), (-1, -1), 2), ("BOTTOMPADDING", (0, 0), (-1, -1), 2),
        ("BOTTOMPADDING", (0, 1), (-1, -1), 8),
    ]))

    story = [
        Paragraph("Tabletop simulation training set &#8211; design objects", title),
        Spacer(1, 6), table, PageBreak(),
        Paragraph("French side, engraved on the back", heading),
        Spacer(1, 8), back_table,
    ]
    doc.build(story, onFirstPage=footer, onLaterPages=footer)
    print("wrote %s (%d items)" % (OUT, len(ITEMS)))


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--skip-thumbs", action="store_true", help="reuse the previews in %s/" % THUMBS)
    ap.add_argument("--openscad", default="openscad", help="path to the OpenSCAD binary")
    args = ap.parse_args()
    if not args.skip_thumbs:
        render_thumbs(args.openscad)
    build_pdf()


if __name__ == "__main__":
    main()
