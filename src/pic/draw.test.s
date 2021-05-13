; draw.test.s
;
; code that was initially in draw.s when getting it working
;

@var.port.low: defb 0

if defined( test-draw )

        org 0x8000
        dump 1,0

        autoexec

        di
        ld (@sp+1),sp
        ld sp,0
        call draw.pic
        call @exit
    @sp:
        ld sp,0
        ei
        ret

    var.resource.start: defw @draw.test

    @draw.command.picture.color:    equ 0xf0
    @draw.command.picture.off:      equ 0xf1
    @draw.command.priority.color:   equ 0xf2
    @draw.command.priority.off:     equ 0xf3
    @draw.command.y.corner:         equ 0xf4
    @draw.command.x.corner:         equ 0xf5
    @draw.command.absolute.line:    equ 0xf6
    @draw.command.relative.line:    equ 0xf7
    @draw.command.fill:             equ 0xf8
    @draw.command.exit:             equ 0xff

    if defined(draw-line-test)

        @draw.test:
            defb @draw.command.picture.color, 15
            defb @draw.command.absolute.line, 128, 96, 128     , 96 - 64    ; N
            defb @draw.command.absolute.line, 128, 96, 128 + 20, 96 - 40    ; NNE
            defb @draw.command.absolute.line, 128, 96, 128 + 48, 96 - 48    ; NE
            defb @draw.command.absolute.line, 128, 96, 128 + 40, 96 - 20    ; ENE
            defb @draw.command.absolute.line, 128, 96, 128 + 64, 96         ; E
            defb @draw.command.absolute.line, 128, 96, 128 + 40, 96 + 20    ; ESE
            defb @draw.command.absolute.line, 128, 96, 128 + 48, 96 + 48    ; SE
            defb @draw.command.absolute.line, 128, 96, 128 + 20, 96 + 40    ; SSE
            defb @draw.command.absolute.line, 128, 96, 128     , 96 + 64    ; S
            defb @draw.command.absolute.line, 128, 96, 128 - 20, 96 + 40    ; SSW
            defb @draw.command.absolute.line, 128, 96, 128 - 48, 96 + 48    ; SW
            defb @draw.command.absolute.line, 128, 96, 128 - 40, 96 + 20    ; WSW
            defb @draw.command.absolute.line, 128, 96, 128 - 64, 96         ; W
            defb @draw.command.absolute.line, 128, 96, 128 - 40, 96 - 20    ; WNW
            defb @draw.command.absolute.line, 128, 96, 128 - 48, 96 - 48    ; NW
            defb @draw.command.absolute.line, 128, 96, 128 - 20, 96 - 40    ; NWN
            defb @draw.command.exit

    endif

    if defined(draw-fill-test)

        @draw.test:
            defb @draw.command.picture.color, 1
            defb @draw.command.absolute.line, 32, 32, 32, 48, 48, 48, 48, 32, 32, 32
            defb @draw.command.picture.color, 3
            defb @draw.command.fill, 40, 40
            defb @draw.command.exit

    endif

    @draw.test:

    color: equ for 8
        defb @draw.command.picture.color, color
        defb @draw.command.absolute.line, 20 * color , 0, 20 * color, 20, 20 * ( color + 1 ) - 1, 20, 20 * ( color + 1 ) - 1, 0, 20 * color, 0
        defb @draw.command.fill, ( 20 * color ) + 1, 1
    next color

    color: equ for 7
        defb @draw.command.picture.color, color + 8
        defb @draw.command.absolute.line, 20 * color , 20, 20 * color, 40, 20 * ( color + 1 ) - 1, 40, 20 * ( color + 1 ) - 1, 20, 20 * color, 20
        defb @draw.command.fill, ( 20 * color ) + 1, 21
    next color

        defb @draw.command.exit


    if not defined( print.s )
        print.s:    include "util/print.s"
    endif
    include "util/keyboard.s"
    include "util/ports.s"

endif

; for sam basic
;    ld hl,@palette
;    ld de,0x55d8
;    ld bc,16
;    ldir
;    inc de
;    inc de
;    inc de
;    inc de
;    ld hl,@palette
;    ld bc,16
;    ldir

;    in a,(port.lmpr)
;    ld (@var.port.low), a
;    in a,(port.vmpr)
;    and %00011111
;    or  %00100000  ; ram in AB
;    out (port.lmpr), a

    call pic.draw

;    ld a,(@var.port.low)
;    out (port.lmpr),a

    ret
