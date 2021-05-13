; cycle.time(oA,vB);

; The delay (in interpreter cycles) between cel changes of object oA (when it is
; cycling) is set to vB. If vB is equal to 0, the cels do not change (even when
; the object is cycling). Note that an object's cycle time is separate to it's
; step time.

logic.action.cycle.time:

    ld b,(ix)   ; oA

    ld h,vars.high
    ld l,(ix+1)
    ld c,(hl)   ; vB

    ld hl,view.cycle.time
    call section.call.object

    inc ix
    inc ix

    ret
