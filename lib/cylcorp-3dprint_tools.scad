$fn=50;

// local variables used for this library
PT3D_J = 0.01; // small offset to avoid z-fighting

// Generic hole module
// Creates a simple round hole at the origin, extending downwards (-Z)
// If countersink is true, adds a 45 degree countersink at the top
module round_hole(d=1, h=1, countersink=false) {
    translate([0, 0, -h])
    union() {
        if(countersink) {
            // Countersink part
            translate([0, 0, h-d/2])
            cylinder(d1=d, d2=d*2, h=d/2);

            translate([0, 0, h-PT3D_J])
            cylinder(d=d*2, h=PT3D_J+PT3D_J);
        }

        // Main hole cutter
        cylinder(d=d, h=h+PT3D_J);
    }
}

module teardrop_hole(d=1, h=1) {
    translate([0, 0, -h])
    hull() {
        // Main hole cutter
        cylinder(d=d, h=h+PT3D_J);

        // Tear-drop shaping at top
        translate([0, d*0.5, 0])
        cylinder(d=d*0.3, h=h+PT3D_J);
    }
}

module sawtooth_hole(d=1, h=1) {
    teeth=24;
    bump_size=d*0.1;

    translate([0, 0, -h])
    difference() {
        // Main hole cutter
        cylinder(d=d+bump_size, h=h+PT3D_J);

        // Tear-drop shaping at top
        for(i= [0: 1: teeth-1]) {
            rotate([0, 0, (360/teeth)*i])
            translate([0, d/2+bump_size/2, 0])
            cylinder(d=bump_size, h=(h+PT3D_J)*1.1);
        }
    }
}

module slotted_hole(d=1, h=1) {
    translate([0, 0, -h])
    union() {
        // Main hole cutter
        cylinder(d=d, h=h+PT3D_J);

        hull() {
            translate([0, d*0.75, 0])
            cylinder(d=d*0.2, h=h+PT3D_J);

            translate([0, -d*0.75, 0])
            cylinder(d=d*0.2, h=h+PT3D_J);
        }
    }
}


module slotted_hole_m3(h) {slotted_hole(d=3.2, h=h);}
module teardrop_hole_m3(h) {teardrop_hole(d=3.2, h=h);}
module sawtooth_hole_m3(h) {sawtooth_hole(d=3.2, h=h);}

// Demonstrations
translate([ 0, 0, 0]) round_hole();
translate([ 0, 5, 0]) round_hole(countersink=true);

translate([ 5, 0, 0]) teardrop_hole();
translate([10, 0, 0]) sawtooth_hole();
translate([15, 0, 0]) slotted_hole();