// Copyright 2018 Michael K Johnson
// Use allowed under Attribution 4.0 International (CC BY 4.0) license terms
// https://creativecommons.org/licenses/by/4.0/legalcode
// This was initially designed as a set of bushing holders for the
// HICTOP i3 clone, which has a frog designed for three SCS8UU pillow blocks.
// This is intended to replace those bearing pillow blocks with 8mm bronze
// bushings with graphite inserts. It can be adjusted for smaller 8mm
// oil-impregnated bronze bushings by changing the bushing length (15mm
// is a common length) and diameters (they may not have a tapered end)
rail_d=9; // leave some room around 8mm rail
bushing_d=12;
bushing_l=30;
bushing_t=2;
clip_t=0.5;
clip_center_l=4;
screw_d=3.4; // tap for M4 screws — smaller hole than tapping AL
screw_x=24; // distance between screw centers short dimension
screw_y_long=2*24 + 26; // 2 * 24 (center to far edge) + 26 (between)
screw_y_short=18;
base_thickness=5.5;
edge_offset=screw_d/2+3;
separation=2;

e=0.01;

module base(screw_y) {
    difference() {
        hull() {
            y=max(screw_y/2, bushing_l/2+bushing_t-edge_offset);
            for (sign=[[1, 1], [-1, 1], [1, -1], [-1, -1]]) {
                translate([sign[0]*screw_x/2, sign[1]*y, 0])
                    cylinder(d=edge_offset*2, h=base_thickness, $fn=20);
            }
        }
        union() {
            for (sign=[[1, 1], [-1, 1], [1, -1], [-1, -1]]) {
                translate([sign[0]*screw_x/2, sign[1]*screw_y/2, -e])
                    cylinder(d=screw_d, h=base_thickness+2*e, $fn=30);
            }
        }
    }
}
module clip() {
    translate([-(bushing_d/2+bushing_t), -(bushing_l/2+bushing_t), base_thickness]) {
        hull_w=bushing_d+2*bushing_t;
        hull_l=bushing_l+2*bushing_t;
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
                // cut out top middle of cube either side of side clip
                translate([-e, bushing_t, 0])
                    cube([bushing_d+2*bushing_t+2*e, bushing_l/2-clip_center_l/2, bushing_d+bushing_t+e]);
                translate([-e, bushing_l/2+clip_center_l, 0])
                    cube([hull_w+2*e, bushing_l/2-clip_center_l/2, bushing_d+bushing_t+e]);
                // make top of clip work
                translate([bushing_t+clip_t, bushing_l/2-e, bushing_d/2])
                    cube([bushing_d-2*clip_t, clip_center_l+2*e, bushing_d]);
                // rail through the whole thing
                translate([bushing_d/2+bushing_t, -e, bushing_t+rail_d/2])
                    rotate([-90, 0, 0])
                    cylinder(d=rail_d, h=bushing_l+2*bushing_t+2*e, $fn=60);
                // bushing outer diameter
                translate([bushing_d/2+bushing_t, bushing_t, bushing_t+rail_d/2])
                    rotate([-90, 0, 0])
                cylinder(d=bushing_d, h=bushing_l, $fn=60);
            }
        }
    }
}
module long() {
    base(screw_y_long);
    translate([0, bushing_l/2-screw_y_long/2-edge_offset+bushing_t])
        clip();
    translate([0, -bushing_l/2+screw_y_long/2+edge_offset-bushing_t])
        clip();
}
module short() {
    base(screw_y_short);
    clip();
}
//long();
translate([-(screw_x/2+edge_offset+separation/2), 0, 0])
    long();
translate([(screw_x/2+edge_offset+separation/2), 0, 0])
    short();
