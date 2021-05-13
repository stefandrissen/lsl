
; set.game.id(mID); TODO

; Sets the game ID to mID. This is a short name, up to 6 characters, that
; identifies the game, such as KQ2, SQ2, GR, MG etc. When the game ID is set
; like this, the interpreter checks it against it's own internal game ID and if
; they do not match, it quits. This was to make sure games were not run with the
; wrong interpreter. Once the game ID is set, saved games include it in their
; filenames (e.g. SQSG.1).

; There is a simple way around the game ID checking problem - simply do not use
; this command, and the interpreter will not find the wrong one and quit. This
; is especially important with new games, so that they can be run using
; interpreters from different games, which of course will have different IDs
; (although they must be the right interpreter version). Saved games will just
; be called SG.1, SG.2 etc. but that is not a real problem.

logic.action.set.game.id:

if defined( strict )

    jp logic.action.nyi

else

    ld a,(ix)
    inc ix

    call message.get.hl

    ret

endif
