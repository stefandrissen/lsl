debug.enable:

    push af
    xor a
    jr @set.debug

debug.disable:

    push af
    ld a,0xc9 ; ret
  @set.debug:
    ld (logic.action.debug),a
    ld (logic.test.debug),a

    pop af

logic.action.debug:

    ret

    push ix
    push bc
    push af

    call util.print.reset
    ld b,40
    @loop:
        call util.print.space
        djnz @-loop

    call util.print.reset
    call util.print.ix
    call util.print.space
    pop af
    push af
    call util.print.hex
    call util.print.space
    pop af
    push af

    ld hl,@actions
  @print:
    ld e,a
    ld d,0
    add hl,de
    add hl,de
    ld e,(hl)
    inc l
    ld d,(hl)
    ex de,hl

    @loop:
        ld a,(hl)
        cp " "
        jr z,@end

        cp "%"
        jr nz,@normal

        inc hl
        inc ix
        ld a,(ix)
        call util.print.hex
        jr @continue

      @normal:
        call util.print.char

      @continue:

        inc hl
        jr @-loop

 @end:
    ; call util.print.lf
    pop af
    pop bc
    pop ix

    cp 0xff ; if

    call nz,util.keyboard.pause

    ret

logic.test.debug:

    ret

    push ix
    push bc
    push af

    call util.print.space

    pop af
    push af

    dec ix
    ld hl,@tests
    jr @-print

@actions:

    defw @return                ; 00
    defw @increment             ; 01
    defw @decrement             ; 02
    defw @assignn               ; 03
    defw @assignv               ; 04
    defw @addn                  ; 05
    defw @addv                  ; 06
    defw @subn                  ; 07
    defw @subv                  ; 08
    defw @lindirectv            ; 09
    defw @rindirect             ; 0a
    defw @lindirectn            ; 0b
    defw @set                   ; 0c
    defw @reset                 ; 0d
    defw @toggle                ; 0e
    defw @set.v                 ; 0f

    assert $ - @actions == 0x10 * 2

    defw @reset.v               ; 10
    defw @toggle.v              ; 11
    defw @new.room              ; 12
    defw @new.room.v            ; 13
    defw @load.logics           ; 14
    defw @load.logics.v         ; 15
    defw @call                  ; 16
    defw @call.v                ; 17
    defw @load.pic              ; 18
    defw @draw.pic              ; 19
    defw @show.pic              ; 1a
    defw @discard.pic           ; 1b
    defw @overlay.pic           ; 1c
    defw @show.pri.screen       ; 1d
    defw @load.view             ; 1e
    defw @load.view.v           ; 1f

    assert $ - @actions == 0x20 * 2

    defw @discard.view          ; 20
    defw @animate.obj           ; 21
    defw @unanimate.all         ; 22
    defw @draw                  ; 23
    defw @erase                 ; 24
    defw @position              ; 25
    defw @position.v            ; 26
    defw @get.posn              ; 27
    defw @reposition            ; 28
    defw @set.view              ; 29
    defw @set.view.v            ; 2a
    defw @set.loop              ; 2b
    defw @set.loop.v            ; 2c
    defw @fix.loop              ; 2d
    defw @release.loop          ; 2e
    defw @set.cel               ; 2f

    assert $ - @actions == 0x30 * 2

    defw @set.cel.v             ; 30
    defw @last.cel              ; 31
    defw @current.cel           ; 32
    defw @current.loop          ; 33
    defw @current.view          ; 34
    defw @number.of.loops       ; 35
    defw @set.priority          ; 36
    defw @set.priority.v        ; 37
    defw @release.priority      ; 38
    defw @get.priority          ; 39
    defw @stop.update           ; 3a
    defw @start.update          ; 3b
    defw @force.update          ; 3c
    defw @ignore.horizon        ; 3d
    defw @observe.horizon       ; 3e
    defw @set.horizon           ; 3f

    assert $ - @actions == 0x40 * 2

    defw @object.on.water       ; 40
    defw @object.on.land        ; 41
    defw @object.on.anything    ; 42
    defw @ignore.objs           ; 43
    defw @observe.objs          ; 44
    defw @distance              ; 45
    defw @stop.cycling          ; 46
    defw @start.cycling         ; 47
    defw @normal.cycle          ; 48
    defw @end.of.loop           ; 49
    defw @reverse.cycle         ; 4a
    defw @reverse.loop          ; 4b
    defw @cycle.time            ; 4c
    defw @stop.motion           ; 4d
    defw @start.motion          ; 4e
    defw @step.size             ; 4f

    assert $ - @actions == 0x50 * 2

    defw @step.time             ; 50
    defw @move.obj              ; 51
    defw @move.obj.v            ; 52
    defw @follow.ego            ; 53
    defw @wander                ; 54
    defw @normal.motion         ; 55
    defw @set.dir               ; 56
    defw @get.dir               ; 57
    defw @ignore.blocks         ; 58
    defw @observe.blocks        ; 59
    defw @block                 ; 5a
    defw @unblock               ; 5b
    defw @get                   ; 5c
    defw @get.v                 ; 5d
    defw @drop                  ; 5e
    defw @put                   ; 5f

    assert $ - @actions == 0x60 * 2

    defw @put.v                 ; 60
    defw @get.room.v            ; 61
    defw @load.sound            ; 62
    defw @sound                 ; 63
    defw @stop.sound            ; 64
    defw @print                 ; 65
    defw @print.v               ; 66
    defw @display               ; 67
    defw @display.v             ; 68
    defw @clear.lines           ; 69
    defw @text.screen           ; 6a
    defw @graphics              ; 6b
    defw @set.cursor.char       ; 6c
    defw @set.text.attribute    ; 6d
    defw @shake.screen          ; 6e
    defw @configure.screen      ; 6f

    assert $ - @actions == 0x70 * 2

    defw @status.line.on        ; 70
    defw @status.line.off       ; 71
    defw @set.string            ; 72
    defw @get.string            ; 73
    defw @word.to.string        ; 74
    defw @parse                 ; 75
    defw @get.num               ; 76
    defw @prevent.input         ; 77
    defw @accept.input          ; 78
    defw @set.key               ; 79
    defw @add.to.pic            ; 7a
    defw @add.to.pic.v          ; 7b
    defw @status                ; 7c
    defw @save.game             ; 7d
    defw @restore.game          ; 7e
    defw @init.disk             ; 7f

    assert $ - @actions == 0x80 * 2

    defw @restart.game          ; 80
    defw @show.obj              ; 81
    defw @random                ; 82
    defw @program.control       ; 83
    defw @player.control        ; 84
    defw @obj.status.v          ; 85
    defw @quit                  ; 86
    defw @show.mem              ; 87
    defw @pause                 ; 88
    defw @echo.line             ; 89
    defw @cancel.line           ; 8a
    defw @init.joy              ; 8b
    defw @toggle.monitor        ; 8c
    defw @version               ; 8d
    defw @script.size           ; 8e
    defw @set.game.id           ; 8f

    assert $ - @actions == 0x90 * 2

    defw @log                   ; 90
    defw @set.scan.start        ; 91
    defw @reset.scan.start      ; 92
    defw @reposition.to         ; 93
    defw @reposition.to.v       ; 94
    defw @trace.on              ; 95
    defw @trace.info            ; 96
    defw @print.at              ; 97
    defw @print.at.v            ; 98
    defw @discard.view.v        ; 99
    defw @clear.text.rect       ; 9a
    defw @set.upper.left        ; 9b
    defw @set.menu              ; 9c
    defw @set.menu.item         ; 9d
    defw @submit.menu           ; 9e
    defw @enable.item           ; 9f

    assert $ - @actions == 0xa0 * 2

    defw @disable.item          ; a0
    defw @menu.input            ; a1
    defw @show.obj.v            ; a2
    defw @open.dialog           ; a3
    defw @close.dialog          ; a4
    defw @mul.n                 ; a5
    defw @mul.v                 ; a6
    defw @div.n                 ; a7
    defw @div.v                 ; a8
    defw @close.window          ; a9
    defw @set.simple            ; aa
    defw @push.script           ; ab
    defw @pop.script            ; ac
    defw @hold.key              ; ad
    defw @set.pri.base          ; ae
    defw @discard.sound         ; af

    assert $ - @actions == 0xb0 * 2

    defw @hide.mouse            ; b0
    defw @allow.menu            ; b1
    defw @show.mouse            ; b2
    defw @fence.mouse           ; b3
    defw @mouse.posn            ; b4
    defw @release.key           ; b5
    defw @adj.ego.move.to.xy    ; b6

    for 69, defw @invalid

    assert $ - @actions == 0xfc * 2

    defw @invalid               ; fc logic.action.or  - but must be in if
    defw @invalid               ; fd logic.action.not - but must be in if
    defw @else                  ; fe
    defw @if                    ; ff

    assert $ - @actions == 0x100 * 2

 @return:       defm "return() "
 @increment:    defm "increment(v%A) "
 @decrement:    defm "decrement(v%A) "
 @assignn:      defm "assign(v%A,%B) "
 @assignv:      defm "assign(v%A,v%B) "
 @addn:         defm "add(v%A,%B) "
 @addv:         defm "add(v%A,v%B) "
 @subn:         defm "sub(v%A,%B) "
 @subv:         defm "sub(v%A,v%B) "
 @lindirectv:   defm "lindirect(v%A,v%B) "
 @rindirect:    defm "rindirect(v%A,v%B) "
 @lindirectn:   defm "lindirect(v%A,%B) "
 @set:          defm "set(f%A) "
 @reset:        defm "reset(f%A) "
 @toggle:       defm "toggle(f%A) "
 @set.v:        defm "set(v%A) "

 @reset.v:      defm "reset(v%A) "
 @toggle.v:     defm "toggle(v%A) "
 @new.room:     defm "new.room(%A) "
 @new.room.v:   defm "new.room(v%A) "
 @load.logics:  defm "load.logics(%A) "
 @load.logics.v: defm "load.logics(v%A) "
 @call:         defm "call(%A) "
 @call.v:       defm "call(v%A) "
 @load.pic:     defm "load.pic(v%A) "
 @draw.pic:     defm "draw.pic(v%A) "
 @show.pic:     defm "show.pic(v%A) "
 @discard.pic:  defm "discard.piC(v%A) "
 @overlay.pic:  defm "overlay.pic(v%A) "
 @show.pri.screen: defm "show.pri.screen() "
 @load.view:    defm "load.view(%A) "
 @load.view.v:  defm "load.view(v%A) "

 @discard.view: defm "discard.view(%A) "
 @animate.obj:  defm "animate.obj(o%A) "
 @unanimate.all: defm "animate.all "
 @draw:         defm "draw(o%A) "
 @erase:        defm "erase(o%A) "
 @position:     defm "position(o%A,%X,%Y) "
 @position.v:   defm "position(o%A,v%X,v%Y) "
 @get.posn:     defm "get.posn(o%A,v%X,v%Y) "
 @reposition:   defm "reposition(o%A,v%X,v%Y) " ; delta X, delta Y
 @set.view:     defm "set.view(o%A,%V) "
 @set.view.v:   defm "set.view(o%A,v%V) "
 @set.loop:     defm "set.loop(o%A,%V) "
 @set.loop.v:   defm "set.loop(o%A,v%V) "
 @fix.loop:     defm "fix.loop(o%A) "
 @release.loop: defm "release.loop(o%A) "
 @set.cel:      defm "set.cel(o%A,%V) "

 @set.cel.v:        defm "set.cel(o%A,v%B) "
 @last.cel:         defm "last.cel(o%A,v%B) "
 @current.cel:      defm "current.cel(o%A,v%B) "
 @current.loop:     defm "current.loop(o%A,v%B) "
 @current.view:     defm "current.view(o%A,v%B) "
 @number.of.loops:  defm "number.of.loops(o%A,v%B) "
 @set.priority:     defm "set.priority(o%A,%B) "
 @set.priority.v:   defm "set.priority(o%A,v%B) "
 @release.priority: defm "release.priority(o%A) "
 @get.priority:     defm "get.priority(o%A,v%B) "
 @stop.update:      defm "stop.update(o%A) "
 @start.update:     defm "start.update(o%A) "
 @force.update:     defm "force.update(o%A) "
 @ignore.horizon:   defm "ignore.horizon(o%A) "
 @observe.horizon:  defm "observe.horizon(o%A) "
 @set.horizon:      defm "set.horizon(%A) "

 @object.on.water:  defm "object.on.water(o%A) "
 @object.on.land:   defm "object.on.land(o%A) "
 @object.on.anything: defm "object.on.anything(o%A) "
 @ignore.objs:      defm "ignore.objs(o%A) "
 @observe.objs:     defm "observe.objs(o%A) "
 @distance:         defm "distance(o%A,o%B,v%C) "
 @stop.cycling:     defm "stop.cycling(o%A) "
 @start.cycling:    defm "start.cycling(o%A) "
 @normal.cycle:     defm "normal.cycle(o%A) "
 @end.of.loop:      defm "end.of.loop(o%A,f%B) "
 @reverse.cycle:    defm "reverse.cycle(o%A) "
 @reverse.loop:     defm "reverse.loop(o%A,f%B) "
 @cycle.time:       defm "cycle.time(o%A,v%B) "
 @stop.motion:      defm "stop.motion(o%A) "
 @start.motion:     defm "start.motion(o%A) "
 @step.size:        defm "set.size(o%A,v%B) "

 @step.time:        defm "step.time(o%A,v%B) "
 @move.obj:         defm "move.obj(o%A,%X,%Y,%S,f%D) "
 @move.obj.v:       defm "move.obj(o%A,v%X,v%Y,v%S,f%D) "
 @follow.ego:       defm "follow.ego(o%A,%D,f%C) "
 @wander:           defm "wander(o%A) "
 @normal.motion:    defm "normal.motion(o%A) "
 @set.dir:          defm "set.dir(o%A,v%B) "
 @get.dir:          defm "get.dir(o%A,v%B) "
 @ignore.blocks:    defm "ignore.blocks(o%A) "
 @observe.blocks:   defm "observe.blocks(o%A) "
 @block:            defm "block(%X,%Y,%X,%Y) "
 @unblock:          defm "unblock() "
 @get:              defm "get(i%A) "
 @get.v:            defm "get(v%A) "
 @drop:             defm "drop(i%A) "
 @put:              defm "put(i%A,v%B) "

 @put.v:            defm "put(v%A,v%B) "
 @get.room.v:       defm "get.room(v%A,v%B) "
 @load.sound:       defm "load.sound(%A) "
 @sound:            defm "sound(%A,f%D) "
 @stop.sound:       defm "stop.sound() "
 @print:            defm "print(%A) "
 @print.v:          defm "print(v%A) "
 @display:          defm "display(%R,%C,%M) "
 @display.v:        defm "display(v%R,v%C,v%M) "
 @clear.lines:      defm "clear.lines(%T,%B,%C) "
 @text.screen:      defm "text.screen() "
 @graphics:         defm "graphics() "
 @set.cursor.char:  defm "set.cursor.char(M%A) "
 @set.text.attribute: defm "set.text.attribute(%F,%B) "
 @shake.screen:     defm "shake.screen(%A) "
 @configure.screen: defm "configure.screen(%T,%I,%S) "

 @status.line.on:   defm "status.line.on() "
 @status.line.off:  defm "status.line.off() "
 @set.string:       defm "set.string(s%A,m%B) "
 @get.string:       defm "get.string(s%A,m%P,%R,%C,%L) "
 @word.to.string:   defm "word.to.string(s%A,w%B) "
 @parse:            defm "parse(s%A) "
 @get.num:          defm "get.num(m%P,v%B) "
 @prevent.input:    defm "prevent.input() "
 @accept.input:     defm "accept.input() "
 @set.key:          defm "set.key(%A,%S,c%C) "
 @add.to.pic:       defm "add.to.pic(%V,%L,%C,%X,%Y,%P,%M) "
 @add.to.pic.v:     defm "add.to.pic(v%V,v%L,v%C,v%X,v%Y,v%P,v%M) "
 @status:           defm "status() "
 @save.game:        defm "save.game() "
 @restore.game:     defm "restore.game() "
 @init.disk:        defm "init.disk "

 @restart.game:     defm "restart.game() "
 @show.obj:         defm "show.obj(%A) "
 @random:           defm "random(%L,%U,v%R) "
 @program.control:  defm "program.control() "
 @player.control:   defm "player.control() "
 @obj.status.v:     defm "obj.status(v%A) "
 @quit:             defm "quit(%M) "
 @show.mem:         defm "show.mem() "
 @pause:            defm "pause() "
 @echo.line:        defm "echo.line() "
 @cancel.line:      defm "cancel.line() "
 @init.joy:         defm "init.joy() "
 @toggle.monitor:   defm "toggle.monitor() "
 @version:          defm "version() "
 @script.size:      defm "script.size(%A) "
 @set.game.id:      defm "set.game.id(m%A) "

 @log:              defm "log(m%A) "
 @set.scan.start:   defm "set.scan.start() "
 @reset.scan.start: defm "reset.scan.start() "
 @reposition.to:    defm "reposition(o%A,%X,%Y) "
 @reposition.to.v:  defm "reposition(o%A,v%X,v%Y) "
 @trace.on:         defm "trace.on() "
 @trace.info:       defm "trace.info(%L,%T,%H) "
 @print.at:         defm "print.at(m%A,%R,%C,%W) "
 @print.at.v:       defm "print.at(v%A,%R,%C,%W) "
 @discard.view.v:   defm "discard.view(v%A) "
 @clear.text.rect:  defm "clear.text.rect(%R,%C,%R,%C,%C) "
 @set.upper.left:   defm "set.upper.left(%A,%B) "
 @set.menu:         defm "set.menu(m%A) "
 @set.menu.item:    defm "set.menu.item(m%A,c%B) "
 @submit.menu:      defm "submit.menu() "
 @enable.item:      defm "enable.item(c%A) "

 @disable.item:     defm "disable.item(c%A) "
 @menu.input:       defm "menu.input() "
 @show.obj.v:       defm "show.obj(v%A) "
 @open.dialog:      defm "open.dialog() "
 @close.dialog:     defm "close.dialog() "
 @mul.n:            defm "mul(v%A,%B) "
 @mul.v:            defm "mul(v%A,v%B) "
 @div.n:            defm "div(v%A,%B) "
 @div.v:            defm "div(v%A,v%B) "
 @close.window:     defm "close.window() "
 @set.simple:       defm "set.simple(s%A) "
 @push.script:      defm "push.script() "
 @pop.script:       defm "pop.script() "
 @hold.key:         defm "hold.key() "
 @set.pri.base:     defm "set.pri.base(%A) "
 @discard.sound:    defm "discard.sound(%A) "

 @hide.mouse:       defm "hide.mouse() "
 @allow.menu:       defm "allow.menu(%A) "
 @show.mouse:       defm "show.mouse() "
 @fence.mouse:      defm "fence.mouse(%X,%Y,%X,%Y) "
 @mouse.posn:       defm "mouse.pos(v%X,v%Y) "
 @release.key:      defm "release.key() "
 @adj.ego.move.to.xy: defm "adj.ego.move.to.xy() "

 @invalid:          defm "invalid "
 @else:             defm "else "
 @if:               defm "if "

@tests:

    defw @invalid
    defw @equaln
    defw @equalv
    defw @lessn
    defw @lessv
    defw @greatern
    defw @greaterv
    defw @isset
    defw @issetv
    defw @has
    defw @obj.in.room
    defw @posn
    defw @controller
    defw @have.key
    defw @said
    defw @compare.strings
    defw @obj.in.box
    defw @center.posn
    defw @right.posn

 @equaln:           defm "v%A==%B "
 @equalv:           defm "v%A==v%B "
 @lessn:            defm "v%A<%B "
 @lessv:            defm "v%A<v%B "
 @greatern:         defm "v%A>%B "
 @greaterv:         defm "v%A>v%B "
 @isset:            defm "f%A "
 @issetv:           defm "fv%A "
 @has:              defm "has(i%A) "
 @obj.in.room:      defm "obj.in.room(i%A,v%B) "
 @posn:             defm "posn(o%A,%X,%Y,%X,%Y) "
 @controller:       defm "controller(c%A) "
 @have.key:         defm "have.key() "
 @said:             defm "said(m%A) "
 @compare.strings:  defm "compare.strings(s%1,s%2) "
 @obj.in.box:       defm "obj.in.box(o%A,%X,%Y,%X,%Y) "
 @center.posn:      defm "center.posn(o%A,%X,%Y,%X,%Y) "
 @right.posn:       defm "right.posn(o%A,%X,%Y,%X,%Y) "