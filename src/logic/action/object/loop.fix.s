; fix.loop(oA);

; This stops the interpreter from choosing the loop number for object oA based
; on it's direction. You can turn this back on again using the release.loop
; command.

logic.action.fix.loop:

    ld b,(ix)   ; oA

    ld hl,view.fix.loop
    call section.call.object

    inc ix

    ret
