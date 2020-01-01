batHeight=9; // 8
batWidth=27; //5
batLen=45; // 40

botThick=1;
topThick=1;

wallThick=2;

dividerThick=1;  /*Divider between the battery and the pcb*/ 

pcbX=28.5; /*Actually 27.5, but the esp-01 is a little long.*/ 
pcbY=29;
pcbXSpace=1;
pcbYSpace=2;
pcbLowHoleX=5.75;
pcbLowHoleY=26.4;
pcbUpHoleX=24.55;
pcbUpHoleY=9.8;
pcbHoleR=1;
pcbSwHeight=4.3;
pcbSwR=5.5/2;
pcbSw1X=12.65;
pcbSw2X=pcbSw1X+6.7;
pcbSw1Y=19.2;
pcbSw2Y=19.35;
pcbOutCutStartX=10.2;
pcbOutCutLenX=16.85;
pcbOutCutHeight=3;
pcbTopHeight=10;
pcbHeightToTop=pcbSwHeight+1.6;
pcbTotalHeight=pcbHeightToTop+pcbTopHeight;

pcbOrigY=wallThick+batLen+dividerThick+pcbY+(pcbYSpace/2);
pcbOrigX=wallThick+(pcbXSpace/2);


caseInsideX=pcbX+pcbXSpace;
caseInsideH=pcbTotalHeight;
caseInsideY=batLen+dividerThick+pcbY+pcbYSpace;
if (batWidth > pcbX){
	caseInsideX=batWidth;
} else {
	caseInsideX = pcbX+1; /*PCBW is exact, battery has been padded*/ 
}
$fn=20;
rad=1;
lipHeight=1.5;
splitHeight=pcbSwHeight+botThick+lipHeight;
caseHeight=caseInsideH+botThick+topThick;
BotHalf();
translate([-5,0,caseHeight])
rotate([0,180,0])
	TopHalf();

	module TopHalf(){
		intersection(){  /*This difference makes the lip that the unit fits into*/ 
			difference(){
				wholeCase();
				cube([400,100,splitHeight]);
			}
			color("green")
				hull()
				chainHullTopCyl([
						[caseInsideX+wallThick, wallThick],
						[wallThick, wallThick],
						[wallThick, caseInsideY+wallThick],
						[caseInsideX+wallThick, caseInsideY+wallThick]]);
		}
		difference(){
			wholeCase();
				translate([-50,0,0])
			cube([300,100,splitHeight+lipHeight]);
		}
	}
module chainHullCyl(coord){
	for (i=[0:len(coord)-2]){

		hull(){
			translate([coord[i][0], coord[i][1], splitHeight-lipHeight+.01])
				cylinder(r=wallThick/2, h=lipHeight);
			translate([coord[i+1][0], coord[i+1][1], splitHeight-lipHeight+.01])
				cylinder(r=wallThick/2, h=lipHeight);
		}
	}
	hull(){
		translate([coord[0][0], coord[0][1], splitHeight-lipHeight+.01])
			cylinder(r=wallThick/2, h=lipHeight);
		translate([coord[len(coord)-1][0], coord[len(coord)-1][1], splitHeight-lipHeight+.01])
			cylinder(r=wallThick/2, h=lipHeight);
	}
}
module chainHullTopCyl(coord){
	r=wallThick/2-.1;
	/*r=.3;*/
	for (i=[0:len(coord)-2]){

		hull(){
			translate([coord[i][0], coord[i][1], splitHeight+.01])
				cylinder(r=r, h=lipHeight);
			translate([coord[i+1][0], coord[i+1][1], splitHeight+.01])
				cylinder(r=r, h=lipHeight);
		}
	}
	hull(){
		translate([coord[0][0], coord[0][1], splitHeight+.01])
			cylinder(r=r, h=lipHeight);
		translate([coord[len(coord)-1][0], coord[len(coord)-1][1], splitHeight+.01])
			cylinder(r=r, h=lipHeight);
	}
}
module BotHalf(){
	difference(){  /*This difference makes the lip that the unit fits into*/ 
		intersection(){
			wholeCase();
			translate([-50,0,0])
			cube([500,100,splitHeight]);
		}
		hull()
			chainHullCyl([
					[caseInsideX+wallThick, wallThick],
					[wallThick, wallThick],
					[wallThick, caseInsideY+wallThick],
					[caseInsideX+wallThick, caseInsideY+wallThick]]);
	}
	/*translate([pcbOrigX, pcbOrigY, pcbSwHeight])*/
		/*import("controllerBoard.stl");*/
}

module wholeCase(){
	/*Main thing*/ 
	difference(){
		roundedCube(wallThick*2+caseInsideX, wallThick*2+caseInsideY, topThick+botThick+caseInsideH,1);
		translate([wallThick, wallThick, botThick])
			roundedCube(caseInsideX, caseInsideY, caseInsideH,1);// [>This doesn't cut off the top<] 
		/*roundedCube(caseInsideX, caseInsideY, caseInsideH+5,1); //This cuts off the top */
		translate([pcbOrigX, pcbOrigY, botThick]){
			/*PCB origin referenced area*/ 

			translate([pcbSw1X, -pcbSw1Y, 0])
				cylinder(r=pcbSwR, h=botThick*3, center=true);

			translate([pcbSw2X, -pcbSw2Y, 0])
				cylinder(r=pcbSwR, h=botThick*3, center=true);

			translate([pcbOutCutStartX,-5, pcbSwHeight+1.5])
				cube([pcbOutCutLenX,10,pcbOutCutHeight]);
		}
	}
	/*This is the divider*/ 
	translate([wallThick,wallThick+batLen,botThick])
		difference(){
			cube([caseInsideX, dividerThick,caseInsideH]); 
			translate([20, -2, caseInsideH/2-3])
				roundedCube(8,4,6,1);
		}

translate([2,caseInsideY+wallThick*2+1,+.01])
difference(){
cylinder(r=3, h=caseHeight);
translate([0,0,-.02])
cylinder(r=1, h=caseHeight*2);
}
translate([caseInsideX+wallThick,caseInsideY+wallThick*2+1,+.01])
difference(){
cylinder(r=3, h=caseHeight);
translate([0,0,-.02])
cylinder(r=1, h=caseHeight*2);
}
	translate([pcbOrigX, pcbOrigY, botThick]){
		translate([pcbLowHoleX, -pcbLowHoleY, 0])
			pcbScrewPost();
		translate([pcbUpHoleX, -pcbUpHoleY, 0])
			pcbScrewPost();
	}

}



module pcbScrewPost(){
	translate([0,0,pcbSwHeight/2])
		difference(){
			cylinder(r=pcbHoleR+1, h=pcbSwHeight, center=true);
			translate([0,0,0.1])
				cylinder(r=pcbHoleR, h=pcbSwHeight, center=true);
		}
}
module roundedCube(x,y,z,r,fn=10){
	hull(){
		translate([r,r,r])
			sphere(r=r);

		translate([r,y-r,r])
			sphere(r=r);

		translate([x-r,r,r])
			sphere(r=r);

		translate([x-r,y-r,r])
			sphere(r=r);

		translate([r,r,z-r])
			sphere(r=r);

		translate([r,y-r,z-r])
			sphere(r=r);

		translate([x-r,r,z-r])
			sphere(r=r);

		translate([x-r,y-r,z-r])
			sphere(r=r);
	}
}


module roundedCubeFlatTop(x,y,z,r,fn=10){
	hull(){
		translate([r,r,0])
			cylinder(h=z, r=r);

		translate([r,y-r,0])
			cylinder(h=z, r=r);

		translate([x-r,r,0])
			cylinder(h=z, r=r);

		translate([x-r,y-r,0])
			cylinder(h=z, r=r);

	}
}

