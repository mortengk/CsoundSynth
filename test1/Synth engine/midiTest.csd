
<CsoundSynthesizer>
<CsOptions>
-o dac -+rtmidi=null -+rtaudio=null -+msg_color=0 -M0 -m0 -b512 -B1024 ;-d
</CsOptions>
<CsInstruments>
nchnls  = 2
0dbfs   = 1
ksmps   = 256
sr      = 44100

;cpuprc 1, 50
;prealloc 1, 48
maxalloc    1, 24
maxalloc    6, 1
giZeldaSoundfont            sfload "Zelda_3.sf2" 
giGeneralMidiSoundfont      sfload "sf_GMbank.sf2"
giSuperMarioWorldSoundfont  sfload "SuperMarioWorld.sf2"
        sfilist giZeldaSoundfont 
        sfilist giSuperMarioWorldSoundfont 
        sfilist giGeneralMidiSoundfont 


giSine          ftgen 0, 0, 2^12, 10, 1
giTri           ftgen 0, 0, 8192, 7, 0, 2048, 1, 4096, -1, 2048, 0
giSquare        ftgen 3, 0, 8192, 7, 1, 4096, 1, 0, -1, 4096, -1 
gisine          ftgen 0, 0, 4096, 10, 1
    
giPlayedNotes   ftgen 0, 0, -100, 2, 1
giActiveNotes   ftgen 0, 0, 128, -2, 0      ;CREATES A TABLE WITH ON/OFF-STATUS OF ALL 128 NOTE VALUES 
;giNotePriority ftgen 0, 0, 64, -2, 0       ;ORDERED ROW OF NOTES (IN THE ORDER IN WHICH THEY WERE PLAYED)

; Sound generation
gaOscilL        init 0
gaOscilR        init 0
gkOscil1State   init 0
gkOscil2State   init 0
gkFineTuneOsc1  init 0
gkFineTuneOsc2  init 0
gkOscil1Amp     init 0
gkOscil1Mod     init 0
gkOscil1Mod2    init 0
gkOscil2Tune    init 0
gkOscil2Amp     init 0
gkOscil2Mod     init 0
gkOscil2Mod2    init 0
gkAmpAttack     init 0
gkAmpDecay      init 0
gkAmpSustain    init 0
gkAmpRelease    init 0
gkPitchAttack   init 0
gkPitchDecay    init 0
gkPitchSustain  init 0
gkPitchRelease  init 0
gkLFOType       init 0
gkLFOAmp        init 0
gkLFOFreq       init 0
gkLFODelay      init 0
gkLFO1Osc1      init 0
gkLFO1Osc2      init 0

; Soundfonts
giSelectedOscillator1SoundfontPreset init 6
giSelectedOscillator2SoundfontPreset init 6

; EFX
gkDistState     init 0
gkDistGain      init 0
gkDistMix       init 0

gkFilterType    init 0
gkFilterCutoff  init 0
gkFilterRes     init 0 
gkFilterEnvAmt  init 0  
gkFilterAttack  init 0
gkFilterDecay   init 0
gkFilterSustain init 0
gkFilterRelease init 0
gkFilterEnv     init 0

gkPhaserState   init 0
gkPhaserFreq    init 0
gkPhaserFeed    init 0
gkPhaserMix     init 0

gkReverbState   init 0
gkReverbRoomSize init 0
gkReverbFreq    init 0
gkReverbMix     init 0

gkChorusState   init 0
gkChorusFreq    init 0
gkChorusDepth   init 0
gkChorusWidth   init 0
gkChorusMix     init 0

gkDelayState    init 0
gkDelayTime     init 0
gkDelayFeedback init 0
gkDelayMix      init 0

gkArpeggiatorState      init 0
gkCurrentFilterValue    init 0
gkCurrentNumberOfNotes  init 0
gkTrigger               init 0

gkporttime      init 0
gkcps           init 0
gkCPSOsc1       init 0
gkCPSOsc2       init 0


opcode  cpsmid, k, k
kmid    xin
#define MIDI2CPS(xmidi) # (440.0*exp(log(2.0)*(($xmidi)-69.0)/12.0)) #
kCPS    = $MIDI2CPS(kmid)
xout    kCPS
endop

opcode  cpsmid2, k, k
kmid    xin
#define MIDI2CPS(xmidi) # (440.0*exp(log(2.0)*(($xmidi)-69.0 + gkOscil2Tune)/12.0)) #
kCPS    = $MIDI2CPS(kmid)
xout    kCPS
endop

opcode  StChorus,aa,aakkk
    ainL,ainR,krate,kdepth,kwidth   xin                 ;READ IN INPUT ARGUMENTS
    ilfoshape   ftgentmp    0, 0, 131072, 19, 1, 0.5, 0,  0.5   ;POSITIVE DOMAIN ONLY SINE WAVE
    kporttime   linseg  0,0.001,0.02                    ;RAMPING UP PORTAMENTO VARIABLE
    kChoDepth   portk   kdepth*0.01, kporttime              ;SMOOTH VARIABLE CHANGES WITH PORTK
    aChoDepth   interp  kChoDepth                   ;INTERPOLATE TO CREATE A-RATE VERSION OF K-RATE VARIABLE
    amodL       osciliktp   krate, ilfoshape, 0         ;LEFT CHANNEL LFO
    amodR       osciliktp   krate, ilfoshape, kwidth*0.5        ;THE PHASE OF THE RIGHT CHANNEL LFO IS ADJUSTABLE
    amodL       =       (amodL*aChoDepth)+.01           ;RESCALE AND OFFSET LFO (LEFT CHANNEL)
    amodR       =       (amodR*aChoDepth)+.01           ;RESCALE AND OFFSET LFO (RIGHT CHANNEL)
    aChoL       vdelay  ainL, amodL*1000, 1.2*1000          ;CREATE VARYING DELAYED / CHORUSED SIGNAL (LEFT CHANNEL) 
    aChoR       vdelay  ainR, amodR*1000, 1.2*1000          ;CREATE VARYING DELAYED / CHORUSED SIGNAL (RIGHT CHANNEL)
    aoutL       sum     aChoL*0.6, ainL*0.6                         ;MIX DRY AND WET SIGNAL (LEFT CHANNEL)
    aoutR       sum     aChoR*0.6, ainR*0.6             ;MIX DRY AND WET SIGNAL (RIGHT CHANNEL)
                xout    aoutL,aoutR                 ;SEND AUDIO BACK TO CALLER INSTRUMENT
endop


instr 1

midinoteonkey       p4, p5
kCPS                cpsmid p4
kCPS2               cpsmid2 p4
gkCPSOsc1           = kCPS * cent(100/12*gkFineTuneOsc1)
gkCPSOsc2           = kCPS2 * cent(100/12*gkFineTuneOsc2) ; Need separate frequencies for each osc

kAmpAdjust          = 0.1
a1TempL             = 0
a1TempR             = 0
a2TempL             = 0
a2TempR             = 0
a1R                 = 0
a2R                 = 0

kAmpEnvelope        linsegr 0, i(gkAmpAttack) + 0.01, 1, i(gkAmpDecay), i(gkAmpSustain), i(gkAmpRelease) + 0.01, 0
kPitchEnvelope      linsegr 0, i(gkPitchAttack), 1, i(gkPitchDecay), i(gkPitchSustain), i(gkPitchRelease), 0
;kAmpEnvelope        madsr i(gkAmpAttack) + 0.01, 1, i(gkAmpDecay), i(gkAmpSustain), i(gkAmpRelease)

gkCPSOsc1           = gkCPSOsc1 + gkLFO1Osc1*gkCPSOsc1 ;
gkCPSOsc2           = gkCPSOsc2 + gkLFO1Osc2*gkCPSOsc2

; ---------- OSCILLATORS ----------

; SINE WAVE/HARD SYNC
if (gkOscil1State >= 1 && gkOscil1State < 2) then

    ; SINE
    kInstrumentNumber = 1
    kSliderCompensation = abs(kInstrumentNumber - gkOscil1State)    ; THE SLIDER CAN HAVE CONTINOUS VALUES, WHICH NEEDS TO BE COMPENSATED FOR WITH EACH INSTRUMENT -NUMBER- 
    ;printk2 kSliderCompensation
    a1SineL     poscil kAmpAdjust*kAmpEnvelope*gkOscil1Amp * sqrt(1 - kSliderCompensation), gkCPSOsc1, giSine
    a1SineR     poscil kAmpAdjust*kAmpEnvelope*gkOscil1Amp * sqrt(1 - kSliderCompensation), gkCPSOsc1, giSine



    ; ; HARD SYNC
 ;    ; the slave's frequency affects the timbre 
 ;    ;kslavecps   line        i(kCPS * cent(100/12*gkFineTuneOsc1)), 1, i(kCPS * cent(100/12*gkFineTuneOsc1)) * 5
    
 ;    ; the master "oscillator"
 ;    ; the master has no sync input 
 ;    anosync     init        0.0
 ;    am, async   syncphasor  kCPSOsc1, anosync
    
 ;    ; the slave "oscillator"
 ;    kOscil1Mod    portk gkOscil1Mod, .1
 ;    kCPS1Temp     = kCPS * cent(100/12*gkFineTuneOsc1)
 ;    asig, as    syncphasor kCPS1Temp*1*kOscil1Mod, async


    ; a1L1 = a1SineL * (1 - gkOscil1Mod)
    ; a1R1 = a1SineR * (1 - gkOscil1Mod)

    ; a1L2 = (asig/2) * gkOscil1Mod
    ; a1R2 = (asig/2) * gkOscil1Mod

    a1TempL = a1TempL + a1SineL
    a1TempR = a1TempR + a1SineR
endif

; SAW WAVE
if (gkOscil1State > 1 && gkOscil1State < 3) then
    kInstrumentNumber = 2
    kSliderCompensation = abs(kInstrumentNumber - gkOscil1State)
    a1L     vco2 kAmpAdjust*kAmpEnvelope*gkOscil1Amp*sqrt(1 - kSliderCompensation), (gkCPSOsc1 + 0), 4, (gkOscil1Mod * 0.98) + 0.01
    a1R     vco2 kAmpAdjust*kAmpEnvelope*gkOscil1Amp*sqrt(1 - kSliderCompensation), (gkCPSOsc1 + 0), 4, (gkOscil1Mod * 0.98) + 0.01
    a1TempL = a1TempL + a1L 
    a1TempR = a1TempR + a1R 
endif

; PWM WAVE
if (gkOscil1State > 2 && gkOscil1State < 4) then
    kInstrumentNumber = 3
    kSliderCompensation = abs(kInstrumentNumber - gkOscil1State)
    a1L     vco2    kAmpAdjust*kAmpEnvelope*gkOscil1Amp * sqrt(1 - kSliderCompensation)*.75, (gkCPSOsc1 + 0), 2, (gkOscil1Mod * 0.9) + 0.05
    a1R     vco2    kAmpAdjust*kAmpEnvelope*gkOscil1Amp * sqrt(1 - kSliderCompensation)*.75, (gkCPSOsc1 + 0), 2, (gkOscil1Mod * 0.9) + 0.05
    a1TempL = a1TempL + a1L 
    a1TempR = a1TempR + a1R
endif

; FM
if (gkOscil1State > 3 && gkOscil1State < 5) then
    kInstrumentNumber = 4
    kSliderCompensation = abs(kInstrumentNumber - gkOscil1State)
    a1L     foscili kAmpAdjust*kAmpEnvelope*gkOscil1Amp * sqrt(1 - kSliderCompensation), (gkCPSOsc1 + 0), 1, gkOscil1Mod*1000, gkOscil1Mod2*10, giSine
    a1R     foscili kAmpAdjust*kAmpEnvelope*gkOscil1Amp * sqrt(1 - kSliderCompensation), (gkCPSOsc1 + 0), 1, gkOscil1Mod*1000, gkOscil1Mod2*10, giSine
    a1TempL = a1TempL + a1L 
    a1TempR = a1TempR + a1R 
endif

; SOUNDFONT
if (gkOscil1State > 4 && gkOscil1State <= 6) then
    kInstrumentNumber = 5
    kSliderCompensation = abs(kInstrumentNumber - gkOscil1State)
    iAmp    = 0.001*i(kAmpAdjust)                       ;scale amplitude
    iAmp    = iAmp * p4 * 1/128             ;make velocity-dependent
    ;a1, a2 sfinstr3 p5, p4, iAmp, kCPSOsc1, 180, giZeldaSoundfont, 1 ;= Slap Bass 3
    a1L, a1R sfinstr3 p5, p4, iAmp*gkOscil1Amp*kAmpEnvelope*sqrt(1 - kSliderCompensation), (gkCPSOsc1 + 0), giSelectedOscillator1SoundfontPreset, giGeneralMidiSoundfont, 1
    aEnv    linsegr 0,0.001,1,0.005,0
    a1TempL = a1TempL + a1L
    a1TempR = a1TempR + a1R
endif

; OSCILLATOR 2

; SINE WAVE
if (gkOscil2State >= 11 && gkOscil2State < 12) then
    kInstrumentNumber = 11
    kSliderCompensation = abs(kInstrumentNumber - gkOscil2State)
    a2L     poscil kAmpAdjust*kAmpEnvelope*gkOscil2Amp * sqrt(1 - kSliderCompensation), gkCPSOsc2, giSine
    a2R     poscil kAmpAdjust*kAmpEnvelope*gkOscil2Amp * sqrt(1 - kSliderCompensation), gkCPSOsc2, giSine
    a2TempL = a2TempL + a2L 
    a2TempR = a2TempR + a2R 
endif

; SAW WAVE
if (gkOscil2State > 11 && gkOscil2State < 13) then
    kInstrumentNumber = 12
    kSliderCompensation = abs(kInstrumentNumber - gkOscil2State)
    a2L     vco2 kAmpAdjust*kAmpEnvelope*gkOscil2Amp*sqrt(1 - kSliderCompensation), (gkCPSOsc2 + 0), 4, (gkOscil2Mod * 0.98) + 0.01
    a2R     vco2 kAmpAdjust*kAmpEnvelope*gkOscil2Amp*sqrt(1 - kSliderCompensation), (gkCPSOsc2 + 0), 4, (gkOscil2Mod * 0.98) + 0.01
    a2TempL = a2TempL + a2L 
    a2TempR = a2TempR + a2R 
endif

; PWM WAVE
if (gkOscil2State > 12 && gkOscil2State < 14) then
    kInstrumentNumber = 13
    kSliderCompensation = abs(kInstrumentNumber - gkOscil2State)
    a2L     vco2    kAmpAdjust*kAmpEnvelope*gkOscil2Amp * sqrt(1 - kSliderCompensation)*.75, (gkCPSOsc2 + 0), 2, (gkOscil2Mod * 0.9) + 0.05
    a2R     vco2    kAmpAdjust*kAmpEnvelope*gkOscil2Amp * sqrt(1 - kSliderCompensation)*.75, (gkCPSOsc2 + 0), 2, (gkOscil2Mod * 0.9) + 0.05
    a2TempL = a2TempL + a2L 
    a2TempR = a2TempR + a2R 
endif

; FM
if (gkOscil2State > 13 && gkOscil2State < 15) then
    kInstrumentNumber = 14
    kSliderCompensation = abs(kInstrumentNumber - gkOscil2State)
    a2L     foscili kAmpAdjust*kAmpEnvelope*gkOscil2Amp * sqrt(1 - kSliderCompensation), (gkCPSOsc2 + 0), gkOscil2Mod2*100, gkOscil2Mod*100, 4, giSine
    a2R     foscili kAmpAdjust*kAmpEnvelope*gkOscil2Amp * sqrt(1 - kSliderCompensation), (gkCPSOsc2 + 0), gkOscil2Mod2*100, gkOscil2Mod*100, 4, giSine
    a2TempL = a2TempL + a2L 
    a2TempR = a2TempR + a2R 
endif

; SAMPLE
if (gkOscil2State > 14 && gkOscil2State <= 16) then
    kInstrumentNumber = 15
    kSliderCompensation = abs(kInstrumentNumber - gkOscil2State)
    iAmp    = 0.001*i(kAmpAdjust)                       ;scale amplitude
    iAmp    = iAmp * p4 * 1/128             ;make velocity-dependent
    ;a1, a2 sfinstr3 p5, p4, iAmp, kCPSOsc1, 180, giZeldaSoundfont, 1 ;= Slap Bass 3
    a2L, a2R sfinstr3 p5, p4, iAmp*gkOscil2Amp*kAmpEnvelope*sqrt(1 - kSliderCompensation), (gkCPSOsc2 + 0), giSelectedOscillator2SoundfontPreset, giGeneralMidiSoundfont, 1
    ;a2L, a2R    loscil3 kAmpAdjust*kAmpEnvelope*gkOscil2Amp * sqrt(1 - kSliderCompensation), 1, 2, 2
    a2TempL = a2TempL + a2L 
    a2TempR = a2TempR + a2R 
endif

aTempL          = a1TempL + a2TempL
aTempR          = a1TempR + a2TempR

a1TempL = 0
a1TempR = 0
a2TempL = 0
a2TempR = 0


#include "filters.inc"
;aEnv             expsegr 0.01, i(gkAmpAttack), 1, i(gkAmpDecay), i(gkAmpSustain), i(gkAmpRelease), 0.01
;aL = aL * aEnv

gaOscilL        = gaOscilL + aFiltered

endin


instr 2 ;NOTE ON/OFF AND PITCH REGISERING INSTRUMENT. THIS INSTRUMENT WILL BE TRIGGERED BY NOTE PLAYED ON THE MIDI KEYBOARD
    prints "instr 6"
    midinoteonkey       p4, p5
    gkcps               cpsmid p4

    kCPS                cpsmid p4
    kCPS2               cpsmid2 p4
    gkCPSOsc1           = kCPS * cent(100/12*gkFineTuneOsc1)
    gkCPSOsc2           = kCPS2 * cent(100/12*gkFineTuneOsc2)

    ;icps       cpsmidi     ;READ IN MIDI PITCH VALUES
    ;gkcps  =   icps        ;CREATE A K-RATE GLOBAL VARIABLE VERSION OF MIDI PITCH THAT WILL BE USED IN INSTRUMENT 2.
    gkNoteOn    init    1   ;A FLAG TO INDICATE WHEN A NEW NOTE HAS BEEN PLAYED. THIS FLAG IS CLEARED (RESET TO ZERO) AT THE BOTTOM OF INSTR 2.
    event_i "i", 6, 0, -1   ;THE VERY FIRST MIDI NOTE PLAYED WILL TRIGGER AN INFINITELY HELD NOTE IN INSTR 2. THE maxalloc SETTING IN THE ORCHESTRA HEADER WILL PREVENT ANY FURTHER TRIGGERINGS. 
endin

instr 6 ;SOUND PRODUCING INSTRUMENT

    ;VIBRATO ENVELOPE CHARACTERISTICS 
    ivibamp     init    0.05
    ivibdelayTim    init    0.3
    ivibRiseTim init    1.2
    kvibfreq    init    6

    ;AMPLITUDE ENVELOPE CHARACTERISTICS
    iAmpAttTim  init    0.01
    iAmpRelTim  init    1
    
    ;RESONANT LOWPASS FILTER ENVELOPE CHARACTERISTICS (ADSR TYPE)
    iFiltAttTim init    0.01        ;FILTER ENVELOPE ATTACK TIME
    iFiltAttLev init    1           ;ATTACK LEVEL FOR THE FILTER ENVELOPE (RANGE 0 - 1)
    iFiltDecTim init    2           ;FILTER ENVELOPE DECAY TIME 
    iFiltRelTim init    1           ;FILTER ENVELOPE RELEASE TIME 
    iFiltSusLev init    0.7         ;SUSTAIN LEVEL FOR THE FILTER ENVELOPE (RANGE 0 - 1)
    iFiltBase   init    4           ;BASIC FILTER CUTOFF OFFSET IN OCT FORMAT. ENVELOPE WILL BE ADDED TO THIS VALUE.
    iFiltEnvRange   init    10          ;RANGE OF THE ENVELOPE'S INFLUENCE IN OCT FORMAT
    kres        init    0.9         ;FILTER RESONANCE

    kactive1    active  2                       ;CONTINUALLY TRACK THE NUMBER OF ACTIVE INSTANCES OF INSTRUMENT 1. I.E. THE NUMBER OF MIDI NOTES HELD.
    
    ;CREATE PORTAMENTO ON PITCH PARAMETER
    kporttime   linseg  0,0.04,1                    ;PORTAMENTO TIME RISES QUICKLY TO A HELD VALUE OF '1'
    kporttime   =   kporttime*gkporttime                ;PORTAMENTO TIME FUNCTION SCALED BY VALUE OUTPUT BY FLTK SLIDER
    kcps        portk   gkCPSOsc1, kporttime                ;APPLY PORTAMENTO TO PITCH CHANGES

    ;SENSE WHEN TO RE-TRIGGER THE VIBRATO ENVELOPE...
    if  gkNoteOn=1 then                         ;IF A NEW NOTE HAS BEGUN...
      reinit    RestartVibEnv                       ;RESTART THE VIBRATO ENVELOPE FROM LABEL 'RestartVibEnv'
    endif                                   ;END OF THIS CONDITIONAL BRANCH
    ;CREATE A VIBRATO FUNCTION - THIS ENVELOPE WILL BE TRIGGERED WITH EACH NEW NEW THAT IS PRESSED WHETHER LEGATO OR NOT
    RestartVibEnv:                              ;REINITIALISE FROM HERE IF A NEW NOTE HAS BEGUN - THIS WILL RESTART THE VIBRATO ENVELOPE
    kvibenv     transeg 0, ivibdelayTim, 0, 0, ivibRiseTim, 2, ivibamp  ;SLIGHTLY CONCAVE BUILD-UP (shape=2)
    rireturn                                ;RETURN FROM REINITIALISATION PASS
    kvib        oscil   kvibenv, kvibfreq, gisine           ;CREATE VIBRATO FUNCTION
    kvib        =   kvib+1                      ;SHIFT VIBRATO FUNCTION UP THE Y-AXIS SO THAT IT OSCILLATES ABOUT 1
    
    ;CREATE A SAWTOOTH OSCILLATOR USING THE vco2 OPCODE
    ;asig       vco2    0.3,kcps*kvib


    ; Sound generation is the same as in instrument 1
    kAmpAdjust          = 0.1
    a1TempL             = 0
    a1TempR             = 0
    a2TempL             = 0
    a2TempR             = 0

    gkCPSOsc1           = gkCPSOsc1 + gkLFO1Osc1*gkCPSOsc1
    gkCPSOsc2           = gkCPSOsc2 + gkLFO1Osc2*gkCPSOsc2

    ; ---------- OSCILLATORS ----------

    ; SINE WAVE/HARD SYNC
    if (gkOscil1State >= 1 && gkOscil1State < 2) then

        ; SINE
        kInstrumentNumber = 1
        kSliderCompensation = abs(kInstrumentNumber - gkOscil1State)    ; THE SLIDER CAN HAVE CONTINOUS VALUES, WHICH NEEDS TO BE COMPENSATED FOR WITH EACH INSTRUMENT -NUMBER- 
        ;printk2 kSliderCompensation
        a1SineL     poscil kAmpAdjust*gkOscil1Amp * sqrt(1 - kSliderCompensation), gkCPSOsc1, giSine
        a1SineR     poscil kAmpAdjust*gkOscil1Amp * sqrt(1 - kSliderCompensation), gkCPSOsc1, giSine



        ; ; HARD SYNC
     ;    ; the slave's frequency affects the timbre 
     ;    ;kslavecps   line        i(kCPS * cent(100/12*gkFineTuneOsc1)), 1, i(kCPS * cent(100/12*gkFineTuneOsc1)) * 5
        
     ;    ; the master "oscillator"
     ;    ; the master has no sync input 
     ;    anosync     init        0.0
     ;    am, async   syncphasor  kCPSOsc1, anosync
        
     ;    ; the slave "oscillator"
     ;    kOscil1Mod    portk gkOscil1Mod, .1
     ;    kCPS1Temp     = kCPS * cent(100/12*gkFineTuneOsc1)
     ;    asig, as    syncphasor kCPS1Temp*1*kOscil1Mod, async




        ; a1L1 = a1SineL * (1 - gkOscil1Mod)
        ; a1R1 = a1SineR * (1 - gkOscil1Mod)

        ; a1L2 = (asig/2) * gkOscil1Mod
        ; a1R2 = (asig/2) * gkOscil1Mod

        a1TempL = a1TempL + a1SineL
        a1TempR = a1TempR + a1SineR
    endif

    ; SAW WAVE
    if (gkOscil1State > 1 && gkOscil1State < 3) then
        kInstrumentNumber = 2
        kSliderCompensation = abs(kInstrumentNumber - gkOscil1State)
        a1L     vco2 kAmpAdjust*gkOscil1Amp*sqrt(1 - kSliderCompensation), (gkCPSOsc1 + 0), 4, (gkOscil1Mod * 0.98) + 0.01
        a1R     vco2 kAmpAdjust*gkOscil1Amp*sqrt(1 - kSliderCompensation), (gkCPSOsc1 + 0), 4, (gkOscil1Mod * 0.98) + 0.01
        a1TempL = a1TempL + a1L 
        a1TempR = a1TempR + a1R 
    endif

    ; PWM WAVE
    if (gkOscil1State > 2 && gkOscil1State < 4) then
        kInstrumentNumber = 3
        kSliderCompensation = abs(kInstrumentNumber - gkOscil1State)
        a1L     vco2    kAmpAdjust*gkOscil1Amp * sqrt(1 - kSliderCompensation), (gkCPSOsc1 + 0), 2, (gkOscil1Mod * 0.9) + 0.05
        a1R     vco2    kAmpAdjust*gkOscil1Amp * sqrt(1 - kSliderCompensation), (gkCPSOsc1 + 0), 2, (gkOscil1Mod * 0.9) + 0.05
        a1TempL = a1TempL + a1L 
        a1TempR = a1TempR + a1R 
    endif

    ; FM
    if (gkOscil1State > 3 && gkOscil1State < 5) then
        kInstrumentNumber = 4
        kSliderCompensation = abs(kInstrumentNumber - gkOscil1State)
        a1L     foscili kAmpAdjust*gkOscil1Amp * sqrt(1 - kSliderCompensation), (gkCPSOsc1 + 0), gkOscil1Mod2*100, gkOscil1Mod*100, 1, giSine
        a1R     foscili kAmpAdjust*gkOscil1Amp * sqrt(1 - kSliderCompensation), (gkCPSOsc1 + 0), gkOscil1Mod2*100, gkOscil1Mod*100, 1, giSine
        a1TempL = a1TempL + a1L 
        a1TempR = a1TempR + a1R 
    endif

    ; SOUNDFONT
    if (gkOscil1State > 4 && gkOscil1State <= 6) then
        kInstrumentNumber = 5
        kSliderCompensation = abs(kInstrumentNumber - gkOscil1State)
        iAmp    = 0.001*i(kAmpAdjust)                       ;scale amplitude
        iAmp    = iAmp * p4 * 1/128             ;make velocity-dependent
        ;a1, a2 sfinstr3 p5, p4, iAmp, kCPSOsc1, 180, giZeldaSoundfont, 1 ;= Slap Bass 3
        a1L, a1R sfinstr3 p5, p4, iAmp*gkOscil1Amp*sqrt(1 - kSliderCompensation), (gkCPSOsc1 + 0), giSelectedOscillator1SoundfontPreset, giGeneralMidiSoundfont, 1
        aEnv    linsegr 0,0.001,1,0.005,0
        a1TempL = a1TempL + a1L
        a1TempR = a1TempR + a1R
    endif

    ; OSCILLATOR 2

    ; SINE WAVE
    if (gkOscil2State >= 11 && gkOscil2State < 12) then
        kInstrumentNumber = 11
        kSliderCompensation = abs(kInstrumentNumber - gkOscil2State)
        a2L     poscil kAmpAdjust*gkOscil2Amp * sqrt(1 - kSliderCompensation), gkCPSOsc2, giSine
        a2R     poscil kAmpAdjust*gkOscil2Amp * sqrt(1 - kSliderCompensation), gkCPSOsc2, giSine
        a2TempL = a2TempL + a2L 
        a2TempR = a2TempR + a2R 
    endif

    ; SAW WAVE
    if (gkOscil2State > 11 && gkOscil2State < 13) then
        kInstrumentNumber = 12
        kSliderCompensation = abs(kInstrumentNumber - gkOscil2State)
        a2L     vco2 kAmpAdjust*gkOscil2Amp*sqrt(1 - kSliderCompensation), (gkCPSOsc2 + 0), 4, (gkOscil2Mod * 0.98) + 0.01
        a2R     vco2 kAmpAdjust*gkOscil2Amp*sqrt(1 - kSliderCompensation), (gkCPSOsc2 + 0), 4, (gkOscil2Mod * 0.98) + 0.01
        a2TempL = a2TempL + a2L 
        a2TempR = a2TempR + a2R 
    endif

    ; PWM WAVE
    if (gkOscil2State > 12 && gkOscil2State < 14) then
        kInstrumentNumber = 13
        kSliderCompensation = abs(kInstrumentNumber - gkOscil2State)
        a2L     vco2    kAmpAdjust*gkOscil2Amp * sqrt(1 - kSliderCompensation), (gkCPSOsc2 + 0), 2, (gkOscil2Mod * 0.9) + 0.05
        a2R     vco2    kAmpAdjust*gkOscil2Amp * sqrt(1 - kSliderCompensation), (gkCPSOsc2 + 0), 2, (gkOscil2Mod * 0.9) + 0.05
        a2TempL = a2TempL + a2L 
        a2TempR = a2TempR + a2R 
    endif

    ; FM
    if (gkOscil2State > 13 && gkOscil2State < 15) then
        kInstrumentNumber = 14
        kSliderCompensation = abs(kInstrumentNumber - gkOscil2State)
        a2L     foscili kAmpAdjust*gkOscil2Amp * sqrt(1 - kSliderCompensation), (gkCPSOsc2 + 0), gkOscil2Mod2*100, gkOscil2Mod*100, 1, giSine
        a2R     foscili kAmpAdjust*gkOscil2Amp * sqrt(1 - kSliderCompensation), (gkCPSOsc2 + 0), gkOscil2Mod2*100, gkOscil2Mod*100, 1, giSine
        a2TempL = a2TempL + a2L 
        a2TempR = a2TempR + a2R 
    endif

    ; SAMPLE
    if (gkOscil2State > 14 && gkOscil2State <= 16) then
        kInstrumentNumber = 15
        kSliderCompensation = abs(kInstrumentNumber - gkOscil2State)
        iAmp    = 0.001*i(kAmpAdjust)                       ;scale amplitude
        iAmp    = iAmp * p4 * 1/128             ;make velocity-dependent
        ;a1, a2 sfinstr3 p5, p4, iAmp, kCPSOsc1, 180, giZeldaSoundfont, 1 ;= Slap Bass 3
        a2L, a2R sfinstr3 p5, p4, iAmp*gkOscil2Amp*sqrt(1 - kSliderCompensation), (gkCPSOsc2 + 0), giSelectedOscillator2SoundfontPreset, giGeneralMidiSoundfont, 1
        ;a2L, a2R    loscil3 kAmpAdjust*kAmpEnvelope*gkOscil2Amp * sqrt(1 - kSliderCompensation), 1, 2, 2
        a2TempL = a2TempL + a2L 
        a2TempR = a2TempR + a2R 
    endif

    aTempL          = a1TempL + a2TempL
    aTempR          = a1TempR + a2TempR



    ; HARD SYNC
    ; the slave's frequency affects the timbre 
    kslavecps   line        i(kcps), 1, i(kcps) * 5
    
    ; the master "oscillator"
    ; the master has no sync input 
    anosync     init        0.0
    am, async   syncphasor  gkCPSOsc1 + gkCPSOsc1*gkLFO1Osc1, anosync
    
    ; the slave "oscillator"
    kOscil1Mod  portk gkOscil1Mod, .1
    asig, as    syncphasor kcps*10*kOscil1Mod, async


    ; ENVELOPES
    kAmpEnv     init    0
    kFiltEnv    init    0
    if gkNoteOn = 1 && kactive1 = 1 then                      ;IF A NEW LEGATO PHRASE IS BEGUN (I.E. A NEW NOTE HAS BEEN PRESSED AND NO OTHER PREVIOUS NOTES ARE BEING HELD)...
      reinit RestartLegEnvs                      ;RESTART THE 'LEGATO PHRASE' ENVELOPES (IN THIS CASE AMPLITUDE AND FILTER)
    endif                                   ;END OF THIS CONDITIONAL BRANCH
    RestartLegEnvs:                             ;A LABEL: BEGIN A REINITIALISATION PASS FROM HERE TO RESTART THE LEGATO PHRASE ENVELOPE
        if  kactive1 > 0 then                         ;IF A NEW LEGATO PHRASE IS BEGINNING...
          kAmpEnv   transeg i(kAmpEnv), i(gkAmpAttack), -2, 1          ;MOVE THROUGH AMPLITUDE ATTACK (NOTE ON) ENVELOPE. IT WILL HOLD THE FINAL VALUE
          kAmpSus   = kAmpEnv                 ;REGISTER OF THE FINAL VALUE OF THE ATTACK-SUSTAIN ENVELOPE - USED BY THE RELEASE STAGE OF THE ENVELOPE
          kFiltEnv  transeg i(kFiltEnv), i(gkFilterAttack), -2,iFiltAttLev, i(gkFilterDecay), -2, i(gkFilterSustain);MOVE THROUGH FILTER ATTACK (NOTE ON) ENVELOPE. IT WILL HOLD THE FINAL VALUE
          kFiltSus  = kFiltEnv                ;REGISTER OF THE FINAL VALUE OF THE ATTACK-SUSTAIN ENVELOPE - USED BY THE RELEASE STAGE OF THE ENVELOPE
        elseif kactive1 = 0 then                         ;OR IF A LEGATO PHRASE HAS FINISHED (NO NOTE ARE BEGIN HELD)...
          kAmpEnv   transeg 1, i(gkAmpRelease), -2, 0                          ;MOVE THROUGH AMPLITUDE RELEASE ENVELOPE (FINAL VALUE WILL BE HELD)
          kAmpEnv   = kAmpEnv * kAmpSus                 ;RELEASE ENVELOPE RESCALED ACCORDING TO THE FINAL VALUE OF THE ATTACK SUSTAIN PORTION OF THE ENVELOPE BEFORE THE NOTE OFF WAS RECEIVED
          kFiltEnv  transeg i(gkFilterSustain), i(gkFilterRelease), -2, 0          ;MOVE THROUGH FILTER RELEASE ENVELOPE (FINAL VALUE WILL BE HELD)
          kFiltEnv  = kFiltEnv * kFiltSus               ;RELEASE ENVELOPE RESCALED ACCORDING TO THE FINAL VALUE OF THE ATTACK SUSTAIN PORTION OF THE ENVELOPE BEFORE THE NOTE OFF WAS RECEIVED
        endif
    rireturn                                ;RETURN FROM REINITIALISATION PASS
    
    aAmpEnv     interp kAmpEnv                     ;SMOOTHER A-RATE AMPLITUDE ENVELOPE - MAY PROVE BENEFICIAL IF THERE ARE FAST CHANGING ENVELOPE SEGMENTS 
    kFiltEnvScl = cpsoct((kFiltEnv*iFiltEnvRange) + iFiltBase)  ;FILTER ENVELOPE RESCALED AND CONVERTED FROM OCT FORMAT TO CPS
    
    ;CREATE A FILTERED VERSION OF THE OSCILLATOR SIGNAL
    asigL       moogladder  aTempL, gkFilterCutoff, gkFilterRes
    asigR       moogladder  aTempR, gkFilterCutoff, gkFilterRes

    #include "filters.inc"

    asigL = aFiltered
    asigR = aFiltered

    gaOscilL = gaOscilL + asigL*aAmpEnv/2
    gaOscilR = gaOscilR + asigR*aAmpEnv/2
    gkNoteOn = 0

endin

; ------- EFFECT INSTRUMENTS -------

instr 108
    if (gkDistState == 1) kgoto distIsActive
        kgoto continue

    distIsActive: 
        a1          distort1 gaOscilL, gkDistGain, .2, 0, 0
        a2          distort1 gaOscilR, gkDistGain, .2, 0, 0
        gaOscilL    = sqrt(1 - gkDistMix)*gaOscilL + a1*sqrt(gkDistMix)
        gaOscilR    = sqrt(1 - gkDistMix)*gaOscilR + a2*sqrt(gkDistMix)
        kgoto continue

    continue:
endin


instr 109
    if (gkPhaserState == 1) kgoto phaserIsActive
        kgoto continue

    phaserIsActive: 
        iFeedback   chnget "phaserFeed"
        kFreq  oscil 4000, gkPhaserFreq, 1
        kMod   = kFreq + 5600
        a1          phaser1 gaOscilL, kMod, 4, iFeedback
        a2          phaser1 gaOscilR, kMod, 4, iFeedback
        gaOscilL    = sqrt(1 - gkPhaserMix)*gaOscilL + a1*sqrt(gkPhaserMix)
        gaOscilR    = sqrt(1 - gkPhaserMix)*gaOscilR + a2*sqrt(gkPhaserMix)
        kgoto continue
    continue:
endin

instr 110
    a1L = 0
    a1R = 0
    a2L = 0
    a2R = 0

    if (gkChorusState == 1) kgoto chorusIsActive
        kgoto       continue

    chorusIsActive: 
        aL, aR StChorus gaOscilL, gaOscilR, gkChorusFreq, gkChorusDepth, gkChorusWidth
        gaOscilL    = sqrt(1 - gkChorusMix)*gaOscilL + aL*sqrt(gkChorusMix)
        gaOscilR    = sqrt(1 - gkChorusMix)*gaOscilR + aR*sqrt(gkChorusMix)    
        kgoto       continue
    continue:
        aL = 0
        aR = 0
    ; vdelay3, lpf18 med dist -> 10,
endin


instr 111
    if (gkDelayState == 1) kgoto delayIsActive
        kgoto       continue

    delayIsActive: 
        aDelayTime  = a(gkDelayTime + .01)
        aFeedback   init 0

        aL vdelay3 gaOscilL + aFeedback, aDelayTime, 4000
        aR vdelay3 gaOscilR + aFeedback, aDelayTime, 4000

        aFeedback = aL * gkDelayFeedback

        gaOscilL    = sqrt(1 - gkDelayMix)*gaOscilL + aL*sqrt(gkDelayMix)
        gaOscilR    = sqrt(1 - gkDelayMix)*gaOscilR + aR*sqrt(gkDelayMix)
        kgoto       continue
    continue:
        aL = 0
        aR = 0
endin


instr 112
    a1L = 0
    a1R = 0
    a2L = 0
    a2R = 0

    if (gkReverbState == 1) kgoto reverbIsActive
        kgoto       continue

    reverbIsActive: 
        aL, aR      reverbsc gaOscilL, gaOscilR, gkReverbRoomSize, gkReverbFreq
        gaOscilL    = sqrt(1 - gkReverbMix)*gaOscilL + aL*sqrt(gkReverbMix)
        gaOscilR    = sqrt(1 - gkReverbMix)*gaOscilR + aR*sqrt(gkReverbMix)
        kgoto       continue
    continue:
        aL = 0
        aR = 0

    ; vdelay3, lpf18 med dist -> 10,
endin


instr 199
    gaOscilL        limit gaOscilL, -.5, .5
    gaOscilR        limit gaOscilR, -.5, .5

                    outs    gaOscilL + gaOscilR, gaOscilL + gaOscilR
    gaOscilL        = 0
    gaOscilR        = 0
endin


; Always on utility instrument

instr 200
;#include "channel.inc"

; Updating the global variables once per k-cycle
kOscil1State    chnget "oscillator1State"
kOscil2State    chnget "oscillator2State"
kOscil1FineTune chnget "oscil1FineTune"
kOscil1Amp      chnget "oscil1Amp"
kOscil1Mod      chnget "oscil1Mod"
kOscil1Mod2     chnget "oscil1Mod2"
kOscil2FineTune chnget "oscil2FineTune"
kOscil2Tune     chnget "oscil2Tune"
kOscil2Amp      chnget "oscil2Amp"
kOscil2Mod      chnget "oscil2Mod"
kOscil2Mod2     chnget "oscil2Mod2"
gkOscil1State   = kOscil1State
gkFineTuneOsc1  = kOscil1FineTune
gkOscil1Amp     = kOscil1Amp
gkOscil1Mod     portk kOscil1Mod, .02
gkOscil1Mod2    portk kOscil1Mod2, .02
gkOscil2State   = kOscil2State + 10     ; COMPENSATING FOR VALUES COMING FROM UISEGMENTEDCONTROL
gkFineTuneOsc2  = kOscil2FineTune

; Adding port when changing value
kOsc2TunePort   portk kOscil2Tune, .01
gkOscil2Tune    = floor(kOsc2TunePort)
gkOscil2Amp     = kOscil2Amp
gkOscil2Mod     portk kOscil2Mod, .02
gkOscil2Mod2    portk kOscil2Mod2, .02

; Amp envelope
kattack         chnget "attack"
kdecay          chnget "decay"
ksustain        chnget "sustain"
krelease        chnget "release"
gkAmpAttack     = kattack
gkAmpDecay      = kdecay
gkAmpSustain    = ksustain
gkAmpRelease    = krelease

; Pitch envelope
kPitchAttack    chnget "pitchAttack"
kPitchDecay     chnget "pitchDecay"
kPitchSustain   chnget "pitchSustain"
kPitchRelease   chnget "pitchRelease"
gkPitchAttack   = kPitchAttack
gkPitchDecay    = kPitchDecay
gkPitchSustain  = kPitchSustain
gkPitchRelease  = kPitchRelease

; LFO
kLFOType        chnget "lfoType"
kLFOAmp         chnget "lfoAmp"
kLFOFreq        chnget "lfoFreq"
kLFODelay       chnget "lfoDelay"
gkLFOType       = kLFOType
gkLFOAmp        = kLFOAmp
gkLFOFreq       = kLFOFreq
gkLFODelay      = kLFODelay*3


; --- EFFECTS ---

; Filter
kFilterCutoff   chnget "filterCutoff"
kFilterRes      chnget "filterResonance"
kFilterEnvAmt   chnget "filterEnvAmt"
kFilterType     chnget "filterType"
kFilterAttack   chnget "filterAttack"
kFilterDecay    chnget "filterDecay"
kFilterSustain  chnget "filterSustain"
kFilterRelease  chnget "filterRelease"
gkFilterCutoff  = kFilterCutoff * 18000 + 100
gkFilterRes     = kFilterRes
gkFilterEnvAmt  = kFilterEnvAmt
gkFilterType    = kFilterType
gkFilterAttack  = kFilterAttack
gkFilterDecay   = kFilterDecay
gkFilterSustain = kFilterSustain
gkFilterRelease = kFilterRelease

; Distortion
kDistState      chnget "distState"
kDistGain       chnget "distGain"
kDistMix        chnget "distMix"
gkDistState     = kDistState
gkDistGain      = kDistGain * 10
gkDistMix       = kDistMix

; Phaser
kPhaserState    chnget "phaserState"
kPhaserFreq     chnget "phaserFreq"
kPhaserFeed     chnget "phaserFeed"
kPhaserMix      chnget "phaserMix"
gkPhaserState   = kPhaserState
gkPhaserFreq    = kPhaserFreq
gkPhaserFeed    = kPhaserFeed
gkPhaserMix     = kPhaserMix

; Reverb
kReverbState    chnget "reverbState"
kReverbRoomSize chnget "reverbRoomSize"
kReverbFreq     chnget "reverbFreq"
kReverbMix      chnget "reverbMix"
gkReverbState   = kReverbState
gkReverbRoomSize = kReverbRoomSize
gkReverbFreq    = kReverbFreq
gkReverbMix     = kReverbMix

; Chorus
kChorusState    chnget "chorusState"
kChorusFreq     chnget "chorusFreq"
kChorusDepth    chnget "chorusDepth"
kChorusWidth    chnget "chorusWidth"
kChorusMix      chnget "chorusMix"
gkChorusState   = kChorusState
gkChorusFreq    = (kChorusFreq * 7) + 0.001
gkChorusDepth   = kChorusDepth
gkChorusWidth   = kChorusWidth
gkChorusMix     = kChorusMix

; Delay
kDelayState     chnget "delayState"
kDelayTime      chnget "delayTime"
kDelayFeedback  chnget "delayFeedback"
kDelayMix       chnget "delayMix"
gkDelayState    = kDelayState
;gkDelayTime     = kDelayTime
gkDelayTime     portk kDelayTime * 3000, .1
gkDelayFeedback = kDelayFeedback
gkDelayMix      = kDelayMix

endin


; Global LFO, always running
instr 201 

#include "lfo.inc"

endin


instr 300 

printk2 gkOscil1State
printk2 gkOscil2State
printk2 gkFineTuneOsc1  
printk2 gkOscil1Amp 
printk2 gkOscil1Mod 
printk2 gkOscil1Mod2 
printk2 gkFineTuneOsc2  
printk2 gkOscil2Tune
printk2 gkOscil2Amp 
printk2 gkOscil2Mod 
printk2 gkOscil2Mod2 
printk2 gkAmpAttack     
printk2 gkAmpDecay      
printk2 gkAmpSustain    
printk2 gkAmpRelease    
printk2 gkPitchAttack
printk2 gkPitchDecay
printk2 gkPitchSustain
printk2 gkPitchRelease
printk2 gkLFOType
printk2 gkLFOAmp
printk2 gkLFOFreq
printk2 gkLFODelay

; EFX
printk2 gkDistState     
printk2 gkDistGain      
printk2 gkDistMix       
printk2 gkFilterType    
printk2 gkFilterCutoff  
printk2 gkFilterRes 
printk2 gkFilterEnvAmt      
printk2 gkFilterAttack  
printk2 gkFilterDecay   
printk2 gkFilterSustain 
printk2 gkFilterRelease 
printk2 gkFilterEnv     
printk2 gkCurrentFilterValue
printk2 gkPhaserState   
printk2 gkPhaserFreq    
printk2 gkPhaserFeed    
printk2 gkPhaserMix     
printk2 gkReverbState   
printk2 gkReverbRoomSize
printk2 gkReverbFreq    
printk2 gkReverbMix
printk2 gkChorusState
printk2 gkChorusFreq
printk2 gkChorusDepth
printk2 gkChorusWidth
printk2 gkChorusMix
printk2 gkDelayState
printk2 gkDelayTime
printk2 gkDelayFeedback
printk2 gkDelayMix

endin

instr 400 
    sfilist giZeldaSoundfont 
endin

instr 401
    iValue = p4
    print iValue 
    giSelectedOscillator1SoundfontPreset = p4

endin

instr 402
    iValue = p4
    print iValue 
    giSelectedOscillator2SoundfontPreset = p4

endin

instr 450
    turnoff2 1, 0, 1
    turnoff
endin

instr 451
    turnoff2 2, 0, 1
    turnoff
endin


instr allNotesOff
turnoff2 1, 0, 1
turnoff
endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1
f2 0 0 1 "kickroll.wav" 0 0 0

i6   0 360000
i108 0 360000
i109 0 360000
i110 0 360000
i111 0 360000
i112 0 360000
i199 0 360000
i200 0 360000
i201 0 360000
i300 0 360000
 
</CsScore>
</CsoundSynthesizer>
