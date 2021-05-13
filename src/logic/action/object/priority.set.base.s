
; set.pri.base(A);

; This command affects the priority base of the AGI interpreter. King's Quest 4
; uses this function to affect the table so the "base" (priorities <= 4) is
; bigger or larger at the top.

logic.action.set.pri.base:

    jp logic.action.nyi
