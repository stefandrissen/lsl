; print functions
; completely unoptimized stuff for now

util.print.x:   defb 0  ; column [0-31]
util.print.y:   defb 0  ; row    [0-23]

util.print.reset:

    push af
    xor a
    ld (util.print.x),a
    ld (util.print.y),a
    pop af
    ret

util.print.string:

    push af
    push hl
    ld a,(hl)

@util.print.string.all:

    call util.print.char
    inc hl
    ld a,(hl)
    cp 0
    jr nz,@util.print.string.all
    pop hl
    pop af
    ret

util.print.bc:

    push hl
    ld h,b
    ld l,c
    jr @util.print.rr

util.print.de:

    push hl
    ld h,d
    ld l,e
@util.print.rr:
    call util.print.hl
    pop hl
    ret

util.print.ix:

    push ix
    pop hl

util.print.hl:

    ld a,h
    or l
    jr z,util.print.dash

    ld a,h
    call util.print.hex
    ld a,l
    jr util.print.hex

util.print.dash:
    ld hl,util.text.dash
    jr util.print.string

util.print.hex:

    push af
    rrca
    rrca
    rrca
    rrca
    call util.print.hex.nibble
    pop af
    push af
    call util.print.hex.nibble
    pop af
    ret

util.print.hex.nibble:

    and %00001111
    sub 10
    jr c,util.print.hex.nibble.1
    add a,"A"
    jr util.print.char
util.print.hex.nibble.1:
    add a,10 + "0"
    jr util.print.char

util.print.space:
    ld a," "
    jr util.print.char

util.print.lf:

    ld a,chr_linefeed

util.print.char:

    push hl
    push de
    push bc
    push af

    cp " "
    jr nc,util.print.normal

    ;control codes

    cp chr_linefeed
    jr z,util.print.linefeed
    jp @exit

util.print.normal:

    ld l,a

    in a,(port.hmpr)
    ld (util.print.char.high + 1),a
    in a,(port.vmpr)
    and high.memory.page.mask
    out (port.hmpr),a

    ld a,(util.print.x)
    ld e,a
    add a,a
    add a,e     ; x * 3 (1 byte = 2 pixels)
    ld e,a
    ld a,(util.print.y)
    add a,a
    add a,a     ; y * 4 (128 bytes per row)
    ld d,a

assert ptr.screen == 0x8000
    set 7,d

    push de     ; screen address

    ld a,l
    sub 32
    ld hl,util.print.font.table
    ld e,a
    ld d,0
    add hl,de
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    pop hl      ; screen address
    ld b,8
@loop:
        ld a,(de)
        ld (hl),a
        inc l
        inc de
        ld a,(de)
        ld (hl),a
        inc l
        inc de
        ld a,(de)
        ld (hl),a
        inc de
        ld a,0x80 - 2
        add a,l
        ld l,a
        jr nc,@char.ok
        inc h
@char.ok:
    djnz @-loop

util.print.char.high:
    ld a,0
    out (port.hmpr),a

    ld a,(util.print.x)
    inc a
    cp 42
    jr c,@x.ok
util.print.linefeed:
    ld a,(util.print.y)
    inc a
    cp 24
    jr c,@y.ok

    call util.keyboard.pause

    ;scroll up one line
    in a,(port.hmpr)
    ld (util.print.char.high2 + 1),a
    in a,(port.vmpr)
    and high.memory.page.mask
    out (port.hmpr),a
    ld hl,ptr.screen + ( 8 * 128 )
    ld de,ptr.screen
    ld bc,8 * 128 * 23
    ldir
    ld h,d
    ld l,e
    inc e
    ld (hl),0
    ld bc,8 * 128 - 1
    ldir
util.print.char.high2:
    ld a,0
    out (port.hmpr),a
    ld a,23

@y.ok:
    ld (util.print.y),a
    ld a,0
@x.ok:
    ld (util.print.x),a

@exit:
    pop af
    pop bc
    pop de
    pop hl
    ret

util.print.font.table:
    include "font.i"

util.text.dash:
    defm "----"
    defb 0

chr_linefeed: equ 10


