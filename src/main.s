; Z80 AGI for Leisure Suit Larry In The Land Of The Lounge Lizards
;
; (C) 2016-2021 Stefan Drissen
;
; data files:
;    http://www.myabandonware.com/game/leisure-suit-larry-in-the-land-of-the-lounge-lizards-bl
;
; documentation:
;    http://wiki.scummvm.org/index.php/AGI/Specifications
;
; gba c implementation based on disassembly of original:
;   http://web.archive.org/web/20080509121504/http://www.bripro.com/gbagi/index.php
;
; javascript implementation:
;   https://github.com/r1sc/agi.js
;
; c++ agi-studio
;   https://git.nox-rhea.org/globals/Sierra-games/qt-agi-studio
;
; logic scripts with descriptive variable names
;   https://github.com/historicalsource/leisuresuitlarry
;
;-------------------------------------------------------------------------------
; memory map:
;
; first block of every page with code contains entry and return routines
; entry stores context and pushes return onto stack
; sp at 0x100
;
; A 1 bootstrap
;   2 stub (im1) + main
;   4 stub (im1) + views
; B 3 main
;   5 views
;
; C 1 load routines
;   6 screen
;   8 priority screen
; D 7 screen          + graphics routines
;   9 priority screen + graphics routines
;
; maybe put sound + pic in own pages too with code at start
;-------------------------------------------------------------------------------

    include "memory.i"
    include "util/ports.i"

;===============================================================================

    dump page.main,0
    org 0x0000

;-------------------------------------------------------------------------------
    jp @main.init.low

;===============================================================================

    include "section.i"

;-------------------------------------------------------------------------------

main.flags:
    include "flags.s"

;-------------------------------------------------------------------------------
    ds align 0x100
;===============================================================================
main.vars:
vars.high: equ main.vars / 0x100

; variables
; - 26 reserved variables
;-------------------------------------------------------------------------------
var.current_room_number:        defb 0          ; v0 currentRoom
var.previous_room_number:       defb 0          ; v1 previousRoom
var.border_touched_ego:         defb 0          ; v2 edgeEgoHit
var.current_score:              defb 0          ; v3 currentScore
var.object_touched_border:      defb 0          ; v4 objHitEdge
    enum.border_none:               equ 0
    enum.border_top_or_horizon:     equ 1
    enum.border_right:              equ 2
    enum.border_bottom:             equ 3
    enum.border_left:               equ 4
var.edge_obj_hit:               defb 0          ; v5 edgeObjHit
main.var.ego_direction:         defb 0          ; v6 egoDir
    enum.direction_up:              equ 1
    enum.direction_up_right:        equ 2
    enum.direction_right:           equ 3
    enum.direction_right_down:      equ 4
    enum.direction_down:            equ 5
    enum.direction_down_left:       equ 6
    enum.direction_left:            equ 7
    enum.direction_left_up:         equ 8

var.maximum_score:              defb 0          ; v7 maxScore
var.free_pages:                 defb 0          ; v8 memoryLeft
var.word_not_found:             defb 0          ; v9 unknownWordNum
var.interpreter_cycle_time:     defb 0          ; v10 animationInterval
var.seconds:                    defb 0          ; v11 elapsedSeconds
var.minutes:                    defb 0          ; v12 elapsedMinutes
var.hours:                      defb 0          ; v13 elapsedHours
var.days:                       defb 0          ; v14 elapsedDays
var.joystick_sensitivity:       defb 0          ; v15 dblClickDelay
var.view_resource_ego:          defb 0          ; v16 currentEgoView
var.interpreter_error_code:     defb 0          ; v17 errorNumber
var.error_code_parameter:       defb 0          ; v18 errorParameter
var.key_pressed:                defb 0          ; v19 lastChar
var.computer_type:              defb 8          ; v20 machineType
    enum.computer.ibm_pc:           equ 0
    enum.computer.atari_st:         equ 4
    enum.computer.amiga:            equ 5
    enum.computer.apple_iigs:       equ 7
    enum.computer.sam_coupe:        equ 8 ; ;-)

var.message_window_timer:       defb 0          ; v21 printTimeout
var.sound_type:                 defb 0          ; v22 numberOfVoices
var.sound_volume:               defb 0          ; v23 attenuation
var.input_buffer_size:          defb 41         ; v24 inputLength
var.inventory_items_selected:   defb 0          ; v25 selectedItem
var.monitor_type:               defb 3          ; v26 monitorType
    enum.monitor.cga:               equ 0
    enum.monitor.rgb:               equ 1
    enum.monitor.mono:              equ 2
    enum.monitor.ega:               equ 3
    enum.monitor.vga:               equ 4


;-------------------------------------------------------------------------------
; - 230 'user' variables
    defs 230
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------

@main.init.low:

    in a,(port.hmpr)
    ld (@store.hmpr+1),a

    ld hl,main.update.frames
    call @set.interrupt.handlers

    ei

    ld a,page.screen.1
    or video.mode.4
    out (port.vmpr),a

    ; load logic script 0

    ld a,0
    call logic.load.script

    ; when a new room is entered, everything but logic script 0 is deallocated

    in a,(port.hmpr)
    push af
    ld a,page.boot
    out (port.hmpr),a
    ld hl,(obj.logdir+obj.free)
    ld (var.resource.end.0),hl

    pop af
    out (port.hmpr),a

    ld a,flag.room_script_first_time
    call flag.set

main.game.loop:

    ; 1. delay time

    ld hl,var.frames - 0x8000
    ld a,(hl)
@not.frame.interrupt:
    halt
    cp (hl)
    jr z,@not.frame.interrupt

    ; 2. clear keyboard buffer
    ; 3. poll keyboard and joystick
    ; 4. variable analysis
    ; 5. move objects

    ld ix,view.move.objects
    call section.call.view

    ; 6. execute logic

    ld a,0
    call logic.execute

    ; 7. test new.room

    ld a,flag.room_script_first_time
    call flag.reset

    jr main.game.loop

@store.hmpr:
    ld a,0
    out (port.hmpr),a

    ret


;-------------------------------------------------------------------------------
@set.interrupt.handlers:

    ld (maskable.interrupt.handler + 1),hl

    ld a,page.view
    call @set.interrupt.handler

    ld a,page.pic
    call @set.interrupt.handler

    ret

;-------------------------------------------------------------------------------
@set.interrupt.handler:

    out (port.hmpr),a
    ld (maskable.interrupt.handler + 0x8001),hl

    ret

;-------------------------------------------------------------------------------

    include "error.s"

    include "resource/load.s"

    include "logic/load.s"
    include "logic/execute.s"

    include "util/print.s"
    include "util/keyboard.s"
;    include "list.s"

;===============================================================================
    org $ + 0x8000
main.update.frames:
; paged in high and called by maskable.interrupt.handler
;-------------------------------------------------------------------------------

    push hl

    ld hl,var.frames
    inc (hl)
    ld a,50
    cp (hl)
    jr nz,@done

    ld (hl),0
    ld hl,var.seconds + 0x8000
    inc (hl)
    ld a,60
    cp (hl)
    jr nz,@done

    ld (hl),0
    inc l       ; minutes
    inc (hl)
    cp (hl)
    jr nz,@done

    ld (hl),0
    inc l       ; hours
    inc (hl)
    ld a,24
    cp (hl)
    jr nz,@done

    ld (hl),0
    inc l       ; days
    inc (hl)
@done:
    pop hl

    ret

var.frames: defb 0  ; increased by interrupt, flows over to var.seconds

    org $ - 0x8000

    align 0x100
;===============================================================================
strings:
strings.high: equ strings / 0x100

; Strings - There are 12 to 24 (depending on the version) strings available to
; the games to use. Each is a maximum of 40 bytes in size and can be used for
; anything. Most commonly they are used for storing input.
;-------------------------------------------------------------------------------

    defs 12 * 40

;===============================================================================
controllers:
controllers.high: equ controllers / 0x100

; Contollers - 1bit boolean flags. 50 controllers are available. They are paired
; with keys and/or menu items and upon a key press or item selection, are set.
; The games then check if they are set, and perform tasks accordingly.
;-------------------------------------------------------------------------------

    defs 50

;-------------------------------------------------------------------------------


; logic script 0 is first script, when new.room called, everything but logic 0
; is discarded, these variables hold values /after/ loading 0

var.resource.end.0:     defw 0

;-------------------------------------------------------------------------------

    ds align 0x1000

free.main:

