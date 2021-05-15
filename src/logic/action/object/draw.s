; draw(oA);

; Object oA is drawn on screen.

logic.action.draw:

    ld b,(ix+0) ; oA

    ld hl,view.draw
    call section.call.object

    inc ix

    ret
