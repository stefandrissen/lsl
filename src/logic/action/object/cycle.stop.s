; stop.cycling(oA);

; This tells the interpreter to stop cycling object oA. To turn cycling back on,
; use the start.cycling command.

logic.action.stop.cycling:

    ld b,(ix)   ; oA

    ld hl,view.stop.cycling
    call section.call.object

    inc ix

    ret
