use <lib/cylcorp-vslot-accessories.scad>
$fn=50;

bolt_size=3;

// Standoff test
//Printing it upright puts the layers lines in the weakest orientation, so lie it down
rotate([0, 90, 0])
union() {
    translate([0, 10, 0])
    rotate([0, 90, 0])
    %extrusionProfile(type="positive", size="2020", length=200);

    Bracket2020U(extend_down=20, locator_scale=0.5, hole_size=M(bolt_size));
}