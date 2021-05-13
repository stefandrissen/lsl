
; save.game();

; Saves the game, which basically means writing all the information about the
; current status of everything in the game to a file so that it can be restored
; later. The user is prompted for a saved game directory, and then is asked to
; choose from one of 12 save game slots to save the game in.

logic.action.save.game:

    jp logic.action.nyi
