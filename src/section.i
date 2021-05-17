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

;-------------------------------------------------------------------------------
    defs 0x0038 - $
;-------------------------------------------------------------------------------
maskable.interrupt:

    push af

    in a,(port.hmpr)
    ld (@port.hmpr+1),a

    ld a,page.snd
    out (port.hmpr),a
    call snd.interrupt.handler

    ld a,page.main
    out (port.hmpr),a
maskable.interrupt.handler:
    call 0  ; set to main.update.frames by set.interrupt.handler

@port.hmpr:
    ld a,0
    out (port.hmpr),a

    pop af

    ei
    ret

;-------------------------------------------------------------------------------
    defs 0x0066 - $
;-------------------------------------------------------------------------------
non.maskable.interrupt:

    ret

;-------------------------------------------------------------------------------

    assert $ <= stack.top - stack.size

    align 0x100


