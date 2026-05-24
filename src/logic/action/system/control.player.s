
; player.control();

; Allows the player to move ego (object 0) around with the arrow keys, after
; they have been prevented from doing so by the program.control command.

logic.action.player.control:

    ld a,enum.control.player
    ld (internal.var.control),a

    ret
