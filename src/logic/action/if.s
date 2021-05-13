logic.action.if:
;
;   if nothing between two tests, then and (&&)
;------------------------------------------------------------------------------

    ld b,0                  ; not
    ld c,1                  ; result - initially true

@if.loop:
    ld a,(ix)
    inc ix

    cp 0xfd             ; not
    jr nz,@not.not

    ld b,1
    jr @if.loop

@not.not:

    cp 0xfc             ; or
    jr z,@or

    push bc
    call logic.call.test    ; -> a = 0/1
    pop bc

@or.return:

    xor b               ; 1 = not
    and c
    ld c,a
    ld b,0

    ld a,(ix)
    cp 0xff             ; end of if

    jr nz,@if.loop

    inc ix
    ld e,(ix+0)     ; \ offset to end of if
    ld d,(ix+1)     ; /

    inc ix
    inc ix

    ld a,c
    or a

    ret nz              ; if true -> continue in command mode

    add ix,de           ; skip true commands

    ret

@or:
    ld a,c
    push af
    ld c,0

@or.loop:

    ld a,(ix)
    inc ix

    cp 0xfd             ; not
    jr nz,@not.not

    ld b,1
    jr @or.loop

@not.not:

    push bc
    call logic.call.test    ; -> a = 0 / 1
    pop bc

    xor b               ; 1 = not
    or c
    ld c,a
    ld b,0

    ld a,(ix)
    cp 0xfc     ; or

    jr nz,@or.loop

    inc ix

    pop af

    jr @or.return

