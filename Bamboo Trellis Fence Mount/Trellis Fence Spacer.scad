/*#################################################################################*\
   Trellis Fence Spacer.scad
	-----------------------------------------------------------------------------

	Developed by:			Richard A. Milewski
	
	-----------------------------------------------------------------------------

	Version:                1.0.1
	Creation Date:          23 May 2022
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
standoff = 76; 
standoffR = 8;

mount = [50,25,5];

fillet = 5;

bambooR = 10;
wall = 2;
grip = bambooR+wall;
bambooL = standoffR*2;
arc = 200;
tiewrap = ([2,5]);

/*#################################################################################*\
    
    Main

\*#################################################################################*/
	difference() {
		union () {
			scale([1,0.8,1]) cylinder(h=standoff, r=standoffR, $fn=6);
			translate ([0,0,standoff]) rotate([0,90,0])
				 cylinder (h=bambooL, r=grip, center=true);
		}
		union () {
			translate ([0,0,standoff]) rotate([0,90,0]) 
				cylinder(h=bambooL*2, r=bambooR, center=true);
			translate ([0,0,standoff+grip+wall*1.6])
				cube ([bambooL+1, grip*2, grip], center = true);
			translate ([0,0,standoff-bambooR-wall]) rotate([0,90,90])
				cube([tiewrap.x,tiewrap.y,bambooL], center = true);	
			
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

