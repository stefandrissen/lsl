
; decrement(vA);

; If the value of vA is greater than 0, then it is decreased by 1.

logic.action.decrement:

    ld h,vars.high
    ld l,(ix+0)

    ld a,(hl)
    or a
    jr z,@zero

    dec (hl)

@zero:
    inc ix

    ret
