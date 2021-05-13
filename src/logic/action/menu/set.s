
; set.menu(n) TODO

; Message n is used as the header of the menu elements which follow.

logic.action.set.menu:

if defined( strict )

    jp logic.action.nyi

else

    inc ix    ; n

    ret

endif
