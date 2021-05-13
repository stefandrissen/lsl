; observe.horizon(oA);

; Object oA is not allowed to go above the horizon.

logic.action.observe.horizon:

    ld b,(ix)

    ld hl,view.observe.horizon
    call section.call.object

    inc ix

    ret
