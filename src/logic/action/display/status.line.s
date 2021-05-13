; status line

; The status line is usually on the top line of the screen (although this can be
; changed with configure.screen), and displays the  current score and sound
; on/off status.

;-------------------------------------------------------------------------------

; status.line.on(); TODO

; Turns the status line on.

logic.action.status.line.on:

if defined( strict )

    jp logic.action.nyi

else

    ret

endif

;-------------------------------------------------------------------------------

; status.line.off(); TODO

; Turns the status line off. When it is turned off, the line is blank.

logic.action.status.line.off:

if defined( strict )

    jp logic.action.nyi

else

    ret

endif
