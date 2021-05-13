; follow.ego(oA,STEPSIZE,fDONEFLAG);

; Object oA moves towards ego (object 0) by STEPSIZE pixels every step. When the
; object is within STEPSIZE pixels of ego, it stops moving and flag fDONEFLAG is
; set. If STEPSIZE is 0, the current step size of object oA is used.

logic.action.follow.ego:

    jp logic.action.nyi
