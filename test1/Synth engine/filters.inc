
iFilterAttack	chnget "filterAttack"
iFilterDecay	chnget "filterDecay"
iFilterSustain	chnget "filterSustain"
iFilterRelease	chnget "filterRelease"


kFilterEnvelope expseg (0.05 + (i(1 - gkFilterEnvAmt) * 0.95)), iFilterAttack, 1, iFilterDecay, iFilterSustain
kCutoff 		= gkFilterCutoff*kFilterEnvelope

kPortTime		linseg	0, 0.001, 0.1
kFltrResWthPort	portk	gkFilterRes, kPortTime
kFltrCutoffPort	portk 	kCutoff, .01

; Lowpass filter
if (gkFilterType == 0) then 
	aFiltered	lpf18 aTemp, kFltrCutoffPort, gkFilterRes*.98, 0
	;aFiltered 	moogladder aTemp, kFltrCutoffPort, gkFilterRes*.98, 5000000
	aFiltered	balance aFiltered, (aTemp)
	;aL 			butterlp a1L + a2L, kCutoff
;	aR 			moogladder a1R + a2R, kCutoff, kFltrResWthPort*.98
; Highpass filter
elseif (gkFilterType == 1) then
	aFiltered	butterhp aTemp, kCutoff
	;aR 			butterhp a1R + a2R, kCutoff
; Bandpass filter
elseif (gkFilterType == 2) then 
	aFiltered	butterbp aTemp, kCutoff, gkFilterRes*gkFilterCutoff
	;aR 			butterbp a1R + a2R, kCutoff, gkFilterRes*gkFilterCutoff
; Notch filter
elseif (gkFilterType == 3) then 
	aFiltered	butterbr aTemp, kCutoff, gkFilterRes*gkFilterCutoff
	;aR 			butterbr a1R + a2R, kCutoff, gkFilterRes*gkFilterCutoff
endif
