logic.test.said:

; if ( said( "a" [, "b" [, "c" ]]] ) { ...
;
; The said test command uses different parameters to all the other commands.
; Where as the others use 8 bit arguments (0--255), said takes 16 bit arguments
; (0--65535). Also, the number of arguments in a said command can vary. The
; numbers given in the arguments are the word group numbers from the words.tok
; file.

if defined( strict )

    jp logic.test.invalid

else

    ld a,(ix)   ; number of arguments
    inc ix

    ; TODO

@loop:
    inc ix      ; \ words.tok pointer
    inc ix      ; /

    dec a
    jr nz,@loop

    ld a,0

    ret

endif

