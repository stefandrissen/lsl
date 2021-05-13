; distance(oA,oB,vD);

; vD is set to the distance between objects oA and oB. The formula used for
; calculating the distance is abs(x1-x2) + abs(y1-y2) where x1,y1 and x2,y2 are
; the co-ordinates of the center of the baselines of oA and oB.

; If one or more of the objects is not on screen, the distance is 255.

logic.action.distance:

    jp logic.action.nyi
