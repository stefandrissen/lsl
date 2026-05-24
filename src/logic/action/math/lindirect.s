
; lindirectn(vA,B);

; The value of vC (where C is the value of vA) is set to B.

logic.action.lindirectn:

    ld h,vars.high
    ld l,(ix+0)     ; vA
    ld a,(ix+1)     ; B

    ld l,(hl)       ; vC
    ld (hl),a

    inc ix
    inc ix

    ret

;-------------------------------------------------------------------------------

; lindirectv(vA,vB);

; The value of vC (where C is the value of vA) is set to vB.

logic.action.lindirectv:

    ld h,vars.high
    ld l,(ix+1)     ; vB
    ld a,(hl)

    ld l,(ix+0)     ; vA
    ld (hl),a

    inc ix
    inc ix

    ret