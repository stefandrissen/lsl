
; set.key(nCODE1,CODE2,cA); TODO

; The key determined by the combination of nCODE1 and nCODE2 is assigned to
; controller cA. You can assign multiple menu items and keys to the one
; controller, for example most game functions like save, restore, quit etc.
; usually have both a menu item and a key.

; To assign a key by it's ASCII code, set nCODE1 to the ASCII code you need
; (these can be obtained from an ASCII chart) and leave nCODE2 as 0. There are a
; few special codes:

; nCODE1    Key
; 1-26      CTRL-A-Z
; 8         Backspace (CTRL-H)
; 9         Tab (CTRL-I)
; 13        Enter (CTRL-M)
; 27        Esc
; 32        Space

; However, there are some keys and key combinations which use extended codes.
; For these, nCODE1 should be 0 and nCODE2 should be one of the values listed
; below (these are all standard PC-Keyboard codes, taken from the Epson GW-BASIC
; 3.20 manual.)

; nCODE2    Key
; 3         CTRL-@
; 15        SHIFT-TAB
; 16-25     ALT-Q W E R T Y U I O P
; 30-38     ALT-A S D F G H J K L
; 44-50     ALT-Z X C V B N M
; 59-68     F1-F10
; 82        INS
; 83        DEL
; 84-93     SHIFT-F1-F10
; 94-103    CTRL-F1-F10
; 104-113   ALT-F1-F10
; 115       CTRL-LEFT
; 116       CTRL-RIGHT
; 117       CTRL-END
; 118       CTRL-PAGE DOWN
; 119       CTRL-HOME
; 120-131   ALT-1 2 3 4 5 6 7 8 9 - =
; 132       CTRL-PAGE UP

logic.action.set.key:

if defined( strict )

    jp logic.action.nyi

else

    ld a,(ix)   ; nCODE1
    inc ix
    ld a,(ix)   ; nCODE2
    inc ix
    ld a,(ix)   ; controller cA
    inc ix

    ret

endif
