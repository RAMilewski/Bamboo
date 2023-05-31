/*#################################################################################*\
   FenceFrame.scad
	-----------------------------------------------------------------------------

	Developed by:			Richard A. Milewski
	Description:            Bamboo Fence Builder
   	

	Version:                1.0
	Creation Date:          
	Modification Date:      
	Email:                  richard+scad@milewski.org
	Copyright 				©2023 by Richard A. Milewski
    License - CC-BY-NC      https://creativecommons.org/licenses/by-nc/3.0/ 

\*#################################################################################*/


/*#################################################################################*\
    
    Notes

	Requires the BOSL2 library for OpenSCAD  https://github.com/revarbat/BOSL2/wiki

\*#################################################################################*/


/*#################################################################################*\
    
    CONFIGURATION

\*#################################################################################*/
include <BOSL2/std.scad>	// https://github.com/revarbat/BOSL2/wiki

bamboo = 13;   // Diameter
length = 160;  // holder length
ring = [2, undef, 2];     // wall, undef, height
grip = 1;
center = 3;
slice = 45;
module hide_variables () {}  // variables below hidden from Customizer

$fn = 72;               //openSCAD roundness variable
eps = 0.01;             //fudge factor to display holes properly in preview mode
$slop = 0.025;			//printer dependent fudge factor for nested parts
 
count = floor(length/(bamboo + ring.x/2));
delta = bamboo + ring.x - 0.25;


/*#################################################################################*\
    
    Main

\*#################################################################################*/

   row(count);

/*#################################################################################*\
    
    Modules

\*#################################################################################*/

module frame() {
    row(count); 
    back(delta) row(count-1);
}

module coupler() {
    row(2);
    back(delta) ring();
}

module row(count) {
    xcopies(n = count, spacing = delta) ring();
}

module ring() {
    tube(id = bamboo, wall = ring.x, h = ring.z, anchor = BOT);
    difference() {
        zrot_copies(n = 4) pie_slice(d =  bamboo + ring.x, h = grip, spin = (90 - slice)/2, ang = slice, anchor = BOT);
        cyl(d = center, h = ring.z, anchor = BOT);
    }
}



module echo2(arg) {						// for debugging - puts space around the echo.
	echo(str("\n\n", arg, "\n\n" ));
}