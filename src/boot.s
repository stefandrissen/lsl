; boot.s
;
; - loader
; - disk routines
;
; [C] 0x8000
;-------------------------------------------------------------------------------

    include "memory.i"
    include "util/ports.i"

; hook codes for samdos - from technical manual page 83

@samdos.hgthd:              equ 0x81    ; get file header
    ; ix = uifa

@samdos.hload:              equ 0x82    ; load file
    ; ix = uifa
    ; hl = destination [0x8000 - 0xbfff]
    ; c  = length (in 16k pages)
    ; de = length (modulo 16k)

@samdos.hrsad:              equ 0xa0    ; read a sector from the disk
    ; d = track  [0 - 79] / [128 - 207]
    ; e = sector [1 - 10]
    ; a = drive  [1 - 2]
    ; hl = destination [0x4000 - 0xfe00] -> page 0,1 or 2


@samdos.dir.file_type:      equ 0x00
@samdos.dir.filename:       equ 0x01
@samdos.dir.first.track:    equ 0x0d
@samdos.dir.first.sector:   equ 0x0e

samdos.sector.size:         equ 0x200

; file types

@samdos.filetype.code:      equ 0x13    ; code file

; user / disk information file area - in page 0

@samdos.uifa:               equ 0x4b00
    @samdos.uifa.length.pages:      equ 0x22
    @samdos.uifa.length.bytes:      equ 0x23
    @samdos.uifa.length.bytes.low:  equ 0x23    ; [0x00-0xff]
    @samdos.uifa.length.bytes.high: equ 0x24    ; [0x00-0x3f]

@samdos.difa:               equ 0x4b50

;-------------------------------------------------------------------------------

    dump page.boot,0
    org 0x8000

    autoexec

    jp @boot.init.high

;-------------------------------------------------------------------------------

obj.filename:       equ 0
obj.page:           equ 7
obj.ptr.dir:        equ 8
obj.free:           equ 10
obj.entries:        equ 12
obj.last.start:     equ 13

obj.logdir:
    defm "logdir "
    defb page.log
    defw ptr.logdir
    defw ptr.logdir
    defb 0              ; entries
    defw 0

obj.viewdir:
    defm "viewdir"
    defb page.view
    defw ptr.viewdir
    defw ptr.viewdir
    defb 0
    defw 0

obj.picdir:
    defm "picdir "
    defb page.pic
    defw ptr.picdir
    defw ptr.picdir
    defb 0
    defw 0

obj.snddir:
    defm "snddir "
    defb page.snd
    defw ptr.snddir
    defw ptr.snddir
    defb 0
    defw 0

;-------------------------------------------------------------------------------

@directories:
    defw obj.logdir
    defw obj.viewdir
    defw obj.picdir
    defw obj.snddir
    defw 0

;-------------------------------------------------------------------------------

@files:
    defw @file.main
    defw @file.pic
    defw @file.view
    defw 0

@file.main:
    defm "main"
    defb page.main

@file.pic:
    defm "pic"
    defb page.pic

@file.view:
    defm "view"
    defb page.view

;-------------------------------------------------------------------------------

@section.heap:

    ld a,page.heap - 1
    and low.memory.page.mask    ; https://github.com/simonowen/pyz80/issues/17
    out (port.lmpr),a           ; A:ROM + B:0

    ret

    align 0x100

;-------------------------------------------------------------------------------

@boot.init.high:

    di
    ld (@store.sp+1),sp

    in a,(port.vmpr)
    ld (@store.vmpr+1),a

    ld sp,stack.top + 0x8000
    call @relocate

    ld ix,@files
@loop:

    ld l,(ix+0)
    ld h,(ix+1)

    ld a,h
    or l
    jr z,@loaded

    inc ix
    inc ix

    push ix

    call @samdos.load.file

    pop ix

    jr @loop

@loaded:
    call @load.directories

    ld a,page.main | low.memory.ram.0
    out (port.lmpr),a

    call @update.sp
    defb -0x80

    rst 0

@store.sp:
    ld sp,0
@store.vmpr:
    ld a,0
    out (port.vmpr+1),a

    ei
    ret

;===============================================================================
@load.directories:
;-------------------------------------------------------------------------------

    ld hl,@directories
@loop:
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl

    ld a,e
    or d
    ret z

    push hl

    push de
    pop ix

    call @load.dir

    pop hl
    jr @-loop

;===============================================================================
@load.dir:

;   ix = obj.*
;
; *dir files are directories pointing to resource in vol.*
;
; documentation: http://wiki.scummvm.org/index.php/AGI/Specifications/Formats
;
; each entry is 3 bytes
; - first 4 bits indicate vol.#
; - next 20 bits are offset in vol.#
;
; VVVVPPPP PPPPPPPP PPPPPPPP
;
; when 0xffffff -> empty
;-------------------------------------------------------------------------------

    push ix
    pop hl

    ld e,(ix+obj.free+0)        ; destination
    ld d,(ix+obj.free+1)        ; destination

    push hl     ; -> pop ix
    push de     ; -> pop hl

    call @samdos.load.file.de   ; -> bc = length

    pop hl      ; <- push de (obj.free)
    pop ix      ; <- push hl

    push bc
    push hl

    ld l,c
    ld h,b

    xor a                       ; divide file size by 3 to get number of entries
    ld bc,3
@divide.by.3:
    inc a
    sbc hl,bc
    jr nz,@divide.by.3

    ld (ix+obj.entries),a       ; entries

    ld l,a
    ld h,0
    add hl,hl
    add hl,hl
    add hl,hl       ; entries * 8
    pop de          ; start address (push hl)
    add hl,de       ; -> hl = 1 byte past end address 8 byte entries

    ex de,hl

    pop bc

    add hl,bc       ; <- bc = length from load file, -> hl = 1 byte past end of file

    ld (ix+obj.free+0),e
    ld (ix+obj.free+1),d

    ld b,a

    ; space out directory 8 bytes per entry to accomodate add page + offset where loaded

    ld a,(ix+obj.page)
    or low.memory.ram.0
    out (port.lmpr),a

    res 7,h
    res 7,d

@outer.loop:
    push bc

    xor a
    ld b,5
@inner.loop:
    dec de
    ld (de),a
    djnz @-inner.loop

    ld b,3
@inner.loop:
    dec hl
    dec de
    ld a,(hl)
    ld (de),a
    djnz @-inner.loop

    pop bc
    djnz @-outer.loop

    ret

;-------------------------------------------------------------------------------

@var.resource.offset:   defs 3
@var.sectors:           defb 0      ; how many sectors loaded (1 or 2)

@vol.filename:          defm "vol.#     "

;===============================================================================
boot.load.resource:

; input
;   - ix  = obj.*dir
;   - b   = volume  'VOL #'
;   - ahl = offset of resource in volume [ 0x000000 - 0x0fffff ]
;-------------------------------------------------------------------------------

; ix obj has page + offset

    push ix

    ld (@var.resource.offset+0),hl
    ld (@var.resource.offset+2),a


; now call samdos to load the file  - which fails miserably so:
; - scan directory for file name
; - get starting track / sector
; - assume file is sequential
; - calculate required track / sector
; - load enough sectors based on resource header

    ld a,b                          ; -> a = vol.#
    ld ix,@vol.filename
    add a,"0"
    ld (ix+4),a                     ; vol.# <- a

    call @samdos.find.file          ; <- z = found, d = track, e = sector

    pop ix

@err.empty_entry:
    jr nz,@err.empty_entry

    call @calculate.sector          ; <- de / hl

    add hl,bc

    in a,(port.lmpr)
    push af
    call @section.heap
    call @update.sp
    defb -0x40

    call @read.sectors

    call @update.sp
    defb 0x40
    pop af
    out (port.lmpr),a

    ret

@update.sp:
    include "update.sp.s"

;===============================================================================
@calculate.sector:

; input
;   - d = track  start of file
;   - e = sector start of file
;   - (@var.resource.offset) = ahl
;
; output
;   - d = track  resource
;   - e = sector resource
;-------------------------------------------------------------------------------

    ld hl,(@var.resource.offset+0)
    ld bc,9                         ; first sector contains 9 byte header
    add hl,bc
    jr nc,@nc
    ld a,(@var.resource.offset+2)
    inc a
    ld (@var.resource.offset+2),a
@nc:
    ld bc,samdos.sector.size - 2
@loop:
    or a
    sbc hl,bc
    jr nc,@next

    ld a,(@var.resource.offset+2)
    dec a
    cp -1
    ret z           ; found

    ld (@var.resource.offset+2),a

@next:
    inc e
    ld a,e
    cp 11           ; 10 sectors per track
    jr c,@loop

    ld e,1
    inc d
    ld a,d
    and %01111111
    cp 80           ; 80 tracks per side
    jr c,@loop

    bit 7,d
    ld d,128        ; side 2
    jr z,@loop

@err.out.of.sectors:
    di
    halt

;===============================================================================
@err.invalid.header:
    di
    halt

;===============================================================================
@err.invalid.resource:
    di
    halt

;===============================================================================

@samdos.get.file.header:

    ld ix,@samdos.uifa
;-------------------------------------------------------------------------------
@samdos.get.file.header.ix:
;
;   ix -> uifa
;
; output
;   bc = length in bytes [0x0000-0x3fff] - pages ignored for now
;-------------------------------------------------------------------------------

    push af
    in a,(port.lmpr)
    ld (@+store.lmpr + 1),a
    ld a,low.memory.page.mask   ;A = ROM, B = 0
    out (port.lmpr),a
    pop af

    rst 8
    defb @samdos.hgthd

    di

    ld bc,(@samdos.difa + @samdos.uifa.length.bytes)
    ld a,b
    and %00111111
    ld b,a
@store.lmpr:
    ld a,0
    out (port.lmpr),a

    ret


;===============================================================================
@samdos.load.file:
;
;   hl -> file.name, terminated by page (< 0x20)
;-------------------------------------------------------------------------------
    ld de,0x8000
;-------------------------------------------------------------------------------
@samdos.load.file.de:
;
;   hl -> file.name, terminated by page (< 0x20)
;   de =  destination - 0 = use var.free

; output
;   bc = length
;-------------------------------------------------------------------------------

    push de

    call @section.heap

    ld de,@samdos.uifa
    ld a,@samdos.filetype.code
    ld (de),a
    inc de

    ld b,10
@loop:
    ld a,(hl)
    inc hl
    cp " "
    jr nc,@ok
    dec hl
    ld a," "
@ok:
    ld (de),a
    inc de
    djnz @loop

    ld a,(hl)           ; page
    push af

    call @samdos.get.file.header

    pop af
    pop de

    push bc

    call @update.sp
    defb -0x40          ; move sp to section B

    call @load.file

    call @update.sp
    defb 0x40           ; move sp back to section C

    pop bc

    ret

;===============================================================================
@samdos.find.file:

; reads directory entries searching for file
;   ix -> file name (12 characters, space padded)
;
; output
;   de = starting track / sector
;   z  = file found
;-------------------------------------------------------------------------------

    push hl

    ld d,0      ; track 0
    ld e,1      ; sector 1

@next.sector:

    push de
    push ix
    call @samdos.read.sector
    pop ix

    ld hl,samdos.buffer.C + @samdos.dir.filename
    call @compare
    jr z,@leave

    ld hl,samdos.buffer.C + 0x0100 + @samdos.dir.filename
    call @compare
    jr z,@leave

    pop de

    inc e       ; sector
    ld a,e
    cp 11
    jr c,@next.sector
    ld e,1
    inc d       ; track
    ld a,d
    cp 4
    jr c,@next.sector

@file.not.found:
    di
    halt

@leave:

    pop hl      ; toss push de
    pop hl

    ret

;-------------------------------------------------------------------------------
@compare:
;
; input
;   ix = uifa
;   hl = samdos.buffer + @samdos.dir.filename
; output
;   z  = matched
;   d  = track
;   e  = sector
;-------------------------------------------------------------------------------

    ld b,10
@compare:
    push ix
    pop de
@loop:
    ld a,(de)
    cp (hl)
    ret nz      ; different
    inc hl
    inc de
    djnz @loop

    inc l
    inc l

    ld d,(hl)   ; @samdos.dir.first.track
    inc l
    ld e,(hl)   ; @samdos.dir.first.sector

    xor a       ; set Z

    ret

;===============================================================================
@samdos.read.sector:
;
;   read sector into buffer
;
;   d = track
;   e = sector
;-------------------------------------------------------------------------------
    ld hl,samdos.buffer.C

    in a,(port.lmpr)
    ld (@+store.lmpr+1),a

    ld a,low.memory.page.mask   ;A = ROM, B = 0
    out (port.lmpr),a

    ld a,1                      ; drive [0-1]

    rst 8
    defb @samdos.hrsad

    di
@store.lmpr:
    ld a,0
    out (port.lmpr),a

    ret

;===============================================================================
@samdos.read.sector.np:
;
;   read sector into buffer - no paging
;
;   d = track
;   e = sector
;-------------------------------------------------------------------------------
    ld hl,samdos.buffer.B

;-------------------------------------------------------------------------------
@samdos.read.sector.np.hl:
;-------------------------------------------------------------------------------

    push ix

    ld a,1                      ; drive [0-1]

    rst 8
    defb @samdos.hrsad

    di

    pop ix

    ret

;===============================================================================
@relocate:
;-------------------------------------------------------------------------------
    call @section.heap

    ld hl,@boot.heap
    ld de,addr.heap
    ld bc,@boot.heap.length
    ldir

    ret


;===============================================================================
@boot.heap:
;-------------------------------------------------------------------------------

    org addr.heap

;===============================================================================
@load.file:
;
;   first call @samdos.find.file to populate difa
;
; input
;   a  = page
;   de = destination
;-------------------------------------------------------------------------------

    out (port.hmpr),a

    ex de,hl

    ld ix,@samdos.difa
    ld c,(ix+@samdos.uifa.length.pages)
    ld e,(ix+@samdos.uifa.length.bytes.low)
    ld d,(ix+@samdos.uifa.length.bytes.high)

    rst 8
    defb @samdos.hload

    di

    ld a,page.boot
    out (port.hmpr),a

    ret

;===============================================================================
@read.sectors:
;
; input
;   - ix = obj.*dir
;   - d  = track
;   - e  = sector
;   - hl = offset
;-------------------------------------------------------------------------------

    push hl                         ; -> pop hl

    push de
    ld de,samdos.sector.size - 5    ; sector size - header size
    or a
    sbc hl,de
    pop de
    jr nc,@onesector

    call @samdos.read.sector.np

    ld hl,samdos.buffer.B + samdos.sector.size - 2
    ld d,(hl)
    inc hl
    ld e,(hl)
    dec hl
    ld a,2
    jr @twosectors

@onesector:
    ld hl,samdos.buffer.B
    ld a,1
@twosectors:
    ld (@var.sectors),a

    call @samdos.read.sector.np.hl

    pop hl                          ; <- push hl

    ld bc,samdos.buffer.B
    add hl,bc                       ; start of resource in buffer

; http://wiki.scummvm.org/index.php/AGI/Specifications/Formats#Vol2
;
; Byte  Meaning
; ----- ------------------------------------------------------------------------
; 0-1   Signature (0x12--0x34)
;  2    Vol number that the resource is contained in
; 3-4   Length of the resource taken from after the header
; ----- ------------------------------------------------------------------------

    ld a,(hl)
    cp 0x12
    jp nz,@err.invalid.header

    inc hl
    ld a,(hl)
    cp 0x34
    jp nz,@err.invalid.header

    ld a,(@vol.filename+4)
    sub "0"
    inc hl
    cp (hl)
    jp nz,@err.invalid.header

    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)   ; bc = length
    inc hl

;    ld (ix+obj.last.length+0),c
;    ld (ix+obj.last.length+1),b

    ld a,(ix+obj.free+0)
    ld (ix+obj.last.start+0),a
    ld a,(ix+obj.free+1)
    ld (ix+obj.last.start+1),a

    ex de,hl        ; de = start of resource

    ; minimum ( bytes left in disc buffer, resource length )
    ld hl,samdos.buffer.B + samdos.sector.size - 2
    ld a,(@var.sectors)
    dec a
    jr z,@one
    ld hl,samdos.buffer.B + ( samdos.sector.size - 2 ) * 2
@one:               ; hl = at end of buffer
    or a
    sbc hl,de       ; buffer end - start resource = bytes left in buffer - [ 505 - 1015 ]
@next:
    push hl
    sbc hl,bc       ; bytes left in buffer - bytes needed
    jr nc,@buffer.sufficient

    ld l,c
    ld h,b          ; hl = bytes needed
    pop bc
    or a
    sbc hl,bc
    push hl         ; bytes needed

    ex de,hl        ; hl = start of resource

    ld a,page.boot
    out (port.hmpr),a

    ld e,(ix+obj.free+0)
    ld d,(ix+obj.free+1)

    ld a,b
    or c
    jr z,@edge.case

    ld a,(ix+obj.page)
    out (port.hmpr),a

    ldir

    ld a,page.boot
    out (port.hmpr),a
    ld (ix+obj.free+0),e
    ld (ix+obj.free+1),d

    ; keep loading sectors until resource loaded
@edge.case:
    ld d,(hl)
    inc hl
    ld e,(hl)

    call @samdos.read.sector.np

    pop bc                          ; bytes needed
    ld hl,samdos.sector.size - 2    ; bytes in buffer
    ld de,samdos.buffer.B

    jr @next

@buffer.sufficient:

    ; block move buffer to resource area
    pop af          ; toss bytes left in buffer
    ex de,hl        ; hl = start of resource

    ld a,page.boot
    out (port.hmpr),a

    ld e,(ix+obj.free+0)
    ld d,(ix+obj.free+1)

    ld a,(ix+obj.page)
    out (port.hmpr),a

    ldir

    ld a,page.boot
    out (port.hmpr),a

    ld (ix+obj.free+0),e
    ld (ix+obj.free+1),d

    ret

@boot.heap.length: equ $ - addr.heap

;-------------------------------------------------------------------------------
; buffer must be in 0x4000-0xfe00

    ds align 0x100

samdos.buffer.B:

    assert samdos.buffer.B >= 0x4000
    assert samdos.buffer.B <= 0x7fff

;    defs samdos.sector.size * 2

    org @boot.heap + @boot.heap.length

    ds align 0x100

samdos.buffer.C:

    assert samdos.buffer.C >= 0x8000
    assert samdos.buffer.C <= 0xbfff

;    defs samdos.sector.size * 2

;-------------------------------------------------------------------------------
