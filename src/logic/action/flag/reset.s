; reset(fA);

; Flag fA is reset.

logic.action.reset:

    ld a,(ix)

@reset.flag:
    inc ix

    jp flag.reset

;-------------------------------------------------------------------------------

; reset.v(vA);

; Flag fB (where B is the value of vA) is reset.

logic.action.reset.v:

    ld l,(ix)
    ld h,vars.high
    ld a,(hl)

    jr @reset.flag
