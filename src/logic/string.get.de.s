
string.get.de:

; a = string

    ld l,a
    ld h,0
    add hl,hl   ; * 2
    add hl,hl   ; * 4
    add hl,hl   ; * 8
    ld e,l
    ld d,h
    add hl,hl   ; * 16
    add hl,hl   ; * 32

    add hl,de   ; * 40
    ld de,strings
    add hl,de   ; -> hl = string pointer
    ex de,hl

    ret
