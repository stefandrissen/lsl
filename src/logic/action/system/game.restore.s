
; restore.game();

; Restores the game, which basically means reading information from a file
; (which was saved earlier) about the current status of everything in the game.
; The user is prompted for a saved game directory, and then chooses from up to
; 12 available saved games.

logic.action.restore.game:

    jp logic.action.nyi
