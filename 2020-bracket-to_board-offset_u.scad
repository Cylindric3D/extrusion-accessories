use <lib/cylcorp-vslot-accessories.scad>
$fn=50;

// Standoff test
translate([0, 10, 0])
rotate([0, 90, 0])
%extrusionProfile(type="positive", size="2020", length=200);

Bracket2020U(extend_down=20, locator_scale=0.5);
