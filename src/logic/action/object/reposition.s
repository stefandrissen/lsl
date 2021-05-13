; reposition(oA,vDX,vDY);

; Object oA is repositioned relative to it's current co-ordinates. It's new co-ordinates are X+vDX,Y+vDY where X,Y is it's current position. If vDX or vDY are greater than 127, they are treated as a negative number (vDX-256 or vDY-256).

logic.action.reposition:

    jp logic.action.nyi

;------------------------------------------------------------------------------

; reposition.to(oA,X,Y);

; The position on the screen of object oA is changed to X,Y. The reposition.to command should be used for objects that are currently on the screen. reposition.to does the same job as position, but it erases the object before moving it and draws it again afterwards.

logic.action.reposition.to:

    jp logic.action.nyi

;------------------------------------------------------------------------------

; reposition.to.v(oA,vX,vY);

; The position on the screen of object oA is changed to vX,vY. The reposition.to command should be used for objects that are currently on the screen. reposition.to.v does the same job as position.v, but it erases the object before moving it and draws it again afterwards

logic.action.reposition.to.v:

    jp logic.action.nyi

;------------------------------------------------------------------------------
