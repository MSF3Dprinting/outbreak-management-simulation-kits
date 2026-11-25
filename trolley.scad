// trolley.scad - procedure trolley (design_brief.md 4.5), version = "small" (30 x 20, 26 high)
// or "large" (52 x 34, 30 high). Solid body with a 1.6 deep tray, rim 1.6 (2.4 at the handle
// end), 2.4 push handle rising 6 at +x, bottom 5 mm set in 1.2 with a 45 deg step, four
// embossed wheels on the long sides touching the table, optional drawer lines as V-grooves.
// Single colour, prints upright.   Export: openscad -o trolley_small.stl -D 'version="small"' trolley.scad
//                                          openscad -o trolley_large.stl -D 'version="large"' trolley.scad
include <common.scad>

version      = "small";
handle       = true;
handle_h     = 6;
handle_t     = min_handled;    // 2.4
rim          = min_wall;       // 1.6
rim_handle   = min_handled;    // 2.4 at the handle end
tray_depth   = 1.6;
base_h       = 5;              // set-in bottom
base_in      = 1.2;
drawer_lines = true;
groove_w     = 1;              // drawer line opening; 0.5 deep, 45 deg flanks
wheel_sink   = 0.35;           // wheel sunk into the table by this share of its radius: flat
                               // bottom on the bed, no overhang beyond 42 deg

function trolley_size(v)  = v == "large" ? [52, 34, 24] : [30, 20, 20];   // length, width, body height
function wheel_dia(v)     = v == "large" ? 8 : 6;
function drawer_z(v)      = v == "large" ? [11, 17] : [12];

module trolley(v = version) {
    sz = trolley_size(v); l = sz[0] / 2; w = sz[1] / 2; body_h = sz[2];
    cb = chamfer_bottom; g = groove_w / 2; wd = wheel_dia(v); r = wd / 2;
    band_colour(1) difference() {
        intersection() {
            union() {
                ring_stack(concat([[l - base_in - cb, w - base_in - cb, 0], [l - base_in, w - base_in, cb],
                                   [l - base_in, w - base_in, base_h - base_in], [l, w, base_h]],
                                  drawer_lines ? [for (z = drawer_z(v)) each [[l, w, z - g], [l - g, w - g, z], [l, w, z + g]]] : [],
                                  [[l, w, body_h]]));
                for (x = [-(l - wd), l - wd], s = [-1, 1])
                    translate([x, s * (w - (base_in + 1) / 2), r - wheel_sink * r])
                        rotate([90, 0, 0]) cylinder(d = wd, h = base_in + 1, center = true, $fn = 48);
                if (handle) translate([l - handle_t / 2, 0, body_h - 0.5])
                    chamfered_box([handle_t, sz[1], handle_h + 0.5], cb = 0, ct = 0.6);
            }
            translate([-l - 1, -w - 1, 0]) cube([sz[0] + 2, sz[1] + 2, body_h + handle_h + 1]);   // clips the wheels at the table
        }
        translate([-l + rim, -(w - rim), body_h - tray_depth]) cube([sz[0] - rim - rim_handle, sz[1] - 2 * rim, tray_depth + 1]);
    }
}

trolley();
