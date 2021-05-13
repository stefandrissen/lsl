logic.action.invalid:

    ld hl,@text.action.invalid
    jp error

@text.action.invalid:

    defm " ACTION INVALID: "
    defb 0
