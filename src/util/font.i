
    defw @space,@exclaim,@todo,@todo,@todo,@percent,@todo,@todo     ; 32
    defw @par_open,@par_close,@todo,@todo,@comma,@minus,@dot,@slash ; 40
    defw @0,@1,@2,@3,@4,@5,@6,@7                                    ; 48
    defw @8,@9,@colon,@todo,@lt,@eq,@gt,@question                   ; 56
    defw @todo,@A,@B,@C,@D,@E,@F,@G                                 ; 64
    defw @H,@I,@J,@K,@L,@M,@N,@O                                    ; 72
    defw @P,@Q,@R,@S,@T,@U,@V,@W                                    ; 80
    defw @X,@Y,@Z,@bracket_open,@todo,@bracket_close,@todo,@todo    ; 88
    ; lowercase - same font as upper for now
    defw @todo,@a_,@b_,@c_,@d_,@e_,@f_,@g_                          ; 96
    defw @h_,@i_,@j_,@k_,@l_,@m_,@n_,@o_                            ; 104
    defw @p_,@q_,@r_,@s_,@t_,@u_,@v_,@w_                            ; 112
    defw @x_,@y_,@z_,@todo,@todo,@todo,@todo,@todo                  ; 120

 __: equ 0x00
 _X: equ 0x0f
 X_: equ 0xf0
 XX: equ 0xff

@todo:
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb 0x77,0x77,0x77
@space:
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
@exclaim:
    defb __,__,__
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb __,__,__
    defb __,X_,__
    defb __,__,__
@percent:
    defb __,__,__
    defb XX,__,X_
    defb X_,_X,__
    defb __,X_,__
    defb __,X_,__
    defb _X,__,X_
    defb X_,_X,X_
    defb __,__,__
@par_open:
    defb __,__,__
    defb __,__,X_
    defb __,_X,__
    defb __,_X,__
    defb __,_X,__
    defb __,_X,__
    defb __,__,X_
    defb __,__,__
@par_close:
    defb __,__,__
    defb X_,__,__
    defb _X,__,__
    defb _X,__,__
    defb _X,__,__
    defb _X,__,__
    defb X_,__,__
    defb __,__,__
@comma:
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,X_,__
    defb _X,__,__
@minus:
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb XX,XX,X_
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
@dot:
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,__,__
    defb __,X_,__
    defb __,__,__
@slash:
    defb __,__,__
    defb __,__,X_
    defb __,_X,X_
    defb __,XX,__
    defb _X,X_,__
    defb XX,__,__
    defb X_,__,__
    defb __,__,__
@0:
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@1:
    defb __,__,__
    defb __,X_,__
    defb _X,X_,__
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb _X,XX,__
    defb __,__,__
@2:
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb __,_X,__
    defb __,X_,__
    defb _X,__,__
    defb XX,XX,X_
    defb __,__,__
@3:
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb __,_X,__
    defb __,__,X_
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@4:
    defb __,__,__
    defb __,_X,__
    defb __,XX,__
    defb _X,_X,__
    defb X_,_X,__
    defb XX,XX,X_
    defb __,_X,__
    defb __,__,__
@5:
    defb __,__,__
    defb XX,XX,X_
    defb X_,__,__
    defb XX,XX,__
    defb __,__,X_
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@6:
    defb __,__,__
    defb _X,XX,__
    defb X_,__,__
    defb XX,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@7:
    defb __,__,__
    defb XX,XX,X_
    defb __,__,X_
    defb __,_X,__
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb __,__,__
@8:
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb _X,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@9:
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb _X,XX,X_
    defb __,__,X_
    defb _X,XX,__
    defb __,__,__
@colon:
    defb __,__,__
    defb __,__,__
    defb __,X_,__
    defb __,X_,__
    defb __,__,__
    defb __,X_,__
    defb __,X_,__
    defb __,__,__
@lt:
    defb __,__,__
    defb __,_X,__
    defb __,X_,__
    defb _X,__,__
    defb __,X_,__
    defb __,_X,__
    defb __,__,__
    defb __,__,__
@eq:
    defb __,__,__
    defb __,__,__
    defb XX,XX,X_
    defb __,__,__
    defb XX,XX,X_
    defb __,__,__
    defb __,__,__
    defb __,__,__
@gt:
    defb __,__,__
    defb _X,__,__
    defb __,X_,__
    defb __,_X,__
    defb __,X_,__
    defb _X,__,__
    defb __,__,__
    defb __,__,__
@question:
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb __,__,X_
    defb __,_X,__
    defb __,__,__
    defb __,X_,__
    defb __,__,__

@A:
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb XX,XX,X_
    defb X_,__,X_
    defb __,__,__
@B:
    defb __,__,__
    defb XX,XX,__
    defb X_,__,X_
    defb XX,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb XX,XX,__
    defb __,__,__
@C:
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb X_,__,__
    defb X_,__,__
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@D:
    defb __,__,__
    defb XX,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb XX,XX,__
    defb __,__,__
@E:
    defb __,__,__
    defb XX,XX,X_
    defb X_,__,__
    defb XX,XX,__
    defb X_,__,__
    defb X_,__,__
    defb XX,XX,X_
    defb __,__,__
@F:
    defb __,__,__
    defb XX,XX,X_
    defb X_,__,__
    defb XX,XX,__
    defb X_,__,__
    defb X_,__,__
    defb X_,__,__
    defb __,__,__
@G:
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb X_,__,__
    defb X_,_X,X_
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@H:
    defb __,__,__
    defb X_,__,X_
    defb X_,__,X_
    defb XX,XX,X_
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb __,__,__
@I:
    defb __,__,__
    defb _X,XX,__
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb _X,XX,__
    defb __,__,__
@J:
    defb __,__,__
    defb __,__,X_
    defb __,__,X_
    defb __,__,X_
    defb __,__,X_
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@K:
    defb __,__,__
    defb X_,_X,__
    defb X_,X_,__
    defb XX,__,__
    defb X_,X_,__
    defb X_,_X,__
    defb X_,__,X_
    defb __,__,__
@L:
    defb __,__,__
    defb X_,__,__
    defb X_,__,__
    defb X_,__,__
    defb X_,__,__
    defb X_,__,__
    defb XX,XX,X_
    defb __,__,__
@M:
    defb __,__,__
    defb X_,__,X_
    defb XX,_X,X_
    defb X_,X_,X_
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb __,__,__
@N:
    defb __,__,__
    defb X_,__,X_
    defb XX,__,X_
    defb XX,X_,X_
    defb X_,XX,X_
    defb X_,_X,X_
    defb X_,__,X_
    defb __,__,__
@O:
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@P:
    defb __,__,__
    defb XX,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb XX,XX,__
    defb X_,__,__
    defb X_,__,__
    defb __,__,__
@Q:
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,X_
@R:
    defb __,__,__
    defb XX,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb XX,XX,__
    defb X_,_X,__
    defb X_,__,X_
    defb __,__,__
@S:
    defb __,__,__
    defb _X,XX,__
    defb X_,__,__
    defb _X,XX,__
    defb __,__,X_
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@T:
    defb __,__,__
    defb XX,XX,X_
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb __,__,__
@U:
    defb __,__,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@V:
    defb __,__,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb _X,_X,__
    defb __,X_,__
    defb __,__,__
@W:
    defb __,__,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb X_,X_,X_
    defb XX,_X,X_
    defb X_,__,X_
    defb __,__,__
@X:
    defb __,__,__
    defb X_,__,X_
    defb _X,_X,__
    defb __,X_,__
    defb __,X_,__
    defb _X,_X,__
    defb X_,__,X_
    defb __,__,__
@Y:
    defb __,__,__
    defb X_,__,X_
    defb _X,_X,__
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb __,__,__
@Z:
    defb __,__,__
    defb XX,XX,X_
    defb __,_X,__
    defb __,X_,__
    defb __,X_,__
    defb _X,__,__
    defb XX,XX,X_
    defb __,__,__

@bracket_open:
    defb __,__,__
    defb _X,XX,X_
    defb _X,__,__
    defb _X,__,__
    defb _X,__,__
    defb _X,__,__
    defb _X,XX,X_
    defb __,__,__

@bracket_close:
    defb __,__,__
    defb _X,XX,X_
    defb __,__,X_
    defb __,__,X_
    defb __,__,X_
    defb __,__,X_
    defb _X,XX,X_
    defb __,__,__

@a_:
    defb __,__,__
    defb __,__,__
    defb _X,XX,__
    defb __,__,X_
    defb _X,XX,X_
    defb X_,__,X_
    defb _X,XX,X_
    defb __,__,__
@b_:
    defb __,__,__
    defb X_,__,__
    defb X_,__,__
    defb XX,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb XX,XX,__
    defb __,__,__
@c_:
    defb __,__,__
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb X_,__,__
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@d_:
    defb __,__,__
    defb __,__,X_
    defb __,__,X_
    defb _X,XX,X_
    defb X_,__,X_
    defb X_,__,X_
    defb _X,XX,X_
    defb __,__,__
@e_:
    defb __,__,__
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb XX,XX,__
    defb X_,__,__
    defb _X,XX,X_
    defb __,__,__
@f_:
    defb __,__,__
    defb __,XX,__
    defb _X,__,__
    defb XX,X_,__
    defb _X,__,__
    defb _X,__,__
    defb _X,__,__
    defb __,__,__
@g_:
    defb __,__,__
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb _X,XX,X_
    defb __,__,X_
    defb _X,XX,__
@h_:
    defb __,__,__
    defb X_,__,__
    defb X_,__,__
    defb XX,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb __,__,__
@i_:
    defb __,__,__
    defb __,X_,__
    defb __,__,__
    defb _X,X_,__
    defb __,X_,__
    defb __,X_,__
    defb _X,XX,__
    defb __,__,__
@j_:
    defb __,__,__
    defb __,__,X_
    defb __,__,__
    defb __,_X,X_
    defb __,__,X_
    defb __,__,X_
    defb __,__,X_
    defb _X,XX,__
@k_:
    defb __,__,__
    defb X_,__,__
    defb X_,X_,__
    defb XX,__,__
    defb X_,X_,__
    defb X_,_X,__
    defb X_,__,X_
    defb __,__,__
@l_:
    defb __,__,__
    defb _X,X_,__
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb _X,XX,X_
    defb __,__,__
@m_:
    defb __,__,__
    defb __,__,__
    defb XX,_X,__
    defb X_,X_,X_
    defb X_,X_,X_
    defb X_,X_,X_
    defb X_,X_,X_
    defb __,__,__
@n_:
    defb __,__,__
    defb __,__,__
    defb XX,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb __,__,__
@o_:
    defb __,__,__
    defb __,__,__
    defb _X,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@p_:
    defb __,__,__
    defb __,__,__
    defb XX,XX,__
    defb X_,__,X_
    defb X_,__,X_
    defb XX,XX,__
    defb X_,__,__
    defb X_,__,__
@q_:
    defb __,__,__
    defb __,__,__
    defb _X,XX,X_
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb _X,XX,X_
    defb __,__,X_
@r_:
    defb __,__,__
    defb __,__,__
    defb X_,XX,__
    defb XX,__,X_
    defb X_,__,__
    defb X_,__,__
    defb X_,__,__
    defb __,__,__
@s_:
    defb __,__,__
    defb __,__,__
    defb _X,XX,__
    defb X_,__,__
    defb _X,XX,__
    defb __,__,X_
    defb _X,XX,__
    defb __,__,__
@t_:
    defb __,__,__
    defb __,X_,__
    defb _X,XX,X_
    defb __,X_,__
    defb __,X_,__
    defb __,X_,__
    defb __,_X,X_
    defb __,__,__
@u_:
    defb __,__,__
    defb __,__,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb _X,XX,__
    defb __,__,__
@v_:
    defb __,__,__
    defb __,__,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb _X,_X,__
    defb __,X_,__
    defb __,__,__
@w_:
    defb __,__,__
    defb __,__,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,X_,X_
    defb XX,_X,X_
    defb X_,__,X_
    defb __,__,__
@x_:
    defb __,__,__
    defb __,__,__
    defb X_,__,X_
    defb _X,_X,__
    defb __,X_,__
    defb _X,_X,__
    defb X_,__,X_
    defb __,__,__
@y_:
    defb __,__,__
    defb __,__,__
    defb X_,__,X_
    defb X_,__,X_
    defb X_,__,X_
    defb _X,XX,X_
    defb __,__,X_
    defb _X,XX,__
@z_:
    defb __,__,__
    defb __,__,__
    defb XX,XX,X_
    defb __,_X,__
    defb __,X_,__
    defb _X,__,__
    defb XX,XX,X_
    defb __,__,__
