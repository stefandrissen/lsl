; end.of.loop(oA,fB);

; Object oA is cycled in normal order until the last cel in the loop is reached.
; Flag fB is reset when the command is issued, and when the last cel is
; displayed fB is set.

logic.action.end.of.loop:

    jp logic.action.nyi
