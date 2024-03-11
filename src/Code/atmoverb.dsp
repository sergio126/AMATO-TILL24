import("stdfaust.lib");

// lo slider è in atm = 101325 Pa
atm = hslider("[01]Pressure[unit:atm]", 1, 0.1, 10, .1);
// temperatura 
temp = hslider("[02]Temperature [unit:Cdeg]", 20, -200, 200, .1);
// mc
larghezza = hslider("[03]Larghezza[unit:mt]", 10,1,100,1);
lunghezza = hslider("[04]Lunghezza[unit:mt]", 10,1,100,1);
altezza = hslider("[05]Altezza[unit:mt]", 10,1,100,1);

// position
xpos = hslider("[06]x[unit:%]",50,0,100,1)/100;
ypos = hslider("[07]y[unit:%]",50,0,100,1)/100;
zpos = hslider("[08]z[unit:%]",10,0,100,1)/100;

rifLat = .8;
rifFro = .5;
rifSoff = .85;
rifPav = .13;

index = hslider("Gas",1.,0.,9.,1);

velSuono = sqrt((1.402*atm*(1.013*10^5))/dens)
with{
    press = 76 * (atm);
    stp = (1.2930, 0.7710, 1.2507, 3.2170, 1.9760, 0.0899, 0.7170, 1.2500,1.4290, 0.804);
    dens = (ba.take(4,stp)*press)/(press * (1 + (0.00367* (temp))));
};
//process = velSuono;

ltosamps(mt) = mt*ma.SR/velSuono : int;
//process = ltosamps;
//process = ltosamps(mc/10/10), pm.l2s(10);

c1 = ltosamps(larghezza*xpos);
c2 = ltosamps(larghezza-(larghezza*ypos));
c3 = ltosamps(lunghezza*ypos);
c4 = ltosamps(lunghezza-(lunghezza*ypos));
c5 = ltosamps(altezza*zpos);
c6 = ltosamps(altezza-(altezza*zpos));

combtimes = (c1,c2,c3,c4,c5,c6);

//process = combtimes;

g1 = zpos*rifPav ; 
g6 = (1 - zpos)*rifSoff ;
g2 = xpos*rifLat;
g3 = (1 - xpos)*rifLat;
g4 = ypos*rifFro ;
g5 = (1 - ypos)*rifFro ;

combg=(g1,g6,g2,g3,g4,g5);
gz=(g1,g6);
gx=(g2,g3);
gy=(g4,g5);

//process = combg;

//----------------------------------------------- MOORER COMB CON FILTRO
// first order FIR
// LP = 0 < g < 1
// HP = 0 > g > -1
fir(g) = *(1-g) <: (@(1)*(g)+_);
// process = no.pink_noise : fir(0.999);
// MOORER COMB CON FILTRO
dfldf(t,g,g1) = (+ : de.delay(ma.SR,t-1))~(fir(g1)*(g2(g,g1))) : mem
with{
    g2(g,g1) = g*(1-g1);
};
//--------------------------- 6 COMB controllati da pressione temperatura dimensiuone e posizione
//process = ba.pulsen(1,ma.SR) <: par(i,6,dfldf(ba.take(i+1,combtimes),1/sqrt(2),0.16));


a1 = ltosamps(larghezza);
a2 = ltosamps(lunghezza);
a3 = ltosamps(altezza);

//-------------------------------- MOORER OSCILLATING ALL-PASS (LATTICE)
apf(t,g,x) = (x+_ : *(-g) <: _+x,_ :
             de.delay(ma.SR,t-1),_)~(0-_) : mem+_;
apfo(0,t,g,x) = x;
apfo(1,t,g,x) = apf(t,g,x);
apfo(n,t,g,x) = (x+_ : *(-g) <: _+x,_ : apfo(n-1,t,g),_ :
                de.delay(ma.SR,t-1),_)~(0-_) : mem+_;

process = //ba.pulsen(1,2*ma.SR)
  _ <:
  (apfo(2,a1,1/sqrt(2)) <: par(i,2,dfldf(ba.take(i+1,combtimes),ba.take(i+1,gz),0.75))),
  (apfo(2,a2,1/sqrt(1.8)) <: par(i,2,dfldf(ba.take(i+3,combtimes),ba.take(i+1,gx),0.75))),
  (apfo(2,a3,1/sqrt(2)) <: par(i,2,dfldf(ba.take(i+5,combtimes),ba.take(i+1,gy),0.75))):
  par(i,6,midside(1,i*2*ma.PI/6)) :> sdmx;

nsum(x,y) = (x+y)/sqrt(2);
ndif(x,y) = (x-y)/sqrt(2);
sdmx(x,y) = nsum(x,y), ndif(x,y);

midside(p,rad,x) = x <: m(p,rad), s(rad)
  with{
    m(p,rad) = _ <: (*(1-p)) + ((p)*(*(cos(rad))));
    s(rad) = _ *(sin(rad));
};