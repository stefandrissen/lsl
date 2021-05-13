; observe.objs(oA);

; Object oA is prohibited from moving through other objects, i.e. it's baseline
; is not allowed to touch another object's baseline.

logic.action.observe.objs:

    ld b,(ix)   ; oA

    ld hl,view.observe.objs
    call section.call.object

    inc ix

    ret
