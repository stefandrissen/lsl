; script.size(n) TODO

; Sets the size of script table in bytes. Script table stores codes of some
; interpreter commands.
; It is needed by the interpreter to correctly reload resources when
; restore_game is executed.
;------------------------------------------------------------------------------

logic.action.script.size:

if defined( strict )

    jp logic.action.nyi

else

    inc ix    ; n

    ret

endif
