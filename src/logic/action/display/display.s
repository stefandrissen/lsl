; display(ROW,COLUMN,mMESSAGE);

; Displays the text of message mMESSAGE at the specified row and column.
; - row    = 0 - 24 (200 pixels high)
; - column = 0 - 39 (320 pixels wide)

logic.action.display:

    ld a,(ix+2)     ; message
    call message.get.hl

    push hl

    call @print

    pop hl

    in a,(port.vmpr)
    push af
    xor page.screen.2 - page.screen.1
    out (port.vmpr),a

    call @print

    pop af
    out (port.vmpr),a

    inc ix
    inc ix
    inc ix

    ret

    ; copy message to buffer
    ; page in screen
    ; print

@print:
    ld a,(ix+0)     ; row
    or a
    jr z,@top
    dec a           ; row = 0-24, SAM = 0-23, intro displays text on bottom row
@top:
    ld (util.print.y),a

    ld a,(ix+1)     ; column
    ld (util.print.x),a

    call util.print.string

    ret

;-------------------------------------------------------------------------------

; display.v(vROW,vCOLUMN,vMESSAGE);

; Displays the text of message number vMESSAGE at the location determined by the
; values of vROW and vCOLUMN.

logic.action.display.v:

    jp logic.action.nyi
