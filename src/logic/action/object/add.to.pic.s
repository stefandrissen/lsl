
; add.to.pic(VIEWNO,LOOPNO,CELNO,X,Y,PRI,MARGIN);

; This command allows you to add a view to the visual picture screen in memory.
; Cel CELNO of loop LOOPNO of view VIEWNO is drawn on the picture at X,Y with a
; priority of PRI. If MARGIN is 0, 1, 2 or 3, the base line of the object (the
; bottom row of pixels of the cel) is given a priority of MARGIN. Since priority
; is taken into account, so you can use add.to.pic to add views behind other
; parts of the picture.

; Note that the view must be loaded before you use it with add.to.pic. This can
; be done with the load.view command.

logic.action.add.to.pic:

; TODO - how does priority work?

    ld a,(ix+0)     ; viewno
    ld l,(ix+1)     ; loopno
    ld h,(ix+2)     ; celno
    ld e,(ix+3)     ; x
    ld d,(ix+4)     ; y
    ld c,(ix+5)     ; pri
    ld b,(ix+6)     ; margin

    ex af,af'

    push ix

    ld ix,view.add.to.pic
    call section.call.view

    pop ix

    ld bc,7
    add ix,bc

    ret

;-------------------------------------------------------------------------------

; add.to.pic.v(vVIEWNO,vLOOPNO,vCELNO,vX,vY,vPRI,vMARGIN);

; This command allows you to add a view to the visual picture screen in memory.
; Cel vCELNO of loop vLOOPNO of view vVIEWNO is drawn on the picture at vX,vY
; with a priority of vPRI. If vMARGIN is 0, 1, 2 or 3, the base line of the
; object (the bottom row of pixels of the cel) is given a priority of vMARGIN.
; Since priority is taken into account, so you can use add.to.pic.v to add views
; behind other parts of the picture.

; Note that the view must be loaded before you use it with add.to.pic.v. This
; can be done with the load.view command.

logic.action.add.to.pic.v:

    jp logic.action.nyi
