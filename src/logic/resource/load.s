; logic/resource/load.s
;
; load resource
;
; a  = resource
; hl = resource directory

include "util\samdos.s"

var.resource.start:		defw 0	; start address of last loaded resource
var.resource.length:	defw 0	; length of last loaded resource
@var.offset: 			defs 3
@var.sectors:			defb 0	; how many sectors loaded (1 or 2)

load.resource:

	push af
	push bc
	push de
	push hl
	
	ld hl,0
	ld (var.resource.length), hl
	
	if defined(debug)
		call util.print.hex

		ld hl,text.vol	
		call util.print.string		
	endif
	
	pop hl
	push hl

	ld b,0
	ld c,a
	add hl,bc
	add hl,bc
	add hl,bc		; hl = directory pointer
	
	ld a,(hl)
	and %11110000
	rrca
	rrca
	rrca
	rrca
	cp &f
	jp z,err.empty.entry	
	ld b,a 			; b = vol.#
	
	if defined(debug)
		call util.print.hex.nibble		
		ld a, ":"
		call util.print.char	
	endif
	
	ld a,(hl)	
	and %00001111	; a = 64k offset	
	ld (@var.offset + 2),a
	if defined(debug)
		call util.print.hex.nibble
	endif
	
	if defined(debug)
		inc hl
		ld a,(hl)
		call util.print.hex
		ld d,a
		inc hl
		ld a,(hl)
		call util.print.hex
		ld e,a
	else 
		inc hl
		ld d,(hl)
		inc hl
		ld e,(hl)
	endif	
	ex de,hl		; hl = offset			
	ld (@var.offset),hl
	
	if defined(debug)
		ld a, " "
		call util.print.char	
	endif

; now call samdos to load the file  - which fails miserably so let's:
; - scan directory for file name
; - get starting track / sector
; - assume file is sequential
; - calculate required track / sector
; - load enough sectors based on resource header

	ld a,b	
	ld ix,load.filename
	add a,"0"
	ld (ix+4),a
	call samdos.find.file
	
	jp z,empty_entry
	
	;d = track, e = sector	
	;ahl = offset 

	ld hl,(@var.offset)
	ld bc,9				; first sector contains 9 header bytes
	add hl,bc
	jr nc,@nc
	ld a,(@var.offset + 2)
	inc a
	ld (@var.offset + 2),a
@nc:	
	ld bc,510
@loop:
	or a		
	sbc hl,bc
	jr nc,@next

	ld a,(@var.offset + 2)
	cp 0
	jr z,@atoffset
	dec a
	ld (@var.offset + 2 ),a

@next:
	inc e
	ld a,e
	cp 11
	jr c,@loop
	ld e,1
	inc d
	ld a,d
	bit 7,d
	jr nz,@side_2
	cp 80
	jr c,@loop
	ld d,128
	jr @loop	
@side_2:
	cp 128 + 80
	jr c,@loop
	ld de,-1
	
@atoffset:	

	add hl,bc	

	if defined(debug)
		ld a,d
		call util.print.hex	
		ld a,e	
		call util.print.hex	
		ld a," "
		call util.print.char
	endif

	push hl
	push de	
	ld de, 510 - 5 ; sector size - header size
	or a
	sbc hl,de
	pop de
	jr nc,@onesector
	
	ld hl,samdos.buffer
	ld a,1
	rst 8
	defb samdos.hrsad
	di
	
	ld hl,samdos.buffer+510
	ld d,(hl)
	inc hl
	ld e,(hl)
	dec hl
	ld a,2
	jr @twosectors
	
@onesector:
	ld hl,samdos.buffer
	ld a,1
@twosectors:	
	ld (@var.sectors),a

	ld a,1		
	rst 8
	defb samdos.hrsad
	di
	
	pop ix	
	
	ld bc,samdos.buffer
	add ix,bc

; http://wiki.scummvm.org/index.php/AGI/Specifications/Formats#Vol2
;
; Byte  Meaning
; ----- -----------------------------------------------------------
; 0-1  Signature (0x12--0x34)
;  2   Vol number that the resource is contained in
; 3-4  Length of the resource taken from after the header
; ----- -----------------------------------------------------------		
	
	ld a,(ix+0)
	cp &12
	jp nz,err.invalid.header
	ld a,(ix+1)
	cp &34
	jp nz,err.invalid.header
	ld a,(load.filename+4)
	sub "0"	
	cp (ix+2)
	jp nz,err.invalid.header

	ld c,(ix+3)				; bc = length
	ld b,(ix+4)
	
	if defined(debug) 
		ld hl,text.length
		call util.print.string
		ld a,b
		call util.print.hex
		ld a,c
		call util.print.hex
	endif
	
	ld (var.resource.length),bc

	ld hl,(var.free)
	ld (var.resource.start),hl

	if defined(debug) 
		ld a," "
		call util.print.char
		ld a,h
		call util.print.hex
		ld a,l
		call util.print.hex	
		ld a,chr_linefeed
		call util.print.char
	endif
	
	; ix = start of resource header
	; bc = length
	
	push ix
	pop hl	
	ld de,5
	add hl,de	

	ex de,hl	; de = start of resource
	
	; minimum ( bytes left in disc buffer, resource length )	
	ld hl,samdos.buffer + 510
	ld a,(@var.sectors)
	dec a
	jr z,@one	
	ld hl,samdos.buffer + 510 * 2
@one:		; hl = at end of buffer
	or a
	sbc hl,de	; buffer end - start resource = bytes left in buffer - [ 505 - 1015 ]
@next:
	push hl
	sbc hl,bc	; bytes left in buffer - bytes needed 
	jr nc,@buffer.sufficient

	ld l,c
	ld h,b	; hl = bytes needed
	pop bc	
	or a
	sbc hl,bc
	push hl	; bytes needed
	
	ex de,hl		; hl = start of resource
	ld de,(var.free)	
	ldir
	ld (var.free),de
	
	; keep loading sectors until resource loaded

	ld d,(hl)
	inc hl
	ld e,(hl)
	
	ld hl,samdos.buffer

	ld a,1		
	rst 8
	defb samdos.hrsad
	di

	pop bc 		; bytes needed
	ld hl,510	; bytes in buffer
	ld de,samdos.buffer	
	
	jr @next
	
@buffer.sufficient:

	; block move buffer to resource area
	pop af		; toss bytes left in buffer
	ex de,hl	; hl = start of resource
	ld de,(var.free)	
	ldir
	ld (var.free),de

	jr @exit	
	
empty_entry:	

	add hl,bc

	ld a,d
	call util.print.hex	
	ld a,e
	call util.print.hex
	
	ld a," "
	call util.print.char
	ld a,h
	call util.print.hex
	ld a,l
	call util.print.hex	
@exit:
	pop hl
	pop de
	pop bc
	pop af
	
	ret

; ix = header
	
err.invalid.header:

	ld a,chr_linefeed
	call util.print.char	
	ld hl,text.invalid.header
	call util.print.string
	
	ld a,(ix+0)
	call util.print.hex
	ld a,(ix+1)
	call util.print.hex
	ld a,(ix+2)
	call util.print.hex	
	
	jr @err.exit
	
err.empty.entry:

;	ld hl,text.empty.entry
;	call util.print.string
	
	jr @err.exit
	
@err.exit:
	ld a,chr_linefeed
	call util.print.char
	jr @exit
	
	
text.vol:	
	defm " VOL."  	
	defb 0

text.length:
	defm "LEN:"
	defb 0
	
text.invalid.header:
	defm "INVALID HEADER: " 
	defb 0
	
	
load.filename:	defm "vol.#     "		; filename
