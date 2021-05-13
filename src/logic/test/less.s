; lessn(vA,B)

; Returns true if vA is less than B.

logic.test.lessn:

    ld h,vars.high
    ld l,(ix+0)     ; n
    ld a,(hl)       ; vn
    cp (ix+1)       ; m

    ld a,0
    jr z,@false
    jr nc,@true
@false:
    ld a,1
@true:

    inc ix
    inc ix

    ret

;------------------------------------------------------------------------------

logic.test.lessv:

    jp logic.test.invalid
