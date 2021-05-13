;===============================================================================
error:

    push hl
    call util.print.ix
    pop hl
    call util.print.string

    ld a,(ix+0)
    call util.print.hex

    call util.print.lf

    jp util.keyboard.pause
