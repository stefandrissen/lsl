;===============================================================================
@update.sp:
;   add byte following call as high byte to sp
;-------------------------------------------------------------------------------

    ld (@hl+1),hl
    pop hl
    ld (@ret+1),hl
    ld h,(hl)
    ld l,0

    add hl,sp
    ld sp,hl
@ret:
    ld hl,0
    inc hl
    push hl
@hl:
    ld hl,0

    ret
