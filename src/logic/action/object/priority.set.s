; set.priority(oA,PRI);

; Object oA's priority is set to PRI. The object keeps this priority wherever it
; goes on the screen.

; To change it back so the priority is dependent on the object's position, use
; the release.priority command.

; Note: If the object's priority is 15, it ignores all control lines and blocks,
; and thus can move anywhere on the screen below the horizon. If the object is
; ego (object 0), then flags 0 and 3 are no longer set according to whether ego
; is on a control line of color 3 or 2. After this, if the object's priority is
; released or set to something lower than 15, it returns to it's normal
; behaviour.

logic.action.set.priority:

    ld b,(ix)   ; oA
    ld c,(ix+1) ; PRI

    ld hl,view.set.priority
    call section.call.object

    inc ix
    inc ix

    ret

;-------------------------------------------------------------------------------

; set.priority.v(oA,vPRI)

logic.action.set.priority.v:

    jp logic.action.nyi
