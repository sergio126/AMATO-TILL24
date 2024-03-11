import("stdfaust.lib");

//Calcolo tempi Comb e conversione in campioni

c1 = ltosamps(larghezza*xpos);
c2 = ltosamps(larghezza-(larghezza*ypos));
c3 = ltosamps(lunghezza*ypos);
c4 = ltosamps(lunghezza-(lunghezza*ypos));
c5 = ltosamps(altezza*zpos);
c6 = ltosamps(altezza-(altezza*zpos));

combtimes = (c1,c2,c3,c4,c5,c6);

process = combtimes;