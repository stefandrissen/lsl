
; set.menu.item(mNAME,cA); TODO

; Adds an item with the name mNAME to the menu previously created using the
; set.menu command. The item is assigned to controller cA, so when the user
; selects it from the menu the test command controller(cA) will be true.

logic.action.set.menu.item:

if defined( strict )

    jp logic.action.nyi

else

    inc ix    ; n
    inc ix    ; c

    ret

endif

;-------------------------------------------------------------------------------

; enable.item(cA);

; Enables the menu item that is assigned to controller cA.

; All menu items are enabled again whenever the game is restarted.

logic.action.enable.item:

    jp logic.action.nyi

;-------------------------------------------------------------------------------

; disable.item(cA); TODO

; Disables the menu item that is assigned to controller cA.

; All menu items are enabled again when the game is restarted, so if there are
; any items that need to be disabled permenantly (such as seperators) then they
; should be disabled again when the game is restarted.

logic.action.disable.item:

if defined( strict )

    jp logic.action.nyi

else

    ld a,(ix)       ; controller
    inc ix
    ret

endif
