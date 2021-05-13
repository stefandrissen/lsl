; draw.pic(vA); TODO move pic.draw in here and draw actual pic

; Picture vA is drawn. Only the visual and priority screens in memory updated -
; not the actual screen itself. To update the screen, use the show.pic command.
; Make sure the picture is loaded into memory before drawing it.

logic.action.draw.pic:

    ld h,vars.high
    ld l,(ix)
    inc ix

    ld c,(hl)

    push ix

    ld hl,pic.draw
    call section.call.pic

    pop ix

    ret

