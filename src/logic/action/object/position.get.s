; get.posn(oA,vX,vY);

; vX and vY are set to the X and Y co-ordinates of object oA.; position(oA,X,Y);

logic.action.get.posn:

    ld b,(ix + 0)   ; oA

    ld hl,view.get.posn
    call section.call.object

    ld h,vars.high
    ld l,(ix + 1)   ; vX
    ld (hl),e       ; X

    ld l,(ix + 2)   ; vY
    ld (hl),d       ; Y

    inc ix
    inc ix
    inc ix

    ret
