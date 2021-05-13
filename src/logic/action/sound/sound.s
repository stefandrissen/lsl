; sound(SOUNDNO,fDONEFLAG); TODO

; Sound SOUNDNO is played. fDONEFLAG is reset when the command is issued, and
; set when the sound finishes playing or is stopped with the stop.sound command.

; The sound must be loaded before it is played. This can be done with the
; load.sound command.

logic.action.sound:

if defined( strict )

    jp logic.action.nyi

else

    ld a,(ix)   ; soundno

    ld h,sounds.high
    ld l,a

    ld a,(ix+1) ; doneflag
    ld (hl),a

    call flag.reset

    inc ix
    inc ix

    ret

endif
