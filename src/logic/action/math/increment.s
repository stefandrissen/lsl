
; increment(vA);

; If the value of vA is less than 255, then it is increased by 1.

logic.action.increment:

    ld h,vars.high
    ld l,(ix+0)

    ld a,(hl)
    cp 0xff
    jr z,@max

    inc (hl)

@max:
    inc ix

    ret
