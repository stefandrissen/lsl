; ignore.objs(oA);

; Object oA is allowed to move through other objects, i.e. it's baseline is
; allowed to touch another object's baseline.

; If oA stops because it runs into another object, it will keep going once that
; object moves out of the way (provided it is not stopped or it's direction
; changed before then).

logic.action.ignore.objs:

    ld b,(ix)

    ld hl,view.ignore.objs
    call section.call.object

    inc ix

    ret
