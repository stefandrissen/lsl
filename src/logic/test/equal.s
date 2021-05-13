logic.test.equaln:

; equaln(n,m)
; True if Var(n) = m.

    ld h,vars.high
    ld l,(ix+0)
    ld a,(hl)
    cp (ix+1)
@equal:
    ld a,1
    jr z,@true
    ld a,0
@true:

    inc ix
    inc ix

    ret

;------------------------------------------------------------------------------

logic.test.equalv:

; equalv(n, m)
; True if Var(n) = Var(m)

    ld h,vars.high
    ld l,(ix+0)     ; n
    ld a,(hl)       ; vn
    ld l,(ix+1)     ; m
    cp (hl)         ; vm
    jr @equal
