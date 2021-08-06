; pic.s
;
; draw a picture - code located at start of page containing pictures
;
; TODO
;   - draw priority screen
;
;-------------------------------------------------------------------------------

    include "memory.i"

;-------------------------------------------------------------------------------

    dump page.pic,0
    org 0

    jp 0

;-------------------------------------------------------------------------------

    include "section.i"

;-------------------------------------------------------------------------------

; [name]    pic/draw.s
;
; TODO      draw priority screen
;           improve performance fill routine
;           1.5 wide pixels?
;
; takes A as a parameter for which picture to draw, but I am not storing /which/
; pictures were loaded at the moment - for another day

; http://wiki.scummvm.org/index.php/AGI/Specifications/Pic


@var.picture.color:         defb 0
@var.picture.draw.enabled:  defb 0

@var.priority.color:        defb 0
@var.priority.draw.enabled: defb 0



;===============================================================================
pic.draw:
;
; input
;   c = picture to draw
;-------------------------------------------------------------------------------

    ld l,c
    ld h,0
    add hl,hl
    add hl,hl
    add hl,hl   ; * 8

    ld a,page.boot
    out (port.hmpr),a

    ld ix,obj.picdir
    ld c,(ix + obj.ptr.dir + 0)
    ld b,(ix + obj.ptr.dir + 1)
    res 7,b
    add hl,bc

    inc l
    inc l
    inc l
    ld a,(hl)
    inc l
    ld h,(hl)
    ld l,a

    res 7,h                             ; pic is in AB with this code
    push hl
    pop ix

    ld a,page.screen.draw
    out (port.hmpr),a

    call @clear.screen

@main.loop:
    ld a,(ix)
    inc ix

    sub @command.minimum
    jr c,@err.picture

    add a,a
    ld e,a
    ld d,0
    ld hl,@commands
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld hl,@main.loop
    push hl
    ex de,hl
    jp (hl)

@exit:

    ret

@command.exit:

    pop hl          ; toss @loop
    jr @exit


if defined( picdraw-debug )

    @pause:

        push af
        push hl
        push de

        ld a,(@var.picture.draw.enabled)
        or a
        jr z,@no.pause

        push ix
        pop hl
        ld de,0x9633
        sbc hl,de
        jr c,@no.pause
        add hl,de

        call util.print.reset

        call util.print.hl
        ld a,":"
        call util.print.char
        ld a,(ix)
        call util.print.hex

        call util.print.lf
        call util.print.lf

        ld a,(ix+1)
        call util.print.hex
        call util.print.space
        ld a,(ix+2)
        call util.print.hex
        call util.keyboard.pause
    @no.pause:

        pop de
        pop hl
        pop af

        ret

endif

@err.picture:

    if defined( picdraw-debug )
        ld e,a
        ld hl,@text.error
        call util.print.string
        call util.print.ix
        call util.print.space
        ld a,e
        add @command.minimum
        call util.print.hex
        call util.print.lf
    else
        jr @err.picture
    endif

    jr @exit

@text.error:
    defm "ERROR: "
    defb 0

; 0xf0 - 0xff
@command.minimum: equ 0xf0
@commands:
    defw @change.picture.color.and.enable.picture.draw      ; 0xf0
    defw @disable.picture.draw                              ; 0xf1
    defw @change.priority.color.and.enable.priority.draw    ; 0xf2
    defw @disable.priority.draw                             ; 0xf3
    defw @draw.y.corner                                     ; 0xf4
    defw @draw.x.corner                                     ; 0xf5
    defw @absolute.line                                     ; 0xf6
    defw @relative.line                                     ; 0xf7
    defw @fill                                              ; 0xf8
    defw @change.pen.size.and.style                         ; 0xf9 - sq2 only
    defw @plot.with.pen                                     ; 0xfA - sq2 only
    defw @command.exit
    defw @command.exit
    defw @command.exit
    defw @command.exit
    defw @command.exit


; EGA 0-63 per channel, SAM 0-3 per channel (+ bright)

@palette:           ; Code  Color             R    G    B
        ; GRB!grb     ----- ---------------- ---- ---- ----
    defb %0000000   ;   0   black            0x00,0x00,0x00
    defb %0010000   ;   1   blue             0x00,0x00,0x2a
    defb %1000000   ;   2   green            0x00,0x2a,0x00
    defb %1010000   ;   3   cyan             0x00,0x2a,0x2a
    defb %0100000   ;   4   red              0x2a,0x00,0x00
    defb %0110000   ;   5   magenta          0x2a,0x00,0x2a
    defb %0100100   ;   6   brown            0x2a,0x15,0x00
    defb %1110000   ;   7   light grey       0x2a,0x2a,0x2a
    defb %0000111   ;   8   dark drey        0x15,0x15,0x15
    defb %0010111   ;   9   light blue       0x15,0x15,0x3f
    defb %1000111   ;  10   light green      0x15,0x3f,0x15
    defb %1010111   ;  11   light cyan       0x15,0x3f,0x3f
    defb %0100111   ;  12   light red        0x3f,0x15,0x15
    defb %0110111   ;  13   light magenta    0x3f,0x15,0x3f
    defb %1100111   ;  14   yellow           0x3f,0x3f,0x15
    defb %1110111   ;  15   white            0x3f,0x3f,0x3f

@change.picture.color.and.enable.picture.draw:

    ld a,1
    ld (@var.picture.draw.enabled),a
    ld a,(ix)
    inc ix
    ld (@var.picture.color),a

    ret

@disable.picture.draw:

    xor a
    ld (@var.picture.draw.enabled),a

    ret

@change.priority.color.and.enable.priority.draw:

    ld a,1
    ld (@var.priority.draw.enabled),a
    ld a,(ix)
    inc ix
    ld (@var.priority.color),a

    ret

@disable.priority.draw:

    xor a
    ld (@var.priority.draw.enabled),a

    ret

@draw.y.corner:

    ld e,(ix)       ; x
    inc ix
    ld d,(ix)       ; y
    inc ix
    call @plot.xy
@params.y.corner:
    ld a,(ix)
    cp @command.minimum
    ret nc
    inc ix

@y.loop.y:
    cp d
    jr z,@y.done.y
    jr c,@d.gt.a
    inc d
    jr @a.gt.d
@d.gt.a:
    dec d
@a.gt.d:
    push af
    call @plot.xy
    pop af
    jr @y.loop.y

@y.done.y:
    ld a,(ix)
    cp @command.minimum
    ret nc
    inc ix
@y.loop.x:
    cp e
    jr z,@params.y.corner
    jr c,@e.gt.a
    inc e
    jr @a.gt.e
@e.gt.a:
    dec e
@a.gt.e:
    push af
    call @plot.xy
    pop af
    jr @y.loop.x


@draw.x.corner:

    ld e,(ix)   ; x
    inc ix
    ld d,(ix)   ; y
    inc ix

    call @plot.xy
    jr @y.done.y

@var.dx:    defb 0
@var.dy:    defb 0
@var.D:     defb 0

@absolute.line:

; Function: Draws lines between points.
; The first two arguments are the starting coordinates.
; The remaining arguments are in groups of two which give the coordinates of the next location to draw a line to.
; There can be any number of arguments but there should always be an even number.

    ld e,(ix+0)     ; picX1
    ld d,(ix+1)     ; picY1

    call @plot.xy

@al.next:

    inc ix
    inc ix

    ld a,(ix+0)     ; picX2
    cp @command.minimum
    ret nc

    cp e
    jp z,@VLineDraw

    ld a,(ix+1)     ; picY2
    cp d
    jp z,@HLineDraw

    ld a,(ix+0)     ; picX2
    sub e           ; picX1
    ld (@var.xDiff),a
    jr nc,@else.1
    neg
    ld (@var.xDiff),a
    ld a,-1
    jr @endif.1
@else.1:
    ld a,1
@endif.1:
    ld (@var.dirX),a

    ld a,(ix+1)     ; picY2
    sub d           ; picY1
    ld (@var.yDiff),a
    jr nc,@else.2
    neg
    ld (@var.yDiff),a
    ld a,-1
    jr @endif.2
@else.2:
    ld a,1
@endif.2:
    ld (@var.dirY),a

    ld a,(@var.yDiff)
    ld b,a
    ld a,(@var.xDiff)
    sub b
    jr nc,@else.3
    ld a,b  ; yDiff
    ld (@var.lineLen),a
    ld (@var.wide),a
    srl a
    ld (@var.dcX),a
    jr @endif.3
@else.3:
    ld a,(@var.xDiff)
    ld (@var.lineLen),a
    ld (@var.wide),a
    srl a
    ld (@var.dcY),a
@endif.3:

@do:
    ld a,(@var.xDiff)
    ld b,a
    ld a,(@var.dcX)
    add b
    ld (@var.dcX),a
    ld c,a
    ld a,(@var.wide)
    ld b,a
    ld a,c
    sub b
    jr c,@endif.4

    ld (@var.dcX),a
    ld a,(@var.dirX)
    add e
    ld e,a

@endif.4:


    ld a,(@var.yDiff)
    ld b,a
    ld a,(@var.dcY)
    add b
    ld (@var.dcY),a
    ld c,a
    ld a,(@var.wide)
    ld b,a
    ld a,c
    sub b
    jr c,@endif.5

    ld(@var.dcY),a
    ld a,(@var.dirY)
    add d
    ld d,a

@endif.5:

    call @plot.xy

    ld a,(@var.lineLen)
    dec a
    ld (@var.lineLen),a

    jr nz,@do

    ld (@var.wide),a
    ld (@var.lineLen),a
    ld (@var.dirX),a
    ld (@var.dirY),a
    ld (@var.xDiff),a
    ld (@var.yDiff),a
    ld (@var.dcX),a
    ld (@var.dcY),a

    jp @al.next

@VLineDraw:

    ld a,(ix+1)
    sub d
    jp z,@al.next

    jr nc,@VLineDrawDown

    ld a,d
    sub (ix+1)
    ld b,a
@loop.1:
    dec d
    call @plot.xy
    djnz @loop.1
    jp @al.next

@VLineDrawDown:

    ld b,a
@loop.2:
    inc d
    call @plot.xy
    djnz @loop.2
    jp @al.next

@HLineDraw:

    ld a,(ix+0)
    sub e
    jr nc,@HLineDrawRight

    ld a,e
    sub (ix+0)
    ld b,a
@loop.3:
    dec e
    call @plot.xy
    djnz @loop.3
    jp @al.next

@HLineDrawRight:

    ld b,a
@loop.4:
    inc e
    call @plot.xy
    djnz @loop.4
    jp @al.next


@var.wide:      defb 0
@var.lineLen:   defb 0
@var.dirX:      defb 0
@var.dirY:      defb 0
@var.xDiff:     defb 0
@var.yDiff:     defb 0
@var.dcX:       defb 0
@var.dcY:       defb 0


@error.out.of.bounds:

if defined( picdraw-debug )

    ld hl,@text.error
    call util.print.string
    ld a,e
    call util.print.hex
    ld a,d
    call util.print.hex

    call util.keyboard.pause

    ret
else
    jr @error.out.of.bounds

endif

@plot.xy:

    ;e = x [ 0-159 ]
    ;d = y [ 0-199 ]

    if defined( debug )

        ld a,e
        cp 160
        jr nc,@error.out.of.bounds

        ld a,d
        cp 200
        jr nc,@error.out.of.bounds

    endif


    ld a,(@var.picture.draw.enabled)
    or a
    ret z

    push hl
    push de

    ld a,e
    srl a
    add screen.offset.to.center
    ld l,a

    ld a,d
    srl a
    ld h,a
    set 7,h
    jr nc,@even.row
    set 7,l
@even.row:
    bit 0,e
    jr nz,@even.pixel

    ld a,(hl)
    and %00001111
    ld e,a
    ld a,(@var.picture.color)
    rlca
    rlca
    rlca
    rlca
    or e
    ld (hl),a
    pop de
    pop hl
    ret

@even.pixel:
    ld a,(hl)
    and %11110000
    ld e,a
    ld a,(@var.picture.color)
    or e
    ld (hl),a
    pop de
    pop hl
    ret

@relative.line:

    ;set data for an absolute line

    ld e,(ix)       ; x
    inc ix
    ld d,(ix)       ; y
    inc ix

    ld a,(ix)
    cp @command.minimum
    jr c,@rl.go

    call @plot.xy
    ret

@rl.params:

    ld a,(ix)
    cp @command.minimum
    ret nc
@rl.go:
    inc ix

    push ix
    ld ix,@rl.abs.line
    ld (ix+0),e
    ld (ix+1),d

    ld c,a
    and %11110000
    rrca
    rrca
    rrca
    rrca
    bit 3,a
    jr nz,@x.neg
    add e
    jr @x
@x.neg:
    res 3,a
    ld b,a
    ld a,e
    sub b
@x:
    ld (ix+2),a

    ld a,c
    and %00001111
    bit 3,a
    jr nz,@y.neg
    add d
    jr @y
@y.neg:
    res 3,a
    ld b,a
    ld a,d
    sub b
@y:
    ld (ix+3),a

    call @absolute.line

    pop ix

    jr @rl.params

@rl.abs.line:
    defb 0,0,0,0,0xff


; Function: Flood fill from the locations given. Arguments are given in groups
; of two bytes which give the coordinates of the location to start the fill at.
; If picture drawing is enabled then it flood fills from that location on the
; picture screen to all pixels locations that it can reach which are white in
; color. The boundary is given by any pixels which are not white.

; currently recursive stack based
; next: queue based https://github.com/Yonaba/FloodFill/blob/master/floodfill/flood4stack.lua

@fill:

    ;e = x [ 0-159 ]
    ;d = y [ 0-199 ]

    ld a,(ix)
    cp @command.minimum
    ret nc

    ld e,(ix)       ; x
    inc ix
    ld d,(ix)       ; y
    inc ix

    ld a,(@var.picture.draw.enabled)
    or a

    call nz,@fill.q
@skip:
    jr @fill

@fill.q:

    call @white.xy
    ret nz

    ld (@q.start + 1),sp
    push de

@fill.q.loop:

    or a
@q.start:
    ld hl,0
    sbc hl,sp
    ret z

    pop de

    call @white.xy
    jr nz,@fill.q.loop

    ld c,e
@go.west:
    dec e
    call @white.xy
    jr z,@go.west

    ld b,e      ; b = west

    ld e,c
@go.east:
    inc e
    call @white.xy
    jr z,@go.east

    ld c,e      ; c = east

    ld e,b      ; e = west

    ld l,0      ; l = push state

@loop:
    inc e
    ld a,e
    cp c
    jr nc,@fill.q.loop

    call @plot.xy

    dec d
    ld a,d
    cp -1           ; check on y out of bounds can be solved by adding white boundary
    jr z,@no.north

    call @white.xy
    jr nz,@no.north
    bit 0,l
    jr nz,@+continue
    push de         ; should only push when previous pixel was not pushed
    set 0,l
    jr @+continue
@no.north:
    res 0,l
@continue:
    inc d
    inc d
    call @white.xy
    jr nz,@no.south
    bit 1,l
    jr nz,@+continue
    push de         ; should only push when previous pixel was not pushed
    set 1,l
    jr @+continue
@no.south:
    res 1,l
@continue:
    dec d
    jr @loop


@fill.recursive:

    call @white.xy
    ret nz
    call @plot.xy               ; x, y

    inc e
    call @fill.recursive        ; x + 1, y
    dec e

    dec e
    call @fill.recursive        ; x - 1, y
    inc e

    inc d
    call @fill.recursive        ; x, y + 1
    dec d

    dec d
    call @fill.recursive        ; x, y - 1
    inc d

    ret

; check color at xy matches white (15) - returns Z when match

@white.xy:

    ;e = x [ 0-159 ]
    ;d = y [ 0-199 ]

    push hl
    push de

    ld a,e
    srl a
    add screen.offset.to.center
    ld l,a

    ld a,d
    srl a
    ld h,a
    set 7,h
    jr nc,@even.row
    set 7,l
@even.row:
    bit 0,e
    ld e,%00001111
    jr nz,@odd.pixel
    ld e,%11110000
@odd.pixel:
    ld a,(hl)
    and e
    cp e
    pop de
    pop hl
    ret

@change.pen.size.and.style: ;sq2 only

@plot.with.pen: ;sq2 only

@eat.params:
    ld a,(ix)
    cp @command.minimum
    ret nc
    inc ix
    jr @eat.params

;-------------------------------------------------------------------------------

@clear.screen:

    ld hl,@palette + 15
    ld c,port.clut
    ld b,16
    otdr

    ld hl,ptr.screen
    ld de,ptr.screen+1
    ld b,168
@cls:
    push bc
    ld bc,screen.offset.to.center
    ld a,0x00       ; black
    ld (hl),a
    ldir
    ld bc,80
    ld a,0xff       ; white
    ld (hl),a
    ldir
    ld bc,screen.offset.to.center - 1
    ld a,0x00       ; black
    ld (hl),a
    ldir
    inc hl
    inc de
    pop bc
    djnz @cls

    ret

    assert $ <= 0x1000

    ds align &1000

pic.free:
;-------------------------------------------------------------------------------
