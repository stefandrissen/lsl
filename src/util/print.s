; print functions
; completely unoptimized stuff for now

util.print.x:	defb	0
util.print.y:	defb 	0

util.print.reset:

	push af
	xor a
	ld (util.print.x),a
	ld (util.print.y),a
	pop af
	ret

util.print.string:

	push af
	push hl
	ld a,(hl)
util.print.string.all:	
	call util.print.char
	inc hl
	ld a,(hl)
	cp 0
	jr nz, util.print.string.all	
	pop hl
	pop af
	ret

util.print.hex:

	push af
	rrca
	rrca
	rrca
	rrca
	call util.print.hex.nibble
	pop af
	push af	
	call util.print.hex.nibble	
	pop af
	ret

util.print.hex.nibble:

	and %00001111	
	sub 10
	jr c,util.print.hex.nibble.1
	add a, "A" 
	jr util.print.char
util.print.hex.nibble.1:
	add a, 10 + "0"
	jr util.print.char	
	

util.print.char:

	push hl	
	push de
	push bc
	push af	
	
	cp 32
	jr nc,util.print.normal
	
	;control codes
	
	cp chr_linefeed
	jr z,util.print.linefeed
	jp util.print.exit
	
util.print.normal:
	ld l,a
	
	in a,(port.low_memory)
	ld (util.print.char.low + 1), a
	in a,(port.video_memory)
	and %00011111
	or  %00100000	; ram in AB
	out (port.low_memory), a		
	
	ld a, (util.print.x)
	ld e,a
	add a,a
	add a,e	; x * 3 (1 byte = 2 pixels)
	ld e,a
	ld a, (util.print.y)
	add a,a
	add a,a	; y * 4 (128 bytes per row)
	ld d,a			
	push de	; screen address
	
	ld a,l	
	sub 32
	ld hl,util.print.font.table
	ld e,a 
	ld d,0 
	add hl,de
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	pop hl	; screen address
	ld b,8
util.print.char.loop:	
		ld a,(de)
		ld (hl),a
		inc l
		inc de
		ld a,(de)
		ld (hl),a 
		inc l
		inc de 
		ld a,(de)
		ld (hl),a 
		inc de 
		ld a,&80 - 2
		add a,l
		ld l,a
		jr nc,util.print.char.ok
		inc h
util.print.char.ok:
	djnz util.print.char.loop	

util.print.char.low:
	ld a,0
	out (port.low_memory), a
	
	ld a,(util.print.x)
	inc a
	cp 42
	jr c,util.print.x.ok
util.print.linefeed:	
	ld a,(util.print.y)	
	inc a
	cp 24
	jr c,util.print.y.ok		

	call util.keyboard.pause
	
	;scroll up one line	
	in a,(port.low_memory)
	ld (util.print.char.low2 + 1), a
	in a,(port.video_memory)
	and %00011111
	or  %00100000	; ram in AB
	out (port.low_memory), a
	ld hl,8 * 128
	ld de,0
	ld bc,8 * 128 * 23
	ldir	
util.print.char.low2:
	ld a,0
	out (port.low_memory), a
	ld a,23
	
util.print.y.ok:	
	ld (util.print.y),a	
	ld a,0
util.print.x.ok:
	ld (util.print.x),a
	
util.print.exit:	
	pop af
	pop bc
	pop de
	pop hl
	ret
	
util.print.font.table:
	defw 	chr_space,chr_exclaim,chr_todo,chr_todo,chr_todo,chr_todo,chr_todo,chr_todo	;32
	defw 	chr_todo,chr_todo,chr_todo,chr_todo,chr_todo,chr_todo,chr_dot,chr_slash 	;40	
	defw	chr_0,chr_1,chr_2,chr_3,chr_4,chr_5,chr_6,chr_7								;48
	defw	chr_8,chr_9,chr_colon,chr_todo,chr_todo,chr_todo,chr_todo,chr_todo			;56
	defw	chr_todo,chr_A,chr_B,chr_C,chr_D,chr_E,chr_F,chr_G							;64
	defw	chr_H,chr_I,chr_J,chr_K,chr_L,chr_M,chr_N,chr_O								;72
	defw	chr_P,chr_Q,chr_R,chr_S,chr_T,chr_U,chr_V,chr_W								;80
	defw    chr_X,chr_Y,chr_Z															;88
	
	
chr_linefeed: equ 10
	
chr_todo:
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &77,&77,&77	
chr_space:
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
chr_exclaim:
	defb &00,&00,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&00,&00
	defb &00,&f0,&00
	defb &00,&00,&00	
chr_dot:
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&f0,&00
	defb &00,&00,&00
chr_slash:
	defb &00,&00,&00
	defb &00,&00,&f0
	defb &00,&0f,&f0
	defb &00,&ff,&00
	defb &0f,&f0,&00
	defb &ff,&00,&00
	defb &f0,&00,&00
	defb &00,&00,&00	
chr_0:
	defb &00,&00,&00
	defb &0f,&ff,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &0f,&ff,&00
	defb &00,&00,&00	
chr_1:
	defb &00,&00,&00
	defb &00,&f0,&00
	defb &0f,&f0,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &0f,&ff,&00
	defb &00,&00,&00
chr_2:
	defb &00,&00,&00
	defb &0f,&ff,&00
	defb &f0,&00,&f0
	defb &00,&0f,&00
	defb &00,&f0,&00
	defb &0f,&00,&00
	defb &ff,&ff,&f0
	defb &00,&00,&00
chr_3:
	defb &00,&00,&00
	defb &0f,&ff,&00
	defb &f0,&00,&f0
	defb &00,&0f,&00
	defb &00,&00,&f0
	defb &f0,&00,&f0
	defb &0f,&ff,&00
	defb &00,&00,&00
chr_4:
	defb &00,&00,&00
	defb &00,&0f,&00
	defb &00,&ff,&00
	defb &0f,&0f,&00
	defb &f0,&0f,&00
	defb &ff,&ff,&f0
	defb &00,&0f,&00
	defb &00,&00,&00
chr_5:
	defb &00,&00,&00
	defb &ff,&ff,&f0
	defb &f0,&00,&00
	defb &ff,&ff,&00
	defb &00,&00,&f0
	defb &f0,&00,&f0
	defb &0f,&ff,&00
	defb &00,&00,&00
chr_6:
	defb &00,&00,&00
	defb &0f,&ff,&00
	defb &f0,&00,&00
	defb &ff,&ff,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &0f,&ff,&00
	defb &00,&00,&00
chr_7:
	defb &00,&00,&00
	defb &ff,&ff,&f0
	defb &00,&00,&f0
	defb &00,&0f,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&00,&00
chr_8:
	defb &00,&00,&00
	defb &0f,&ff,&00
	defb &f0,&00,&f0
	defb &0f,&ff,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &0f,&ff,&00
	defb &00,&00,&00
chr_9:
	defb &00,&00,&00
	defb &0f,&ff,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &0f,&ff,&f0
	defb &00,&00,&f0
	defb &0f,&ff,&00
	defb &00,&00,&00
chr_colon:
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&00,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&00,&00	

chr_A:
	defb &00,&00,&00
	defb &0f,&ff,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &ff,&ff,&f0
	defb &f0,&00,&f0
	defb &00,&00,&00
chr_B:
	defb &00,&00,&00
	defb &ff,&ff,&00
	defb &f0,&00,&f0
	defb &ff,&ff,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &ff,&ff,&00
	defb &00,&00,&00
chr_C:
	defb &00,&00,&00
	defb &0f,&ff,&00
	defb &f0,&00,&f0
	defb &f0,&00,&00
	defb &f0,&00,&00
	defb &f0,&00,&f0
	defb &0f,&ff,&00
	defb &00,&00,&00
chr_D:
	defb &00,&00,&00
	defb &ff,&ff,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &ff,&ff,&00
	defb &00,&00,&00
chr_E:
	defb &00,&00,&00
	defb &ff,&ff,&f0
	defb &f0,&00,&00
	defb &ff,&ff,&00
	defb &f0,&00,&00
	defb &f0,&00,&00
	defb &ff,&ff,&f0
	defb &00,&00,&00
chr_F:
	defb &00,&00,&00
	defb &ff,&ff,&f0
	defb &f0,&00,&00
	defb &ff,&ff,&00
	defb &f0,&00,&00
	defb &f0,&00,&00
	defb &f0,&00,&00
	defb &00,&00,&00
chr_G:
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
chr_H:
	defb &00,&00,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &ff,&ff,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &00,&00,&00
chr_I:
	defb &00,&00,&00
	defb &0f,&ff,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &0f,&ff,&00
	defb &00,&00,&00
chr_J:
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
chr_K:
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
chr_L:
	defb &00,&00,&00
	defb &f0,&00,&00
	defb &f0,&00,&00
	defb &f0,&00,&00
	defb &f0,&00,&00
	defb &f0,&00,&00
	defb &ff,&ff,&f0
	defb &00,&00,&00
chr_M:
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
chr_N:
	defb &00,&00,&00
	defb &f0,&00,&f0
	defb &ff,&00,&f0
	defb &ff,&f0,&f0
	defb &f0,&ff,&f0
	defb &f0,&0f,&f0
	defb &f0,&00,&f0
	defb &00,&00,&00
chr_O:
	defb &00,&00,&00
	defb &0f,&ff,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &0f,&ff,&00
	defb &00,&00,&00
chr_P:
	defb &00,&00,&00
	defb &ff,&ff,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &ff,&ff,&00
	defb &f0,&00,&00
	defb &f0,&00,&00
	defb &00,&00,&00
chr_Q:
	defb &00,&00,&00
	defb &0f,&ff,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &0f,&ff,&00
	defb &00,&00,&f0
chr_R:
	defb &00,&00,&00
	defb &ff,&ff,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &ff,&ff,&00
	defb &f0,&0f,&00
	defb &f0,&00,&f0
	defb &00,&00,&00
chr_S:
	defb &00,&00,&00
	defb &0f,&ff,&00
	defb &f0,&00,&00
	defb &0f,&ff,&00
	defb &00,&00,&f0
	defb &f0,&00,&f0
	defb &0f,&ff,&00
	defb &00,&00,&00
chr_T:
	defb &00,&00,&00
	defb &ff,&ff,&f0
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &00,&00,&00
chr_U:
	defb &00,&00,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &0f,&ff,&00
	defb &00,&00,&00
chr_V:
	defb &00,&00,&00
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &f0,&00,&f0
	defb &0f,&0f,&00
	defb &00,&f0,&00
	defb &00,&00,&00
chr_W:
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
chr_X:
	defb &00,&00,&00
	defb &f0,&00,&f0
	defb &0f,&0f,&00
	defb &00,&f0,&00
	defb &00,&f0,&00
	defb &0f,&0f,&00
	defb &f0,&00,&f0
	defb &00,&00,&00
chr_Y:
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
chr_Z:
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00
	defb &00,&00,&00

	
	
	
	
	
		
	
	
	
	
	
	
	