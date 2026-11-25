// syringe.scad - syringe with needle, token (design_brief.md 4.12). Flat silhouette
// 46 x 14 x 2.6, in line along x: thumb press, plunger rod 4 wide, finger flange 14 wide,
// barrel 9 x 22, hub, needle 2.4 wide x 9 with a rounded tip. The whole outline is 2.6
// thick; barrel marks are 0.6 deep grooves. Single colour (clear PETG), prints flat.
// Export: openscad -o syringe.stl syringe.scad
include <common.scad>

length     = 46;
barrel_w   = 9;
barrel_l   = 22;
flange_w   = 14;
rod_w      = 4;
needle_l   = 9;
needle_w   = min_handled;       // 2.4
marks      = true;
mark_w     = picto_min;         // 1.2 wide grooves
mark_l     = 5;
mark_n     = 5;
thickness  = band1_h + detail_h;   // 2.6

press_l = 2.5; rod_l = 7.5; flange_l = 2.5;
barrel_x = press_l + rod_l + flange_l;                       // 12.5
hub_l    = length - barrel_x - barrel_l - needle_l;          // 2.5
needle_x = barrel_x + barrel_l + hub_l;                      // 37

module syringe_2d() {
    translate([0, -4]) square([press_l, 8]);                                  // thumb press
    translate([press_l - 0.5, -rod_w / 2]) square([rod_l + 1, rod_w]);        // plunger rod
    translate([press_l + rod_l, -flange_w / 2]) square([flange_l, flange_w]); // finger flange
    translate([barrel_x - 0.5, -barrel_w / 2]) square([barrel_l + 0.5, barrel_w]);
    hx = barrel_x + barrel_l;                                                 // hub, tapering to the needle
    polygon([[hx - 0.5, barrel_w / 2], [hx + hub_l, needle_w / 2], [hx + hub_l, -needle_w / 2], [hx - 0.5, -barrel_w / 2]]);
    hull() {                                                                  // needle with a rounded tip
        translate([needle_x - 0.5, -needle_w / 2]) square([0.5, needle_w]);
        translate([length - needle_w / 2, 0]) circle(d = needle_w);
    }
}

module syringe() band_colour(1) difference() {
    extrude_chamfered(thickness) syringe_2d();
    if (marks) for (i = [0 : mark_n - 1])
        translate([barrel_x + 2.5 + i * (barrel_l - 5 - mark_w) / (mark_n - 1), -mark_l / 2 + 0.5, thickness - detail_h])
            cube([mark_w, mark_l, detail_h + 1]);
}

syringe();
