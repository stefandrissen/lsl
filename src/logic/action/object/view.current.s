; current.view(oA,vB);

; vB is set to the number of the view currently assigned to object oA.

logic.action.current.view:

    ld b,(ix + 0)   ; oA

    ld hl,view.current.view
    call section.call.object

    ld h,vars.high
    ld l,(ix + 1)   ; vB
    ld (hl),c       ; B

    inc ix
    inc ix

    ret
