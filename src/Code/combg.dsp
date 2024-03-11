import("stdfaust.lib");


//Calcolo Gain Comb 

g1 = zpos*rifPav ; 
g6 = (1 - zpos)*rifSoff ;
g2 = xpos*rifLat;
g3 = (1 - xpos)*rifLat;
g4 = ypos*rifFro ;
g5 = (1 - ypos)*rifFro ;

combg=(g1,g6,g2,g3,g4,g5);

process = combg;