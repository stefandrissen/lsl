
; menu.input();

; This brings up the menu at the end of the current interpreter cycle. The next
; cycle does not start until the user has selected an item from the menu, or
; pressed ESC to exit the menu.

; Flag 14 (or menu_enabled in the template game) must be set for this command to
; work.

; ESC is usually the key that activates the menu, but this is not built in to
; the interpreter so do do this you need assign the ESC key to a controller
; using set.key, and then test for that controller to activate the menu (this is
; already done in the template game).

logic.action.menu.input:

    jp logic.action.nyi

