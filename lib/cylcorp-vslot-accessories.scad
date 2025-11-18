include <extrusionProfile.scad>
use <cylcorp-3dprint_tools.scad>

M3 = 3.2;

thickness=3;
width=30;
top_length=30;
extrusion_holes=2;
bolt_size=3.2;

screw_size=3;
screw_holes_x=2;
screw_holes_y=2;
screw_hole_countersink=true;
j=0.1;

$fn=50;

module VSlotWedge(locator_scale=1.0) {
    slot_wedge_depth=1.0;
    v_slot_wide_opening=9;
    if (locator_scale > 0.0) {
        scale([1.0, locator_scale, 1.0])
        rotate([0, 90, 180])
        linear_extrude(height=width)
        polygon(points=[
            [-v_slot_wide_opening/2, j],
            [-v_slot_wide_opening/2+slot_wedge_depth, -slot_wedge_depth],
            [v_slot_wide_opening/2-slot_wedge_depth, -slot_wedge_depth],
            [v_slot_wide_opening/2, j]
        ]);
    }
}

module Bracket2020U(extend_down=0, locator_scale=1.0) {
    extrusion_thickness=20;
    screw_tab_stickout=10;

    translate([-width/2, 0, -extrusion_thickness/2])
    difference() {
        union() {
            // The solid shape of the bracket
            difference() {
                hull() {
                    // Top of the extrusion-attaching part
                    translate([0, -thickness, 0])
                    cube([width, thickness+extrusion_thickness+thickness, extrusion_thickness]);

                    // Bottom of the extrusion-attaching part
                    translate([0, -thickness-screw_tab_stickout, -thickness])
                    cube([width, screw_tab_stickout+thickness+extrusion_thickness+thickness+screw_tab_stickout, thickness]);

                    // Bottom of the baseplate-attaching part
                    translate([0, -thickness-screw_tab_stickout, -extend_down])
                    cube([width, screw_tab_stickout+thickness+extrusion_thickness+thickness+screw_tab_stickout, thickness]);
                }

                // Take out the space where the rail goes
                translate([-j, 0, 0])
                cube([j+width+j, extrusion_thickness, extrusion_thickness+j]);

                // Take out the space down to the baseplate
                translate([width/2, extrusion_thickness/2, -extend_down+thickness])
                for(i = [0: 1: 1]) {
                    rotate([0, 0, i*180])
                    translate([-(width-thickness-thickness)/2, -thickness-extrusion_thickness/2-screw_tab_stickout-j, 0])
                    cube([width-thickness-thickness, screw_tab_stickout+j, extrusion_thickness+extend_down]);
                }
            }

            // Add in the wedges to centre the bracket to the extrusion
            union() {
                // front
                translate([width, 0, extrusion_thickness/2])
                VSlotWedge(locator_scale=locator_scale);

                // back
                translate([0, extrusion_thickness, extrusion_thickness/2])
                rotate([0, 0, 180])
                VSlotWedge(locator_scale=locator_scale);

                // bottom
                translate([width, extrusion_thickness/2, 0])
                rotate([90, 0, 0])
                VSlotWedge(locator_scale=1.0);
            }
        }

        // Cut out bolt-holes for extrusion
        for(i = [1: 1: extrusion_holes]) {
            // side holes
            translate([(width/(extrusion_holes+1))*i, -thickness, extrusion_thickness/2])
            rotate([90, 0, 0])
            teardrop_hole(d=M3, h=100); // 100 just makes sure it goes through all

            // bottom holes
            translate([(width/(extrusion_holes+1))*i, extrusion_thickness/2, 0])
            union() {
                // counterbore
                translate([0, 0, -extend_down-thickness-j])
                cylinder(d=screw_size+4, h=extend_down+j);

                // hole
                translate([0, 0, -thickness])
                rotate([180, 0, 0])
                round_hole(d=screw_size, h=100, countersink=false);
            }
        }

        // Cut out screw-holes for baseplate
        translate([0, 0, -extend_down+thickness])
        union() {
            translate([width*0.25, -thickness-screw_tab_stickout/2, 0])
            round_hole(d=screw_size, h=100, countersink=screw_hole_countersink);

            translate([width*0.75, -thickness-screw_tab_stickout/2, 0])
            round_hole(d=screw_size, h=100, countersink=screw_hole_countersink);

            translate([width*0.25, extrusion_thickness+thickness+screw_tab_stickout/2, 0])
            round_hole(d=screw_size, h=100, countersink=screw_hole_countersink);

            translate([width*0.75, extrusion_thickness+thickness+screw_tab_stickout/2, 0])
            round_hole(d=screw_size, h=100, countersink=screw_hole_countersink);
        }
    }
}

module Bracket2020(extend_down=0) {
    extrusion_thickness=20;

    translate([-width/2, 0, -extrusion_thickness/2])
    difference() {
        // The solid shape of the bracket
        union() {
            hull() {
                // Extrusion-attaching part
                translate([0, -thickness, 0])
                cube([width, thickness, extrusion_thickness]);

                // Baseplate-attaching part
                translate([0, -top_length, -extend_down])
                cube([width, top_length, thickness+extend_down]);
            }

            // The wedge to centre the bracket to the extrusion
            translate([width, 0, extrusion_thickness/2])
            VSlotWedge();
        }

        // Hollow out the bracket
        translate([thickness, -thickness-top_length-thickness, thickness-extend_down])
        cube([width-thickness-thickness, thickness+top_length, extrusion_thickness+extend_down]);

        // Bolt-holes for extrusion
        for(i = [1: 1: extrusion_holes]) {
            translate([(width/(extrusion_holes+1))*i, -thickness, extrusion_thickness/2])
            rotate([90, 0, 0])
            teardrop_hole(d=M3, h=100); // 100 just makes sure it goes through all
        }

        // Screw-holes for baseplate
        hole_location_offset=1.4;
        hole_cutter_height=thickness+j;
        translate([width/2, -top_length/2, 0])
        union() {
            for(dx = [-(screw_holes_x-1)/2: 1: (screw_holes_x-1)/2]) {
                for(dy = [-(screw_holes_y-1)/2: 1: (screw_holes_y-1)/2]) {
                    translate([
                        (width/(screw_holes_x+1))*dx*hole_location_offset,
                        -(top_length/(screw_holes_y+1))*dy*hole_location_offset, 
                        thickness-extend_down
                    ])
                    round_hole(d=screw_size, h=hole_cutter_height+extend_down, countersink=screw_hole_countersink);
                }
            }
        }
    }
}
