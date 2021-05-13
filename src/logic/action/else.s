
logic.action.else:

; reached when if true was executed

    ld e,(ix+0)     ; length of else
    ld d,(ix+1)     ;

    inc de
    inc de

    add ix,de

    ret
