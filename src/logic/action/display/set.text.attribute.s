; set.text.attribute(FG,BG); TODO

; Sets the foreground and background colors for display and display.v. The
; background color can only be black (if BG is 0) or white (if BG is greater
; than 0). If the background is white, all text will be displayed with a black
; foreground. Otherwise, the text will be displayed with the foreground
; specified by FG (0-15).

logic.action.set.text.attribute:

if defined( strict )

    jp logic.action.nyi

else

    ld a,(ix)   ; fg
    inc ix
    ld a,(ix)   ; bg
    inc ix

    ret

endif
