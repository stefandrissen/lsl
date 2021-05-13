
; program.control();

; Prevents the player from moving ego (object 0) around with the arrow keys.
; After this command has been executed, ego can only be moved by using the
; various object movement commands that are available such as move.obj. If ego
; is already moving, it continues in it's current direction.

; The player can be given control of ego again by using the player.control
; command.

logic.action.program.control:

if defined( strict )

    jp logic.action.nyi

else

    ; TODO

    ret


endif
