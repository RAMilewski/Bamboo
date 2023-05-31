/*#################################################################################*\
   Trellis Fence Mount.scad
	-----------------------------------------------------------------------------

	Developed by:			Richard A. Milewski
	
	-----------------------------------------------------------------------------

	Version:                1.0.1
	Creation Date:          11 May 2022
	Modification Date:      
	Email:                  Richard A. Milewski
	Description:            
    Copyright ©2022 by Richard A. Milewski
    License - CC-BY-NC

\*#################################################################################*/
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>


/*#################################################################################*\
    
    CONFIGURATION

\*#################################################################################*/
$fn = 360;
standoff = 2 * INCH; 
standoffR = 8;

mount = [50,25,5];

fillet = 5;

bambooR = 11.7;
wall = 2;
grip = bambooR+wall;
bambooL = 35;
arc = 200;

/*#################################################################################*\
    
    Main

\*#################################################################################*/
	difference() {
		union () {
			join_prism(circle(r=standoffR),base="plane",
			length=standoff, fillet=3, n=12);
			translate([-mount.x/2,-mount.y/2,-mount.z/2]) 
				rounded_prism(square([mount.x,mount.y]), height=mount.z,
              	joint_top=1, joint_bot=1, joint_sides=2.5);

			translate ([0,0,standoff]) rotate([0,90,0])
				cylinder (h=bambooL, r=grip, center=true);
		}
		union () {
			translate ([0,0,standoff]) rotate([0,90,0]) 
				cylinder(h=bambooL+1, r=bambooR, center=true);
			translate ([0,0,standoff+bambooR*.9])
				cube ([bambooL+1, grip*2, grip], center = true);
			translate([bambooL/2,0,-mount.z]) screwHole();
			translate([-bambooL/2,0,-mount.z]) screwHole();
		}				
		
	}

/*#################################################################################*\
    
    Modules
f
\*#################################################################################*/
module screwHole () {
	cylinder (h=mount.z, r=2);
	translate ([0,0,mount.z/2]) cylinder(h=mount.z/2, r1=2, r2=4);
}

