; section.i

;===============================================================================
section.call.pic:
;   change bank AB to pic - identical code in bank pic
;-------------------------------------------------------------------------------

    in a,(port.hmpr)
    push af

    ld a,page.pic | low.memory.ram.0
    out (port.lmpr),a

    ld (@call+1),hl
@call:
    call 0

    jr @return

;===============================================================================
section.call.view:
;   change bank AB to view - identical code in bank view
;-------------------------------------------------------------------------------

    in a,(port.hmpr)
    push af

    ld a,page.view | low.memory.ram.0
    out (port.lmpr),a

    ld (@call+1),ix
@call:
    call 0

    jr @return

;===============================================================================
section.call.object:
;   change bank AB to view - identical code in bank view
;
; input
;   b  = object
;   hl = routine
;-------------------------------------------------------------------------------

    in a,(port.hmpr)
    push af

    ld a,page.view | low.memory.ram.0
    out (port.lmpr),a

    call view.object.call

;-------------------------------------------------------------------------------

@return:
    ld a,page.main | low.memory.ram.0
    out (port.lmpr),a

    pop af
    out (port.hmpr),a

    ret
