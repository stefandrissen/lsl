logic.action.return:

   if defined( debug )
    call debug.popScript
   endif

    pop af  ; toss call

    ret

