
; subn(vA,B);

; B is subtracted from vA. Since a var can only be from 0-255, if the result is
; less than 0, then the value "wraps around", e.g. 10 - 12 would give 254.

logic.action.subn:

    jp logic.action.nyi

;-------------------------------------------------------------------------------

; subv(vA,vB);

; vB is subtracted from vA. Since a var can only be from 0-255, if the result is
; less than 0, then the value "wraps around", e.g. 10 - 12 would give 254.

logic.action.subv:

    jp logic.action.nyi
