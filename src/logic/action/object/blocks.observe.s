; observe.blocks(oA);

; Object oA is prevented from crossing over conditional barriers (pixels set to
; color 1 on the priority screen) and borders of blocks set up with the block
; command.

logic.action.observe.blocks:

    ld b,(ix)

    ld hl,view.observe.blocks
    call section.call.object

    inc ix

    ret
