; has(itm iA)

; The has command returns TRUE if the specified inventory item is in the player's inventory (i.e. the item's room number equals 255).
logic.test.has:

    ld h,object.locations.high
    ld l,(ix+0)
    inc ix

    ld a,(hl)
    cp 0xff
    jr z,@true

    xor a   ; false
    ret

@true:
    inc a
    ret
