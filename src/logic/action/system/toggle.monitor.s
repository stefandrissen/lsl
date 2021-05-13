; toggle.monitor();

; Switches between CGA and RGB graphics modes. This is only useful when the
; interpreter is running in one of these modes (either it is running on a
; computer with a CGA graphics adapter or the interpreter has been loaded with
; the -C or -R parameters). Note that although Sierra's DOS interpreter will run
; in these modes, newer interpreters may not.

; This command does not really have any practical use. It was available from a
; menu item in Sierra's AGI games (the menu item was only present when running
; in these modes). The template game does not include this menu item, however.
; If you do want to run the game in these modes, just type "sierra -c" or
; "sierra -r" at the DOS prompt (assuming you are using Sierra's interpreter).
; CGA mode uses the black-cyan-magenta-white CGA color palette while RGB mode
; uses the blue-yellow-red-green CGA palette.

logic.action.toggle.monitor:

    jp logic.action.nyi
