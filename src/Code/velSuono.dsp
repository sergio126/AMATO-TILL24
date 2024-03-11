import("stdfaust.lib");

//VELOCITA DEL SUONO

//pressione
atm = hslider("[01]Pressure[unit:atm]", 1, 0.1, 10, .1);
// temperatura 
temp = hslider("[02]Temperature [unit:Cdeg]", 20, -200, 200, .1);

velSuono = sqrt((1.402*atm*(1.013*10^5))/dens)
with{
    press = 76 * (atm);
    stp = (1.2930, 0.7710, 1.2507, 3.2170, 1.9760, 0.0899, 0.7170, 1.2500,1.4290, 0.804);
    dens = (ba.take(4,stp)*press)/(press * (1 + (0.00367* (temp))));
};
process = velSuono;