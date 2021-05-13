
; set.loop(oA,B);

; The current loop of object oA is set to B. If an invalid loop number is given,
; the interpreter generates an error. If the current cel of the object is
; greater than the last cel in loop B, then the current cel is set to 0.

logic.action.set.loop:

    ld b,(ix)   ; oA
    ld c,(ix+1) ; B

    ld hl,view.set.loop
    call section.call.object

    inc ix
    inc ix

    ret

;-------------------------------------------------------------------------------

; set.loop.v(oA,vB);

; The current loop of object oA is set to vB. If an invalid loop number is
; given, the interpreter generates an error. If the current cel of the object is
; greater than the last cel in loop vB, then the current cel is set to 0.

logic.action.set.loop.v:

    jp logic.action.nyi
