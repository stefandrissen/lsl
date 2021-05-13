; start.cycling(oA);

; This tells the interpreter to start cycling object oA. If the object was
; previously cycling in reverse order before it was stopped, then it will
; continue to cycle in reverse order. Otherwise, it will cycle in normal order.
; To turn cycling off, use the stop.cycling command.

logic.action.start.cycling:

    ld b,(ix)   ; oA

    ld hl,view.start.cycling
    call section.call.object

    inc ix

    ret
