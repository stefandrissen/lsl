; have.key
; True if the user has pressed any key on the keyboard. Used to create cycles
; to wait until any key is pressed.

logic.test.have.key:

if defined( strict )

    jp logic.test.invalid

else

    ld a,0

    ; TODO - maybe add quick hack to check port.keyboard?

    ret

endif

