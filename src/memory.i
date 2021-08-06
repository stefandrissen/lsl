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
objects.max:                equ 0x10

page.pic:               equ 8
ptr.picdir:                 equ 0x8000 + 0x1000 ; drawing code

page.snd:               equ 10
snd.interrupt.handler:      equ 0x8000
ptr.snddir:                 equ 0x8000 + 0x1000 ; sound code

; screen pages must be even (bottom bit vmpr ignored)
; screen.1 must be multiple of 4 since xor 2 is used to select other screen

page.screen.1:          equ 12  ; alternate buffer 1
page.screen.2:          equ 14  ; alternate buffer 2
page.screen.draw:       equ 16  ; pictures are drawn here before being shown
page.screen.priority:   equ 18
ptr.screen:                 equ 0x8000
lst.background:             equ 0xe000
var.ptr.background:         equ lst.background + objects.max * 2
ptr.background:             equ var.ptr.background + 2

assert page.screen.1 \ 4 == 0

screen.offset.to.center:    equ 24
