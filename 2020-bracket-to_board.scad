use <lib/cylcorp-vslot-accessories.scad>
$fn=50;

bolt_size=4;

// Bracket test
translate([0, 10, 0])
rotate([0, 90, 0])
%extrusionProfile(type="positive", size="2020", length=100);

Bracket2020(hole_size=M(bolt_size));
