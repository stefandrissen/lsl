; addn(n,m),addv(n,m)
;   The value of variable vn is incremented by m (vm), i.e. vn = vn + m (vm).

logic.action.addn:
;------------------------------------------------------------------------------

    ld h,vars.high
    ld l,(ix+0)

    ld a,(ix+1)
    add a,(hl)
    ld (hl),a

    inc ix
    inc ix

    ret

logic.action.addv:
;------------------------------------------------------------------------------

    ld h,vars.high
    ld l,(ix+1)
    ld a,(hl)
    ld l,(ix+0)
    add a,(hl)
    ld (hl),a

    inc ix
    inc ix

    ret
