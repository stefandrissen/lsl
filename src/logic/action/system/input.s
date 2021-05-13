
; prevent.input(); TODO

; Hides the input prompt and prevents the player from entering input.

logic.action.prevent.input:

if defined( strict )

    jp logic.action.nyi

else

    ret

endif

;-------------------------------------------------------------------------------

; accept.input(); TODO

; Allows the player to enter input, if they have been prevented from doing so.
; If the input prompt is hidden, it is displayed again (including any text that
;  was on it).

logic.action.accept.input:

if defined( strict )

    jp logic.action.nyi

else

    ret

endif

