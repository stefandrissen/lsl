
; mul.n(vA,B);

; vA is multiplied by B. Since a var can only be from 0-255, if the result is
; greater than 255, then the value "wraps around", e.g. 100 * 3 would give 44.

logic.action.mul.n:

    jp logic.action.nyi

;-------------------------------------------------------------------------------

; mul.v(vA,vB);

; vA is multiplied by vB. Since a var can only be from 0-255, if the result is
; greater than 255, then the value "wraps around", e.g. 100 * 3 would give 44.

logic.action.mul.v:

    jp logic.action.nyi
