
; set.cel(oA,B);

; The current cel of object oA is set to B. If an invalid cel number is given,
; the interpreter will generates an error (the number of the last cel in a loop
; can be determined using the last.cel command).

logic.action.set.cel:

    ld b,(ix)           ; oA
    ld c,(ix+1)         ; B

    ld hl,view.set.cel
    call section.call.object

    inc ix
    inc ix

    ret

;-------------------------------------------------------------------------------

; set.cel.v(oA,vB);

; The current cel of object oA is set to vB. If an invalid cel number is given,
; the interpreter will generates an error (the number of the last cel in a loop
; can be determined using the last.cel command).

logic.action.set.cel.v:

    jp logic.action.nyi
