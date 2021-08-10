; release.loop(oA);

; This enables the interpreter to choose the loop number of an object based on it's direction.

logic.action.release.loop:

    ld b,(ix)   ; oA

    ld hl,view.release.loop
    call section.call.object

    inc ix

    ret
