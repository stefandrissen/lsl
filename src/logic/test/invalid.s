;===============================================================================
logic.test.invalid:

    ld hl,@text.test.invalid
    dec ix
    jp error

@text.test.invalid:

    defm " TEST INVALID: "
    defb 0
