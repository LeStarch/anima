// **********************************************************************************
// A Simple Tracked Exploation vehicle 
//  Author: David M. Flynn 2015

// **********************************************************************************
// **********************************************************************************
//     For STL and 3D Printing

	//Bumper();			// Print 2
	//RollPlateSTL();	// Print 4
	//DetectorHolder();	// Print 2
	//EmitterHolder();	// Print 2
	IdlerWheel();		// Half of an idler wheel, Print 8

// **********************************************************************************
//		For laser cutting (export as DXF)

	//SidePlate2D(IsInner=1);	// Cut 2
	//SidePlate2D(IsInner=0);	// Cut 2
	//TnB_Plate2D();			// Cut 2

// **********************************************************************************
//     For viewing

	//ShowAll();
	
	//SidePlate();
	//translate([0,SidePalteSpace/2+3,0]) rotate([-90,0,0]) Bumper();

// **********************************************************************************

include <CommonStuff.scad> // Screw holes and stuff

Track_t=14.5;			// Thickness of track from LynxMotion.com
Track_w=51;  			// Width of track
SidePalteSpace=38;		// Length of 6-32 x 1.5" threaded stand-off
Sprocket_r=32.5;		// LynxMotion track sprocket
Sprocket_cl=304;		// axil centerline
Spocket_sep=150;		// track seperation cl-cl

Plate_t=3;
InsidePlate_t=6;
	
DriveMotor_r=17.5;
DriveMotor_l=73;
DriveMotorBoss_r=6;
DriveMotorBoltCircle_r=14;
LED_l=7;
LED_r=2.5;

SecondIdleInset=97.5;
QEMount=15;
QEHole=22.5;
	
Plate_h=64;
IdleBearing_r=4;

hBoltHeadTorx6=3.5;
rBoltHeadTorx6=3;

module BoltHeadHoleTorx6(depth=16,lAccessDepth=12){
translate([0,0,-depth])
cylinder(r=rBoltClear6,h=depth,$fn=24);
translate([0,0,-hBoltHeadTorx6])
cylinder(r=rBoltHeadTorx6,h=lAccessDepth,$fn=24);
} // BoltHeadHolePan6

module Bumper(){
    Bumper_w=Spocket_sep-SidePalteSpace-6;
    difference(){
        cylinder(r=Sprocket_r-2,h=Bumper_w,$fn=90);
		
		translate([0,0,-0.05]) cylinder(r=Sprocket_r-12,h=Bumper_w+0.1,$fn=90);
		
		// Back
        translate([0,-Sprocket_r,-0.05]) cube([Sprocket_r,Sprocket_r*2,Spocket_sep-SidePalteSpace-6+0.1]);
        
		// Headlights
		translate([-Sprocket_r+1.9,0,15]){
		rotate([0,90,0]) cylinder(r=LED_r, h=LED_l,$fn=36);
		translate([5,0,0]) rotate([0,90,0]) cylinder(r=LED_r+2, h=10,$fn=36);}
		
		translate([-Sprocket_r+1.9,0,Bumper_w-15]){
		rotate([0,90,0]) cylinder(r=LED_r, h=LED_l,$fn=36);
		translate([5,0,0]) rotate([0,90,0]) cylinder(r=LED_r+2, h=10,$fn=36);}
		
		// Camera 
		translate([-Sprocket_r+1.9,0,Bumper_w/2]){
		rotate([0,90,0]) cylinder(r=6, h=10,$fn=36);
		translate([8,0,0]) rotate([0,90,0]) cylinder(r=15, h=10,$fn=36);}

		// Bolt Holes
        translate([-6,Plate_h/2-8,3.15]) rotate([0,-90,0]) BoltHeadHoleTorx6(lAccessDepth=30);
        translate([-6,-Plate_h/2+8,3.15]) rotate([0,-90,0]) BoltHeadHoleTorx6(lAccessDepth=30);
        translate([-6,Plate_h/2-8,Bumper_w-3.15]) rotate([0,-90,0]) BoltHeadHoleTorx6(lAccessDepth=30);
        translate([-6,-Plate_h/2+8,Bumper_w-3.15]) rotate([0,-90,0]) BoltHeadHoleTorx6(lAccessDepth=30);

    } // diff
    
} // Bumper


module IdlerWheel(){
	IW_r=34; // 6/20/15 increased from 32.5 to lift center of vehicle and make turning easier.
	IW_h=15.4;
	IW_BC_r=15.84/2;
	
	difference(){
		cylinder(r=IW_r,h=IW_h,$fn=180);
		
		translate([0,0,2]) cylinder(r1=IW_r-3.5,r2=IW_r-2,h=IW_h,$fn=180);
		translate([0,0,-0.05]) cylinder(r=4.9,h=3,$fn=60);
		
		for (J=[0:3]){
			rotate([0,0,J*90]) translate([IW_BC_r,0,4]) BoltClearHole();}
		
	} // diff
} // IdlerWheel


module EmitterHolder(){
	boltBoss_r=4;
	$fn=90;
	
	difference(){
		union(){
		// base
		hull(){
			translate([(QEMount+boltBoss_r*2)/2,-boltBoss_r,0]) cylinder(r=1,h=3);
			translate([-(QEMount+boltBoss_r*2)/2,-boltBoss_r,0]) cylinder(r=1,h=3);
			translate([(QEMount+boltBoss_r*2)/2,QEHole-QEMount+boltBoss_r,0]) cylinder(r=1,h=3);
			translate([-(QEMount+boltBoss_r*2)/2,QEHole-QEMount+boltBoss_r,0]) cylinder(r=1,h=3);
		} // hull
		// LED
		translate([0,QEHole-QEMount,0]) cylinder(r=LED_r+3,h=LED_l);
		
		// mounting
		translate([-QEMount/2,0,0]) cylinder(r=boltBoss_r,h=10);
		translate([QEMount/2,0,0]) cylinder(r=boltBoss_r,h=10);
	} // union
		
	// LED
		translate([0,QEHole-QEMount,-0.05]) cylinder(r=2.7,h=10);
	
	// Bolts
		translate([-QEMount/2,0,11]) BoltHole();
		translate([QEMount/2,0,11]) BoltHole();
	} // diff
} // EmitterHolder



module DetectorHolder(){
	boltBoss_r=4;
	PQ_l=5.6;
	PQ_r=2.35;
	$fn=90;
	PQ_a=13;
	PQ_Space=0.35;
	
	difference(){
		union(){
		// base
		hull(){
			translate([(QEMount+boltBoss_r*2)/2,-boltBoss_r,0]) cylinder(r=1,h=3);
			translate([-(QEMount+boltBoss_r*2)/2,-boltBoss_r,0]) cylinder(r=1,h=3);
			translate([(QEMount+boltBoss_r*2)/2,QEHole-QEMount+boltBoss_r,0]) cylinder(r=1,h=3);
			translate([-(QEMount+boltBoss_r*2)/2,QEHole-QEMount+boltBoss_r,0]) cylinder(r=1,h=3);
		} // hull
		// PhotoTransistors
		translate([PQ_r+PQ_Space,QEHole-QEMount,0]) rotate([0,PQ_a,0]) translate([0,0,1.5]) cylinder(r=PQ_r+2.6,h=PQ_l-1.5);
		translate([-PQ_r-PQ_Space,QEHole-QEMount,0]) rotate([0,-PQ_a,0]) translate([0,0,1.5]) cylinder(r=PQ_r+2.6,h=PQ_l-1.5);
		
		// mounting
		translate([-QEMount/2,0,0]) cylinder(r=boltBoss_r,h=14);
		translate([QEMount/2,0,0]) cylinder(r=boltBoss_r,h=14);
	} // union
		
	// PhotoTransistors
		translate([PQ_r+PQ_Space,QEHole-QEMount,0]) rotate([0,PQ_a,0]) translate([0,0,-1]) cylinder(r=PQ_r,h=10);
		translate([-PQ_r-PQ_Space,QEHole-QEMount,0]) rotate([0,-PQ_a,0]) translate([0,0,-1]) cylinder(r=PQ_r,h=10);
		
		// cleanup
	translate([0,QEHole-QEMount,PQ_l+0.4]) cylinder(r=PQ_r+3,h=2);
	
	// Bolts
		translate([-QEMount/2,0,14]) BoltHole();
		translate([QEMount/2,0,14]) BoltHole();
	} // diff
	
		// projection lines
	//	translate([PQ_r+PQ_Space,QEHole-QEMount,0]) rotate([0,PQ_a,0]) translate([0,0,-20]) cylinder(r=0.1,h=30);
	//	translate([-PQ_r-PQ_Space,QEHole-QEMount,0]) rotate([0,-PQ_a,0]) translate([0,0,-20]) cylinder(r=0.1,h=30);

} // DetectorHolder


module SidePlate2D(IsInner=1){
	
    LaserIDInc=0.07;
    
    
	$fn=180;
	difference(){
		hull(){
		circle(r=Plate_h/2);
		translate([Sprocket_cl,0,0]) circle(r=Plate_h/2);
		} // hull
		
		
			circle(r=IdleBearing_r-LaserIDInc);
			translate([SecondIdleInset,0,0]) circle(r=IdleBearing_r-LaserIDInc);
		
			// Encoder mount
            translate([QEMount,QEMount/2,0]) circle(r=1.6);
            translate([QEMount,0,0]) circle(r=2);
			translate([QEMount,-QEMount/2,0]) circle(r=1.6);
			
			translate([Sprocket_cl-SecondIdleInset,0,0]) circle(r=IdleBearing_r-LaserIDInc);
			
        if (IsInner==1){
			translate([Sprocket_cl,0,0]){
                hull(){
                    translate([1,0,0]) circle(r=DriveMotorBoss_r);
                    translate([-1,0,0]) circle(r=DriveMotorBoss_r);
                }
				for (J=[0:2]) hull(){
                    translate([1,0,0]) rotate([0,0,120*J]) translate([DriveMotorBoltCircle_r,0,0]) circle(r=1.6);
                    translate([-1,0,0]) rotate([0,0,120*J]) translate([DriveMotorBoltCircle_r,0,0]) circle(r=1.6);
			}}}
			
			// spacer bolt holes
			translate([SecondIdleInset/2,0,0]){
			translate([0,Plate_h/2-8,0]) circle(r=2);
                translate([0,0,0]) circle(r=3); // wire hole
			translate([0,-Plate_h/2+8,0]) circle(r=2);}
			
			translate([Sprocket_cl/2,0,0]){
			translate([0,Plate_h/2-8,0]) circle(r=2);
                translate([0,0,0]) circle(r=3); // wire hole
			translate([0,-Plate_h/2+8,0]) circle(r=2);}
			
			translate([Sprocket_cl-SecondIdleInset/2,0,0]){
			translate([0,Plate_h/2-8,0]) circle(r=2);
                translate([0,0,0]) circle(r=3); // wire hole
			translate([0,-Plate_h/2+8,0]) circle(r=2);}
			
		
	} // diff
} // SidePlate2D

module SidePlate(IsInner=1){
	
	
	difference(){
		hull(){
		cylinder(r=Plate_h/2, h=Plate_t);
		translate([Sprocket_cl,0,0]) cylinder(r=Plate_h/2, h=Plate_t);
		} // hull
		
		translate([0,0,-0.05]){
			cylinder(r=IdleBearing_r, h=Plate_t+0.1);
			translate([SecondIdleInset,0,0]) cylinder(r=IdleBearing_r, h=Plate_t+0.1);
			translate([Sprocket_cl-SecondIdleInset,0,0]) cylinder(r=IdleBearing_r, h=Plate_t+0.1);
					
			// Encoder holes
			translate([QEMount,QEMount/2,0]) cylinder(r=1.6, h=Plate_t+0.1);
            translate([QEMount,0,0]) cylinder(r=2, h=Plate_t+0.1);
			translate([QEMount,-QEMount/2,0]) cylinder(r=1.6, h=Plate_t+0.1);

			if (IsInner==1){
			translate([Sprocket_cl,0,0]){
				hull(){
					translate([1,0,0]) cylinder(r=DriveMotorBoss_r, h=Plate_t+0.1);
					translate([-1,0,0]) cylinder(r=DriveMotorBoss_r, h=Plate_t+0.1);
				}
				for (J=[0:2]) hull(){
					translate([1,0,0]) rotate([0,0,120*J])
						translate([DriveMotorBoltCircle_r,0,0]) cylinder(r=1.6, h=Plate_t+0.1);
					translate([-1,0,0]) rotate([0,0,120*J])
						translate([DriveMotorBoltCircle_r,0,0]) cylinder(r=1.6, h=Plate_t+0.1);
			}}}
			

			// spacer bolt holes
			translate([SecondIdleInset/2,0,0]){
			translate([0,Plate_h/2-8,0]) cylinder(r=2, h=Plate_t+0.1);
				translate([0,0,0]) cylinder(r=3, h=Plate_t+0.1); // wire holes
			translate([0,-Plate_h/2+8,0]) cylinder(r=2, h=Plate_t+0.1);}
			
			translate([Sprocket_cl/2,0,0]){
			translate([0,Plate_h/2-8,0]) cylinder(r=2, h=Plate_t+0.1);
				translate([0,0,0]) cylinder(r=3, h=Plate_t+0.1); // wire holes
			translate([0,-Plate_h/2+8,0]) cylinder(r=2, h=Plate_t+0.1);}
			
			translate([Sprocket_cl-SecondIdleInset/2,0,0]){
			translate([0,Plate_h/2-8,0]) cylinder(r=2, h=Plate_t+0.1);
				translate([0,0,0]) cylinder(r=3, h=Plate_t+0.1); // wire holes
			translate([0,-Plate_h/2+8,0]) cylinder(r=2, h=Plate_t+0.1);}
			
		}
	} // diff
} // SidePlate

//SidePlate();

module Track(){
	CordOffset=2;
    difference(){
        hull(){
			translate([0,0,-Track_w/2]) cylinder(r=Sprocket_r+Track_t,h=Track_w,$fn=9);
			translate([Sprocket_cl,0,-Track_w/2]) cylinder(r=Sprocket_r+Track_t,h=Track_w,$fn=9);
        } // hull
        hull(){
			translate([0,0,-Track_w/2-0.05]) cylinder(r=Sprocket_r+CordOffset,h=Track_w+0.1,$fn=9);
			translate([Sprocket_cl,0,-Track_w/2-0.05]) cylinder(r=Sprocket_r+CordOffset,h=Track_w+0.1,$fn=9);
        } // hull
    } // diff

} // Track

//Track();

module BatteryPack(){
	rotate([0,0,90]) cube([150,60,40],center=true);
} // BatteryPack


module DriveMotor(){
	translate([0,0,SidePalteSpace/2+Plate_t]) cylinder(r=DriveMotor_r,h=DriveMotor_l);
} // DriveMotor

rBoltClear6=2;
hBoltHeadPan6=3;
rBoltHeadPan6=4;

module BoltHeadHolePan6(depth=16,lAccessDepth=12){
	translate([0,0,-depth])
		cylinder(r=rBoltClear6,h=depth,$fn=24);
	translate([0,0,-hBoltHeadPan6])
		cylinder(r=rBoltHeadPan6,h=lAccessDepth,$fn=24);
} // BoltHeadHolePan6

module RollPlate(){
    StandOff_h=10;
    BoltBoss_h=7;
	
    difference(){
		hull(){
			cylinder(r=Sprocket_r-3.5, h=StandOff_h+0.1);
			translate([Sprocket_cl,0,0]) cylinder(r=Sprocket_r-3.5, h=StandOff_h+0.1);
		} // hull
		
		translate([0,0,-0.05]){
			cylinder(r=IdleBearing_r, h=Plate_t+0.1);
			translate([SecondIdleInset,0,0]) cylinder(r=IdleBearing_r, h=Plate_t+0.1);
			translate([Sprocket_cl-SecondIdleInset,0,0]) cylinder(r=IdleBearing_r, h=Plate_t+0.1);
						
			translate([SecondIdleInset+QEMount,QEMount/2,0]) cylinder(r=1.6, h=Plate_t+0.1);
            translate([SecondIdleInset+QEMount,0,0]) cylinder(r=2, h=Plate_t+0.1);
			translate([SecondIdleInset+QEMount,-QEMount/2,0]) cylinder(r=1.6, h=Plate_t+0.1);
		}
				// spacer bolt holes
			translate([SecondIdleInset/2,0,0]){
			translate([0,Plate_h/2-8,BoltBoss_h]) BoltHeadHolePan6();
				translate([0,0,-0.05]) cylinder(r=3, h=StandOff_h+0.1); // wire holes
			translate([0,-Plate_h/2+8,BoltBoss_h]) BoltHeadHolePan6();}
			
			translate([Sprocket_cl/2,0,0]){
			translate([0,Plate_h/2-8,BoltBoss_h]) BoltHeadHolePan6();
				translate([0,0,-0.05]) cylinder(r=3, h=StandOff_h+0.1); // wire holes
			translate([0,-Plate_h/2+8,BoltBoss_h]) BoltHeadHolePan6();}
			
			translate([Sprocket_cl-SecondIdleInset/2,0,0]){
			translate([0,Plate_h/2-8,BoltBoss_h]) BoltHeadHolePan6();
				translate([0,0,-0.05]) cylinder(r=3, h=StandOff_h+0.1); // wire holes
			translate([0,-Plate_h/2+8,BoltBoss_h]) BoltHeadHolePan6();}
		
        } // diff
    
    translate([0,0,StandOff_h])
    
	difference(){
		translate([0,0,-15])
		hull(){
			sphere(r=Sprocket_r);
			translate([Sprocket_cl,0,0]) sphere(r=Sprocket_r);
		} // hull
		translate([-Sprocket_r,-Sprocket_r,0]) mirror([0,0,1])
            cube([Sprocket_cl+Sprocket_r*2+1,Sprocket_r*2+1,Sprocket_r+20]);
		
		translate([0,0,0]){
    			// spacer bolt holes
			translate([SecondIdleInset/2,0,0]){
			translate([0,Plate_h/2-8,0]) BoltHeadHolePan6(lAccessDepth=Sprocket_r);
			translate([0,-Plate_h/2+8,0]) BoltHeadHolePan6(lAccessDepth=Sprocket_r);}
			
			translate([Sprocket_cl/2,0,0]){
			translate([0,Plate_h/2-8,0]) BoltHeadHolePan6(lAccessDepth=Sprocket_r);
			translate([0,-Plate_h/2+8,0]) BoltHeadHolePan6(lAccessDepth=Sprocket_r);}
			
			translate([Sprocket_cl-SecondIdleInset/2,0,0]){
			translate([0,Plate_h/2-8,0]) BoltHeadHolePan6(lAccessDepth=Sprocket_r);
			translate([0,-Plate_h/2+8,0]) BoltHeadHolePan6(lAccessDepth=Sprocket_r);}
		}
	} // diff
		/**/
} // RollPlate

AlBar_h=6.35;
	
module AlBar(){
	
		cube([Sprocket_cl,AlBar_h,AlBar_h],center=true);
		
		
	
} // AlBar

module RollPlateSTL(){
	difference(){
		RollPlate();
		translate([Sprocket_cl/2+20-0.25,0,-0.05]) cube([Sprocket_cl,Sprocket_r*2+1,Sprocket_r+20]);
		translate([Sprocket_cl/2-20-0.25,0.25,-0.05]) mirror([0,1,0]) cube([Sprocket_cl,Sprocket_r*2+1,Sprocket_r+20]);
	} // diff
} // RollPlateSTL

 //RollPlateSTL();

//translate([0,0,SidePalteSpace/2+Plate_t]) RollPlate();
TnB_Plate_w=Spocket_sep-SidePalteSpace-Plate_t*2;
	
module TnB_Plate2D(){
	$fn=180;
	difference(){
		square([Sprocket_cl,TnB_Plate_w]);
	
		// bolt holes
		for (J=[0:5]){
			translate([Sprocket_cl/6/2+J*(Sprocket_cl/6),AlBar_h/2,0]) circle(r=2);
			translate([Sprocket_cl/6/2+J*(Sprocket_cl/6),TnB_Plate_w-AlBar_h/2,0]) circle(r=2);
		}
	} // diff
} // TnB_Plate2D



module TnB_Plate(){
	
	difference(){
		cube([Sprocket_cl,TnB_Plate_w,3]);
	
		// bolt holes
		for (J=[0:5]){
			translate([Sprocket_cl/6/2+J*(Sprocket_cl/6),AlBar_h/2,-0.05]) cylinder(r=2,h=3.1);
			translate([Sprocket_cl/6/2+J*(Sprocket_cl/6),TnB_Plate_w-AlBar_h/2,-0.05]) cylinder(r=2,h=3.1);
		}
	} // diff
} // TnB_Plate

module ShowAll(){
	// Tracks
	color("LightBlue"){
		//rotate([90,0,0]) Track();
		translate([0,Spocket_sep,0]) rotate([90,0,0]) Track();}
		
	//translate([0,-SidePalteSpace/2,0]) rotate([90,0,0]) RollPlate();
	translate([0,Spocket_sep+SidePalteSpace/2+Plate_t,0]) rotate([-90,0,0]) RollPlate();
		
	color("Red") translate([Sprocket_cl/2,Spocket_sep/2,0]) rotate([0,0,90]) BatteryPack();
		
	color("Tan"){
	rotate([-90,0,0]) DriveMotor();
	translate([Sprocket_cl,Spocket_sep,0]) rotate([90,0,0]) DriveMotor();}
	
	color("Orange"){
		//rotate([90,0,0]) translate([0,0,SidePalteSpace/2-Plate_t]) SidePlate(IsInner=0);
		//rotate([90,0,0]) translate([0,0,-SidePalteSpace/2-Plate_t]) SidePlate(IsInner=1);
		
		translate([0,SidePalteSpace/2+Plate_t,-Plate_h/2+8-AlBar_h/2-Plate_t]) TnB_Plate();
		translate([0,SidePalteSpace/2+Plate_t,Plate_h/2-8+AlBar_h/2]) TnB_Plate();
		
		translate([0,Spocket_sep,0]){
		rotate([90,0,0]) translate([0,0,SidePalteSpace/2]) SidePlate(IsInner=1);
		rotate([90,0,0]) translate([0,0,-SidePalteSpace/2]) SidePlate(IsInner=0);}
	}
	color("Red"){
		translate([Sprocket_cl/2,SidePalteSpace/2+Plate_t+AlBar_h/2,-Plate_h/2+8]) AlBar();
		translate([Sprocket_cl/2,SidePalteSpace/2+Plate_t+AlBar_h/2,Plate_h/2-8]) AlBar();
		
		translate([Sprocket_cl/2,Spocket_sep-SidePalteSpace/2-Plate_t-AlBar_h/2,-Plate_h/2+8]) AlBar();
		translate([Sprocket_cl/2,Spocket_sep-SidePalteSpace/2-Plate_t-AlBar_h/2,Plate_h/2-8]) AlBar();

	}

} // ShowAll






















