action.print.v:

; print(n), print.v(n)
;   Opens a text window in the centre of the screen, where a message number n
;   (or vn) from the messages field of the current LOGIC resource is displayed.
;   Output mode is determined by f15 (see Flag description). The message is a
;   NULL-terminated string of text.
;
;   In addition to letters, digits, and other symbols, the string may contain:
;
;   1.  Newline character (0x0A);
;   2.  Format element:
;       -   %v<decimal number>: at this place the output will include a decimal
;           value of variable with the given number.
;       -   %m <number>: the text of the message with the given number is
;           inserted at this place.
;       -   %0 <number>: the name of the item with the given number is inserted
;           at this place.
;       -   %w <number>: a vocabulary word with the given number is inserted at
;           this place.
;       -   %s <number>: a string variable with the given number is inserted at
;           this place.
;       -   %g <number>: a message with this number from message field of
;           Logic(0) is inserted at this place.
;
;   For %v, you can add a vertical line and a number of characters the output
;   should take. In this case leading zeros are not suppressed in the output.
;
;       Example: %v34|2
;
;   When you write your messages, remember that the interpreter wraps the text
;   between the lines as needed when the message is displayed.
;-------------------------------------------------------------------------------

    ld h,vars.high
    ld l,(ix+0)     ; variable
    ld a,(hl)
    jr @print.a

logic.action.print:

    ld a,(ix+0)     ; message

@print.a:

    inc ix

    ld hl,(var.messages)
    cp (hl)
    jr nc,@err.invalid.message

    inc hl

    push hl
    ld c,a
    ld b,0
    add hl,bc
    add hl,bc

    ld e,(hl)
    inc hl
    ld d,(hl)

    pop hl
    add hl,de

    jp util.print.string

@err.invalid.message:

    ld hl,@text.invalid.message
    call util.print.string
    call util.print.hex
    call util.print.lf

    ret

@text.invalid.message:
    defm "Invalid message: "
    defb 0

;-------------------------------------------------------------------------------

logic.action.print.v:

    jp logic.action.nyi
