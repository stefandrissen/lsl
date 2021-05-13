; set.horizon(Y); TODO

; The horizon's vertical position is set to Y. The horizon is an invisible
; horizontal line, usually near the top of the screen. The default value for the
; horizon (when the new.room command is used) is 36. Objects are not allowed
; above the horizon, unless you use the ignore.horizon command.

logic.action.set.horizon:

if defined( strict )

    jp logic.action.nyi

else

    ld a,(ix)   ; Y
    inc ix

    ret

endif
