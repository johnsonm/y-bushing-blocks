// Copyright 2018 Michael K Johnson
// Use allowed under Attribution 4.0 International (CC BY 4.0) license terms
// https://creativecommons.org/licenses/by/4.0/legalcode
// This was initially designed as a set of bushing holders for the
// HICTOP i3 clone, which has a frog designed for three SCS8UU pillow blocks.
// This is intended to replace those bearing pillow blocks with 8mm bronze
// bushings with graphite inserts.
// Example bushings currently found as:
// https://www.ebay.com/itm/JDB-Oilless-Graphite-Lubricating-Brass-Bearing-Bushing-Sleeve/142771728854?var=441776630372&hash=item213ddbb1d6:m:mp4EiNuPnJOZJdIyJrTz7tQ
// https://www.amazon.com/Micromake-Printer-Ultimaker-Graphite-Bearing/dp/B06XV28WHG
// https://www.amazon.com/uxcell-Self-lubricating-Bushing-Sleeve-Bearings/dp/B076P9PD2B

// Length of bushing, plus room for variation in plastic
bushing_l=15.5; // [8:30]
// Bushing outer diameter
bushing_d=12;
// Extra clearance around bushing
bushing_clearance_r=0.16;
// Bushing inner diameter
bushing_id=8;
// Distance between blocks installed on printer
block_distance=26;

// holes for rail, larger than rail but smaller than bushing_d
rail_d=8.75;

// clip opening distance radius less than bushing_d — larger needs tougher plastic that bends
clip_t=0.5;
// length of clip section; the longer this is the more likely the system is to bind
clip_center_l=4;

// Diameter of bracket screw holes; M3 by default
bracket_screw_d=3;
bracket_screw_tap_d=bracket_screw_d-0.5;
// thickness (Y) of bushing end constraint blocks
bushing_t=2;
// thickness (X) of bracket clips outside bushing diameter
bracket_thickness=bracket_screw_d*2+2;
// Diameter of base screw holes; 3.4 mm to tap for default M4 screws
screw_d=3.4;
// Distance between X screw centers in the short dimension
screw_x=24;
// Distance between Y screw centers in long dimension: two centers to far edges plus distance
screw_y_long=2*24 + block_distance;
// Distance between Y screw centers on a single block
screw_y_short=18;
// Thickness of base block; 5.5 to mimic SCS8UU
base_thickness=5.5;
// Thickness between inner edge of screw hole and outer edge of base block
edge_thickness=3;
edge_offset=screw_d/2+edge_thickness;
// Print the blocks this far apart
separation=2;
// Offset the clips this far from the end on the long block by this factor of bushing length from the end
clip_offset=0.80;

// Used to keep surfaces non-coincident for preview display
e=0.01 * 1;

module base(screw_y, clearance=false) {
    base_y=max(screw_y[0]/2, bushing_l/2+bushing_t-edge_offset);
    difference() {
        hull() {
            y=base_y;
            for (sign=[[1, 1], [-1, 1], [1, -1], [-1, -1]]) {
                translate([sign[0]*screw_x/2, sign[1]*y, 0])
                    cylinder(d=edge_offset*2, h=base_thickness, $fn=20);
            }
        }
        union() {
            for (y=screw_y, sign=[[1, 1], [-1, 1], [1, -1], [-1, -1]]) {
                translate([sign[0]*screw_x/2, sign[1]*y/2, -e])
                    cylinder(d=screw_d, h=base_thickness+2*e, $fn=30);
            }
            if (clearance) {
                d=bushing_d+4*bushing_clearance_r; // extra clearance in base
                signs=len(screw_y)==1?[0]:[-1,1];
                for (sign=signs) {
                    l=sign==1?bushing_l:0;
                    ty=sign*(base_y+edge_offset-(l+bushing_t));
                    y=ty==0?-bushing_l/2:ty;
                    translate([0, y, base_thickness+bushing_d/2])
                        rotate([-90, 0, 0])
                        cylinder(d=d, h=bushing_l, $fn=30);
                }
            }
        }
    }
}
module clip(offset=0.50) {
    translate([-(bushing_d/2+bushing_t), -(bushing_l/2+bushing_t), base_thickness]) {
        hull_w=bushing_d+2*bushing_t;
        hull_l=bushing_l+2*bushing_t;
        axis_z=bushing_t+rail_d/2;
        difference() {
            hull() {
                cube([hull_w, hull_l, bushing_d+bushing_t-edge_offset]);
                translate([edge_offset/2, 0, bushing_d+bushing_t-edge_offset])
                    rotate([-90, 0, 0])
                    cylinder(d=edge_offset, h=hull_l, $fn=24);
                translate([hull_w-edge_offset/2, 0, bushing_d+bushing_t-edge_offset])
                    rotate([-90, 0, 0])
                    cylinder(d=edge_offset, h=hull_l, $fn=24);
            }
            union() {
                // cut out middle of cube either side of side clip
                translate([-e, bushing_t, 0])
                    cube([bushing_d+2*bushing_t+2*e, (bushing_l*(1-offset))-clip_center_l/2, bushing_d+bushing_t+e]);
                translate([-e, (bushing_l*(1-offset))+clip_center_l, 0])
                    cube([hull_w+2*e, (bushing_l*offset)-clip_center_l/2, bushing_d+bushing_t+e]);
                // cut out top middle of clip section
                translate([bushing_t+clip_t, bushing_t+e, bushing_d/2])
                    cube([bushing_d-2*clip_t, bushing_l-2*e, bushing_d]);
                // cut out bottom middle of clip section, slightly thicker for strength
                translate([bushing_t+2*clip_t, bushing_t+e, 0])
                    cube([bushing_d-4*clip_t, bushing_l-2*e, bushing_d/2]);
                // rail through the whole thing
                translate([bushing_d/2+bushing_t, -e, axis_z])
                    rotate([-90, 0, 0])
                    cylinder(d=rail_d, h=bushing_l+2*bushing_t+2*e, $fn=60);
                // bushing outer diameter
                translate([bushing_d/2+bushing_t, bushing_t, axis_z])
                    rotate([-90, 0, 0])
                    cylinder(d=bushing_d+2*bushing_clearance_r, h=bushing_l, $fn=60);
            }
        }
        %translate([bushing_d/2+bushing_t, bushing_t, bushing_t+rail_d/2])
            rotate([-90, 0, 0])
            difference() {
                cylinder(d=bushing_d, h=bushing_l, $fn=60);
                translate([0, 0, -e]) cylinder(d=bushing_id, h=bushing_l+2*e, $fn=60);
            }
    }
}
module bracket(clip=false) {
    d=bushing_d+bushing_clearance_r*2;
    l=d+2*bracket_thickness;
    z=clip?bracket_thickness/2:0;
    screw_d=clip?bracket_screw_d+2*bushing_clearance_r:bracket_screw_tap_d;
    translate([0, -bracket_thickness/2, z])
    difference() {
        translate([-l/2, 0, -bracket_thickness/2])
            cube([l, bracket_thickness, d/2+bracket_thickness/2-bushing_clearance_r*2]);
        union() {
            // space for bushing
            translate([0, -e, bushing_d/2+bushing_clearance_r])
                rotate([-90, 0, 0])
                cylinder(d=d, h=bracket_thickness+2*e, $fn=60);
            // screw holes
            translate([d/2+bracket_thickness/2, bracket_thickness/2, -(e+bracket_thickness/2)])
                cylinder(d=screw_d, h=d/2+bracket_thickness+2*e, $fn=12);
            translate([-(d/2+bracket_thickness/2), bracket_thickness/2, -(e+bracket_thickness/2)])
                cylinder(d=screw_d, h=d/2+bracket_thickness+2*e, $fn=12);
            // screw heads — these show up only for the clip side
            translate([d/2+bracket_thickness/2, bracket_thickness/2, -(e+bracket_thickness/2)])
                cylinder(d1=bracket_screw_d*2, d2=0, h=screw_d, $fn=12);
            translate([-(d/2+bracket_thickness/2), bracket_thickness/2, -(e+bracket_thickness/2)])
                cylinder(d1=bracket_screw_d*2, d2=0, h=screw_d, $fn=12);
        }
    }
}
module long_clip() {
    base([screw_y_long, screw_y_short], true);
    translate([0, bushing_l/2-screw_y_long/2-edge_offset+bushing_t])
        clip(offset=clip_offset);
    translate([0, -bushing_l/2+screw_y_long/2+edge_offset-bushing_t])
        clip(offset=1-clip_offset);
}
module short_clip() {
    base([screw_y_short]);
    clip();
}
module long_bracket() {
    translate([-(screw_x/2+edge_offset+separation/2), 0, 0]) {
        base([screw_y_long, screw_y_short], false);
        translate([0, bushing_l/2+bracket_thickness/2-screw_y_long/2-edge_offset, base_thickness])
            bracket();
        translate([0, -bushing_l/2-bracket_thickness/2+screw_y_long/2+edge_offset, base_thickness])
            bracket();
    }
    y=bushing_d/2+bushing_clearance_r+bracket_thickness+separation/2;
    translate([(bracket_thickness/2+separation/2), y, 0])
        rotate([0, 0, 90])
        bracket(true);
    translate([(bracket_thickness/2+separation/2), -y, 0])
        rotate([0, 0, 90])
        bracket(true);
}
module short_bracket() {
    base([screw_y_short]);
    translate([0, 0, base_thickness])
        bracket();
    translate([0, screw_y_short/2+edge_offset+separation+bracket_thickness/2])
        bracket(true);
}
rotate([0, 0, 90]) long_bracket();
//short_bracket();
//long_clip();
//translate([-(screw_x/2+edge_offset+separation/2), 0, 0])
//    long_clip();
//translate([(screw_x/2+edge_offset+separation/2), 0, 0])
//    short_clip();
