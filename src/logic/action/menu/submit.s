
; submit.menu() TODO

; Initializes the menus set up with the set.menu and set.menu.item commands,
; allowing them to be used. This command can only be used once, and after that
; the menus cannot be changed.

logic.action.submit.menu:

if defined( strict )

    jp logic.action.nyi

else

    ret

endif
