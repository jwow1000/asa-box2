declare filename "pop_synth_lite.dsp";
declare name "pop_synth_lite";
import("stdfaust.lib");

//declare options "[midi:on][nvoices:12]";

declare author "jeremyWY";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

offset = hslider("offset", 1, 0, 10, 0.001);

popOp(i,off) = (myOsc(freq + freqLFO) * ampLFO ) * ampEnv
with{
    myOsc(f) =  (oper*0.5) * bandBal
    with{
        oper = os.phasor(1, f) * (ma.PI*2) : cos;
        bandBal = 1 - ( min( ba.hz2midikey(f), 127) / 127);
        //bandShape = pow( bandBal, 2);
    };
    
    ampA = hslider("ampA%i", 1.4, 0.001, 4, 0.001);
    ampD = hslider("ampD%i", 2, 0.001, 4, 0.001);
    ampS = hslider("ampS%i", 0.5, 0, 1, 0.01);
    ampR = hslider("ampR%i", 2, 0.001, 4, 0.001);

    ampLFOA = hslider("ampLFOA%i", 0.01, 0.001, 10, 0.001);
    ampLFOD = hslider("ampLFOD%i", 4, 0.001, 10, 0.001);
    ampLFOS = hslider("ampLFOS%i", 0.5, 0, 1, 0.01);
    ampLFOR = hslider("ampLFOR%i", 4, 0.001, 10, 0.001);
    ampDepth = en.adsre(a,d,s,r,gate)
    with{
        a = hslider("ampDepthA%i", 1.4, 0.001, 4, 0.001);
        d = hslider("ampDepthD%i", 2, 0.001, 4, 0.001);
        s = hslider("ampDepthS%i", 0.5, 0, 1, 0.01);
        r = hslider("ampDepthR%i", 2, 0.001, 4, 0.001);
    };
    ampRate = hslider("ampRate%i", 5, 0, 400, 1);

    freqLFOA = hslider("freqLFOA%i", 0.01, 0.001, 10, 0.001);
    freqLFOD = hslider("freqLFOD%i", 4, 0.001, 10, 0.001);
    freqLFOS = hslider("freqLFOS%i", 0, 0, 1, 0.01);
    freqLFOR = hslider("freqLFOR%i", 4, 0.001, 10, 0.001);
    freqDepthEnv = en.adsre(a,d,s,r,gate)
    with{
        a = hslider("freqDepthA%i", 1.4, 0.001, 4, 0.001);
        d = hslider("freqDepthD%i", 2, 0.001, 4, 0.001);
        s = hslider("freqDepthS%i", 0.5, 0, 1, 0.01);
        r = hslider("freqDepthR%i", 2, 0.001, 4, 0.001);
    };
    freqRateAmt = hslider("freqRateAmt%i", 5, 0, 400, 1);
    freqRate = hslider("freqRate%i", 5, 0, 400, 1);
    freqDepth = hslider("freqRateAmt%i", 5, 0, 400, 1);

    freqLFO = myOsc(theF) * (freqDepthEnv*freqDepth)
    with{
        theF = (en.adsre(freqLFOA, freqLFOD, freqLFOS, freqLFOR, gate) * freqRateAmt) + freqRate;
    };
    
    ampLFO = (theOs * ampDepth) + (1 - ampDepth)
    with{
        theF = en.adsre(ampLFOA, ampLFOD, ampLFOS, ampLFOR, gate) * ampRate;
        theOs = ( myOsc(theF) * 0.5 ) + 0.5;
    };

    ampEnv = en.adsre(ampA,ampD,ampS,ampR,gate);
    
};

process = popOp(1, 0)  * (gain);