;---------------------------------------------------------------
; [name]        memory.i
; [function]    memory map
;---------------------------------------------------------------

stack.top:              equ 0x0100
stack.size:             equ 0x30

page.heap:              equ 0   ; basic
addr.heap:              equ 0x4000

page.boot:              equ 1

page.main:              equ 2

page.log:               equ 4
ptr.logdir:                 equ 0x8000

page.view:              equ 6
ptr.viewdir:                equ 0x8000 + 0x1000 ; view code

page.pic:               equ 8
ptr.picdir:                 equ 0x8000 + 0x1000 ; drawing code

page.snd:               equ 10
snd.interrupt.handler:      equ 0x8000
ptr.snddir:                 equ 0x8000 + 0x1000 ; sound code

page.screen:            equ 12   ; must be even (bottom bit ignored)

page.screen.priority:   equ 14
ptr.screen:                 equ 0x8000

screen.offset.to.center:    equ 24
