; load.logics(A);

; Loads logic A is into memory. You should do this if you are going to call it a
; lot, to save the interpreter having to load it and unload it every time it
; calls it.

logic.action.load.logics:

    ld a,(ix)
@load.logics:
    inc ix

    jp logic.load.script

;------------------------------------------------------------------------------

; load.logics.v(vA);

logic.action.load.logics.v:

    ld h,vars.high
    ld l,(ix)
    ld a,(hl)

    jr @-load.logics
