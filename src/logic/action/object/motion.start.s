; start.motion(oA);

; I am not quite sure what this command does. The name implies that object oA
; starts to move, but this does not seem to work (instead you have to use
; set.dir to set the direction of the object to something other than 0).

; If oA is ego (object 0), the player.control command is issued by the
; interpreter.

logic.action.start.motion:

    jp logic.action.nyi
