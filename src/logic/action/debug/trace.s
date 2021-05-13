
; trace.info(LOGNUM,TOP,HEIGHT); TODO

; Sets up trace mode. LOGNUM is the number of the logic containing trace
; commands. TOP and HEIGHT are the top line number of the trace window and the
; number of lines it takes up.

; This command should be used before trace mode is enabled or turned on.

logic.action.trace.info:

if defined( strict )

    jp logic.action.nyi

else

    ld a,(ix)   ; lognum
    inc ix
    ld a,(ix)   ; top
    inc ix
    ld a,(ix)   ; height
    inc ix

    ret

endif

;-------------------------------------------------------------------------------

; trace.on();

; Turns trace mode on. This does the same thing as the player pressing the SCROLL
; LOCK key.

; Trace mode must be enabled (by setting flag 10) before using this command.

logic.action.trace.on:

    jp logic.action.nyi
