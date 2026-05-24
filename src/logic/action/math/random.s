
; random(A,B,vC);

; The value of vC is set to a random number between A and B. If A is greater
; than B, then the number chosen is in the 0-255 range.

logic.action.random:

    ld b,(ix)
    inc ix
    ld a,(ix)
    ld c,a
    inc ix

    cp b
    jr nc,@ok

    ld b,0
    ld c,0xff

 @ok:

    ld a,r
    add a,b
    cp c
    jr nc,@-ok

    ld h,vars.high
    ld l,(ix)
    inc ix

    ld (hl),a

    ret
