; move.obj(oA,X,Y,STEPSIZE,fDONEFLAG);

; Object oA moves from it's current location to X,Y by STEPSIZE pixels every
; step. fDONEFLAG is reset when the command is issued, and set when the object
; reaches it's destination. If STEPSIZE is 0, the current step size of object oA
; is used. If object oA is ego (object 0), the interpreter executes the
; program.control command.

; Warning: If your program is relying on the flag fDONEFLAG to be set before
; continuing with something, such as going to the next part of a cutscene, make
; sure that the object will always be able to reach it's destination. It is
; possible that it could get caught behind a barrier or something, and not be
; able to get where it needs to go, in which case the game might sit there
; forever doing nothing. This is more of a problem when the object being moved
; is ego - it might work fine from where you test it, but it may be possible for
; the player to move ego into such a position where they will get "stuck" when
; being moved.

logic.action.move.obj:

    jp logic.action.nyi

;-------------------------------------------------------------------------------

; move.obj.v(oA,vX,vY,STEPSIZE,fDONEFLAG);

logic.action.move.obj.v:

    jp logic.action.nyi
