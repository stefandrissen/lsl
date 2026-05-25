
util.keyboard.pause:

    push af

 @nokey:
    xor a
    in a,(port.keyboard)
    and %00011111
    cp %00011111
    jr nz,@nokey

 @anykey:
    xor a
    in a,(port.keyboard)
    and %00011111
    cp %00011111
    jr z,@anykey

    pop af

    ret

util.keyboard.pause.esc:

    push af

    ld a,keyboard.caps_tab_esc
    in a,(port.status)
    bit 5,a
    call z,debug.disable
    call nz,util.keyboard.pause

    pop af

    ret