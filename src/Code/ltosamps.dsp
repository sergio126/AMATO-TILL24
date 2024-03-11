import("stdfaust.lib");

//Conversione da unità di tempo in campioni
ltosamps(mt) = mt*ma.SR/velSuono : int;
process = ltosamps;