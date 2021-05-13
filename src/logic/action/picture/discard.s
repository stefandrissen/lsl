; discard.pic(vA); TODO

; Picture resource vA is discarded from memory. If the picture is not already
; loaded, the interpreter generates an error.

logic.action.discard.pic:

if defined( strict )

    jp logic.action.nyi

else

    ld h,vars.high
    ld l,(ix)
    inc ix

    ld a,(hl)

    ; TODO

    ret

endif
