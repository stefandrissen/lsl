; display(ROW,COLUMN,mMESSAGE);

; Displays the text of message mMESSAGE at the specified row and column.
; - row    = 0 - 24 (200 pixels high)
; - column = 0 - 39 (320 pixels wide)

logic.action.display:

    ; this can be reused for debug?

    ; copy message to buffer
    ; page in screen
    ; print

    ld a,(ix+0)     ; row
    rlca
    rlca
    rlca            ; * 8
    ld (util.print.y),a

    ld a,(ix+1)     ; column
    ld (util.print.x),a

    ld a,(ix+2)     ; message
    call message.get.hl

    call util.print.string

    inc ix
    inc ix
    inc ix

    ret

;-------------------------------------------------------------------------------

; display.v(vROW,vCOLUMN,vMESSAGE);

; Displays the text of message number vMESSAGE at the location determined by the
; values of vROW and vCOLUMN.

logic.action.display.v:

    jp logic.action.nyi
