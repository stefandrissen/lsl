; An attempt at creating a Z80 AGI for Leisure Suit Larry In The Land Of The Lounge Lizards
;
; (C) 2016 Stefan Drissen
;
; data files:
;	http://www.myabandonware.com/game/leisure-suit-larry-in-the-land-of-the-lounge-lizards-bl
;
; documentation:
;	http://wiki.scummvm.org/index.php/AGI/Specifications
;
;	

	include "util\ports.s"

	org 32768
	dump 1,0
	
autoexec
	
	di
	ld (store.sp),sp
	ld sp,0
	
	ld a,1
	;  1 = land of the lounge lizards
	;  2 = credits 1
	;  3 = credits 2 
	;  4 = credits 3
	;  5 = ! crash
	;  6 = ! error
	;  7 = ! crash
	;  8 = life factory
	;  9 = alley
	; 10 = cab
	; 11 = lefty's - outside
	; 12 = lefty's - alley
	; 13 = toilet - crash
	; 14 = hallway toilet
	; 15 = lefty's - inside
	; 16 = pimp
	; 17 = hooker's room
	; 18 = hooker
	; 19 = leisure suit
	; 20 = ! crash
	; 21 = store - inside
	; 22 = store - outside
	; 23 = disco - outside
	; 24 = disco - inside
	; 25 = fawn
	; 26 = receptionist
	; 27 = eden
	; 28 = doll
	; 29 = ! crash
	; 30 = ! crash
	; 31 = casino - inside
	; 32 = casino - outside
	; 33 = chapel - outside
	; 34 = chapel - inside
	; 35 = hotel - ground floor
	; 36 = caberet
	; 37 = slot machine
	; 38 = ! crash
	; 39 = ! error
	; 40 = hotel 
	; 41 = honeymoon suite
	; 42 = hotel - 
	; 43 = hot tub - error 
	; 44 = penthouse - living room
	; 45 = penthouse - bed room
	
	
	
	ld b,45
	if defined(debug)
		ld a,41
		ld b,1
	endif

@loop:	
		push af
		push bc
		call load.pic 
		call draw.pic
		call discard.pic
		call show.pic
		call util.keyboard.pause
		pop bc
		pop af
		inc a
	djnz @loop
	
	ld sp,(store.sp)
	ei
	ret
	
store.sp: defw 0
	
	include "logic\pic\load.s"
	include "logic\pic\draw.s"
	include "logic\pic\discard.s"
	include "logic\pic\show.s"	
	
	include "util\print.s"
	include "util\keyboard.s"
	include "logic\resource\load.s"
	
; variables
; - 26 reserved variables
var_current_room_number:	defb 0
var_previous_room_number:	defb 0
var_border_touched_ego:		defb 0
var_current_score:			defb 0
var_object_touched_border:	defb 0
	enum_border_none:			equ 0
	enum_border_top_or_horizon:	equ 1
	enum_border_right:			equ 2
	enum_border_bottom:			equ 3
	enum_border_left:			equ 4
	
var_ego_direction:			defb 0	;some naming logic could be applied to enums
	enum_direction_up:			equ 1
	enum_direction_up_right:	equ 2 
	enum_direction_right:		equ 3
	enum_direction_right_down:	equ 4 
	enum_direction_down:		equ 5 
	enum_direction_down_left:	equ 6
	enum_direction_left:		equ 7 
	enum_direction_left_up:		equ 8
	
var_maximum_score:			defb 0
var_free_pages:				defb 0
var_word_not_found:			defb 0
var_interpreter_cycle_time:	defb 0
var_seconds:				defb 0
var_minutes:				defb 0
var_hours:					defb 0
var_days:					defb 0
var_joystick_sensitivity:	defb 0
var_view_resource_ego:		defb 0
var_interpreter_error_code:	defb 0
var_error_code_parameter:	defb 0
var_key_pressed:			defb 0
var_computer_type:			defb 0
	enum_computer_ibm_pc:		equ 0
	enum_computer_atari_st:		equ 4
	enum_computer_amiga:		equ 5
	enum_computer_apple_iigs:	equ 7
	enum_computer_sam_coupe:	equ 8 ; ;-)
	
var_message_window_timer:	defb 0
var_sound_type:				defb 0
var_sound_volume:			defb 0
var_input_buffer_size:		defb 41
var_inventory_items_selected:	defb 0
var_monitor_type:			defb 0

; - 230 'user' variables
defs 256 - 26

; flags
; - 16 reserved flags
flag_ego_completely_on_water:	defb 0
flag_ego_completely_obscured:	defb 0
flag_player_entered_command:	defb 0
flag_ego_touched_trigger_line:	defb 0
flag_said_accepted_user_input:	defb 0
flag_room_script_first_time:	defb 0
flag_restart.game:				defb 0
flag_writing_script_buffer_blocked:	defb 0
flag_use_joystick_sensitivity:	defb 0
flag_enable_sound:				defb 0
flag_enable_debugger:			defb 0
flag_logic_0_first_time:		defb 0
flag_restore.game:				defb 0
flag_status_to_select_items:	defb 0
flag_enable_menu:				defb 0
flag_enable_non_blocking_window:	defb 0
flag_related_to_game_restart:	defb 0

; - 240 'user' flags
flags:		defs 256 - 16

; strings

strings:	defs 12 * 40


;==================================================================

; dir files are directories pointing to resource in vol.*
;
; documentation: http://wiki.scummvm.org/index.php/AGI/Specifications/Formats
; 
; each entry is 3 bytes
; first 4 bits indicate vol.#
; next 28 bits are offset in vol.#
;
; when &ffffff -> empty

var.free:				defw free	; indicates start free memory

var.logdir:				defw 0
var.logdir.entries:		defb 0
var.viewdir:			defw 0
var.viewdir.entries:	defb 0
var.picdir:				defw 0
var.picdir.entries:		defb 0
var.snddir:				defw 0
var.snddir.entries:		defb 0

var.words.tok:			defw 0
var.object:				defw 0
	

free:

	
