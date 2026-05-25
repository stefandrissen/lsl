
util.keyboard.pause:

    push af
    push bc

   @wait.no_key:
    call @keyboard.read
    jr nz,@wait.no_key

   @wait.key:
    call @keyboard.read
    jr z,@wait.key

    pop bc
    pop af

    ret

@keyboard.read:

    xor a
    in a,(port.keyboard)
    and %00011111
    ld c,a

    xor a
    in a,(port.status)
    and %11100000
    or c

    xor 0xff

    ret
