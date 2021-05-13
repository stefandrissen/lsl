
; show.obj(VIEWNO);

; Cel 0 of loop 0 of view VIEWNO is shown at the bottom of the screen, with the
; view's description displayed above. Both dissapear when a key is pressed. The
; view does not need to be loaded in order to use this command.

; The command does not actually have anything to do with screen objects (which
; are normally referred to as just "objects"). It is meant for when the player
; examines an inventory item - each item should have a view with a picture of it
; and a description, which is displayed using show.obj when the player examines
; it. Inventory items were sometimes called "objects", which is why the command
; was called show.obj.

logic.action.show.obj:

    jp logic.action.nyi

;-------------------------------------------------------------------------------

; show.obj.v(vVIEWNO);

logic.action.show.obj.v:

    jp logic.action.nyi
