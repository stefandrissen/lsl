logic.test.controller:
;
; if (controller(cA)) { .....
;
; Returns true if the menu item or key assigned to controller cA has been
; selected or pressed during the current cycle.

if defined( strict )

    jp logic.test.invalid

else

    ld a,(ix)

    ; TODO

    ld a,0

    inc ix
    ret

endif


