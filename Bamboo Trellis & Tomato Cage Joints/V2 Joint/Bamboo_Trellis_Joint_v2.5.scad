/*#################################################################################*\
    Bamboo_Trellis_Joint_v2.scad
	-----------------------------------------------------------------------------

	Developed by:			Richard A. Milewski
	Description:            Parametric Joint for Bamboo Trellises and Tomato Cages

	Version:                2.5
	Creation Date:          21 Apr 2021
	Modification Dates:     25 May 2022 - Added Optional Top Plate
                            26 May 2022 - Changed calculation of lenV
                            30 MAY 2022 - Added inner zip tie collar
	                        02 Jun 2022 - Adjusted Secondary Parameters	
                            13 Jun 2022 - Revised lenH & lenV calculations
   
    Copyright ©2021-2022 by Richard A. Milewski
    License - CC-BY-NC      https://creativecommons.org/licenses/by-nc/3.0/ 

\*#################################################################################*/

/*#################################################################################*|

    NOTES
        Joints should be mounted upside down from the way they print.  
        Horizontals should support the bamboo.

        If your printer supports it, I highly recommend printing these parts 
        with TPU filament.  If not, PETG appears to weather better than PLA.

        ABS and ASA are not recommended.  They are more UV resistant, but quite 
        hazerdous to print without proper ventilation.  Use at your own risk.

        IMPORTANT: If you fasten with zip ties use those labeled "UV resistant" and
        with a minimum of 40lbs of tensile strength.  Use a zip tie gun!

        If you print with the optional top cap, closely matching diaV to the diameter
        of the bamboo is more important, particularly if you print with rigid filament.

\*#################################################################################*/

/*#################################################################################*\

    CONFIGURATION

\*#################################################################################*/

/* [Primary Parameters] */

// This part is for the topmost ring and has a top cap
top = true; // [true,false]
// Number of sides
sides = 5;   // [1,2,3,4,5,6,7,8,9,10]   

/*  ABOUT BAMBOO DIAMETERS
    Bamboo horizontals should be cut and then sorted so that the end diamters of each
    ring are within 2mm of each other then set diaH to the mean value of the diameters.
    Bamboo verticals should be measured at the mount point for each horizontal ring
    and diaV set to the mean value of diameters at that mount point.
    Obviously, joints printed with flex filament are more forgiving of diameter
    mis-matches than those printed from rigid filament. 
*/

// Diameter of horizontal bamboo in mm
diaH  = 16;  // [5:0.25:25]  
// Diameter of vertical bamboo in mm
diaV  = 24 ;  // [5:0.25:25]  


/* [Secondary Parameters - CHANGE WITH CAUTION!] */ 

// Keep everything round | higher numbers increase rendering time.
$fn = 36;
// Tube shell thickness in mm  | 1 for flex, >=1.5 for rigid filament.
shell = 1;    
// Height in mm of zip tie collars above shell
collarH = 1.5;  
// Width in mm of zip tie collars
collarW = 2;
// Length of vertical above the horizontals in vertical diameters 
lengthV = 2;    
// Length of horizontals in diameters
lengthH = 2;    
// Hole position on horizontals (% of LengthH) 
screwH = 60;
// Hole positon on vertical (% of LengthV)
screwV = 70;  
// Diameter of screw hole in mm
diaScr = 3;   
// Fudge factor to adjust horizontal part separation
fudge  = -0.25; 
// Fudge factor to keep holes visible in preview  
fudgeP = 0.5;
// Thickness of top plate
topZ  = 1.5;

/*  
Tube Wrap parameters
Higher numbers provide a more secure joint, lower reduce print time.
40 is a recommended starting point for flex filament, 25 for rigid filament.
Low values, with shell values >= 2 may work if you use the wire-wrap method 
to secure the bamboo to the joint.
*/

// Adjust the vertical tube wrap
wrapV = 45;  // [15:48]
// Adjust the horizontal tube wrap
wrapH = 40;  // [15:48]


// Derived values
liftH = diaH * (wrapH/100);              // Vertical shift of horizontal tubes to adjust wrap
shiftV = diaV * (wrapV/100);             // Horizontal shift of the clearing block to adjust vertical wrap
lenH = diaH * lengthH + diaV + shell;    // Length of horizontal fittings
collarDiaH  = diaH+shell*2+collarH*2;    // Diameter of collar on horizontal fittings
heightH = diaH-liftH+shell;              // Height of horizontals (minus tire-wrap collars).        
lenV = diaV * lengthV + diaH + shell; // Length of vertical fittings
collarDiaV  = diaV+shell*2+collarH*2;    // Diameter of collar on vertical fitting
fudge2  = (fudge) * (diaV/2);            // Fudge factor for Hpart spacing. (pulled out of thin air)
posScrH = screwH/100;                    // Position of screw on horizontals
PosCol2H = lenH*posScrH-diaScr*0.75;     // Position of inner collar on horizontals 
posScrV = screwV/100;                    // Position of screw on vertical
PosCol2V = lenV*posScrV-diaScr*0.75;     // Position of inner collar on horizontals 
angles  = (sides - 2) * 180;             // Sum of interior angles of the polygon
angle = angles / sides;                  // Interior angle of a corner   

/*#################################################################################*|

    MAIN

\*#################################################################################*/


difference() {
    color("DeepSkyBlue",1 ) {
        union() {  // Combine the horizontals and the verticals
                Hparts();
                Vpart();
        }}
    // Clear the core of the vertical tube
    translate ([0, 0, -1])
        cylinder (d = diaV, h = lenV + 2);
    // ...and the space below the plane
    translate ([-50,-50,-50])
        cube ([100,100,50]);
}
color("DeepSkyBlue",1 ) {
    // Add top plate (or not)
    if (top == true) {
        difference() {
            cylinder(h=topZ, d=diaV+shell*2);
            cylinder(h=topZ+fudgeP, d=diaScr);
        }
    }
}





/*#################################################################################*|

    MODULES

\*#################################################################################*/

// "We control the horizontal..."

module Hparts() {
    if (sides > 2) {  // Polygonal or Zig-zag Trellis
        translate ([0, -fudge2, 0])
            rotate(-angle/2,[0,0,1])
                Hpart();

        translate ([0, fudge2, 0])
            rotate(angle/2,[0,0,1])
                Hpart();
    }     
    if (sides == 1) {Hpart();}  // Special case for L bracket
    if (sides == 2) {           // Special case for T bracket
        translate ([shiftV, -fudge2, 0])
        rotate(-90,[0,0,1])
            Hpart();

        translate ([shiftV, fudge2, 0])
        rotate(90,[0,0,1])
            Hpart();

        // Fill the gap across the vertical
        difference() {
            translate ([shiftV, -diaV/2-shell, liftH])
            rotate([0,90,90])
                cylinder (d = (diaH + 2*shell), h = diaV + 2*shell);

            translate ([shiftV, -diaV/2-shell-1, liftH])
                rotate([0,90,90])
                    cylinder (d = diaH, h = diaV + 2*shell+2);
        }
    }
}

module Hpart () {
    
    difference() { // Slice off part of the tube

        Htube ();
            
          translate([diaV/2-1, collarDiaH/-2, -collarDiaH])
                cube ([lenH+2, collarDiaH, collarDiaH]);
    }
}

module Htube() {
    difference() {
 
        difference() {
            translate([diaV/2.5,0,liftH])
           
               union() {
                 // The tube
                 rotate([0,90,0])
                    cylinder (d = (diaH + 2*shell), h = lenH );
                
                 // The zip tie collar  
                 translate ([lenH - collarW, 0, 0])
                    rotate([0,90,0])
                        cylinder (d = collarDiaH, h = collarW );

                 // The inner zip tie collar  
                 translate ([PosCol2H - collarW, 0, 0])
                    rotate([0,90,0])
                        cylinder (d = collarDiaH, h = collarW );
               }
                union() {
                    // Clear he central core of the tube
                    translate([diaV/2-1,0,liftH])
                    rotate([0,90,0])
                        cylinder (d = diaH, h = lenH + 2);
                    
                    //The screw hole
                    translate([diaV/2 + ( lenH*posScrH ),0,0])
                        cylinder ($fn = 32, d = diaScr, h = diaH + shell);    
            }   
        }
    }
}


// "...and we control the vertical." 

module Vpart() {
    
    difference() { // Slice off part of the tube      
        Vtube(); 
        translate([(-collarDiaV/2)-shiftV, -collarDiaV/2, -0.5])
            cube ([collarDiaV/2, collarDiaV, lenV+1]);   
    }
}


module Vtube () {
    difference() {
        union() {
            // The tube
            translate ([0, 0, 0])
                cylinder (d = (diaV + 2*shell), h = lenV);
        
            // The zip tie collar
            translate ([0, 0, lenV-collarW])
                cylinder (d = collarDiaV, h = collarW );

            // The inner zip tie collar  
            translate ([0,0,PosCol2V - collarW])
                rotate([0,0,0])
                cylinder (d = collarDiaV, h = collarW );

        }              
            // The Screw Hole
            translate([0,0,lenV * posScrV])
            rotate([0,90,0])
                cylinder ($fn = 32, d = diaScr, h = diaV + shell);    
    }
}

echo("*****");
echo();
label = str("-",sides,"-",diaH,"-",diaV);
echo(label);

// "We now return control of your system to you."
//      ...with apologies to the old Outer Limits TV show writers.