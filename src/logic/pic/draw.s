; draw.pic

; takes A as a parameter for which picture to draw, but I am not storing /which/ pictures were loaded at the moment - for another day

; http://wiki.scummvm.org/index.php/AGI/Specifications/Pic

if defined(test-draw)

		org 32768
		dump 1,0
		
		autoexec
		
		di
		ld (@sp+1),sp
		ld sp,0
		call draw.pic
		call @exit
	@sp:	
		ld sp,0
		ei
		ret
		
	var.resource.start:	defw @draw.test

	@draw.command.picture.color:	equ &f0
	@draw.command.picture.off:		equ &f1
	@draw.command.priority.color:	equ &f2
	@draw.command.priority.off:		equ &f3
	@draw.command.y.corner:			equ &f4
	@draw.command.x.corner:			equ &f5
	@draw.command.absolute.line:	equ &f6
	@draw.command.relative.line:	equ &f7
	@draw.command.fill:				equ &f8
	@draw.command.exit:				equ &ff

	if defined(draw-line-test)
	
		@draw.test:
			defb @draw.command.picture.color, 15
			defb @draw.command.absolute.line, 128, 96, 128     , 96 - 64	; N
			defb @draw.command.absolute.line, 128, 96, 128 + 20, 96 - 40	; NNE
			defb @draw.command.absolute.line, 128, 96, 128 + 48, 96 - 48	; NE
			defb @draw.command.absolute.line, 128, 96, 128 + 40, 96 - 20	; ENE
			defb @draw.command.absolute.line, 128, 96, 128 + 64, 96			; E
			defb @draw.command.absolute.line, 128, 96, 128 + 40, 96 + 20	; ESE
			defb @draw.command.absolute.line, 128, 96, 128 + 48, 96 + 48	; SE
			defb @draw.command.absolute.line, 128, 96, 128 + 20, 96 + 40	; SSE
			defb @draw.command.absolute.line, 128, 96, 128     , 96 + 64	; S
			defb @draw.command.absolute.line, 128, 96, 128 - 20, 96 + 40	; SSW
			defb @draw.command.absolute.line, 128, 96, 128 - 48, 96 + 48	; SW
			defb @draw.command.absolute.line, 128, 96, 128 - 40, 96 + 20	; WSW		
			defb @draw.command.absolute.line, 128, 96, 128 - 64, 96			; W
			defb @draw.command.absolute.line, 128, 96, 128 - 40, 96 - 20	; WNW		
			defb @draw.command.absolute.line, 128, 96, 128 - 48, 96 - 48	; NW
			defb @draw.command.absolute.line, 128, 96, 128 - 20, 96 - 40	; NWN		
			defb @draw.command.exit	
	
	endif
	
	if defined(draw-fill-test)
	
		@draw.test:
			defb @draw.command.picture.color, 1
			defb @draw.command.absolute.line, 32, 32, 32, 48, 48, 48, 48, 32, 32, 32
			defb @draw.command.picture.color, 3
			defb @draw.command.fill, 40, 40
			defb @draw.command.exit	
			
	endif

	@draw.test:
	
	color: equ for 8
		defb @draw.command.picture.color, color
		defb @draw.command.absolute.line, 20 * color , 0, 20 * color, 20, 20 * ( color + 1 ) - 1, 20, 20 * ( color + 1 ) - 1, 0, 20 * color, 0
		defb @draw.command.fill, ( 20 * color ) + 1, 1
	next color

	color: equ for 7
		defb @draw.command.picture.color, color + 8
		defb @draw.command.absolute.line, 20 * color , 20, 20 * color, 40, 20 * ( color + 1 ) - 1, 40, 20 * ( color + 1 ) - 1, 20, 20 * color, 20
		defb @draw.command.fill, ( 20 * color ) + 1, 21
	next color
	
		defb @draw.command.exit	
	
	
	include "util\print.s"
	include "util\keyboard.s"	
	include "util\ports.s"	
	
endif	


@var.port.low: defb 0

@var.picture.color:			defb 0
@var.picture.draw.enabled:	defb 0

@var.priority.color:		defb 0
@var.priority.draw.enabled:	defb 0

draw.pic:

	ld hl,@palette + 15
	ld c,port.clut
	ld b,16
	otdr
	
; for sam basic
	ld hl,@palette
	ld de,&55d8
	ld bc,16
	ldir	
	inc de
	inc de
	inc de
	inc de
	ld hl,@palette
	ld bc,16
	ldir	

	in a,(port.low_memory)
	ld (@var.port.low), a
	in a,(port.video_memory)
	and %00011111
	or  %00100000	; ram in AB
	out (port.low_memory), a		
	
	ld hl,0
	ld de,1
	ld b,168
@cls:	
	push bc
	ld bc,24
	ld a,&00
	ld (hl),a
	ldir	
	ld bc,80
	ld a,&ff
	ld (hl),a
	ldir
	ld bc,24
	ld a,&00
	ld (hl),a
	ldir
	pop bc
	djnz @cls
	
	; initially only draw actual screen (directly to screen) - later on draw to off screen screen and also priority lines

	; should start completely white - lets just see
	
	
	ld ix,(var.resource.start)	; ignoring any parameter and just using last loaded pic
@loop:	

	if defined(debug)
		xor a
		ld (util.print.x),a
		inc a
		ld (util.print.y),a
		push ix
		pop hl
		ld a,h
		call util.print.hex
		ld a,l
		call util.print.hex
		ld a,":"
		call util.print.char	
		ld a,(ix)	
		call util.print.hex
	endif

	ld a,(ix)		
	
	if defined(pause)
		call util.print.reset
		call util.print.hex
		push af
		ld a,(ix+1)
		call util.print.hex
		ld a,(ix+2)
		call util.print.hex
		pop af
		call util.keyboard.pause
	endif
	
	inc ix	
	
	sub &f0
	jr c,@err.picture		
	
	add a,a
	ld e,a
	ld d,0
	ld hl,@commands
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld hl,@loop
	push hl
	ex de,hl	
	jp (hl)
	
@exit:

	ld a,(@var.port.low)
	out (port.low_memory),a

	ret

@command.exit:
	
	pop hl	; toss @loop
	jr @exit
	
	
@err.picture:

	ld e,a
	ld hl,@text.error
	call util.print.string	
	push ix
	pop hl
	ld a,h
	call util.print.hex
	ld a,l
	call util.print.hex
	ld a," " 
	call util.print.char
	ld a,e
	add &f0
	call util.print.hex
	ld a,chr_linefeed
	call util.print.char
	
	jr @exit

@text.error: 
	defm "ERROR: "
	defb 0

;F0 - FF
@commands: 
	defw @change.picture.color.and.enable.picture.draw		;F0
	defw @disable.picture.draw								;F1
	defw @change.priority.color.and.enable.priority.draw	;F2
	defw @disable.priority.draw								;F3
	defw @draw.y.corner										;F4
	defw @draw.x.corner										;F5
	defw @absolute.line										;F6
	defw @relative.line										;F7
	defw @fill												;F8
	defw @change.pen.size.and.style							;F9 - sq2 only
	defw @plot.with.pen										;FA - sq2 only
	defw @command.exit
	defw @command.exit
	defw @command.exit
	defw @command.exit
	defw @command.exit
	
	
; EGA 0-63 per channel, SAM 0-3 per channel (+ bright) 

@palette:			; Code  Color             R    G    B
		; GRB!GRB	  ----- ---------------- ---- ---- ----
	defb %0000000	;   0   black            0x00,0x00,0x00
	defb %0010000	;   1   blue             0x00,0x00,0x2A
	defb %1000000	;   2   green            0x00,0x2A,0x00
	defb %1010000	;   3   cyan             0x00,0x2A,0x2A
	defb %0100000	;   4   red              0x2A,0x00,0x00
	defb %0110000	;   5   magenta          0x2A,0x00,0x2A
	defb %0100100	;   6   brown            0x2A,0x15,0x00
	defb %1110000	;   7   light grey       0x2A,0x2A,0x2A
	defb %0000111	;   8   dark drey        0x15,0x15,0x15
	defb %0010111	;   9   light blue       0x15,0x15,0x3F
	defb %1000111	;  10   light green      0x15,0x3F,0x15
	defb %1010111	;  11   light cyan       0x15,0x3F,0x3F
	defb %0100111	;  12   light red        0x3F,0x15,0x15
	defb %0110111	;  13   light magenta    0x3F,0x15,0x3F
	defb %1100111	;  14   yellow           0x3F,0x3F,0x15
	defb %1110111	;  15   white            0x3F,0x3F,0x3F		

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

	ld e,(ix)	; x
	inc ix
	ld d,(ix)	; y
	inc ix
	call @plot.xy
@params.y.corner:	
	ld a,(ix)
	cp &f0
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
	cp &f0
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

	ld e,(ix)	; x
	inc ix
	ld d,(ix)	; y
	inc ix
	
	call @plot.xy
	jr @y.done.y	
	
@var.dx:	defb 0
@var.dy:	defb 0
@var.D:		defb 0	

@absolute.line:

; Function: Draws lines between points. 
; The first two arguments are the starting coordinates. 
; The remaining arguments are in groups of two which give the coordinates of the next location to draw a line to. 
; There can be any number of arguments but there should always be an even number.

	ld e,(ix+0)	; x0
	ld d,(ix+1)	; y0
	
	call @plot.xy
@al.next:
	inc ix
	inc ix
	
	ld a,(ix+0)	; x1	
	cp &f0
	ret nc	
	
	; first determine x or y line - line steps by 1 pixel on largest axis, the other axis is fractional
	
	sub e
	ld l,0
	jr z,@ok1
	ld l,1
	jr nc,@ok1
	ld l,-1
	ld a,e
	sub (ix)
@ok1:	
	ld (@var.dx),a
	ld c,a	; c = absolute x1 - x2
	
	ld a,(ix+1)
	sub d
	ld h,0
	jr z,@ok2
	ld h,1
	jr nc,@ok2
	ld h,-1
	ld a,d
	sub (ix+1)
@ok2:		; a = absolute y1 - y2
	ld (@var.dy),a
	sub c
	jr nc,@y.line	; ydif > xdif
	
	
	; move along x-axis one pixel at a time, with y changing with fraction
@x.line:

	; see https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
	
	ld a,(@var.dx)
	ld b,a
	ld a,(@var.dy)
	sub b
	ld (@var.D),a	

@x.loop:
	ld a,e
	cp (ix+0)
	jr z,@al.next

	add a,l
	ld e,a		
	
	ld a,(@var.D)
	bit 7,a
	jr nz,@negd
	ld b,a
	ld a,d
	add a,h	; h = 1 / -1
	ld d,a	
	ld a,(@var.dx)
	ld c,a
	ld a,b
	sub c
@negd:	
	ld c,a
	ld a,(@var.dy)
	add a,c
	ld (@var.D),a
	
	call @plot.xy		
	
	jr @x.loop

	; move along y-axis one pixel at a time, with x changing with fraction
@y.line:

	ld a,(@var.dy)
	ld b,a
	ld a,(@var.dx)
	sub b
	ld (@var.D),a	

@y.loop:

	ld a,d
	cp (ix+1)
	jr z,@al.next
	
	add a,h
	ld d,a	

	ld a,(@var.D)
	bit 7,a
	jr nz,@negd
	ld b,a
	ld a,e
	add a,l	; l = 1 / -1
	ld e,a
	ld a,(@var.dy)
	ld c,a
	ld a,b
	sub c
@negd:	
	ld c,a
	ld a,(@var.dx)
	add a,c
	ld (@var.D),a

	call @plot.xy

	jr @y.loop

	
@plot.xy:

	;e = x [ 0-159 ]
	;d = y [ 0-199 ]	
	
	ld a,(@var.picture.draw.enabled)
	or a
	ret z
	
	push hl
	push de

	ld a,e
	srl a
	add 24	;offset to center 
	ld l,a

	ld a,d
	srl a
	ld h,a
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

	ld e,(ix)	; x
	inc ix
	ld d,(ix)	; y
	inc ix	
	
	ld a,(ix)
	cp &f0
	jr c,@rl.go
	
	call @plot.xy
	ret
	
@rl.params:

	ld a,(ix)
	cp &f0
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
	defb 0,0,0,0,&ff


; Function: Flood fill from the locations given. Arguments are given in groups of two bytes which give the coordinates 
; of the location to start the fill at. If picture drawing is enabled then it flood fills from that location on the picture
; screen to all pixels locations that it can reach which are white in color. The boundary is given by any pixels which are 
; not white.

; currently recursive stack based
; next: queue based https://github.com/Yonaba/FloodFill/blob/master/floodfill/flood4stack.lua

@fill:

	;e = x [ 0-159 ]
	;d = y [ 0-199 ]
	
	ld a,(ix)
	cp &f0
	ret nc		
	
	ld e,(ix)	; x
	inc ix
	ld d,(ix)	; y
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
	
	ld b,e	; b = west
	
	ld e,c
@go.east:
	inc e
	call @white.xy
	jr z,@go.east

	ld c,e	; c = east
	
	ld e,b	; e = west
	
	ld l,0	; l = push state
	
@loop:
	inc e
	ld a,e	
	cp c
	jr nc,@fill.q.loop
	
	call @plot.xy
	
	dec d
	call @white.xy
	jr nz,@no.north	
	bit 0,l
	jr nz,@+continue
	push de			; should only push when previous pixel was not pushed
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
	push de			; should only push when previous pixel was not pushed
	set 1,l
	jr @+continue
@no.south:	
	res 1,l
@continue:	
	dec d
	jr @loop	
	
	
@fill.recursive:

	if defined(test-draw)
	
		xor a
		ld (util.print.x), a
		ld (util.print.y), a
		
		ld a,d
		call util.print.hex
		ld a,e
		call util.print.hex
		; call util.keyboard.pause
	
	endif
	
	call @white.xy	
	ret nz		
	call @plot.xy				; x, y	
	
	inc e
	call @fill.recursive		; x + 1, y	
	dec e

	dec e
	call @fill.recursive		; x - 1, y
	inc e
	
	inc d
	call @fill.recursive		; x, y + 1
	dec d
	
	dec d
	call @fill.recursive		; x, y - 1 	
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
	add 24	;offset to center
	ld l,a

	ld a,d
	srl a
	ld h,a
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
	
@change.pen.size.and.style:	;sq2 only

@plot.with.pen: ;sq2 only
	
@eat.params:	
	ld a,(ix)
	cp &f0
	ret nc	
	inc ix
	jr @eat.params

