/*#################################################################################*\
   Grating Fence Mount.scad
	-----------------------------------------------------------------------------

	Developed by:			Richard A. Milewski
	
	-----------------------------------------------------------------------------

	Description: 			Fence Mount for Wooden Grating
	Version:                1
	Creation Date:          28 June 2023
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
$fn = 72;
eps = 0.1;
standoff = [15, 25, 2*INCH];
mount = [60,25,8];
grip  = [60,25,25];
notch = [25,25 + eps, 20 + eps];
corner = 3;
fillet = -5;
wedge = [standoff.x, 30 + corner, standoff.z + mount.z + 2];
hypot = adj_opp_to_hyp(wedge.y, wedge.z);
ha_angle = hyp_adj_to_ang(hypot,wedge.y);
echo2(ha_angle);
/*#################################################################################*\
    
    Main

\*#################################################################################*/
	diff() {
		
		cuboid (mount, rounding = corner, except = BOT, anchor = BOT) {
			attach(TOP) cuboid(standoff, rounding = corner, edges = "Z", anchor = BOT)
					attach(TOP, overlap = 3) grip();
		}
		tag("remove") xcopies(n=2, spacing = 34) #screwHole();	
	}
	fwd(wedge.y/2 + standoff.y/2 - corner) zrot(180) 
	diff() {
    wedge(wedge, anchor = BOT)  {
        tag("remove") attach("hypot") rot([270,0,0]) left(wedge.x/2) rounding_edge_mask(l = hypot, r = corner);
        tag("remove") attach("hypot") rot([270,90,0]) fwd(wedge.x/2) rounding_edge_mask(l = hypot, r = corner);
    }
}

/*#################################################################################*\
    
    Modules

\*#################################################################################*/

module grip () {
	diff("remove2") 
		cuboid(grip, rounding = 2, anchor = BOT) {
			tag("remove2") attach(TOP, overlap = -0.1) cuboid(notch, anchor = TOP);
		}
}

module screwHole () {
	cylinder (h=mount.z, r=2);
	zmove(mount.z/2) cylinder(h=mount.z/2, r1=2, r2=4);
}

module echo2(arg) {						// for debugging - puts space around the echo.
	echo(str("\n\n", arg, "\n\n" ));
}