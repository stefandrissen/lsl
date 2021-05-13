; set(fA);

; Flag fA is set.

logic.action.set:

    ld a,(ix)

@set.flag:
    inc ix

    jp flag.set

;-------------------------------------------------------------------------------

; set.v(vA);

; Flag fB (where B is the value of vA) is set.

logic.action.set.v:

    ld l,(ix)
    ld h,vars.high
    ld a,(hl)

    jr @set.flag
