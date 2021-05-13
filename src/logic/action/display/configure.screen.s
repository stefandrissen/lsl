; configure.screen(PLAYTOP,INPUTLINE,STATUSLINE); TODO

; Sets the location of certain items on screen:

; PLAYTOP is the top line of the playing area. This is normally set to 1. It
; should always be set to something between 0 and 3, since the playing area is
; 168 pixels high (21 lines) and should not go off the screen.

; INPUTLINE is the line on which the player is prompted for input. This is
; normally set to 22.

; STATUSLINE is the line on which the current score and sound on/off status are
; displayed. This is normally set to 0.

; Note that the menu always appears on line 0.

logic.action.configure.screen:

if defined( strict )

    jp logic.action.nyi

else

    ld a,(ix+0)     ; playtop
    ld a,(ix+1)     ; inputline
    ld a,(ix+2)     ; statusline

    inc ix
    inc ix
    inc ix

    ret

endif
