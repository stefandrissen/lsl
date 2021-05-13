
; set.simple(A);

; This command makes a saved game description using A(which should be a string)
; to specify what to make it. For example: If A = "Name of player" then the game
; description will automatically save it as "Name of player". Also the string
; number you use can have an affect on what the save message is.

; The number of paramaters is known, but not the type of parameters. Therefore,
; the parameters in the unknown commands are all set to numbers at present.

logic.action.set.simple:

    jp logic.action.nyi
