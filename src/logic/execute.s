; [name]        logic/execute.s
; [function]

; documentation:
;    https://wiki.scummvm.org/index.php?title=AGI/Specifications/Resources#action-commands
;    https://wiki.scummvm.org/index.php?title=AGI/Specifications/Resources#test-commands
;    https://wiki.scummvm.org/index.php?title=AGI/Specifications/Resources#LogicFormat


@offset.messages:    defw 0

;===============================================================================
logic.execute:
;
; input
;   a = logic script #
;-------------------------------------------------------------------------------

    ld l,a
    ld h,0
    add hl,hl
    add hl,hl
    add hl,hl   ; * 8
    ld de,ptr.logdir
    add hl,de
    inc l
    inc l
    inc l
    ld a,(hl)
    inc l
    ld h,(hl)
    ld l,a      ; -> hl = logic resource

    ld e,(hl)
    inc hl
    ld d,(hl)   ; -> de = message offset
    inc hl

    push hl
    add hl,de
    ld (var.messages),hl

    pop ix

    ld a,page.log
    out (port.hmpr),a

@loop:

    ld a,(ix)
    or a
    ret z

    if defined( debug-actions )
        push af
        call util.print.ix
        call util.print.space
        pop af
        push af
        call util.print.hex
        call util.print.space
        ld a,(ix+1)
        call util.print.hex
        call util.print.space
        ld a,(ix+2)
        call util.print.hex
        call util.print.lf
        pop af
    endif

    inc ix

    call @call.action

    jr @-loop

;===============================================================================
@call.action:

; call action using jump table

; a = action
;-------------------------------------------------------------------------------

    ld hl,@actions
    ld e,a
    ld d,0
    add hl,de
    add hl,de

    ld e,(hl)
    inc l
    ld d,(hl)
    ex de,hl

    jp (hl)


;-------------------------------------------------------------------------------
    ds align 256
;===============================================================================
@actions:

    defw logic.action.return                ; 00
    defw logic.action.increment             ; 01
    defw logic.action.decrement             ; 02
    defw logic.action.assignn               ; 03
    defw logic.action.assignv               ; 04
    defw logic.action.addn                  ; 05
    defw logic.action.addv                  ; 06
    defw logic.action.subn                  ; 07
    defw logic.action.subv                  ; 08
    defw logic.action.lindirectv            ; 09
    defw logic.action.rindirect             ; 0a
    defw logic.action.lindirectn            ; 0b
    defw logic.action.set                   ; 0c
    defw logic.action.reset                 ; 0d
    defw logic.action.toggle                ; 0e
    defw logic.action.set.v                 ; 0f

    assert $ - @actions == 0x10 * 2

    defw logic.action.reset.v               ; 10
    defw logic.action.toggle.v              ; 11
    defw logic.action.new.room              ; 12
    defw logic.action.new.room.v            ; 13
    defw logic.action.load.logics           ; 14
    defw logic.action.load.logics.v         ; 15
    defw logic.action.call                  ; 16
    defw logic.action.call.v                ; 17
    defw logic.action.load.pic              ; 18
    defw logic.action.draw.pic              ; 19
    defw logic.action.show.pic              ; 1a
    defw logic.action.discard.pic           ; 1b
    defw logic.action.overlay.pic           ; 1c
    defw logic.action.show.pri.screen       ; 1d
    defw logic.action.load.view             ; 1e
    defw logic.action.load.view.v           ; 1f

    assert $ - @actions == 0x20 * 2

    defw logic.action.discard.view          ; 20
    defw logic.action.animate.obj           ; 21
    defw logic.action.unanimate.all         ; 22
    defw logic.action.draw                  ; 23
    defw logic.action.erase                 ; 24
    defw logic.action.position              ; 25
    defw logic.action.position.v            ; 26
    defw logic.action.get.posn              ; 27
    defw logic.action.reposition            ; 28
    defw logic.action.set.view              ; 29
    defw logic.action.set.view.v            ; 2a
    defw logic.action.set.loop              ; 2b
    defw logic.action.set.loop.v            ; 2c
    defw logic.action.fix.loop              ; 2d
    defw logic.action.release.loop          ; 2e
    defw logic.action.set.cel               ; 2f

    assert $ - @actions == 0x30 * 2

    defw logic.action.set.cel.v             ; 30
    defw logic.action.last.cel              ; 31
    defw logic.action.current.cel           ; 32
    defw logic.action.current.loop          ; 33
    defw logic.action.current.view          ; 34
    defw logic.action.number.of.loops       ; 35
    defw logic.action.set.priority          ; 36
    defw logic.action.set.priority.v        ; 37
    defw logic.action.release.priority      ; 38
    defw logic.action.get.priority          ; 39
    defw logic.action.stop.update           ; 3a
    defw logic.action.start.update          ; 3b
    defw logic.action.force.update          ; 3c
    defw logic.action.ignore.horizon        ; 3d
    defw logic.action.observe.horizon       ; 3e
    defw logic.action.set.horizon           ; 3f

    assert $ - @actions == 0x40 * 2

    defw logic.action.object.on.water       ; 40
    defw logic.action.object.on.land        ; 41
    defw logic.action.object.on.anything    ; 42
    defw logic.action.ignore.objs           ; 43
    defw logic.action.observe.objs          ; 44
    defw logic.action.distance              ; 45
    defw logic.action.stop.cycling          ; 46
    defw logic.action.start.cycling         ; 47
    defw logic.action.normal.cycle          ; 48
    defw logic.action.end.of.loop           ; 49
    defw logic.action.reverse.cycle         ; 4a
    defw logic.action.reverse.loop          ; 4b
    defw logic.action.cycle.time            ; 4c
    defw logic.action.stop.motion           ; 4d
    defw logic.action.start.motion          ; 4e
    defw logic.action.step.size             ; 4f

    assert $ - @actions == 0x50 * 2

    defw logic.action.step.time             ; 50
    defw logic.action.move.obj              ; 51
    defw logic.action.move.obj.v            ; 52
    defw logic.action.follow.ego            ; 53
    defw logic.action.wander                ; 54
    defw logic.action.normal.motion         ; 55
    defw logic.action.set.dir               ; 56
    defw logic.action.get.dir               ; 57
    defw logic.action.ignore.blocks         ; 58
    defw logic.action.observe.blocks        ; 59
    defw logic.action.block                 ; 5a
    defw logic.action.unblock               ; 5b
    defw logic.action.get                   ; 5c
    defw logic.action.get.v                 ; 5d
    defw logic.action.drop                  ; 5e
    defw logic.action.put                   ; 5f

    assert $ - @actions == 0x60 * 2

    defw logic.action.put.v                 ; 60
    defw logic.action.get.room.v            ; 61
    defw logic.action.load.sound            ; 62
    defw logic.action.sound                 ; 63
    defw logic.action.stop.sound            ; 64
    defw logic.action.print                 ; 65
    defw logic.action.print.v               ; 66
    defw logic.action.display               ; 67
    defw logic.action.display.v             ; 68
    defw logic.action.clear.lines           ; 69
    defw logic.action.text.screen           ; 6a
    defw logic.action.graphics              ; 6b
    defw logic.action.set.cursor.char       ; 6c
    defw logic.action.set.text.attribute    ; 6d
    defw logic.action.shake.screen          ; 6e
    defw logic.action.configure.screen      ; 6f

    assert $ - @actions == 0x70 * 2

    defw logic.action.status.line.on        ; 70
    defw logic.action.status.line.off       ; 71
    defw logic.action.set.string            ; 72
    defw logic.action.get.string            ; 73
    defw logic.action.word.to.string        ; 74
    defw logic.action.parse                 ; 75
    defw logic.action.get.num               ; 76
    defw logic.action.prevent.input         ; 77
    defw logic.action.accept.input          ; 78
    defw logic.action.set.key               ; 79
    defw logic.action.add.to.pic            ; 7a
    defw logic.action.add.to.pic.v          ; 7b
    defw logic.action.status                ; 7c
    defw logic.action.save.game             ; 7d
    defw logic.action.restore.game          ; 7e
    defw logic.action.init.disk             ; 7f

    assert $ - @actions == 0x80 * 2

    defw logic.action.restart.game          ; 80
    defw logic.action.show.obj              ; 81
    defw logic.action.random                ; 82
    defw logic.action.program.control       ; 83
    defw logic.action.player.control        ; 84
    defw logic.action.obj.status.v          ; 85
    defw logic.action.quit                  ; 86
    defw logic.action.show.mem              ; 87
    defw logic.action.pause                 ; 88
    defw logic.action.echo.line             ; 89
    defw logic.action.cancel.line           ; 8a
    defw logic.action.init.joy              ; 8b
    defw logic.action.toggle.monitor        ; 8c
    defw logic.action.version               ; 8d
    defw logic.action.script.size           ; 8e
    defw logic.action.set.game.id           ; 8f

    assert $ - @actions == 0x90 * 2

    defw logic.action.log                   ; 90
    defw logic.action.set.scan.start        ; 91
    defw logic.action.reset.scan.start      ; 92
    defw logic.action.reposition.to         ; 93
    defw logic.action.reposition.to.v       ; 94
    defw logic.action.trace.on              ; 95
    defw logic.action.trace.info            ; 96
    defw logic.action.print.at              ; 97
    defw logic.action.print.at.v            ; 98
    defw logic.action.discard.view.v        ; 99
    defw logic.action.clear.text.rect       ; 9a
    defw logic.action.set.upper.left        ; 9b
    defw logic.action.set.menu              ; 9c
    defw logic.action.set.menu.item         ; 9d
    defw logic.action.submit.menu           ; 9e
    defw logic.action.enable.item           ; 9f

    assert $ - @actions == 0xa0 * 2

    defw logic.action.disable.item          ; a0
    defw logic.action.menu.input            ; a1
    defw logic.action.show.obj.v            ; a2
    defw logic.action.open.dialog           ; a3
    defw logic.action.close.dialog          ; a4
    defw logic.action.mul.n                 ; a5
    defw logic.action.mul.v                 ; a6
    defw logic.action.div.n                 ; a7
    defw logic.action.div.v                 ; a8
    defw logic.action.close.window          ; a9
    defw logic.action.set.simple            ; aa
    defw logic.action.push.script           ; ab
    defw logic.action.pop.script            ; ac
    defw logic.action.hold.key              ; ad
    defw logic.action.set.pri.base          ; ae
    defw logic.action.discard.sound         ; af

    assert $ - @actions == 0xb0 * 2

    defw logic.action.hide.mouse            ; b0
    defw logic.action.allow.menu            ; b1
    defw logic.action.show.mouse            ; b2
    defw logic.action.fence.mouse           ; b3
    defw logic.action.mouse.posn            ; b4
    defw logic.action.release.key           ; b5
    defw logic.action.adj.ego.move.to.xy    ; b6

    for 69, defw logic.action.invalid

    assert $ - @actions == 0xfc * 2

    defw logic.action.invalid               ; fc logic.action.or  - but must be in if
    defw logic.action.invalid               ; fd logic.action.not - but must be in if
    defw logic.action.else                  ; fe
    defw logic.action.if                    ; ff

    assert $ - @actions == 0x100 * 2

;-------------------------------------------------------------------------------

    include "action/control/return.s"
    include "action/math/increment.s"
    include "action/math/decrement.s"
    include "action/math/assign.s"
    include "action/math/add.s"
    include "action/math/sub.s"
    include "action/math/lindirect.s"
    include "action/math/rindirect.s"

    include "action/flag/set.s"
    include "action/flag/reset.s"
    include "action/flag/toggle.s"

    include "action/control/new.room.s"
    include "action/control/load.logics.s"
    include "action/control/call.s"
    include "action/picture/load.s"
    include "action/picture/draw.s"
    include "action/picture/show.s"
    include "action/picture/discard.s"
    include "action/picture/overlay.s"
    include "action/debug/show.pri.screen.s"
    include "action/object/view.load.s"
    include "action/object/view.discard.s"
    include "action/object/animate.s"
    include "action/object/draw.s"
    include "action/object/erase.s"
    include "action/object/position.s"
    include "action/object/position.get.s"
    include "action/object/reposition.s"
    include "action/object/view.set.s"
    include "action/object/loop.set.s"
    include "action/object/loop.fix.s"
    include "action/object/loop.release.s"
    include "action/object/cel.set.s"
    include "action/object/cel.last.s"
    include "action/object/cel.current.s"
    include "action/object/loop.current.s"
    include "action/object/view.current.s"
    include "action/object/number.of.loops.s"
    include "action/object/priority.set.s"
    include "action/object/priority.release.s"
    include "action/object/priority.get.s"
    include "action/object/update.stop.s"
    include "action/object/update.start.s"
    include "action/object/update.force.s"
    include "action/object/horizon.ignore.s"
    include "action/object/horizon.observe.s"
    include "action/object/horizon.set.s"
    include "action/object/on.water.s"
    include "action/object/on.land.s"
    include "action/object/on.anything.s"
    include "action/object/objs.ignore.s"
    include "action/object/objs.observe.s"
    include "action/object/distance.s"
    include "action/object/cycle.stop.s"
    include "action/object/cycle.start.s"
    include "action/object/cycle.normal.s"
    include "action/object/end.of.loop.s"
    include "action/object/cycle.reverse.s"
    include "action/object/loop.reverse.s"
    include "action/object/cycle.time.s"
    include "action/object/motion.stop.s"
    include "action/object/motion.start.s"
    include "action/object/step.size.s"
    include "action/object/step.time.s"
    include "action/object/move.s"
    include "action/object/follow.ego.s"
    include "action/object/wander.s"
    include "action/object/motion.normal.s"
    include "action/object/dir.set.s"
    include "action/object/dir.get.s"
    include "action/object/blocks.ignore.s"
    include "action/object/blocks.observe.s"
    include "action/object/block.s"
    include "action/item/get.s"
    include "action/item/drop.s"
    include "action/item/put.s"
    include "action/sound/load.s"
    include "action/sound/sound.s"
    include "action/sound/stop.s"
    include "action/display/print.s"
    include "action/display/display.s"
    include "action/display/clear.lines.s"
    include "action/display/text.screen.s"
    include "action/display/graphics.s"
    include "action/display/set.cursor.char.s"
    include "action/display/set.text.attribute.s"
    include "action/display/shake.screen.s"
    include "action/display/configure.screen.s"
    include "action/display/status.line.s"
    include "action/string/set.s"
    include "action/string/get.s"
    include "action/string/word.to.string.s"
    include "action/string/parse.s"
    include "action/math/get.num.s"
    include "action/system/input.s"
    include "action/menu/set.key.s"
    include "action/object/add.to.pic.s"
    include "action/item/status.s"
    include "action/system/game.save.s"
    include "action/system/game.restore.s"
    include "action/system/init.disk.s"
    include "action/system/game.restart.s"
    include "action/item/show.s"
    include "action/math/random.s"
    include "action/system/control.program.s"
    include "action/system/control.player.s"
    include "action/debug/obj.status.s"
    include "action/system/quit.s"
    include "action/debug/show.mem.s"
    include "action/system/pause.s"
    include "action/system/echo.line.s"
    include "action/system/cancel.line.s"
    include "action/system/init.joy.s"
    include "action/system/toggle.monitor.s"
    include "action/debug/version.s"
    include "action/system/script.size.s"
    include "action/system/set.game.id.s"
    include "action/debug/log.s"
    include "action/control/scan.start.s"
    include "action/debug/trace.s"
    include "action/display/print.at.s"
    include "action/display/clear.text.rect.s"
    include "action/object/set.upper.left.s"
    include "action/menu/set.s"
    include "action/menu/item.s"
    include "action/menu/submit.s"
    include "action/menu/input.s"
    include "action/display/dialog.s"
    include "action/math/mul.s"
    include "action/math/div.s"
    include "action/display/window.s"
    include "action/system/set.simple.s"
    include "action/control/script.s"
    include "action/menu/key.hold.s"
    include "action/object/priority.set.base.s"
    include "action/sound/discard.s"
    include "action/menu/mouse.s"
    include "action/menu/allow.s"
    include "action/menu/key.release.s"
    include "action/object/adj.ego.move.to.xy.s"

    include "action/else.s"
    include "action/if.s"

;===============================================================================
; conditions
;
; https://wiki.scummvm.org/index.php?title=AGI/Specifications/Resources#test-commands

    align 2

@tests:
    defw logic.test.invalid         ; 00
    defw logic.test.equaln          ; 01
    defw logic.test.equalv          ; 02
    defw logic.test.lessn           ; 03
    defw logic.test.lessv           ; 04
    defw logic.test.greatern        ; 05
    defw logic.test.greaterv        ; 06
    defw logic.test.isset           ; 07
    defw logic.test.issetv          ; 08
    defw logic.test.has             ; 09
    defw logic.test.obj.in.room     ; 0a
    defw logic.test.posn            ; 0b
    defw logic.test.controller      ; 0c
    defw logic.test.have.key        ; 0d
    defw logic.test.said            ; 0e
    defw logic.test.compare.strings ; 0f
    defw logic.test.obj.in.box      ; 10
    defw logic.test.center.posn     ; 11
    defw logic.test.right.posn      ; 12

;-------------------------------------------------------------------------------

    include "test/equal.s"
    include "test/less.s"
    include "test/greater.s"
    include "test/isset.s"
    include "test/has.s"
    include "test/obj.s"
    include "test/posn.s"
    include "test/controller.s"
    include "test/have.key.s"
    include "test/said.s"
    include "test/compare.strings.s"

;===============================================================================
logic.call.test:

; call test using jump table
;-------------------------------------------------------------------------------

    if defined(debug)
        cp 0x13
        jp nc,logic.test.invalid
    endif

    ld hl,@tests
    ld e,a
    ld d,0
    add hl,de
    add hl,de

    ld e,(hl)
    inc l
    ld d,(hl)
    ex de,hl

    jp (hl)

;===============================================================================
logic.action.nyi:

    dec ix
    ld hl,@text.action.nyi
    jp error

@text.action.nyi:

    defm " ACTION NYI: "
    defb 0

include "action/invalid.s"
include "test/invalid.s"

include "message.get.hl.s"
include "string.get.de.s"

