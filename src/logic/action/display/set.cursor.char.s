; set.cursor.char(mCHAR); TODO

; The cursor character (the character displayed at the end of the player input
; line) is set to the first character of message mCHAR.

logic.action.set.cursor.char:

if defined( strict )

    jp logic.action.nyi

else

    inc ix

    ; (ix) = message #

    ret

endif
