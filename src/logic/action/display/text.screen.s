; text.screen();

; Switches the interpreter to text mode (40x25). This should only be used to
; display text on screen, and not to use menus, print statements, receive
; commands from the player or manipulate graphics as it does not have proper
; support for these things. It is handy for displaying text on a blank screen
; because you do not lose the graphics screen when you use it.

; Once you have finished in text mode, you should use the graphics command to
; switch back.

logic.action.text.screen:

    jp logic.action.nyi
