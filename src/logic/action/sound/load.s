; load.sound(SOUNDNO);

; Sound SOUNDNO is loaded into memory.

logic.action.load.sound:

    ld a,(ix)   ; SOUNDNO

    push ix

    ld ix,obj.snddir
    call resource.load

    pop ix

    inc ix

    ret
