/*#################################################################################*\
    S-Hook.scad
	-----------------------------------------------------------------------------

	Developed by:			Richard A. Milewski
	Description:            Parametric S-Hook 

	Version:                1.0
	Creation Date:          8 June 2022

    Copyright ©2021-2022 by Richard A. Milewski
    License - CC-BY-SA      https://creativecommons.org/licenses/by-sa/3.0/ 

\*#################################################################################*/
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>


type = "square";     // ("round","square")
// radius of first hook curve
loop  =   12;   
// angle of first hook curve
arc   =  220;   
// radius of second hook curve
loop2  =   5;   
// false flips the second loop
trueS = true;
// angle of second hook curve
arc2   =  160; 
// length of straight segment
stem  =   20;   
// width of hook
width =    3;   // width of hook

flat  = 1;   // scale factor for hook cross section

round = 4;

if (trueS) s_hook(); else c_hook();


module s_hook() {
    hook(loop, arc, stem, width, flat);
    move = loop + loop2;
    translate([move,-stem,0]) rotate([180,180,0])
        hook(loop2, arc2, 0, width, flat);
}

module c_hook() {
     hook(loop, arc, stem, width, flat);
    move = loop - loop2;
    translate([move,-stem,0]) rotate([180,0,0])
        hook(loop2, arc2, 0, width, flat);
}



module hook(loop, arc, stem, width, flat) {

    $fn = 64;
    halfStem = stem/2;

    //First loop end
    rotate_extrude(angle=arc){
       xmove(loop) scale([flat,1,1]) 
        if (type=="round") {circle(d=width);} 
        else {offset(r=width/round) offset(r=-width/round) square(width,center=true);}
    }
    //stem 
    xrot(90) xmove(loop) scale([flat,1,1])
    if (type == "round") {cylinder(h=stem, d=width);} 
    else { linear_extrude(height=stem) translate([0,0,stem/2])
            offset(r=width/round) offset(r=-width/round) square(width,center=true);}   
          
    //Round the loop end
    zrot(arc-180) xmove(-loop)  scale([flat,flat,1]) 
    if (type == "round") {sphere(d=width);} 
    else { cyl(h=width, d=width, rounding=width/round);}
    
    

              
    
}

