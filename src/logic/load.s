; [name]        logic/load.s
; [function]

; logic resource format
;
; https://wiki.scummvm.org/index.php?title=AGI/Specifications/Resources#LogicFormat
;
; Offset    Meaning
; ------    -------------------------------------------------------------------
; 0-1       Signature (0x12--0x34)
; 2         Vol number that the resource is contained in
; 3-4       Length of the resource without the header
; 5-6       Offset of logic code message section
; ------    -------------------------------------------------------------------

var.messages:    defw 0

;==============================================================================
logic.load.script:

; a = logic resource to load
; -----------------------------------------------------------------------------

    push hl
    push de
    push bc

    ld ix,obj.logdir
    call resource.load

    ; decrypt messages

    ; ld a,resource, ix,dir call get.resource.start

    ld a,page.boot
    out (port.hmpr),a

    ld hl,(obj.logdir + obj.last.start)
    inc hl      ; messages
    inc hl      ; messages
    ld (obj.logdir + obj.last.start),hl
    dec hl
    dec hl

    ld a,(obj.logdir + obj.page)
    out (port.hmpr),a

    ld c,(hl)    ; offset messages section
    inc hl
    ld b,(hl)    ; offset messages section
    inc hl

;    ld (var.resource.start),hl

    add hl,bc

    ld (var.messages),hl

; messages section
;
; Offset    Description
; ------    -------------------------------------------------------------------
; 0         number of messages
;
; 1-2       offset to the end of the messages
; 3-4       offset message 1 - from here
; ...       offset message 2 - from above

; ?         start of the text data.
;               from this point the messages are encrypted with Avis Durgan,
;               in their unencrypted form, each message is separated by 0x00
; ------    -------------------------------------------------------------------

    ld c,(hl)    ; # messages
    inc hl
    ld b,0

    ld e,(hl)
    inc hl
    ld d,(hl)    ; de = offset end
    inc hl

    ex de,hl
    xor a
    sbc hl,bc
    sbc hl,bc    ; hl = length text data
    ex de,hl

    add hl,bc
    add hl,bc    ; hl = start of text data

    ld c,e
    ld b,d

    push hl

    jr @decode.messages

@decode.key:
    defm "Avis Durgan"
    defb 0

@loop:
    ld a,(de)
    or a
    jr nz,@key.ok

@decode.messages:
    ld de,@decode.key
    ld a,(de)

@key.ok:
    xor (hl)
    ld (hl),a

    inc hl
    inc de

    dec bc
    ld a,b
    or c
    jr nz,@loop

    pop hl

    if defined(debugx)
        call util.print.string
        call util.print.lf
    endif

    pop bc
    pop de
    pop hl
    ret
