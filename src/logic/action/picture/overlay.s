; overlay.pic(vA);

; overlay.pic does the same thing as draw.pic, except that the visual and
; priority screens are not cleared. This means that picture vA is drawn on top
; of the existing picture. Note that because fills only work on white surfaces,
; fills in picture vA which are not on a white part of the existing picture wont
; work. It's generally best not to use fills in pictures that you intend to overlay.

; Remember to use show.pic to update the screen once the picture has been overlayed.

; Make sure the picture is loaded into memory before overlaying it.

logic.action.overlay.pic:

    jp logic.action.nyi
