; load.view(VIEWNUM);

; View VIEWNUM is loaded into memory. This is required before the view is
; assigned to any objects or used anywhere. It is not needed, however, for the
; show.obj command.

logic.action.load.view:

    ld a,(ix)   ; VIEWNUM

@load.view:

    push ix

    ld ix,obj.viewdir
    call resource.load

    pop ix
    inc ix

    ret

;------------------------------------------------------------------------------
; load.view(vVIEWNUM);

logic.action.load.view.v:

    ld l,(ix)
    ld h,vars.high
    ld a,(hl)

    jr @load.view
