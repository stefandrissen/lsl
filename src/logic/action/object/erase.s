; erase(oA);
;
; The erase command removes an object from the visual screen.

logic.action.erase:

    ld b,(ix)   ; oA

    ld hl,view.erase
    call section.call.object

    inc ix

    ret
