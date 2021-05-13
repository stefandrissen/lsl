; set.dir(oA,vDIR);

; The direction of object oA is changed to vDIR. vDIR must be between 0 and 8:

;   812
;   7 3
;   654

; You cannot set the direction of ego (object 0). Instead, change the value of
; v6 to the direction you want.

; To find out what direction an object is currently travelling in, use the
; get.dir command.

logic.action.set.dir:

    jp logic.action.nyi
