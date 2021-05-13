; greatern(n,m)
;     TRUE if vn > m.

logic.test.greatern:

    ld h,vars.high
    ld l,(ix+0)     ; n
    ld a,(hl)       ; vn
    cp (ix+1)       ; m

    ld a,1
    jr z,@false
    jr nc,@true
@false:
    ld a,0
@true:

    inc ix
    inc ix

    ret

;------------------------------------------------------------------------------
logic.test.greaterv:

    jp logic.test.invalid

