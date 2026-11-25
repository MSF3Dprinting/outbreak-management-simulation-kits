// bed_sheet.scad - black sheet for an empty bed (design_brief.md 4.1): a loose panel laid on the
// mattress between the head and foot boards, to mark a bed whose patient has died. A separate
// part, not a colour band: on a single-extruder printer a sheet moulded into the bed would need a
// colour change in a Z band the boards also occupy, so the boards would come out black too.
// 66 x 38 x 2.0 mm, single colour, prints flat. It drops onto any bed, numbered or not.
// Export: openscad -o bed_sheet.stl bed_sheet.scad
include <common.scad>

// clear mattress between the boards, from bed.scad: 80 - 10 (footboard) - 3 (headboard),
// and 40 less the 0.6 mm chamfer on each mattress side edge
span      = bed_l - 10 - 3;              // 67
flat_w    = bed_w - 2 * 0.6;             // 38.8
clearance = 0.5;                         // along the bed, at each end
side_gap  = 0.4;                         // across the bed, at each side
thickness = base_min;                    // 2.0, the base thickness of every flat part

sheet = [span - 2 * clearance, flat_w - 2 * side_gap];   // 66 x 38

module bed_sheet() band_colour(1) chamfered_box([sheet[0], sheet[1], thickness], ct = 0);

bed_sheet();
