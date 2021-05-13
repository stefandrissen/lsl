
; open.dialog();

; This command supposedly enables the get.string and get.num commands when the
; prevent.input command has been used, but they seem to be enabled anyway so I
; am not sure what the command actually does.

logic.action.open.dialog:

    jp logic.action.nyi

; close.dialog();

; This command supposedly disables the get.string and get.num commands when the
; prevent.input command has been used, but it does not seem to do this so I am
; not sure what the command actually does.

logic.action.close.dialog:

    jp logic.action.nyi
