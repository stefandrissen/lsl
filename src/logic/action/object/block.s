
; block(X1,Y1,X2,Y2);

; This sets up an invisible rectangular block on the screen with top-left
; co-ordinates X1,Y1 and bottom-right co-ordinates X2,Y2. Objects are not
; allowed to cross the borders of this block (unless they are told to ignore
; blocks). The block can be removed using the unblock command.

; Note: You can only have one block on the screen at a time. If a block already
; exists, and you use the block command again, the new block will be there but
; the old one will be gone.

logic.action.block:

    jp logic.action.nyi

;-------------------------------------------------------------------------------

; unblock();

; This removes the block set up on the screen by the block command.

logic.action.unblock:

    jp logic.action.nyi
