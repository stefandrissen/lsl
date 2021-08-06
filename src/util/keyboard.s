
util.keyboard.pause:

    push af

@nokey:
    xor a
    in a,(254)
    and %00011111
    cp %00011111
    jr nz,@nokey

@anykey:
    xor a
    in a,(254)
    and %00011111
    cp %00011111
    jr z,@anykey

    pop af

    ret
