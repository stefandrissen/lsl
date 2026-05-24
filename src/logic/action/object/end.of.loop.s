; end.of.loop(oA,fB);

; Object oA is cycled in normal order until the last cel in the loop is reached.
; Flag fB is reset when the command is issued, and when the last cel is
; displayed fB is set.

logic.action.end.of.loop:

if defined( strict )

    jp logic.action.nyi

else

    ld a,(ix)   ; oA
    inc ix
    ld b,(ix)   ; fB
    inc ix

    ret

endif