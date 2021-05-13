; show.pic();

; The visual screen held in memory is updated on the actual screen.

logic.action.show.pic:

if defined( strict )

    jp logic.action.nyi

else

    ; TODO use two screen buffers

    ret

endif
