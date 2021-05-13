; set.string(sA,mB);

; Sets string sA to message mB.

; gbagi:    Copies the contents of mSrc to sDest. If the message is longer than
;           40 bytes, only the first 40 bytes or copied.

logic.action.set.string:

    ld a,(ix)
    inc ix
    call string.get.de
    ld a,(ix)
    inc ix
    push de
    call message.get.hl
    pop de

    ld b,40
@loop:
    ld a,(hl)
    ld (de),a
    or a
    ret z
    inc hl
    inc de
    djnz @loop

    ld hl,@text.message.too.long
    ld a,(ix-1)
    jp error

@text.message.too.long:

    defm " MESSAGE TOO LONG: "
    defb 0



