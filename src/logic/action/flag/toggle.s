; toggle(fA);

; If flag fA is set, then it is reset. Otherwise it is set.

logic.action.toggle:

    ld a,(ix)

@toggle.flag:

    call flag.isset

    ld a,(ix)
    inc ix

    jp z,flag.set

    jp flag.reset

;-------------------------------------------------------------------------------
; toggle.v(vA);

; If flag fB (where B is the value of vA) is set, then it is reset. Otherwise it
; is set.

logic.action.toggle.v:

    ld l,(ix)
    ld h,vars.high
    ld a,(hl)

    jr @toggle.flag
