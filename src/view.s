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

    include "section.i"

;-------------------------------------------------------------------------------
    defs 0x0038 - $
;-------------------------------------------------------------------------------
masked.interrupt:

    ret

;-------------------------------------------------------------------------------
    defs 0x0066 - $
;-------------------------------------------------------------------------------
non.masked.interrupt:

    ret

;-------------------------------------------------------------------------------

    align 0x100

stack:

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

    object.x:               defb 0  ; x position
    object.y:               defb 0  ; y position

    object.view:            defb 0  ; current view
    object.ptr.view:        defw 0  ; pointer to start of view data

    object.loop:            defb 0  ; current loop
    object.loops:           defb 0  ; number of loops
    object.ptr.loop:        defw 0  ; pointer to start of loop data

    object.cel:             defb 0  ; current cel
    object.cels:            defb 0  ; number of cels
    object.ptr.cel:         defw 0  ; pointer to start of cel data

    object.cycle_time:      defb 0  ; cycle time (1/n gives the fraction of the maximum speed)
    object.step_time:       defb 0  ; step time (1/n gives the fraction of the maximum speed)
    object.width:           defb 0  ; x size (in pixels)
    object.height:          defb 0  ; y size (in pixels)
    object.step_size:       defb 0  ; step size
    object.direction:       defb 0  ; direction
    object.priority:        defb 0  ; priority

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

    ld l,c
    ld h,objects.active.high
    ld (hl),1

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

    call nz,view.draw

    inc l

    djnz @-loop

    ret

;===============================================================================
view.draw:
; input
;   l = object
;-------------------------------------------------------------------------------

    push hl
    push bc

    ld a,l
    call @object.get.iy

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

    ld a,(iy+object.cel)
    inc a
    cp (iy+object.cels)
    jr c,@cels.gt.cel
    ld a,0
@cels.gt.cel:
    ld (iy+object.cel),a

    pop bc
    pop hl

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

    ld (iy+object.cycle_time),0 ; TODO correct?
    ret

;-------------------------------------------------------------------------------
view.cycle.time:

    ld (iy + object.cycle_time),c
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
view.set.priority:

    ld (iy + object.priority),c
    ret

;-------------------------------------------------------------------------------
view.step.size:

    ld (iy + object.step_size),c
    ret

;-------------------------------------------------------------------------------
view.step.time:

    ld (iy + object.step_time),c
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

;===============================================================================

    ds align 0x1000


;free.view:

;-------------------------------------------------------------------------------
