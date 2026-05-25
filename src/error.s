;===============================================================================
error:

    call util.print.reset

    push hl

    call util.print.ix
    call util.print.colon
    ld a,(ix+0)
    call util.print.hex

    pop hl
    call util.print.string

    jp util.keyboard.pause
