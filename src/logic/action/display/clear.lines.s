; clear.lines(TOP,BOTTOM,COLOR); TODO

; Clears the lines from TOP to BOTTOM with the color COLOR. I have found that it
; will only use black (if COLOR is 0) or white (if COLOR is greater than 0).

logic.action.clear.lines:

if defined( strict )

    jp logic.action.nyi

else

    ld a,(ix+0)     ; top
    ld a,(ix+1)     ; bottom
    ld a,(ix+2)     ; color

    inc ix
    inc ix
    inc ix

    ret

endif
