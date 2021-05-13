; animate.obj(oA);

; This tells the interpreter to activate oA. You must do this before doing
; anything with the object.

logic.action.animate.obj:

    ld c,(ix)   ; oA

    ld hl,view.animate.obj
    call section.call.object

    inc ix

    ret

;------------------------------------------------------------------------------

; unanimate.all();

; This deactivates all screen objects.

logic.action.unanimate.all:

    ld hl,view.unanimate.all
    call section.call.object

    ret

;------------------------------------------------------------------------------
