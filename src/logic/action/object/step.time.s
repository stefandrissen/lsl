; step.time(oA,vB);

; The delay (in interpreter cycles) between steps (movements) of object oA is
; set to vB. For example, if the step time is set to 2, the object will only
; move every second cycle. Note that an object's step time is independent from
; it's cycle.time.

logic.action.step.time:

    ld b,(ix)

    ld h,vars.high
    ld l,(ix+1)
    ld c,(hl)

    ld hl,view.step.time
    call section.call.object

    inc ix
    inc ix

    ret
