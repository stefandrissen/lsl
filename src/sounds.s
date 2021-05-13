; sounds
;
; structure for sounds - currently only storing flag


;-------------------------------------------------------------------------------

    ds align &100

sounds:
sounds.high:    equ sounds / &100

sound.0:
    defb    0   ; flagdone

@sound.length: equ $ - sound.0

    defs 63 * @sound.length
