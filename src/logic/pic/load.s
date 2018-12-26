; load.pic

; a = picture resource to load

load.pic:

	push hl
	push de
	push bc
	push af		
	ld hl,(var.picdir)
	ld a,h
	or l
	call z,@load.resource.dir
	ld a,(var.picdir.entries)
	ld c,a	
	pop af
	cp c
	jr nc,@err.invalid.resource
	push af	
	call load.resource 
	pop af
@err.exit:
	pop bc
	pop de
	pop hl
	ret

@err.invalid.resource:

	push af
	ld a,chr_linefeed
	call util.print.char	
	ld hl,@text.invalid.resource
	call util.print.string
	call util.print.char	
	pop af
	
	jr @err.exit	
	
@text.invalid.resource:
	defm "INVALID RESOURCE"
	defb 0	

@load.resource.dir:

	ld ix,@uifa

	rst 8
	defb samdos.hgthd
	di
	
	ld a,(samdos.difa+36)	
	and %00111111
	ld d,a	
	ld a,(samdos.difa+35)
	ld e,a
	ld hl,(var.free)
	ld (var.picdir),hl
	push hl
	add hl,de
	ld (var.free),hl

	ld l,e
	ld h,d

	xor a
	ld bc,3
@loop:
	inc a
	sbc hl,bc
	jr nz,@loop
	
	ld (var.picdir.entries),a		
	
	ld ix,samdos.difa
	ld hl,(var.picdir)
	ld c,0
	
	rst 8
	defb samdos.hload
	di

	pop hl
	
	ret

	
@uifa:

	defb samdos.filetype.code
	defm "picdir    "
	defs 48 - 11
	