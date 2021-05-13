; call(A);

; Logic A is executed once. If it is not already loaded into memory, it is
; loaded before being called and then unloaded again afterwards.

;-------------------------------------------------------------------------------

logic.action.call:

    ld a,(ix)       ; A

@call:

    inc ix
    push ix

    ld c,a

    ; check if already loaded

    ld de,ptr.logdir + 3
    ld l,a
    ld h,0
    add hl,hl   ; * 2
    add hl,hl   ; * 4
    add hl,hl   ; * 8
    add hl,de   ; <- ptr
    ld a,(hl)
    or a
    jr nz,@loaded
    inc hl
    ld a,(hl)
    or a
    jr nz,@loaded

    ld a,c
    push af

    call logic.load.script

    pop af
    ld c,a

@loaded:

    ld a,c
    push af

    call logic.execute

    pop af

    ; call z,discard TODO


    pop ix

    ret

;-------------------------------------------------------------------------------

; call.v(vA);

; Logic vA is executed once. If it is not already loaded into memory, it is
; loaded before being called and then unloaded again afterwards.

logic.action.call.v:

    ld h,vars.high
    ld l,(ix)       ; vA
    ld a,(hl)

    jr @call
