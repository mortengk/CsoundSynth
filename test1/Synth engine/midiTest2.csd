
/*
<CsoundSynthesizer>
<CsOptions>
-o dac -+rtmidi=null -+rtaudio=null -+msg_color=0 -M0 -m0 -b 512 -B 768
</CsOptions>
<CsInstruments>
nchnls 	= 2
0dbfs 	= 1
ksmps 	= 128
sr 		= 44100

massign 0, 1

giSine  		ftgen 0, 0, 2^10, 10, 1

; Sound generation
gaOscil1     	init 0
gaOscil2     	init 0
gkFineTuneOsc1	init 0
gkFineTuneOsc2	init 0
gkOscil1Amp		init 0
gkOscil2Amp		init 0
gkAmpAttack		init 0
gkAmpDecay		init 0
gkAmpSustain	init 0
gkAmpRelease	init 0

; EFX
gkDistState		init 0
gkDistGain		init 0
gkDistMix		init 0
gkFilterType	init 0
gkFilterCutoff  init 0
gkFilterRes 	init 0 	
gkFilterAttack	init 0
gkFilterDecay	init 0
gkFilterSustain	init 0
gkFilterRelease	init 0
gkFilterEnv		init 0
gkPhaserState	init 0
gkPhaserFreq	init 0
gkPhaserFeed	init 0
gkPhaserMix		init 0
gkReverbState	init 0
gkReverbRoomSize init 0
gkReverbFreq	init 0
gkReverbMix 	init 0

gkCurrentFilterValue init 0

gkCurrentNumberOfNotes	init 0
gkTrigger		init 0


opcode	cpsmid, k, k
kmid	xin
#define MIDI2CPS(xmidi) # (440.0*exp(log(2.0)*(($xmidi)-69.0)/12.0)) #
kCPS	=	$MIDI2CPS(kmid)
xout	kCPS
endop

instr 1
midinoteonkey 	p4, p5
kCPS        	cpsmid p4
kCPS 			= kCPS * cent(100/12*gkFineTuneOsc1)

#include "ampEnvelope.inc"

a1 				vco2 k2*0.2, kCPS*k2

#include "filters.inc"

gaOscil1		= gaOscil1 + a1
endin


instr 2
midinoteonkey   p4, p5

kCPS            cpsmid p4
kCPS 			= kCPS * cent(100/12*gkFineTuneOsc1)
#include "ampEnvelope.inc"
a1 				vco2         k2 * .2, kCPS, 10

gaOscil1 		= gaOscil1 + a1
endin


instr 3
midinoteonkey   p4, p5

kCPS            cpsmid 	p4
kCPS 			= 		kCPS * cent(100/12*gkFineTuneOsc1)
#include "ampEnvelope.inc"

a1 				vco2    k2 * 0.2, kCPS, 2, .5

gaOscil1 		= 		gaOscil1 + a1
endin


instr 4
midinoteonkey   p4, p5

kCPS            cpsmid p4
kCPS 			= kCPS * cent(100/12*gkFineTuneOsc1)
#include "ampEnvelope.inc"

a1              poscil k2*0.2, kCPS, giSine

gaOscil1 		= gaOscil1 + a1
endin


instr 5
midinoteonkey   p4, p5
kCPS            cpsmid p4
kCPS 			= kCPS * cent(100/12*gkFineTuneOsc1)
#include "ampEnvelope.inc"

a1              foscili k2*0.2, kCPS, 100, 100, 4, giSine

gaOscil1 		= gaOscil1 + a1
endin


instr 6
#include "ampEnvelope.inc"
asigL, asigR    loscil3 k2*2, 1, 2, 2

gaOscil1 		= gaOscil1 + asigL
endin


instr 11
midinoteonkey 	p4, p5

kCPS        	cpsmid p4
kCPS 			= kCPS * cent(100/12*gkFineTuneOsc2)
#include "ampEnvelope.inc"

a1 				vco2 k2 * .2, kCPS

;#include "filters.inc"

gaOscil2 		= gaOscil2 + a1
endin


instr 12
midinoteonkey   p4, p5

kCPS            cpsmid p4
kCPS 			= kCPS * cent(100/12*gkFineTuneOsc2)
#include "ampEnvelope.inc"

a1 				vco2         k2 * .2, kCPS, 10

gaOscil2 		= gaOscil2 + a1
endin


instr 13
midinoteonkey   p4, p5

kCPS            cpsmid p4
kCPS 			= kCPS * cent(100/12*gkFineTuneOsc2)
#include "ampEnvelope.inc"

a1 				vco2         k2 * .2, kCPS, 2, .5

gaOscil2 		= gaOscil2 + a1
endin


instr 14
midinoteonkey   p4, p5

kCPS            cpsmid p4
kCPS 			= kCPS * cent(100/12*gkFineTuneOsc2)
#include "ampEnvelope.inc"

a1              poscil k2*0.2, kCPS, giSine

gaOscil2 		= gaOscil2 + a1
endin


instr 15
midinoteonkey   p4, p5

kCPS            cpsmid p4
kCPS 			= kCPS * cent(100/12*gkFineTuneOsc2)
#include "ampEnvelope.inc"

a1              foscili k2*0.2, kCPS, 100, 100, 4, giSine

gaOscil2 		= gaOscil2 + a1
endin


instr 16
#include "ampEnvelope.inc"
asigL, asigR    loscil3 k2*2, 1, 2, 2

gaOscil2 		= gaOscil2 + asigL
endin


; THIS INSTRUMENT SUMS ALL ACTIVE INSTRUMENT INSTANCES
instr 50
k1 				active 1
k2 				active 2
k3 				active 3
k4 				active 4
k5 				active 5
k6 				active 6

k11 			active 11
k12 			active 12
k13 			active 13
k14 			active 14
k15 			active 15
k16				active 16

kCurrentSum = k1+k2+k3+k4+k5+k6+k11+k12+k13+k14+k15+k16
gkCurrentNumberOfNotes = kCurrentSum
kCurrentSum = 0
endin


; Filter
instr 90
; 	iFilterAttack	chnget "filterAttack"
; 	iFilterDecay	chnget "filterDecay"
; 	iFilterSustain	chnget "filterSustain"
; 	iFilterRelease	chnget "filterRelease"

; kPortTime		linseg	0, 0.001, 0.1
; kFltrResWthPort	portk	gkFilterRes, kPortTime


; if (gkCurrentNumberOfNotes > 0) then
; 	printk2 gkCurrentNumberOfNotes
; elseif (gkCurrentNumberOfNotes == 0) then
; 	printks "hei", .5

; 	kFilterEnvelope linsegr 0, .5, 1, .5, .5, .5, 0

; endif

; ; Lowpass filter
; if (gkFilterType == 0) then 
; 	;kFilterEnvelope linsegr 0, iFilterAttack, 1, iFilterDecay, iFilterSustain, iFilterRelease, 0
; 	;kFilterEnvelope linsegr 0, .5, 1, .5, .5, .5, 0
; 	kCutoff 	= gkFilterCutoff*kFilterEnvelope
; 	a1 			moogladder gaOscil1, gkFilterCutoff, kFltrResWthPort*.98
; 	a2 			moogladder gaOscil2, gkFilterCutoff, kFltrResWthPort*.98
; ; Highpass filter
; elseif (gkFilterType == 1) then
; 	a1 			butterhp gaOscil1, gkFilterCutoff
; 	a2 			butterhp gaOscil2, gkFilterCutoff
; ; Bandpass filter
; elseif (gkFilterType == 2) then 
; 	a1 			butterbp gaOscil1, gkFilterCutoff, gkFilterRes*gkFilterCutoff
; 	a2 			butterbp gaOscil2, gkFilterCutoff, gkFilterRes*gkFilterCutoff
; ; Notch filter
; elseif (gkFilterType == 3) then 
; 	a1 			butterbr gaOscil1, gkFilterCutoff, gkFilterRes*gkFilterCutoff
; 	a2 			butterbr gaOscil2, gkFilterCutoff, gkFilterRes*gkFilterCutoff
; endif

; gaOscil1 		= a1
; gaOscil2 		= a2

endin


; ------- EFFECT INSTRUMENTS -------

instr 108

if (gkDistState == 1) kgoto distIsActive
	kgoto continue

distIsActive: 
	a1 			distort gaOscil1, gkDistGain, giSine
	a2 			distort gaOscil2, gkDistGain, giSine
	gaOscil1 	= sqrt(1 - gkDistMix)*gaOscil1 + a1*sqrt(gkDistMix)
	gaOscil2 	= sqrt(1 - gkDistMix)*gaOscil2 + a2*sqrt(gkDistMix)
	kgoto continue

continue:

endin


instr 109

if (gkPhaserState == 1) kgoto phaserIsActive
	kgoto continue

phaserIsActive: 
	iFeedback 		chnget "phaserFeed"
	kFreq  oscil 4000, gkPhaserFreq, 1
  	kMod   = kFreq + 5600
  	a1   		phaser1 gaOscil1, kMod, 4, iFeedback
  	a2   		phaser1 gaOscil2, kMod, 4, iFeedback
	gaOscil1 	= sqrt(1 - gkPhaserMix)*gaOscil1 + a1*sqrt(gkPhaserMix)
	gaOscil2 	= sqrt(1 - gkPhaserMix)*gaOscil2 + a2*sqrt(gkPhaserMix)
	kgoto continue

continue:

endin


instr 110

a1L = 0
a1R = 0
a2L = 0
a2R = 0

if (gkReverbState == 1) kgoto reverbIsActive
	kgoto 		reverbIsInactive

reverbIsActive: 
	a1L, a1R 	reverbsc gaOscil1, gaOscil1, gkReverbRoomSize, gkReverbFreq
	a2L, a2R 	reverbsc gaOscil2, gaOscil2, gkReverbRoomSize, gkReverbFreq
	gaOscil1 	= sqrt(1 - gkReverbMix)*gaOscil1 + a1L*sqrt(gkReverbMix)
	gaOscil2 	= sqrt(1 - gkReverbMix)*gaOscil2 + a2L*sqrt(gkReverbMix)
	kgoto 		continue

reverbIsInactive:
	a1L 		= 0
	a1R 		= 0
	a2L 		= 0
	a2R 		= 0
	gaOscil1 	= gaOscil1
	gaOscil2 	= gaOscil2
	kgoto 		continue

continue:

endin


instr 199
aEnv			linsegr	0, 0.001, 1, 0.005, 0			;ANTI-CLICK ENVELOPE
gaOscil1 		= gaOscil1*gkOscil1Amp*aEnv
gaOscil2 		= gaOscil2*gkOscil2Amp*aEnv
				outs 	gaOscil1 + gaOscil2, gaOscil1 + gaOscil2
gaOscil1 		= 0
gaOscil2 		= 0

endin


; Always on utility instrument

instr 200
;#include "channel.inc"

; Updating the global variables once per k-cycle
kOscil1FineTune chnget "oscil1FineTune"
kOscil2FineTune chnget "oscil2FineTune"
kOscil1Amp		chnget "oscil1Amp"
kOscil2Amp		chnget "oscil2Amp"
gkFineTuneOsc1 	= kOscil1FineTune
gkFineTuneOsc2 	= kOscil2FineTune
gkOscil1Amp 	= kOscil1Amp
gkOscil2Amp 	= kOscil2Amp

; Amp envelope
kattack         chnget "attack"
kdecay          chnget "decay"
ksustain        chnget "sustain"
krelease        chnget "release"
gkAmpAttack 	= kattack
gkAmpDecay 		= kdecay
gkAmpSustain 	= ksustain
gkAmpRelease 	= krelease


; --- EFFECTS ---

; Distortion
kDistState		chnget "distState"
kDistGain		chnget "distGain"
kDistMix		chnget "distMix"
gkDistState 	= kDistState
gkDistGain 		= kDistGain
gkDistMix 		= kDistMix

; Filter
kFilterCutoff	chnget "filterCutoff"
kFilterRes		chnget "filterResonance"
kFilterType		chnget "filterType"
kFilterAttack	chnget "filterAttack"
kFilterDecay 	chnget "filterDecay"
kFilterSustain	chnget "filterSustain"
kFilterRelease	chnget "filterRelease"
gkFilterCutoff	= kFilterCutoff * 20000
gkFilterRes 	= kFilterRes
gkFilterType	= kFilterType
gkFilterAttack 	= kFilterAttack
gkFilterDecay	= kFilterDecay
gkFilterSustain	= kFilterSustain
gkFilterRelease	= kFilterRelease

; Phaser
kPhaserState	chnget "phaserState"
kPhaserFreq		chnget "phaserFreq"
kPhaserFeed		chnget "phaserFeed"
kPhaserMix		chnget "phaserMix"
gkPhaserState 	= kPhaserState
gkPhaserFreq 	= kPhaserFreq
gkPhaserFeed 	= kPhaserFeed
gkPhaserMix 	= kPhaserMix

; Reverb
kReverbState	chnget "reverbState"
kReverbRoomSize chnget "reverbRoomSize"
kReverbFreq		chnget "reverbFreq"
kReverbMix		chnget "reverbMix"
gkReverbState	= kReverbState
gkReverbRoomSize = kReverbRoomSize
gkReverbFreq 	= kReverbFreq
gkReverbMix 	= kReverbMix

endin


instr allNotesOff
turnoff2 1, 0, 1
turnoff
endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1
f2 0 0 1 "kickroll.wav" 0 0 0

i50 0 360000
i90 0 360000
i108 0 360000
i109 0 360000
i110 0 360000
i199 0 360000
i200 0 360000
 
</CsScore>
</CsoundSynthesizer>

*/