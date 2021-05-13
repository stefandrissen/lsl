
; set.view(oA,B);

; View B is assigned to object oA. The view must be loaded in order to do this.
; If you wish, you can have one view assigned to several objects.

logic.action.set.view:

    ld c,(ix+1) ; B

@set.view:

    ld b,(ix+0) ; oA

    ld hl,view.set.view
    call section.call.object

    inc ix
    inc ix

    ret

;-------------------------------------------------------------------------------

; set.view.v(oA,vB);

; View vB is assigned to object oA. The view must be loaded in order to do this.
; If you wish, you can have one view assigned to several objects.

logic.action.set.view.v:

    ld h,vars.high
    ld l,(ix+1)     ; vB
    ld c,(hl)

    jr @set.view
