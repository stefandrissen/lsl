; [name]        list
; [function]    list all resources

; largest resources:

;   logic:
;       00    2ad4
;       24    2255
;       03    203c

;--------------------------------------------------------------

    org &8000
    dump 1,0

    autoexec

    di
    ld (@store.sp),sp
    ld sp,0

    ld hl,@text.logic
    ld ix,obj.logdir
;    call @resource.list

    ld hl,@text.picture
    ld ix,obj.picdir
;    call @resource.list

    ld hl,@text.view
    ld ix,obj.viewdir
    call @resource.list

    ld hl,@text.sound
    ld ix,obj.snddir
;    call @resource.list

    ld sp,(@store.sp)
    ei
    ret

;==============================================================
@resource.list:

;--------------------------------------------------------------

    call util.print.string
    call resource.load.dir

    ld b,(ix)

    ld a,b
    call util.print.hex
    call util.print.lf

    call util.keyboard.pause
    ld a,0

@list.all:

    push bc

    ld hl,(var.free)

    push hl

    push af
    call util.print.hex
    call util.print.space
    pop af

    push af
    push ix
    call resource.load
    pop ix

    ld hl,(var.resource.length)
    call util.print.hl
    call util.print.lf

    pop af

    pop hl
    ld (var.free),hl

    inc a

    pop bc

    djnz @list.all

    ret

;--------------------------------------------------------------

@store.sp:    defw 0

;--------------------------------------------------------------

@text.logic:
    defm "LOG: "
    defb 0

@text.view:
    defm "VIEW: "
    defb 0

@text.picture:
    defm "PIC: "
    defb 0

@text.sound:
    defm "SND: "
    defb 0

;--------------------------------------------------------------

    include "resource/load.s"
    include "util/ports.s"
    include "util/print.s"
    include "util/keyboard.s"

;--------------------------------------------------------------

free:
