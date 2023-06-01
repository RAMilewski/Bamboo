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
arc   =  200;   
// radius of second hook curve
loop2  =   16;   
// angle of second hook curve
arc2   =  230; 
// length of straight segment
stem  =   25;   
// width of hook
width =    25;   // width of hook

flat  = 0.2;   // scale factor for hook cross section   1=round or square

round = 8;

hook(loop, arc, stem, width, flat);
move = (loop+loop2);
translate([move,-stem,0]) rotate([0,0,180])
hook(loop2, arc2, stem, width, flat);


module hook(loop, arc, stem, width, flat) {

    $fn = 64;
    halfStem = stem/2;

    rotate_extrude(angle=arc){
       translate([loop,0,0]) scale([flat,1,1]) 
        if (type=="round") {circle(d=width);} 
        else {offset(r=width/round) offset(r=-width/round) square(width,center=true);}
    }
    //stem 
    rotate([90,0,0]) translate([loop,0,0]) scale([flat,1,1])
    if (type == "round") {cylinder(h=halfStem, d=width);} 
    else { linear_extrude(height=halfStem) translate([0,0,stem/2])
            offset(r=width/round) offset(r=-width/round) square(width,center=true);}   
          
    //round loop end
    rotate([0,0,arc-180]) translate([-loop,0,0])  scale([flat,flat,1]) 
    if (type == "round") {sphere(d=width);} 
    else { cyl(h=width, d=width, rounding=width/round);}
    
    

              
    
}

