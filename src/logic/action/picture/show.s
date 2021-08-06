; show.pic();

; The visual screen held in memory is updated on the actual screen.

logic.action.show.pic:

    ld a,page.screen.1
    call @copy.screen.draw

    ; show debug I
    ld a,0x0f
    ld (0x8000),a
    ld (0x8080),a
    ld (0x8100),a

    ld a,page.screen.2
    call @copy.screen.draw

    ; show debug II
    ld a,0x0f
    ld (0x8000),a
    ld (0x8080),a
    ld (0x8100),a
    ld (0x8001),a
    ld (0x8081),a
    ld (0x8101),a

    ld a,page.log
    out (port.hmpr),a

    ret

;===============================================================================
@copy.screen.draw:
; copy screen from page.screen.draw to page in a
; input
;   - a = page to copy to
;-------------------------------------------------------------------------------

    call @reset.background.pointers

    ex af,af'
    ld a,page.screen.draw

    ld hl,ptr.screen

    ld b,0x18

    assert 0x18 * buffer.size == ( 192 * 256 / 2 )

@loop:
    push bc

    out (port.hmpr),a

    ld de,buffer
    ld bc,buffer.size
    ldir

    ex af,af'
    out (port.hmpr),a
    ex af,af'

    ld bc,buffer.size
    or a
    sbc hl,bc
    ex de,hl

    ld hl,buffer
    ldir

    ex de,hl

    pop bc

    djnz @-loop

    ret

;-------------------------------------------------------------------------------
@reset.background.pointers:

    out (port.hmpr),a

    ld hl,ptr.background
    ld (var.ptr.background),hl

    ld hl,lst.background
    ld c,0
    ld b,objects.max * 2
@loop:
    ld (hl),c
    inc l
    djnz @-loop

    ret

;-------------------------------------------------------------------------------

buffer:
    defs 0x0400                 ; TODO move out to generic heap
buffer.size: equ $ - buffer
