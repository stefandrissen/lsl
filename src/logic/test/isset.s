; isset(n)
;    TRUE if fn is set.

;------------------------------------------------------------------------------
logic.test.isset:

    ld a,(ix+0)
@test.isset:

    call flag.isset

    ld a,0
    jr z,@false
    inc a
@false:

    inc ix

    ret

;------------------------------------------------------------------------------
logic.test.issetv:


    ld l,(ix+0)
    ld h,vars.high
    ld a,(hl)

    jr @test.isset

