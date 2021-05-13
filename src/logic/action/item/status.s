
; status();

; Displays the inventory screen. This is a text mode screen with the text "You
; are carrying:" on the top line and a list of the items in the player's
; inventory (those with a room number of 255) below. If there are no items in
; the players inventory, "nothing" is displayed.

logic.action.status:

    jp logic.action.nyi
