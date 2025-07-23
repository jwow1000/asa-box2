declare filename "pop_synth.dsp";
declare name "pop_synth";
import("stdfaust.lib");

//declare options "[midi:on][nvoices:12]";

declare author "jeremyWY";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

offset = hslider("offset", 1, 0, 10, 0.001);

popOp(i,off) = myOsc((freq+off)+freqEnv), myOsc(((freq+off)*2.001)+freqEnv)/6, myOsc(((freq+off)*3.01)+freqEnv)/10  :> ampEnv
with{
    myOsc(f) =  (oper*0.5) * bandShape
    with{
        oper = os.phasor(1, f) * (ma.PI*2) : cos;
        bandBal = 1 - ( min( ba.hz2midikey(f), 127) / 127);
        bandShape = pow( bandBal, 2);
    };
    
    oscLFO(f) = os.hsp_phasor(1, f, gate, 0) * (ma.PI*2) : sin;
    
    fA = hslider("fA%i", 0.001, 0.001, 4, 0.001);
    fD = hslider("fD%i", 0.01, 0.001, 4, 0.001);
    freqDepth = hslider("freqDepth%i", -5, -1000, 1000, 1);
    
    ampA = hslider("ampA%i", 1.4, 0.001, 4, 0.001);
    ampD = hslider("ampD%i", 2, 0.001, 4, 0.001);
    ampS = hslider("ampS%i", 0.5, 0, 1, 0.01);
    ampR = hslider("ampR%i", 2, 0.001, 4, 0.001);

    
    lfoRate = hslider("lfoRate%i", 5, 0, 20, 0.001);
    lfoDepth = hslider("lfoDepth%i", 5, 0, 400, 1);
    lfoDelay = hslider("lfoDelay%i", .4, 0, 5, 0.01) * ma.SR;
    lfoA = hslider("lfoA%i", 2, 0.001, 10, 0.001);
    lfoD = hslider("lfoD%i", 2, 0.001, 10, 0.001);
    lfoS = hslider("lfoS%i", 0.5, 0, 1, 0.01);
    lfoR = hslider("lfoR%i", 4, 0.001, 10, 0.001);
    lfo = oscLFO( en.adsre(lfoA,lfoD,lfoS,lfoR,gate@lfoDelay) * lfoRate );
    lfoNorm = ((lfo*0.5) + 0.5) * lfoDepth;
    //freqEnv = (en.adsr(fA,fD,0,fD,gate) * freqDepth) + lfoNorm;
    freqEnv = lfoNorm;
    ampEnv = _ * en.adsre(ampA,ampD,ampS,ampR,gate);
    
};

process = popOp(1, 0)*0.5, popOp(1,offset)*0.5 :> * (gain);