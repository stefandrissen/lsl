; normal.motion(oA);

; Object oA moves normally. That is, if the object was wandering or following
; ego, or it was moving to a location specified by a move.obj command, it
; continues in the direction it was travelling, until it is told to stop, move
; in another direction or runs into an obstacle.

logic.action.normal.motion:

    jp logic.action.nyi
