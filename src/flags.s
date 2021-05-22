
ds align 0x100

;===============================================================================
main.flags:

; flags
; - 16  reserved flags
; - 240 user flags
;-------------------------------------------------------------------------------
    defs ( 16 + 240 ) / 8

flag.ego_completely_on_water:       equ 0   ; f0 onWater
flag.ego_completely_obscured:       equ 1   ; f1 egoHidden
flag.player_entered_command:        equ 2   ; f2 haveInput
flag.ego_touched_trigger_line:      equ 3   ; f3 egoHitSpecial
flag.said_accepted_user_input:      equ 4   ; f4 haveMatch
flag.room_script_first_time:        equ 5   ; f5 newRoom
flag.restart.game:                  equ 6   ; f6 gameRestarted
flag.writing_script_buffer_blocked: equ 7   ; f7 noScript
flag.use_joystick_sensitivity:      equ 8   ; f8 enableDblClick
flag.enable_sound:                  equ 9   ; f9 soundOn
flag.enable_debugger:               equ 10  ; f10 enableTrace
flag.logic_0_first_time:            equ 11  ; f11 hasNoiseChannel
flag.restore.game:                  equ 12  ; f12 gameRestored
flag.status_to_select_items:        equ 13  ; f13 enableItemSelect
flag.enable_menu:                   equ 14  ; f14 enableMenu
flag.enable_non_blocking_window:    equ 15  ; f15 leaveWindow
                                            ; f16 noPromptRestart
                                            ; f20 forceAutoLoop

;===============================================================================
flag.isset:
    ld c,%01000110          ; bit 0,(hl)
    jr @flag.operation

flag.reset:

    ld c,%10000110          ; res n,(hl)
    jr @flag.operation

;===============================================================================
flag.set:

    ld c,%11000110          ; set n,(hl)
    jr @flag.operation

;===============================================================================
@flag.operation:

    ; a = flag [0x00-0xff]

    ; c = opcode mask
    ;       %0100 0110 = bit
    ;       %1000 0110 = res
    ;       %1100 0110 = set

    ld h,main.flags / 0x100

    ld l,a
    srl l
    srl l
    srl l

    and %00000111
    rlca
    rlca
    rlca
    or c
    ld (@smc.bit+1),a

@smc.bit:
    set 0,(hl)  ; or res n,(hl) or bit n,(hl)

    ret
