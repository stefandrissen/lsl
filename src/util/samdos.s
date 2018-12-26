; hook codes for samdos - from technical manual page 83

samdos.hgthd:			equ 129 ; get file header	
	; ix = uifa
	
samdos.hload:			equ 130 ; load file
	; ix = uifa
	; hl = destination (&8000 - &bfff)
	; c  = length (in 16k pages)
	; de = length (modulo 16k)
	
samdos.hrsad:			equ 160 ; read a sector from the disk 
	; d = track ( 0-79 / 128-207 )
	; e = sector ( 1 - 10 )
	; a = drive ( 1 - 2 )
	; hl = destination

samdos.dir.file_type:		equ	0
samdos.dir.filename:		equ 1
samdos.dir.first.track:		equ 13
samdos.dir.first.sector:	equ 14
	
; file types

samdos.filetype.code:	equ 19	; code file

; disk information file area

samdos.difa:			equ &4b50

; get starting track / sector 
; reads directory entries searching for file that matches data at ix (12 characters, space padded)

samdos.find.file:

	ld d,0
	ld e,1
@next.sector:	
	ld hl,samdos.buffer
	
	push hl
	push de
	ld a,1	
	
	push ix
	rst 8
	defb samdos.hrsad
	di
	pop ix
	
	ld b,10
	ld hl,samdos.buffer + samdos.dir.filename
@compare:
	push ix
	pop de
@loop:
	ld a,(de)
	cp (hl)
	jr nz,@different.1
	inc hl
	inc de
	djnz @loop

	pop de
	pop hl
	ld a, (samdos.buffer + samdos.dir.first.track)
	ld d,a
	ld a, (samdos.buffer + samdos.dir.first.sector)
	ld e,a
	or d	; set NZ
	
	ret	
	
@different.1:	
	ld b,10
	ld hl,samdos.buffer + samdos.dir.filename + 256
@compare:
	push ix
	pop de
@loop:
	ld a,(de)
	cp (hl)
	jr nz,@different.2
	inc hl
	inc de
	djnz @loop
	
	pop de
	pop hl
	ld a, (samdos.buffer + samdos.dir.first.track + 256)
	ld d,a
	ld a, (samdos.buffer + samdos.dir.first.sector + 256)
	ld e,a
	or d	; set NZ

	ret
	
@different.2:
	
	pop de
	pop hl
	
	inc e
	ld a,e
	cp 11
	jr c,@next.sector
	ld e,1
	inc d
	ld a,d
	cp 4
	jr c,@next.sector	
	
	ld de,0	
	xor a	; clear NZ
	
	ret
	
	
	ds align 256	
samdos.buffer:
	defs 512
	defs 510 ; second sector loaded at offset 510 of first sector to keep contiguous data block
	
