
; print.at(mA,X,Y,W);

; Message A is displayed in a window with top left coordinates of X,Y and width
; W. If f15 is not set, then the window remains for 1/2 * v21 seconds (provided
; v21 is greater than 0) or until a key is pressed. If f15 is set, then the
; window remains until a close.window command is issued.

logic.action.print.at:

    jp logic.action.nyi

;-------------------------------------------------------------------------------

; print.at.v(vA,vX,vY,vW);

logic.action.print.at.v:

    jp logic.action.nyi
