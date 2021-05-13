; new.room(ROOMNO); / new.room(vROOMNO);

; Switches to a new room, ROOMNO.

; The following things automatically happen when this command is used:

; a. All objects are unanimated
; b. All resources except logic 0 are discarded
; c. player.control command is executed
; d. unblock command is executed
; e. horizon is set to 36
; f. v1 (prev_room_no) is set to the value of v0 (room_no)
; g. v0 (room_no) is assigned to the new room number
; h. v16 (ego_view_no) is set to the view number assigned to ego
; i. The logic for the new room is loaded (logic ROOMNO)
; j. If ego was touching an edge of the screen, it is placed on the opposite side
; k. Flag 5 (new_room) is set (this is reset after the first cycle in the new room)
; l. Execution jumps to the start of logic 0

logic.action.new.room:

    ld a,(ix)       ; ROOMNO

@new.room:

    inc ix

; a. TODO - first need objects :-)

    ; call logic.action.player.control
; d.
    ; call logic.action.unblock
; e.
    ; call logic.action.set.horizon
; f.
    ld hl,var.current_room_number
    ld b,(hl)
    inc l           ; -> hl = var.previous_room_number
    ld (hl),b
    dec l           ; -> hl = var.current_room_number
; g.
    ld (hl),a
; h. TODO - first need a view

; i.
    call logic.load.script

; j. TODO set left / right / up / down
    ld a,(var.object_touched_border)

; k.
    ld a,flag.room_script_first_time
    call flag.set

;    ld a,page.boot
;    out (port.hmpr),a

;    ld ix,(obj.logdir + obj.last.start)
;   execution loop needs to be aborted

;    ld a,(obj.logdir + obj.page)
;    out (port.hmpr),a

    pop hl  ; toss return address execute to escape loop

    jp main.game.loop

;------------------------------------------------------------------------------

logic.action.new.room.v:

    ld h,vars.high
    ld l,(ix)
    ld a,(hl)

    jr @new.room
