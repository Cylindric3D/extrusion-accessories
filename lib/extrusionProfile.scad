module extrusionProfile(type="positive", size="2020", length=1, screwDiameter="M4") {
   
   var_screwDiameter = 
      (str(screwDiameter)==screwDiameter) ?     
         ( (screwDiameter == "M4") ? 4.4 : 0 ) :
         ( screwDiameter );
    var_length = length;
    
   module extrusionProfile2020(type="positive") {
       var_height = var_length;
       
       var_Size = 20;
       var_Rounding = 1.5;
       var_CenterHole = 4.3;
       
       module boundingBox() {
           #cube([var_Size,var_Size,var_height],center=true);
       }
       
       module positive() {
           difference() {
               minkowski() {
                cube([var_Size-var_Rounding,var_Size-var_Rounding,var_height],center=true);
                cylinder(d=var_Rounding,h=0.001,center=true);
               }
               cylinder(d=var_CenterHole,h=2*var_height,center=true);
               
               for(i=[0,90,180,270])rotate([0,0,i]){
                   translate([var_Size/2,0,0])cube([2*1.8,6.2,2*var_height],center=true);
                   hull() {
                       translate([var_Size/2-3.4,11/2,0])cylinder(d=0.1,h=2*var_height,center=true);
                       translate([var_Size/2-3.4,-11/2,0])cylinder(d=0.1,h=2*var_height,center=true);
                       translate([var_Size/2-1.8,11/2,0])cylinder(d=0.1,h=2*var_height,center=true);
                       translate([var_Size/2-1.8,-11/2,0])cylinder(d=0.1,h=2*var_height,center=true);
                       translate([var_Size/2-6.1,5.7/2,0])cylinder(d=0.1,h=2*var_height,center=true);
                       translate([var_Size/2-6.1,-5.7/2,0])cylinder(d=0.1,h=2*var_height,center=true);
                   }
               }
           }
       }
       
       module tools(length=50) {
           #for(i=[0,90,180,270])rotate([0,0,i])translate([length/2+7,0,0])rotate([0,90,0])cylinder(d=var_screwDiameter, h=length,center=true);
       }
       
       if (type=="positive")
           positive();
       else if (type=="boundingBox")
           boundingBox();
       else if (type=="tools")
           tools();
   }

   if (size=="2020") extrusionProfile2020(type=type);
}

//extrusionProfile(type="positive");
//extrusionProfile(type="boundingBox");
//extrusionProfile(type="tools");
