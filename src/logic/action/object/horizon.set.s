; set.horizon(Y);

; The horizon's vertical position is set to Y. The horizon is an invisible
; horizontal line, usually near the top of the screen. The default value for the
; horizon (when the new.room command is used) is 36. Objects are not allowed
; above the horizon, unless you use the ignore.horizon command.

logic.action.set.horizon:

    ld a,(ix)   ; Y
    inc ix

    ld (internal.var.horizon),a

    ret
