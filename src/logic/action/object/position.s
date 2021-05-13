; position(oA,X,Y);

; The position on the screen of object oA is changed to X,Y. The position
; command should only be used if the object is not on screen (either it has not
; been drawn yet, or it has been erased). To change the position of an object
; that is already on screen, use the resposition.to command.

logic.action.position:

    ld e,(ix+1)
    ld d,(ix+2)

@position:

    ld b,(ix)

    ld hl,view.position
    call section.call.object

    inc ix
    inc ix
    inc ix

    ret

;------------------------------------------------------------------------------

logic.action.position.v:

    ld h,vars.high
    ld l,(ix+1)
    ld e,(hl)

    ld l,(ix+2)
    ld d,(hl)

    jr @position
