; sound(SOUNDNO,fDONEFLAG); TODO

; Sound SOUNDNO is played. fDONEFLAG is reset when the command is issued, and
; set when the sound finishes playing or is stopped with the stop.sound command.

; The sound must be loaded before it is played. This can be done with the
; load.sound command.

logic.action.sound:

    ld b,(ix)   ; soundno
    ld c,(ix+1) ; doneflag

    ld a,page.snd
    out (port.hmpr),a

    call snd.sound

    ld a,page.log
    out (port.hmpr),a

    call flag.reset

    inc ix
    inc ix

    ret
