; section.i

;-------------------------------------------------------------------------------
; addresses which cannot be resolved at assembly time

main.flags:                 equ 0x0100
main.vars:                  equ 0x0200
    main.var.ego_direction:     equ 0x0206

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

    in a,(port.status)
    xor 0xff
    and interrupt.line | interrupt.frame

    push af
    ld a,page.snd
    out (port.hmpr),a
    pop af

    push af
    call nz,snd.interrupt.handler
    pop af

    and interrupt.frame
    jr z,@port.hmpr

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
