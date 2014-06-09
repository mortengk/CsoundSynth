
gkLFOAmp	= gkLFOAmp * sqrt(1)
gkLFOFreq 	= gkLFOFreq	* sqrt(1000)
; printk2 gkLFODelay
; if i(gkLFODelay) == 0 then
; 	kLFODelay = 1.
; 	gkLFOAmp = gkLFOAmp*kLFODelay
; else
; 	kLFODelay transeg 0, i(gkLFODelay/4), 0, 0, i(gkLFODelay*3/4), 2, 1 
; 	gkLFOAmp = gkLFOAmp*kLFODelay
; endif

if gkLFOType == 0 then
	kLFO1Osc1 	oscil gkLFOAmp, gkLFOFreq, giSine
	kLFO1Osc2 	oscil gkLFOAmp, gkLFOFreq, giSine
elseif gkLFOType == 1 then
	kLFO1Osc1 	oscil gkLFOAmp, gkLFOFreq, giTri
	kLFO1Osc2 	oscil gkLFOAmp, gkLFOFreq, giTri
elseif gkLFOType == 2 then
	kLFO1Osc1 	oscil gkLFOAmp, gkLFOFreq, giSquare
	kLFO1Osc2 	oscil gkLFOAmp, gkLFOFreq, giSquare
elseif gkLFOType == 3 then
	kRandom randomh 0, 2, gkLFOFreq, 3
	kLFO1Osc1 = gkLFOAmp*kRandom
	kLFO1Osc2 = gkLFOAmp*kRandom
endif

gkLFO1Osc1 = kLFO1Osc1
gkLFO1Osc2 = kLFO1Osc2