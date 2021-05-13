; load.pic(vA); TODO store picture refs

; Picture resource vA is loaded into memory.

logic.action.load.pic:

    ld a,(ix)
    inc ix

    push ix

    ld h,vars.high
    ld l,a
    ld a,(hl)

    ld ix,obj.picdir
    call resource.load

    pop ix

    ret
