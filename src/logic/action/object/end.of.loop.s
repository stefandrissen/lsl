; end.of.loop(oA,fB);

; Object oA is cycled in normal order until the last cel in the loop is reached.
; Flag fB is reset when the command is issued, and when the last cel is
; displayed fB is set.

logic.action.end.of.loop:

if defined( strict )

    jp logic.action.nyi

else

    ld b,(ix)   ; oA
    inc ix

    ld a,(ix)   ; fB
    call flag.reset

    ld c,(ix)   ; fB
    ld hl,view.end.of.loop
    call section.call.object

    inc ix

    ret

endif