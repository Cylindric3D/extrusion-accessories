use <lib/cylcorp-vslot-accessories.scad>
$fn=50;

bolt_size=4;

// Standoff test
translate([0, 10, 0])
rotate([0, 90, 0])
%extrusionProfile(type="positive", size="2020", length=200);

Bracket2020(extend_down=20, hole_size=M(bolt_size));
 