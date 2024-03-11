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