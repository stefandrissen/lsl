; view.s
;
; TODO
;   - priority
;   - mirroring
;   - optimize: transparent - just add instead of looping
;   - optimize: unpack view in usable format
;
;-------------------------------------------------------------------------------

    include "memory.i"

;-------------------------------------------------------------------------------

    dump page.view,0
    org 0

    jp 0

;-------------------------------------------------------------------------------

    include "section.i"

;-------------------------------------------------------------------------------
; indicates if object [0x00-0x0f] is active

objects.max:    equ 0x10

objects.active: defs objects.max
objects.active.high:    equ objects.active / 0x100

    ds align 0x100

objects:
objects.high: equ objects / 0x100

    defw object.0
    defw object.1
    defw object.2
    defw object.3
    defw object.4
    defw object.5
    defw object.6
    defw object.7
    defw object.8
    defw object.9
    defw object.a
    defw object.b
    defw object.c
    defw object.d
    defw object.e
    defw object.f

object.0:

    org 0

    object.no:              defb 0  ;

    object.x:               defb 0  ; x position
    object.y:               defb 0  ; y position
    object.prev.x:          defb 0
    object.prev.y:          defb 0

    object.width:           defb 0  ; x size (in pixels)
    object.height:          defb 0  ; y size (in pixels)
    object.prev.width:      defb 0  ;
    object.prev.height:     defb 0  ;

    object.view:            defb 0  ; current view
    object.ptr.view:        defw 0  ; pointer to start of view data

    object.loop:            defb 0  ; current loop
    object.loops:           defb 0  ; number of loops
    object.ptr.loop:        defw 0  ; pointer to start of loop data

    object.cel:             defb 0  ; current cel
    object.cels:            defb 0  ; number of cels
    object.ptr.cel:         defw 0  ; pointer to start of cel data

    object.cycle:           defb 0
        enum.cycle.normal:          equ 0
        enum.cycle.end.of.loop:     equ 1
        enum.cycle.reverse.loop:    equ 2
        enum.cycle.reverse.cycle:   equ 3
    object.cycle.time:      defb 0  ; cycle time (1/n gives the fraction of the maximum speed)
    object.cycle.count:     defb 0

    object.step.size:       defb 0  ; step size
    object.step.time:       defb 0  ; step time (1/n gives the fraction of the maximum speed)
    object.step.count:      defb 0

    object.direction:       defb 0  ; direction
        enum.direction.stationary:  equ 0
        enum.direction.north:       equ 1
        enum.direction.north.east:  equ 2
        enum.direction.east:        equ 3
        enum.direction.south.east:  equ 4
        enum.direction.south:       equ 5
        enum.direction.south.west:  equ 6
        enum.direction.west:        equ 7
        enum.direction.north.west:  equ 8

    object.motion:          defb 0
        enum.motion.normal:         equ 0
        enum.motion.wander:         equ 1
        enum.motion.follow.ego:     equ 2
        enum.motion.move.obj:       equ 3


    object.priority:        defb 0  ; priority

    object.move.x:          defb 0
    object.move.y:          defb 0
    object.move.doneflag:   defb 0  ; flag to set when at destination
    object.move.step.size:  defb 0

    object.flags:           defb 0  ; see below - 1 byte is enough

    object.flag.ignore_blocks:  equ 0
    object.flag.fixed_priority: equ 1
    object.flag.ignore_horizon: equ 2
    object.flag.cycling:        equ 3
    object.flag.on_water:       equ 4
    object.flag.ignore_objects: equ 5
    object.flag.on_land:        equ 6
    object.flag.loop_fixed:     equ 7

    object.length: equ $
    org object.0 + object.length

    object.1:   defs object.length
    object.2:   defs object.length
    object.3:   defs object.length
    object.4:   defs object.length
    object.5:   defs object.length
    object.6:   defs object.length
    object.7:   defs object.length
    object.8:   defs object.length
    object.9:   defs object.length
    object.a:   defs object.length
    object.b:   defs object.length
    object.c:   defs object.length
    object.d:   defs object.length
    object.e:   defs object.length
    object.f:   defs object.length

;===============================================================================
view.add.to.pic:
;
; input:
;   a'  viewno
;   l   loopno
;   h   celno
;   e   x
;   d   y
;   c   pri
;   b   margin
;
; https://wiki.scummvm.org/index.php?title=AGI/Specifications/View#ViewFormat
;-------------------------------------------------------------------------------

; add.to.pic(42,0,0,4,18,4,4);

    ex af,af'
    exx

    call @get.ptr.view.header.hl

    exx
    ld a,l          ; -> a = loop
    exx

    call @get.ptr.loop.header.hl

    exx
    ld a,h          ; -> a = celno
    exx

    call @get.ptr.cel.header.hl

;-------------------------------------------------------------------------------
@view.draw.cel:

    ; input
    ;   hl = cel header
    ;   e' = x
    ;   d' = y

    ld a,page.screen
    out (port.hmpr),a

    ld c,(hl)       ; width
    inc hl
    ld b,(hl)       ; height
    inc hl
    ld a,(hl)       ; transparency
    inc hl

    and 0x0f
    rlca
    rlca
    rlca
    rlca
    ld (@transparent+1),a

    ld c,a

    exx
    ld a,d          ; y
    exx
    sub b           ; height, y = /bottom/ of view

    ld de,ptr.screen + screen.offset.to.center
    srl a
    jr nc,@even
    set 7,e
@even:
    add a,d
    ld d,a

    exx
    ld a,e          ; x
    exx

    ld c,a          ; keep real x in c
    srl a
    add a,e
    ld e,a          ; e = screen x

@height:
    push de
    push bc
@width:
    ld a,(hl)       ; AX - X pixels of colour A
    inc hl
    or a
    jr z,@eol

    and 0x0f
    ld b,a

    dec hl
    ld a,(hl)
    inc hl
    and 0xf0
@transparent:
    cp 0
    jr nz,@pixel
@chunk.transparent:
    bit 0,c
    jr z,@even
    inc e
@even:
    inc c

    djnz @chunk.transparent

    jr @width

@pixel:
    ld (@even.pixel.colour+1),a
    rrca
    rrca
    rrca
    rrca
    ld (@odd.pixel.colour+1),a
@chunk:
    bit 0,c
    jr nz,@odd

    ld a,(de)
    and 0x0f
@even.pixel.colour:
    or 0
    ld (de),a
    jr @continue

@odd:
    ld a,(de)
    and 0xf0
@odd.pixel.colour:
    or 0
    ld (de),a
    inc e

@continue:
    inc c

    djnz @chunk

    jr @width
@eol:
    pop bc
    pop de
    bit 7,e
    jr z,@even
    res 7,e
    inc d
    jr @odd
@even:
    set 7,e
@odd:
    djnz @height

    ret

;===============================================================================
@get.ptr.view.header.hl:
;
; input
;   a = view
;
; output
;   hl = view header
;
; destroys: bc
;
; View header (7+ bytes)
;  Byte  Meaning
;  ----- -----------------------------------------------------------
;    0   Unknown (always seems to be either 1 or 2)
;    1   Unknown (always seems to be 1)
;    2   Number of loops
;   3-4  Position of description (more on this later)
;        Both bytes are 0 if there is no description
;   5-6  Position of first loop
;   7-8  Position of second loop (if any)
;   9-10 Position of third loop (if any)
;   ...  ...
;  ----- -----------------------------------------------------------
;
;-------------------------------------------------------------------------------

    ld l,a
    ld h,0
    add hl,hl
    add hl,hl
    add hl,hl
    ld bc,ptr.viewdir - 0x8000 + 3
    add hl,bc

    ld a,(hl)
    inc l
    ld h,(hl)
    ld l,a
    res 7,h         ; -> hl = view header

    ret

;===============================================================================
@get.ptr.loop.header.hl:
;
; input
;   a  = loop
;   hl = view header
;
; output
;   hl = loop header
;
; destroys: de
;
; Loop header (3+ bytes)
;  Byte  Meaning
;  ----- -----------------------------------------------------------
;    0   Number of cels in this loop
;   1-2  Position of first cel, relative to start of loop
;   3-4  Position of second cel (if any), relative to start of loop
;   5-6  Position of third cel (if any), relative to start of loop
;  ----- -----------------------------------------------------------
;
;-------------------------------------------------------------------------------

    push hl
    ld de,5
    add hl,de       ; -> hl = view header first loop entry

    ld e,a
    ld d,0

    add hl,de
    add hl,de       ; -> hl = required loop entry

    ld e,(hl)
    inc hl
    ld d,(hl)       ; -> de = offset first loop

    pop hl

    add hl,de       ; -> hl = loop header

    ret

;===============================================================================
@get.ptr.cel.header.hl:
;
; input
;   a  = cel
;   hl = loop header
;
; output
;   hl = cel header
;
; destroys: de
;
; Cel header (3 bytes)
;  Byte  Meaning
;  ----- -----------------------------------------------------------
;    0   Width of cel (remember that AGI pixels are 2 normal EGA
;        pixels wide so a cel of width 12 is actually 24 pixels
;        wide on screen)
;    1   Height of cel
;    2   Transparency (high nibble) and cel mirroring (low nibble)
;  ----- -----------------------------------------------------------
;
;-------------------------------------------------------------------------------

    push hl

    ld e,a
    ld d,0

    inc hl
    add hl,de
    add hl,de       ; -> hl = cel entry

    ld e,(hl)
    inc hl
    ld d,(hl)

    pop hl

    add hl,de       ; -> hl = cel header

    ret

;===============================================================================
view.animate.obj:
;-------------------------------------------------------------------------------

    ld (iy+object.no),b

    ld l,b
    ld h,objects.active.high
;    ld (hl),0       ; how does animate relate to draw?

    ret

;===============================================================================
view.unanimate.all:
;-------------------------------------------------------------------------------

    ld hl,objects.active
    ld b,objects.max
@loop:
    ld (hl),0
    inc l
    djnz @-loop

    ret

;===============================================================================
view.move.objects:
; called from main.game.loop
;-------------------------------------------------------------------------------

    ld a,page.screen
    out (port.hmpr),a

    ld hl,objects.active
    ld b,objects.max
@loop:
    ld a,(hl)
    or a

    jr z,@skip

    push hl
    push bc

    ld a,l
    call @object.get.iy

    call @view.draw

    pop bc
    pop hl

@skip:
    inc l

    djnz @-loop

    ret

;===============================================================================
view.draw:

    ld l,(iy+object.no)
    ld h,objects.active.high    ; animate or draw?
    ld (hl),1

@view.draw:
; input
;   iy = object

    ld l,(iy+object.ptr.loop+0)
    ld h,(iy+object.ptr.loop+1)

    ld a,(iy+object.cel)
    call @get.ptr.cel.header.hl

    exx

    ld e,(iy+object.x)
    ld d,(iy+object.y)

    ld c,(iy+object.priority)

    ld b,0  ; margin

    exx

    call @view.draw.cel

    ; update object

    inc (iy+object.cycle.count)
    ld a,(iy+object.cycle.count)
    cp (iy+object.cycle.time)
    jr c,@no.cycle

    ld a,0
    ld (iy+object.cycle.count),a

    ld a,(iy+object.cel)
    inc a
    cp (iy+object.cels)
    jr c,@cels.gt.cel
    ld a,0
@cels.gt.cel:
    ld (iy+object.cel),a

@no.cycle:

    inc (iy+object.step.count)
    ld a,(iy+object.step.count)
    cp (iy+object.step.time)
    jr c,@no.step

    ld a,0
    ld (iy+object.step.count),a

    ld a,(iy+object.motion)

    push af

    cp enum.motion.move.obj
    call z,@motion.move.obj

    ld a,(iy + object.direction)
    add a,a
    ld e,a

    pop af

    ld d,0
    ld hl,@update.x.y.direction
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a

    ld c,(iy+object.step.size)

    jp (hl)

@no.step:

    ret

;-------------------------------------------------------------------------------
@update.x.y.direction:

    defw @move.stationary
    defw @move.north
    defw @move.north.east
    defw @move.east
    defw @move.south.east
    defw @move.south
    defw @move.south.west
    defw @move.west
    defw @move.north.west

@move.stationary:
    ret

@move.north:
    ld a,(iy+object.y)
    sub c
    ld (iy+object.y),a
    ret

@move.north.east:
    call @move.north

@move.east:
    ld a,(iy+object.x)
    add c
    ld (iy+object.x),a
    ret

@move.south.east:
    call @move.east

@move.south:
    ld a,(iy+object.y)
    add c
    ld (iy+object.y),a
    ret

@move.south.west:
    call @move.south

@move.west:
    ld a,(iy+object.x)
    sub c
    ld (iy+object.x),a
    ret

@move.north.west:
    call @move.north
    jr @move.west

;-------------------------------------------------------------------------------

@obj.directions:

    defb enum.direction.north.west
    defb enum.direction.north
    defb enum.direction.north.east

    defb enum.direction.west
    defb enum.direction.stationary
    defb enum.direction.east

    defb enum.direction.south.west
    defb enum.direction.south
    defb enum.direction.south.east

;===============================================================================
@motion.move.obj:

    ld b,(iy+object.x)
    ld c,(iy+object.y)

    ld d,(iy+object.move.x)
    ld e,(iy+object.move.y)

    ld a,(iy+object.step.size)

    call @find.direction

    ld (iy + object.direction),a

    ld c,a
    ld a,(iy+object.no)
    or a
    jr nz,@not.ego

    ld a,page.main
    out (port.hmpr),a

    ld hl,main.var.ego_direction
    ld (hl),c

@not.ego:
    ld a,c
    cp enum.direction.stationary
    ret nz

    ld a,enum.motion.normal
    ld (iy + object.motion),a

    ld a,(iy + object.move.step.size)
    or a
    jr z,@step.size.not.set
    ld (iy + object.step.size),a
@step.size.not.set:

    ld a,page.main
    out (port.hmpr),a

    ld a,(iy+object.move.doneflag)
    call @view.set.flag

    ret

;-------------------------------------------------------------------------------
@view.set.flag:
;
;-------------------------------------------------------------------------------
    ld h,main.flags / 0x100 + 0x80

    ld l,a
    srl l
    srl l
    srl l

    and %00000111
    rlca
    rlca
    rlca
    or %11000110          ; set n,(hl)
    ld (@smc.bit+1),a

@smc.bit:
    set 0,(hl)  ; or res n,(hl) or bit n,(hl)

    ret

;-------------------------------------------------------------------------------
@find.direction:
; input
;   bc = xy
;   de = xy destination
;   a  = step size
;
; output
;   a = direction
;-------------------------------------------------------------------------------

    ld l,a

    ld a,d
    sub b
    call @distance.vs.step

    ld h,a

    ld a,e
    sub c
    call @distance.vs.step

    ld l,a
    rlca
    add a,l ; * 3
    add a,h
    ld l,a

    ld h,0
    ld de,@obj.directions

    add hl,de

    ld a,(hl)

    ret

;-------------------------------------------------------------------------------
@distance.vs.step:
; input
;   a = distance
;   l = step
; output
;   a = 0 step <= - distance
;       2 step <= distance
;       1
;-------------------------------------------------------------------------------

    bit 7,a
    jr z,@no.2  ; if distance is not negative, step cannot be smaller

    neg
    cp l
    jr c,@no.1

    ld a,0
    ret

@no.1:
    neg
@no.2:
    cp l
    jr c,@no.3

    ld a,2
    ret
@no.3:
    ld a,1
    ret

;===============================================================================
@object.get.iy:

;   a = object to get
;
; result
;   iy = structure
;-------------------------------------------------------------------------------

    ld h,objects.high
    rlca
    ld l,a
    ld a,(hl)
    inc l
    ld h,(hl)
    ld l,a

    push hl
    pop iy

    ret

;===============================================================================
; the following routines are all called by from logic.action.* via
; section.call.object with b indicating object
;
; iy points to the object structure

view.object.call:

    ld a,b
    push hl
    call @object.get.iy
    pop hl
    jp (hl)

;-------------------------------------------------------------------------------

view.observe.blocks:

    res object.flag.ignore_blocks,(iy + object.flags)
    ret

;-------------------------------------------------------------------------------
view.set.cel:

    ld (iy+object.cel),c
    ret

;-------------------------------------------------------------------------------
view.start.cycling:

    ; TODO
    ret

;-------------------------------------------------------------------------------
view.stop.cycling:

    ld (iy+object.cycle.time),0 ; TODO correct?
    ret

;-------------------------------------------------------------------------------
view.cycle.time:

    ld (iy + object.cycle.time),c
    ret

;-------------------------------------------------------------------------------
view.observe.horizon:

    res object.flag.ignore_horizon,(iy + object.flags)
    ret

;-------------------------------------------------------------------------------
view.ignore.objs:

    set object.flag.ignore_objects,(iy + object.flags)
    ret

;-------------------------------------------------------------------------------
view.observe.objs:

    res object.flag.ignore_objects,(iy + object.flags)
    ret

;-------------------------------------------------------------------------------
view.erase:

    ; TODO - first need back buffer in general

    ret

;-------------------------------------------------------------------------------
view.fix.loop:

    ; TODO - but since direction does not automatically choose loop, not
    ;        a problem yet

    ret

;-------------------------------------------------------------------------------
view.get.posn:

    ld e,(iy + object.x)
    ld d,(iy + object.y)
    ret

;-------------------------------------------------------------------------------
view.position:

    ld (iy + object.x),e
    ld (iy + object.y),d
    ret

;-------------------------------------------------------------------------------
view.reposition:

    call view.erase
    ld a,(iy+object.x)
    add e
    ld e,a
    ld a,(iy+object.y)
    add d
    ld d,a
    jr view.position

;-------------------------------------------------------------------------------
view.reposition.to:

    call view.erase
    jr view.position

;-------------------------------------------------------------------------------
view.set.priority:

    ld (iy + object.priority),c
    ret

;-------------------------------------------------------------------------------
view.step.size:

    ld (iy + object.step.size),c
    ret

;-------------------------------------------------------------------------------
view.step.time:

    ld (iy + object.step.time),c
    ret

;-------------------------------------------------------------------------------
view.current.view:

    ld c,(iy + object.view)
    ret

;-------------------------------------------------------------------------------
view.set.view:

    ld (iy + object.view),c

    ld a,c
    call @get.ptr.view.header.hl

    ld (iy + object.ptr.view + 0),l
    ld (iy + object.ptr.view + 1),h

    ld a,0
    jr @set.loop

;-------------------------------------------------------------------------------
view.set.loop:

    ld (iy + object.loop),c ; TODO check out of bounds

    ld l,(iy + object.ptr.view + 0)
    ld h,(iy + object.ptr.view + 1)

    ld a,c
@set.loop:
    call @get.ptr.loop.header.hl

    ld (iy + object.ptr.loop + 0),l
    ld (iy + object.ptr.loop + 1),h

    ld a,(hl)
    ld (iy + object.cels),a

    ld (iy + object.cel),0

    ret

;-------------------------------------------------------------------------------
view.move.obj:

    ld (iy + object.move.x),e
    ld (iy + object.move.y),d
    ld a,c
    or a
    jr z,@keep.step.size
    ld a,(iy + object.step.size)
    ld (iy + object.step.size),c
@keep.step.size:
    ld (iy + object.move.step.size),a
    ex af,af'
    ld (iy + object.move.doneflag),a

    ld (iy + object.motion),enum.motion.move.obj

    ret

;===============================================================================

    ds align 0x1000


;free.view:

;-------------------------------------------------------------------------------
