; [name]        resource/load.s
; [function]    load resource

; *dir files are directories pointing to resource in vol.*
;
; documentation: http://wiki.scummvm.org/index.php/AGI/Specifications/Formats
;
; each entry is 3 bytes
; - first 4 bits indicate vol.#
; - next 20 bits are offset in vol.#
;
; VVVVPPPP PPPPPPPP PPPPPPPP
;
; when 0xffffff -> empty

resource.load:

; a  = resource
; ix = resource directory
;       - obj.logdir
;       - obj.viewdir
;       - obj.picdir
;       - obj.snddir
;-------------------------------------------------------------------------------

    ld l,a          ; l <- resource

    in a,(port.hmpr)
    ld (@store.hmpr+1),a

    ld a,page.boot
    out (port.hmpr),a

    ld a,(ix+obj.entries)
    cp l
    jr c,@err.invalid.resource

    ld h,0
    add hl,hl
    add hl,hl
    add hl,hl       ; * 8

    ld c,(ix+obj.ptr.dir+0)
    ld b,(ix+obj.ptr.dir+1)

    add hl,bc       ; hl = directory pointer

    ld c,(ix+obj.free+0)
    ld b,(ix+obj.free+1)

    ld a,(ix+obj.page)
    out (port.hmpr),a

    ld a,(hl)
    and %11110000
    rrca
    rrca
    rrca
    rrca
    cp 0x0f
    jp z,@err.empty.entry

    ld (@vol+1),a                   ; a = vol.#

    ld a,(hl)
    and %00001111                   ; a = 64k offset
    inc l
    ld d,(hl)
    inc l
    ld e,(hl)
    inc l

    ld (hl),c                       ; <- resource memory offset
    inc l
    ld (hl),b                       ; <- resource memory offset

@vol:
    ld b,0                          ; b = vol.#

    ex de,hl                        ; hl = offset

    push af
    ld a,page.boot
    out (port.hmpr),a
    pop af

    call @update.sp
    defb 0x80                       ; move sp to section C

    call boot.load.resource

    call @update.sp
    defb -0x80                      ; move sp back to section A

@store.hmpr:

    ld a,0
    out (port.hmpr),a

    ret

@err.invalid.resource:
    di
    halt

@err.empty.entry:
    di
    halt

@update.sp:
    include "../update.sp.s"
