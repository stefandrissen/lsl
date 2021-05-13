
; assignn(vA,B);

; The value of vA is set to B.

logic.action.assignn:

    ld l,(ix+0)
    ld h,vars.high

    ld a,(ix+1)

    ld (hl),a

    inc ix
    inc ix

    ret

;-------------------------------------------------------------------------------

; assignv(vA,vB);

; The value of vA is set to the value of vB.

logic.action.assignv:

    ld l,(ix+1)
    ld h,vars.high
    ld a,(hl)
    ld l,(ix+0)
    ld (hl),a

    inc ix
    inc ix

    ret
