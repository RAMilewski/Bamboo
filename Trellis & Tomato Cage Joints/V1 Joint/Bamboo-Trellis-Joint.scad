// Parametric Bamboo Trellis Joint

/* Copyright © 2021 by Richard A. Milewski
Released under the Creative Commons BY-SA 3.0 license.
See the terms at https://creativecommons.org/licenses/by-sa/3.0/  
*/

/* [Primary Parameters] */
// This part is for the topmost ring.
top =   false;
// Number of sides
sides   = 4;   // [1,2,3,4,5,6,7,8,9,10]   
// Diameter of horizontal bamboo in mm
diaH    = 10;  // [5:0.5:25] 
// Diameter of vertical bamboo in mm
diaV    = 8;  // [5:0.5:25]  



/* [Secondary Parameters - CHANGE WITH CAUTION!] */

// Tube shell thickness in mm
shell = 1.5;    
// Height in mm of zip tie collars above shell
collarH = 1.5;  
// Width in mm of zip tie collars
collarW = 2;
// Length of vertical in diameters
lengthV = 2;    
// Length of horizontals in diameters
lengthH = 2.5;    
// Hole position on horizontals (% of LengthH) 
screwH = 60;
// Hole positon on vertical (% of LengthV)
screwV = 70;  
// Diameter of screw hole in mm
diaScr = 3;   
// Fudge factor to adjust horizontal part separation
fudge  = -0.25; 
// Adjust the vertical tube wrap
wrapV = 25;  // [0:35]
// Adjust the horizontal tube wrap
wrapH = 25;  // [0:35]





// Derived values
lenH  = diaH * lengthH;             // Length of horizontal fittings
collarDiaH  = diaH+shell+collarH*2; // Diameter of collar on horizontal fittings
lenV  = diaV * lengthV;             // Length of vertical fittings
collarDiaV  = diaV+shell+collarH*2; // Diameter of collar on vertical fitting
fudge2  = (fudge) * (diaV/2);       // Fudge factor for Hpart spacing. (pulled out of thin air)
posScrH = screwH/100;               // Postition of screw on horizontals
posScrV = screwV/100;               // Postition of screw on vertical
angles  = (sides - 2) * 180;        // Sum of interior angles of the polygon
angle = angles / sides;             // Interior angle of a corner   
liftH = diaH * (wrapH/100);         // Vertical shift of horizontal tubes to adjust wrap
shiftV = diaV * (wrapV/100);        // Horizontal shift of the clearing block to adjust vertical wrap

// ***************************
//         Main
// ***************************

// preview[view:north, tilt:top]

difference() {
    color("DeepSkyBlue",1 ) {
    union() {  // Combine the horizontal parts and the vertical
            Hparts();
            Vpart();
    }}
    // Clear the core of the vertical tube
    translate ([0, 0, -1])
        cylinder ($fn = 64, d = diaV, h = lenV + 2);
    // ...and the space below the plane
    translate ([-50,-50,-50])
        cube ([100,100,50]);
}



// ***************************************************
//         Nothing below here but modules
// ***************************************************


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
                cylinder ($fn = 64, d = (diaH + 2*shell), h = diaV + 2*shell);

            translate ([shiftV, -diaV/2-shell-1, liftH])
                rotate([0,90,90])
                    cylinder ($fn = 64, d = diaH, h = diaV + 2*shell+2);
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
                    cylinder ($fn = 64, d = (diaH + 2*shell), h = lenH );
                
                 // The zip tie collar  
                 translate ([lenH - collarW, 0, 0])
                    rotate([0,90,0])
                        cylinder ($fn = 64, d = collarDiaH, h = collarW );
               }
                union() {
                    // Clear he central core of the tube
                    translate([diaV/2-1,0,liftH])
                    rotate([0,90,0])
                        cylinder ($fn = 64, d = diaH, h = lenH + 2);
                    
                    //The screw hole
                    translate([diaV/2 + ( lenH*posScrH ),0,0])
                        cylinder ($fn = 32, d = diaScr, h = diaH + 3);    
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
                cylinder ($fn = 64, d = (diaV + 2*shell), h = lenV);
        
            // The zip tie collar
            translate ([0, 0, lenV-collarW])
                cylinder ($fn = 64, d = collarDiaV, h = collarW );
        }              
            // The Screw Hole
            translate([0,0,lenV * posScrV])
            rotate([0,90,0])
                cylinder ($fn = 32, d = diaScr, h = diaV + 3);    
    }
}

// "We now return control of your television to you."
//      ...with apologies to the old Outer Limits TV show writers.