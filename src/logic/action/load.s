action.load.logics.v:

; load.logics.v(vA);
;   Loads logic vA into memory. You should do this if you are going to call it
;   a lot, to save the inrepter having to load it and unload it every time it
;   calls it.
;------------------------------------------------------------------------------

    jp logic.action.nyi

    ld a,(ix)
    inc ix

    ret

