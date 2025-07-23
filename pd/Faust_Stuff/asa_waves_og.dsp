declare filename "asa_waves.dsp";
declare name "asa_waves";
// white noise rolling wave like effect
// some notes: 
// - very small changes to these parameters make a realisitic 'waves rolling
// in the distance' sound.
import("stdfaust.lib");

declare author "Jeremy WY";
declare copyright "GRAME";
declare license "LGPL with exception";

gain = hslider("gain", 0.5, 0, 1, 0.001);

hipGain = hslider("hipGain", 0.5, 0, 1, 0.001) : si.smoo;
lopGain = hslider("lopGain", 0.5, 0, 1, 0.001) : si.smoo;

stereo = hslider("stereo", 0, 0, 200, 1) : si.smoo;

lfoRate = hslider("lfoRate", 0.1, 0, 10, 0.01);
lfoDepth = hslider("lfoDepth", 125, 0, 1000, 0.01);
lfoRoot = hslider("lfoRoot", 100, 20, 10000, 0.01) : si.smoo ;

filtQ = hslider("filtQ", 1.1, 1, 100, 0.01) : si.smoo;
lopCut = hslider("lopCut", 800, 20, 10000, 0.01) : si.smoo;

lfo(f,d,r) = min( max( (o * d)+r , 15), 20000)
with{
    o = (os.osc(f) * 0.5) + 0.5;
};

bandPass_loPass = fi.resonbp(lfo( lfoRate, lfoDepth,lfoRoot), filtQ, lopGain) : fi.lowpass(2,lopCut);

hiPass = fi.resonhp(lfo(lfoRate, lfoDepth,lfoRoot), filtQ, hipGain);
// mono in to short delay lines to spread audio
make_stereo(displace) = _ <: _ *(0.7), del *(0.7)
with{
    maxDel = 0.5*ma.SR;
    del = de.fdelay(maxDel, displace*(ma.SR*0.001) );
};

process = no.pink_noise * (0.2) <: bandPass_loPass, hiPass : + : make_stereo(stereo);
