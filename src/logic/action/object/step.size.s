; step.size(oA,vB);

; The step size of oA (the number of pixels it moves each step) is set to vB.

logic.action.step.size:

    ld b,(ix)   ; oA

    ld h,vars.high
    ld l,(ix+1) ; vB
    ld c,(hl)   ; B

    ld hl,view.step.size
    call section.call.object

    inc ix
    inc ix

    ret
