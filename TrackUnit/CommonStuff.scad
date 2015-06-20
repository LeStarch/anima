// filename: CommondStuff.scad
//  by Dave Flynn 2013
// This file contains constants and some common routines used by "The Tank"
//
// *******************************
// History
// 12/29/2013 Added BoltHole6(depth=rPin*3)
//
// ********** Constants **********
rIDInc=0.25; // radius Inside Diameter Increment, material dependant recommended value 0.1 to 0.25
rPin=4; // Track Pin radius, many things are scalled from this.
rPinFlange=0.5;

rBoltClear2=1.3;		// #2-56 clearance hole radius
rBolt2=1.1;			// #2-56 thread major dia/2
hBoltHead2=2.4;		// #2 height of Socket head
rBoltHead2=1.85;		// #2 Socket Head radius

//rEndPinBolt=1.4; // #4-40 thread major dia/2
rEndPinBolt=1.32; // #4-40 thread major dia/2, tighter 12/21/13
rEndPinBoltClear=1.8; // #4-40 clearance hole radius, Changed from 1.8mm on 4/7/13

rEndPinBoltHead=2.6; // #4-40 Socket Head radius, changed for 2.8mm on 4/7/13
hEndPinBoltHead=3.6; // height of Socket head

rButtonBoltHead=2.7+rIDInc; // #4-40 Button Head radius
hButtonBoltHead=1.5; // height of button head

rSetScrew=2.75;	// 1/4"-20 threaded hole
rSetScrewClear=3.5;	// 1/4"-20 clearance hole

rSetScrew8=1.8; // #8-32 threaded hole
rSetScrew6=1.5; // #6-32 threaded hole

// Wheel bearings
rBearing=14.3;
lBearing=8.5;

lDart=73;	// Length of a NERF dart
rHub=16;
lHubWidth=44;

rAxile=6.35; // 1/2" Al tube
rShaft=3.175; // 1/4" Al tube
rTortionBar=2.1; // 5/32" Music wire

lTrackWidth=120;
lLinkWidth=rPin*2;
lCenterLinkWidth=rPin*3;
lTreadWidth=lTrackWidth/2-lLinkWidth-lCenterLinkWidth/2;
//lLinkCenter=16.935;
lLinkCenter=25.8;
//lLinkCenter=rPin*5.5;
lTreadPitch=lLinkCenter+rPin*3;  //37.8
rDriveWheel=(11*lTreadPitch/3.14159/2)-rPin*2; // 58
rLink=rPin*1.75;
offsetDriveWheel=rDriveWheel+rLink;
rSupportWheel=offsetDriveWheel-rPin*1.75;
aTreadPitch=360/((3.14159*(rDriveWheel+rPin*2)*2)/lTreadPitch);

// ********** Routines **********

//BoltHeadHole2();				// #2-56 Socket Head Cap Screw head and body clearance hole
//BoltHole2(depth=rPin*3); 		// #2-56 threaded hole

//BoltHeadHole(depth=rPin*4,lAccessDepth=rPin*3); // #4-40 Socket Head Cap Screw head and body clearance hole
//BoltButtonHeadHole(lDepth=rPin*3); // #4-40 Button Head Screw head and body clearance hole
//BoltHole(depth=rPin*3); 		// #4-40 threaded hole
//BoltHole8(depth=rPin*3); 		// #8-32 threaded hole
//BoltHole6(depth=rPin*3);		// #6-32 threaded hole
//BoltClearHole(depth=rPin*3); 	// #4-40 thread clearance hole

//Rod(len=304.8);				// 1/2" Al Rod
//RodEnd(baseExtend=0);			// Rod end for support rods (1/2" Al tube), w/ setscrew hole, w/o shaft hole
//RodEndHole(Extend=5);			// used to clean out the hole when parts overlap
//ServoCaseHS65();
//ServoMountHS5245MG();
//ServoHS5245MG();
//Size17StepperMount();
//Size17Stepper();

//***********************************************************

module BoltHeadHole2(lDepth=rPin*3,lAccessDepth=rPin*3){
	translate([0,0,-lDepth])
		cylinder(r=rBoltClear2,h=lDepth+rPin,$fn=24);
	translate([0,0,-hBoltHead2])
		cylinder(r=rBoltHead2,h=lAccessDepth,$fn=24);
} // BoltHeadHole2

module BoltHole2(depth=rPin*3){
	translate([0,0,-depth+0.05])
		//thread(0.635,2.8,depth,30); // #2-56
		cylinder(r=rBolt2,h=depth,$fn=18);
} // BoltHole2

module BoltHeadHole(depth=rPin*4,lAccessDepth=rPin*3){
	translate([0,0,-depth])
		cylinder(r=rEndPinBoltClear,h=depth,$fn=24);
	translate([0,0,-hEndPinBoltHead])
		cylinder(r=rEndPinBoltHead,h=lAccessDepth,$fn=24);
} // BoltHeadHole

module BoltButtonHeadHole(lDepth=rPin*3){
	translate([0,0,-lDepth])
		cylinder(r=rEndPinBoltClear,h=lDepth+4,$fn=24);
	translate([0,0,-hButtonBoltHead])
		cylinder(r=rButtonBoltHead,h=rPin*3,$fn=24);
} // BoltButtonHeadHole

module BoltHole(depth=rPin*3){
	translate([0,0,-depth+0.05])
		//thread(0.635,2.8,depth,30); // #4-40
		cylinder(r=rEndPinBolt,h=depth,$fn=24);
} // BoltHole

module BoltHole8(depth=rPin*3){
	translate([0,0,-depth+0.05])
		//thread(0.635,2.8,depth,30); // #4-40
		cylinder(r=rSetScrew8,h=depth,$fn=24);
} // BoltHole8

module BoltHole6(depth=rPin*3){
	translate([0,0,-depth+0.05])
		//thread(0.635,2.8,depth,30); // #4-40
		cylinder(r=rSetScrew6,h=depth,$fn=24);
} // BoltHole6

module BoltClearHole(depth=rPin*3){
	translate([0,0,-depth-0.05])
		cylinder(r=rEndPinBoltClear,h=depth+0.1,$fn=24);
	//translate([0,0,-hEndPinBoltHead])
		//cylinder(r=rEndPinBoltHead,h=depth+0.1,$fn=24);
} // BoltClearHole


module Rod(len=304.8){
	cylinder(r=rAxile,h=len);
} // Rod

module RodEnd(baseExtend=0){
	// Rod end for support rods (1/2" Al tube), w/ setscrew hole, w/o shaft hole
	rLock=10;
	lLock=16;

	difference(){
		union(){
		cylinder(r=rLock,h=lLock);
		translate([-rLock-2,0,lLock/2+2]) rotate(a=[0,90,0]) cylinder(r=rSetScrew*2,h=rLock);
		}

		//translate([0,0,2.05]) cylinder(r=rAxile+rIDInc,h=lLock);
		translate([-rLock-2.05,0,lLock/2+2]) rotate(a=[0,90,0]) cylinder(r=rSetScrew,h=rLock);
	}
		translate([0,0,-baseExtend]) cylinder(r=rLock,h=baseExtend+0.1);
} // RodEnd

//RodEnd();

module RodEndHole(Extend=5){
	// used to clean out the hole when parts overlap

	lLock=16;
		translate([0,0,2.05-Extend]) cylinder(r=rAxile+rIDInc,h=lLock+Extend);
} // RodEndHole


module ServoCaseHS65(){
	translate([0,-6,-24])
	difference(){
		cube([15,33,20],center=true);
		translate([0,0,1.26]) cube([12.7,24.8,17.5],center=true);
		translate([0,12,-1.25]) cube([8,10,12],center=true);

		translate([0,14.4,10.05]) BoltHole2(8);
		translate([0,-14.4,10.05]) BoltHole2(8);

	} // diff
} // ServoCaseHS65

module ServoMountHS5245MG(ExtraH=0){
	servoTray_h=6;
	servo_l=32.5; // length of case + allowance
	servo_w=17.5; // width of case
	sevroBC_l=39;
	servoBC_w=8;

	
	difference(){
		translate([0,0,-servoTray_h/2-ExtraH/2]) cube([servo_l+20,servo_w+6,servoTray_h+ExtraH],center=true);

		translate([servo_l/2,0,-servoTray_h/2-ExtraH/2]) cube([2.5,7,servoTray_h+ExtraH+0.1],center=true);
		hull(){
			translate([servo_l/2,0,-servoTray_h/2-ExtraH/2]) cube([0.1,6,servoTray_h+ExtraH+0.1],center=true);
			translate([servo_l/2+8,0,-servoTray_h/2-ExtraH/2]) cube([0.1,2.8,servoTray_h+ExtraH+0.1],center=true);
		} // hull
		translate([0,0,-servoTray_h/2-ExtraH/2]) cube([servo_l,servo_w,servoTray_h+ExtraH+0.1],center=true);

		translate([sevroBC_l/2,servoBC_w/2,0]) BoltHole2(depth=10);
		translate([-sevroBC_l/2,servoBC_w/2,0]) BoltHole2(depth=10);
		translate([sevroBC_l/2,-servoBC_w/2,0]) BoltHole2(depth=10);
		translate([-sevroBC_l/2,-servoBC_w/2,0]) BoltHole2(depth=10);
	} // diff
} // ServoMountHS5245MG

module ServoHS5245MG(){
	servo_l=32.5; // length of case + allowance
	servoOA_l=44.5;
	servoEar_h=2.5;
	servo_h=24.5; // Height to bottom of mounting ears
	servo_w=17.5; // width of case
	sevroBC_l=39;
	servoBC_w=8;

	
	translate([0,0,-servo_h/2]) cube([servo_l,servo_w,servo_h],center=true);

	difference(){
		translate([0,0,servoEar_h/2]) cube([servoOA_l,servo_w,servoEar_h],center=true);

		// mounting holes
		translate([sevroBC_l/2,servoBC_w/2,servoEar_h/2]) cylinder(r=2.2,h=servoEar_h+0.1,center=true);
		translate([-sevroBC_l/2,servoBC_w/2,servoEar_h/2]) cylinder(r=2.2,h=servoEar_h+0.1,center=true);
		translate([sevroBC_l/2,-servoBC_w/2,servoEar_h/2]) cylinder(r=2.2,h=servoEar_h+0.1,center=true);
		translate([-sevroBC_l/2,-servoBC_w/2,servoEar_h/2]) cylinder(r=2.2,h=servoEar_h+0.1,center=true);
	} // diff
	
	translate([0,0,servoEar_h+2.45]) cube([servo_l,servo_w,5],center=true);

	translate([servo_l/2-9,0,0]) cylinder(r=6.4,h=9.75);
	translate([servo_l/2-9,0,0]) cylinder(r=4.4,h=14);
	translate([servo_l/2-9,0,12.5]) cylinder(r=12,h=2.1);
} // ServoHS5245MG


module Size17StepperMount(x=Motor17_w,y=Motor17_w){
	MotorBoss17_r=11+rIDInc;
	MotorBoltCircle_r=22;

	//Mount_h=5;

	difference(){
		translate([-x/2,-y/2,0]) cube([x,y,Mount_h]);

		translate([0,0,-0.05]) cylinder(r=MotorBoss17_r,h=Mount_h+0.1);

		for (J=[0:3]) rotate([0,0,90*J])
			translate([MotorBoltCircle_r*0.707,MotorBoltCircle_r*0.707,Mount_h]) BoltHole();
		//cylinder(r=MotorBoltHole_r, h=Mount_h+0.1);
	} // diff


} // Size17StepperMount


module Size17Stepper(){
	Motor17_h=33;
	MotorBoss17_r=11;
	MotorBoss17_h=2;
	MotorShaft_r=2.5;
	MotorShaft_l=22;
	MotorBoltCircle_r=22;
	MotorBoltHole_r=1.8;
	MotorBigShaft_h=23.5;
	MotorBigShaft_r=8.4;

	translate([0,0,MotorBigShaft_h-9]) cylinder(r=MotorBigShaft_r,h=9);
	translate([0,0,-Motor17_h]) {
	translate([0,0,Motor17_h]) cylinder(r=MotorBoss17_r, h=MotorBoss17_h);
	translate([0,0,Motor17_h]) cylinder(r=MotorShaft_r, h=MotorShaft_l);
	
	
	difference(){
		translate([-Motor17_w/2,-Motor17_w/2,0]) cube([Motor17_w,Motor17_w,Motor17_h]);
		for (J=[0:3]) rotate([0,0,90*J])
			translate([MotorBoltCircle_r*0.707,MotorBoltCircle_r*0.707,-0.05]) cylinder(r=MotorBoltHole_r, h=Motor17_h+0.1);
	} // diff
	}
} // Size17Stepper




























