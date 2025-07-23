declare filename "fix_richFM.dsp";
declare name "fix_richFM";
declare filename "fm6synth.dsp";
declare name "fm6synth";
// 6 operator fm synth

// declare options "[midi:on][nvoices:12]";
// faust library
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01) : si.polySmooth(gate, 0.999, 64);
gate = button("gate");
gain = hslider("gain", 0.5, 0, 1, 0.001) : si.polySmooth(gate, 0.999, 64);

modAmt = hslider("[2]modAmtt", 0.5, 0, 18, 0.001) : si.polySmooth(gate, 0.999, 64);
feed = hslider("[1]feed", 1, 0, 18, 0.01) : si.polySmooth(gate, 0.999, 64);

operator(i) = (opVol * velScale(gain,vel)) * amp * env
with{
    
    oper = _ , os.phasor(1,freq*index) : + : * (ma.PI*2) : sin;
    bandBal = 1 - ( min( ba.hz2midikey(freq), 127) / 127);
    bandShape = pow( bandBal, 1);
    opVol = (oper*0.5) * bandShape;

    index = hslider("index%i", 1, 0, 16, 0.001);
    amp = hslider("amp%i", 0.5, 0, 1, 0.001);
    vel = hslider("vel%i", 0, -1, 1, 0.01);
    a = hslider("a%i", 0.01, 0.001, 4, 0.001);
    d = hslider("d%i", 0.1, 0.001, 4, 0.001);
    s = hslider("s%i", 0.7, 0, 1, 0.01);
    r = hslider("r%i", 2, 0.001, 4, 0.001);

    env = en.adsre(a,d,s,r,gate);
    
    // scale velocity sensititity
    // 0 = 0.7 1 = 0-1 -1 = 1-0
    velScale(g, am) = ba.if(am<0,1,0) - (amt + bottom) : abs
    with{
        amt = abs(am);
        bottom = 0.7 - (amt*0.7);
    };
    
};

fb(ops, mul) = ops ~ mean *(mul) 
with {
    mean(x) = (x + x') / 2; // 'Tomisawa's anti-hunting filter', as in yamaha pm; reduce noisiness of   feedback
    // https://www.reddit.com/r/FMsynthesis/comments/85jfrb/dx7_feedback_implementation/
    // https://yamahamusicians.com/forum/viewtopic.php?p=33749&sid=80d2ff7f41f9d9e76318151768c53c78#p33749 (thread now blocked to outsiders and not on wayback machine)
};

chunk1 = 0 : operator(3) : operator(2) *(modAmt) : operator(1);

chunk2 = operator(6) : operator(5) *(modAmt) : operator(4) ;

//chunk2 = (operator(6) : operator(5) : operator(1)) ~ *(feed) ;
process = fb(chunk2,feed) + chunk1;
 