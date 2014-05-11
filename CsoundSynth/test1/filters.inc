

iFilterAttack	chnget "filterAttack"
iFilterDecay	chnget "filterDecay"
iFilterSustain	chnget "filterSustain"
iFilterRelease	chnget "filterRelease"

kFilterEnvelope expsegr 0.05, iFilterAttack, 1, iFilterDecay, iFilterSustain, iFilterRelease, 0.001
kCutoff 		= gkFilterCutoff*kFilterEnvelope

kPortTime		linseg	0, 0.001, 0.1
kFltrResWthPort	portk	gkFilterRes, kPortTime
kFltrCutoffPort	portk 	kCutoff, .01

; Lowpass filter
if (gkFilterType == 0) then 
	aFiltered	lpf18 aTempL, kFltrCutoffPort, gkFilterRes*.98, 0
	aFiltered	balance aFiltered, (aTempL)
	;aL 			moogladder a1L + a2L, kCutoff, kFltrResWthPort*.98, 5000000
	;aL 			butterlp a1L + a2L, kCutoff
;	aR 			moogladder a1R + a2R, kCutoff, kFltrResWthPort*.98
; Highpass filter
elseif (gkFilterType == 1) then
	aFiltered	butterhp aTempL, kCutoff
	;aR 			butterhp a1R + a2R, kCutoff
; Bandpass filter
elseif (gkFilterType == 2) then 
	aFiltered	butterbp aTempL, kCutoff, gkFilterRes*gkFilterCutoff
	;aR 			butterbp a1R + a2R, kCutoff, gkFilterRes*gkFilterCutoff
; Notch filter
elseif (gkFilterType == 3) then 
	aFiltered	butterbr aTempL, kCutoff, gkFilterRes*gkFilterCutoff
	;aR 			butterbr a1R + a2R, kCutoff, gkFilterRes*gkFilterCutoff
endif
