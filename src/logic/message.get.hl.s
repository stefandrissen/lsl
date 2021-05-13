message.get.hl:
; input
;   a = message [1-255]
;
; output
;   hl = address of message
;
; TODO
;   - handle all format variables
;   - handle |# number format correctly
;-------------------------------------------------------------------------------

    dec a
    ld hl,(var.messages)
    cp (hl)
    jp nc,@invalid.message

    inc a
    inc hl
    ld e,a
    ld d,0

    push hl

    add hl,de
    add hl,de

    ld e,(hl)
    inc hl
    ld d,(hl)

    pop hl

    add hl,de

    ; now parse the message
    ; %v# = variable
    ; %m# = message
    ; %g# = global message (in logic 0)
    ; %w# = word player entered
    ; %s# = string
    ; %o# = object

    ld de,@text.buffer
    ex de,hl
@main.loop:
    ld a,(de)
    inc de

    cp "%"
    jr z,@special

    ld (hl),a
    inc hl

    or a
    jr nz,@-main.loop

    ld hl,@text.buffer

    ret

@special:

    ld a,(de)
    inc de

    cp "v"
    jr z,@get.variable

    ; not yet handled

    ld (hl),"%"
    inc hl
    ld (hl),a
    inc hl

    jr @-main.loop

@get.variable:

    ld c,0
@loop:
    ld a,(de)
    cp "0"
    jr c,@nan
    cp "9" + 1
    jr nc,@nan

    inc de

    push af
    ld a,c
    add a,a ; * 2
    add a,a ; * 4
    add a,c ; * 5
    add a,a ; * 10
    ld c,a
    pop af

    sub "0"
    add a,c
    ld c,a

    jr @-loop

@nan:

    ld b,vars.high
    ld a,(bc)       ; now we have the variable value, back to decimal...

    ld c,a
    ld a,(de)
    cp "|"
    jr nz,@no.format
    inc de
    ld a,(de)
    inc de

    cp "2"          ; TODO format incomplete, just a quick hack to get rid of |2
    ld b,c
    jr z,@no100

@no.format:
    ld a,c

    ld c,-1
@100s:
    inc c
    sub 100
    jr nc,@100s
    add a,100

    ld b,a
    ld a,c
    or a
    jr z,@no100
    add "0"
    ld (hl),a
    inc hl
@no100:
    ld a,b
    ld c,-1
@10s:
    inc c
    sub 10
    jr nc,@10s
    add a,10

    ld b,a
    ld a,c
    add "0"
    ld (hl),a
    inc hl

    ld a,b
    add "0"
    ld (hl),a
    inc hl

    jr @-main.loop

@text.buffer:
    defs 0x40

@invalid.message:
    ld hl,@text.invalid.message
    jp error

@text.invalid.message:

    defm " INVALID MESSAGE: "
    defb 0
