; snd.s
;
; structure for sounds
; http://agiwiki.sierrahelp.com/index.php?title=AGI_Specifications:_Chapter_9_-_Sound_Resources
; http://www.sierrahelp.com/AGI/Documentation/Specifications/7-1-SOUND.html

;-------------------------------------------------------------------------------
    include "memory.i"

    include "util/saa1099.i"

        org 0x8000
        dump page.snd,0

snd.interrupt.handler:

    jp snd.play

sounds:
sounds.high:    equ sounds / &100

sound:

    org 0

    @no:                defb    0

    @voice.1.ptr:       defw    0
    @voice.2.ptr:       defw    0
    @voice.3.ptr:       defw    0
    @noise.ptr:         defw    0

    @voice.1.duration:  defw    1
    @voice.2.duration:  defw    0
    @voice.3.duration:  defw    0
    @noise.duration:    defw    0

    @flagdone:          defb    0   ; flagdone

    org $ + sound

;===============================================================================
snd.play:
; play sound

; TI SN76496A
; F = frequency = 111860 / (((Byte3 & 0x3f) << 4) + (Byte4 & 0x0f))
;-------------------------------------------------------------------------------

    ld a,(sound+@no)
    or a
    ret z

    push ix
    push hl
    push de
    push bc

    ld ix,@saa

    ;-----------------------------------
    ; voice 1

    ld hl,(sound+@voice.1.duration)
    dec hl
    ld (sound+@voice.1.duration),hl

    ld a,h
    or l
    jr nz,@no.change.1

    ld hl,(sound+@voice.1.ptr)

    ld e,(hl)
    inc hl
    ld a,e
    ld (sound+@voice.1.duration+0),a
    ld d,(hl)
    inc hl
    ld a,d
    ld (sound+@voice.1.duration+1),a

    ld a,0xff
    cp d
    jr nz,@not.end.1
    cp e
    jr z,@silent.1  ; end of note

@not.end.1:

    ld e,(hl)       ; freq
    inc hl
    ld d,(hl)       ; freq
    inc hl
    call @get.tone  ; de = oct tone

    ld a,(ix+@octave.1.0)
    and 0xf0
    or d
    ld (ix+@octave.1.0),a

    ld (ix+@tone.0),e

    ld a,(hl)   ; attenuation
    inc hl

    and 0x0f
    ld b,a
    ld a,0x0f
    sub b

    ld e,a
    rlca
    rlca
    rlca
    rlca
    or e

    ld (ix+@amplitude.0),a

    ld (sound+@voice.1.ptr),hl

    bit 3,(ix+@octave.1.0)
    jr nz,@silent.1
    set 0,(ix+@frequency.enable)
    jr @continue.1

@silent.1:
    res 0,(ix+@frequency.enable)

@continue.1:

@no.change.1:

    ;-----------------------------------
    ; voice 2

    ld hl,(sound+@voice.2.duration)
    dec hl
    ld (sound+@voice.2.duration),hl

    ld a,h
    or l
    jr nz,@no.change.2

    ld hl,(sound+@voice.2.ptr)

    ld e,(hl)
    inc hl
    ld a,e
    ld (sound+@voice.2.duration+0),a
    ld d,(hl)
    inc hl
    ld a,d
    ld (sound+@voice.2.duration+1),a

    ld a,0xff
    cp d
    jr nz,@not.end.2
    cp e
    jr z,@silent.2  ; end of note

@not.end.2:

    ld e,(hl)       ; freq
    inc hl
    ld d,(hl)       ; freq
    inc hl
    call @get.tone  ; de = oct tone

    ld a,d
    rlca
    rlca
    rlca
    rlca
    ld d,a

    ld a,(ix+@octave.1.0)
    and 0x0f
    or d
    ld (ix+@octave.1.0),a

    ld (ix+@tone.1),e

    ld a,(hl)   ; attenuation
    inc hl

    and 0x0f
    ld b,a
    ld a,0x0f
    sub b

    ld e,a
    rlca
    rlca
    rlca
    rlca
    or e

    ld (ix+@amplitude.1),a

    ld (sound+@voice.2.ptr),hl

    bit 7,(ix+@octave.1.0)
    jr nz,@silent.2
    set 1,(ix+@frequency.enable)
    jr @continue.2

@silent.2:
    res 1,(ix+@frequency.enable)

@continue.2:

@no.change.2:

    ;-----------------------------------
    ; voice 3

    ld hl,(sound+@voice.3.duration)
    dec hl
    ld (sound+@voice.3.duration),hl

    ld a,h
    or l
    jr nz,@no.change.3

    ld hl,(sound+@voice.3.ptr)

    ld e,(hl)
    inc hl
    ld a,e
    ld (sound+@voice.3.duration+0),a
    ld d,(hl)
    inc hl
    ld a,d
    ld (sound+@voice.3.duration+1),a

    ld a,0xff
    cp d
    jr nz,@not.end.3
    cp e
    jr z,@silent.3  ; end of note

@not.end.3:

    ld e,(hl)       ; freq
    inc hl
    ld d,(hl)       ; freq
    inc hl
    call @get.tone  ; de = oct tone

    ld a,(ix+@octave.3.2)
    and 0xf0
    or d
    ld (ix+@octave.3.2),a

    ld (ix+@tone.2),e

    ld a,(hl)   ; attenuation
    inc hl

    and 0x0f
    ld b,a
    ld a,0x0f
    sub b

    ld e,a
    rlca
    rlca
    rlca
    rlca
    or e

    ld (ix+@amplitude.2),a

    ld (sound+@voice.3.ptr),hl

    bit 3,(ix+@octave.3.2)
    jr nz,@silent.3
    set 2,(ix+@frequency.enable)
    jr @continue.3

@silent.3:
    res 2,(ix+@frequency.enable)

@continue.3:

@no.change.3:

    ld bc,port.sound.data
    ld hl,@saa

    for 26, outi

    pop bc
    pop de
    pop hl
    pop ix

    ret

;-------------------------------------------------------------------------------
@saa:
    org 0

                        defb saa.register.amplitude_0
    @amplitude.0:       defb 0
                        defb saa.register.amplitude_1
    @amplitude.1:       defb 0
                        defb saa.register.amplitude_2
    @amplitude.2:       defb 0
                        defb saa.register.amplitude_3
    @amplitude.3:       defb 0

                        defb saa.register.frequency_tone_0
    @tone.0:            defb 0
                        defb saa.register.frequency_tone_1
    @tone.1:            defb 0
                        defb saa.register.frequency_tone_2
    @tone.2:            defb 0
                        defb saa.register.frequency_tone_3
    @tone.3:            defb 0

                        defb saa.register.octave_1_0
    @octave.1.0:        defb 0  ; .111.000
                        defb saa.register.octave_3_2
    @octave.3.2:        defb 0  ; .333.222

                        defb saa.register.frequency_enable
    @frequency.enable:  defb 0  ; ..543210
                        defb saa.register.noise_enable
    @noise.enable:      defb 0  ; ..543210

                        defb saa.register.noise_generator_1_0
    @noise.generator:   defb 0  ; ..11..00

    org @saa + $

;===============================================================================
@get.tone:
;
; input
;   de = n in agi format ((Byte3 & 0x3f) << 4) + (Byte4 & 0x0f))
;
; output
;   de = octave, tone
;-------------------------------------------------------------------------------

    ld b,d

    ld a,e
    and %00111111
    rlca            ; << 1
    rlca            ; << 2
    ld d,0
    ld e,a
    sla e
    rl d            ; << 3
    sla e
    rl d            ; << 4
    sla e
    rl d            ; * 2

    ld a,b
    and %00001111
    rlca
    or e
    ld e,a

    ld a,@saa.frequency / 0x100
    add a,d
    ld d,a

    ex de,hl

    ld a,(hl)
    inc l
    ld l,(hl)
    ld h,a

    ex de,hl

    ret

;===============================================================================
snd.sound:
;
; input
;   b = sound
;   c = flagdone
;-------------------------------------------------------------------------------

    ld a,c
    ld (sound+@flagdone),a

    ld a,b
    ld (sound+@no),a

    call @get.ptr.snd.header.hl

    ld a,1
    call @get.voice.ptr.de
    ld (sound+@voice.1.ptr),de

    ld a,2
    call @get.voice.ptr.de
    ld (sound+@voice.2.ptr),de

    ld a,3
    call @get.voice.ptr.de
    ld (sound+@voice.3.ptr),de

    ld a,4
    call @get.voice.ptr.de
    ld (sound+@noise.ptr),de

    ; set all durations to 1, notes will be picked up on first play
    ld hl,1
    ld (sound+@voice.1.duration),hl
    ld (sound+@voice.2.duration),hl
    ld (sound+@voice.3.duration),hl
    ld (sound+@noise.duration),hl

    ld bc,port.sound.address
    ld a,saa.register.sound_enable
    out (c),a
    dec b
    ld a,saa.se.channels.enabled
    out (c),a
    inc b

    ld a,saa.register.frequency_enable
    out (c),a
    dec b
    xor a
    out(c),a

    ret

;===============================================================================
@get.voice.ptr.de:
;
; input
;   a  = voice [0-3]
;   hl = snd header
;
; output
;   de = ptr voice data
;
;-------------------------------------------------------------------------------

    push hl
    push hl

    dec a
    add a,a
    ld e,a
    ld d,0
    add hl,de

    ld e,(hl)
    inc hl
    ld d,(hl)

    pop hl

    add hl,de
    ex de,hl

    pop hl

    ret

;===============================================================================
@get.ptr.snd.header.hl:
;
; input
;   a = snd
;
; output
;   hl = snd header
;
; destroys: bc
;
;
; Byte Meaning
; ---- ----------------------------
; 0-1  Offset of first voice data
; 2-3  Offset of second voice data
; 4-5  Offset of third voice data
; 6-7  Offset of noise voice data
; ---- -----------------------------
;
;-------------------------------------------------------------------------------

    ld l,a
    ld h,0
    add hl,hl
    add hl,hl
    add hl,hl
    ld bc,ptr.snddir + 3
    add hl,bc

    ld a,(hl)
    inc l
    ld h,(hl)
    ld l,a

    ret

;-------------------------------------------------------------------------------

    align 0x100

; Texas Instruments SN 76489 AN -> Philips SAA1099 frequency table
;
; SN:  frequency = 111860 / n
; SAA: frequency = ( 15625 * ( 2^octave ) ) / ( 511-note )
;
; generated with https://abldojo.services.progress.com/?shareId=60a2e6329585066c21979919

@saa.frequency:

    ;  oct,tone  n
    defb 8,255 ; 0
    defb 7,255 ; 1
    defb 7,255 ; 2
    defb 7,255 ; 3
    defb 7,255 ; 4
    defb 7,255 ; 5
    defb 7,255 ; 6
    defb 7,255 ; 7
    defb 7,255 ; 8
    defb 7,255 ; 9
    defb 7,255 ; 10
    defb 7,255 ; 11
    defb 7,255 ; 12
    defb 7,255 ; 13
    defb 7,255 ; 14
    defb 7,243 ; 15
    defb 7,225 ; 16
    defb 7,207 ; 17
    defb 7,189 ; 18
    defb 7,171 ; 19
    defb 7,153 ; 20
    defb 7,136 ; 21
    defb 7,118 ; 22
    defb 7,100 ; 23
    defb 7, 82 ; 24
    defb 7, 64 ; 25
    defb 7, 46 ; 26
    defb 7, 28 ; 27
    defb 7, 10 ; 28
    defb 6,252 ; 29
    defb 6,243 ; 30
    defb 6,234 ; 31
    defb 6,225 ; 32
    defb 6,216 ; 33
    defb 6,207 ; 34
    defb 6,198 ; 35
    defb 6,189 ; 36
    defb 6,180 ; 37
    defb 6,171 ; 38
    defb 6,162 ; 39
    defb 6,153 ; 40
    defb 6,144 ; 41
    defb 6,135 ; 42
    defb 6,127 ; 43
    defb 6,118 ; 44
    defb 6,109 ; 45
    defb 6,100 ; 46
    defb 6, 91 ; 47
    defb 6, 82 ; 48
    defb 6, 73 ; 49
    defb 6, 64 ; 50
    defb 6, 55 ; 51
    defb 6, 46 ; 52
    defb 6, 37 ; 53
    defb 6, 28 ; 54
    defb 6, 19 ; 55
    defb 6, 10 ; 56
    defb 6,  1 ; 57
    defb 5,252 ; 58
    defb 5,247 ; 59
    defb 5,243 ; 60
    defb 5,238 ; 61
    defb 5,234 ; 62
    defb 5,229 ; 63
    defb 5,225 ; 64
    defb 5,220 ; 65
    defb 5,216 ; 66
    defb 5,212 ; 67
    defb 5,207 ; 68
    defb 5,203 ; 69
    defb 5,198 ; 70
    defb 5,194 ; 71
    defb 5,189 ; 72
    defb 5,185 ; 73
    defb 5,180 ; 74
    defb 5,176 ; 75
    defb 5,171 ; 76
    defb 5,167 ; 77
    defb 5,162 ; 78
    defb 5,158 ; 79
    defb 5,153 ; 80
    defb 5,149 ; 81
    defb 5,144 ; 82
    defb 5,140 ; 83
    defb 5,136 ; 84
    defb 5,131 ; 85
    defb 5,127 ; 86
    defb 5,122 ; 87
    defb 5,118 ; 88
    defb 5,113 ; 89
    defb 5,109 ; 90
    defb 5,104 ; 91
    defb 5,100 ; 92
    defb 5, 95 ; 93
    defb 5, 91 ; 94
    defb 5, 86 ; 95
    defb 5, 82 ; 96
    defb 5, 77 ; 97
    defb 5, 73 ; 98
    defb 5, 68 ; 99
    defb 5, 64 ; 100
    defb 5, 60 ; 101
    defb 5, 55 ; 102
    defb 5, 50 ; 103
    defb 5, 46 ; 104
    defb 5, 41 ; 105
    defb 5, 37 ; 106
    defb 5, 32 ; 107
    defb 5, 28 ; 108
    defb 5, 23 ; 109
    defb 5, 19 ; 110
    defb 5, 15 ; 111
    defb 5, 10 ; 112
    defb 5,  6 ; 113
    defb 5,  1 ; 114
    defb 4,254 ; 115
    defb 4,252 ; 116
    defb 4,249 ; 117
    defb 4,247 ; 118
    defb 4,245 ; 119
    defb 4,243 ; 120
    defb 4,240 ; 121
    defb 4,238 ; 122
    defb 4,236 ; 123
    defb 4,234 ; 124
    defb 4,232 ; 125
    defb 4,229 ; 126
    defb 4,227 ; 127
    defb 4,225 ; 128
    defb 4,223 ; 129
    defb 4,220 ; 130
    defb 4,218 ; 131
    defb 4,216 ; 132
    defb 4,214 ; 133
    defb 4,212 ; 134
    defb 4,209 ; 135
    defb 4,207 ; 136
    defb 4,205 ; 137
    defb 4,203 ; 138
    defb 4,200 ; 139
    defb 4,198 ; 140
    defb 4,196 ; 141
    defb 4,194 ; 142
    defb 4,191 ; 143
    defb 4,189 ; 144
    defb 4,187 ; 145
    defb 4,184 ; 146
    defb 4,182 ; 147
    defb 4,180 ; 148
    defb 4,178 ; 149
    defb 4,176 ; 150
    defb 4,173 ; 151
    defb 4,171 ; 152
    defb 4,169 ; 153
    defb 4,166 ; 154
    defb 4,165 ; 155
    defb 4,162 ; 156
    defb 4,160 ; 157
    defb 4,158 ; 158
    defb 4,156 ; 159
    defb 4,153 ; 160
    defb 4,151 ; 161
    defb 4,148 ; 162
    defb 4,146 ; 163
    defb 4,144 ; 164
    defb 4,142 ; 165
    defb 4,140 ; 166
    defb 4,138 ; 167
    defb 4,135 ; 168
    defb 4,133 ; 169
    defb 4,131 ; 170
    defb 4,129 ; 171
    defb 4,126 ; 172
    defb 4,124 ; 173
    defb 4,122 ; 174
    defb 4,120 ; 175
    defb 4,118 ; 176
    defb 4,115 ; 177
    defb 4,113 ; 178
    defb 4,111 ; 179
    defb 4,108 ; 180
    defb 4,106 ; 181
    defb 4,104 ; 182
    defb 4,102 ; 183
    defb 4,100 ; 184
    defb 4, 98 ; 185
    defb 4, 95 ; 186
    defb 4, 93 ; 187
    defb 4, 91 ; 188
    defb 4, 89 ; 189
    defb 4, 86 ; 190
    defb 4, 84 ; 191
    defb 4, 82 ; 192
    defb 4, 80 ; 193
    defb 4, 78 ; 194
    defb 4, 75 ; 195
    defb 4, 73 ; 196
    defb 4, 71 ; 197
    defb 4, 68 ; 198
    defb 4, 66 ; 199
    defb 4, 64 ; 200
    defb 4, 62 ; 201
    defb 4, 60 ; 202
    defb 4, 57 ; 203
    defb 4, 55 ; 204
    defb 4, 53 ; 205
    defb 4, 51 ; 206
    defb 4, 48 ; 207
    defb 4, 46 ; 208
    defb 4, 44 ; 209
    defb 4, 42 ; 210
    defb 4, 39 ; 211
    defb 4, 37 ; 212
    defb 4, 35 ; 213
    defb 4, 33 ; 214
    defb 4, 30 ; 215
    defb 4, 28 ; 216
    defb 4, 26 ; 217
    defb 4, 24 ; 218
    defb 4, 22 ; 219
    defb 4, 19 ; 220
    defb 4, 17 ; 221
    defb 4, 15 ; 222
    defb 4, 13 ; 223
    defb 4, 10 ; 224
    defb 4,  8 ; 225
    defb 4,  6 ; 226
    defb 4,  4 ; 227
    defb 4,  2 ; 228
    defb 3,255 ; 229
    defb 3,254 ; 230
    defb 3,253 ; 231
    defb 3,251 ; 232
    defb 3,250 ; 233
    defb 3,249 ; 234
    defb 3,248 ; 235
    defb 3,247 ; 236
    defb 3,246 ; 237
    defb 3,245 ; 238
    defb 3,244 ; 239
    defb 3,243 ; 240
    defb 3,241 ; 241
    defb 3,240 ; 242
    defb 3,239 ; 243
    defb 3,238 ; 244
    defb 3,237 ; 245
    defb 3,236 ; 246
    defb 3,235 ; 247
    defb 3,234 ; 248
    defb 3,232 ; 249
    defb 3,231 ; 250
    defb 3,231 ; 251
    defb 3,229 ; 252
    defb 3,228 ; 253
    defb 3,227 ; 254
    defb 3,226 ; 255
    defb 3,225 ; 256
    defb 3,223 ; 257
    defb 3,223 ; 258
    defb 3,221 ; 259
    defb 3,220 ; 260
    defb 3,219 ; 261
    defb 3,218 ; 262
    defb 3,217 ; 263
    defb 3,216 ; 264
    defb 3,215 ; 265
    defb 3,214 ; 266
    defb 3,213 ; 267
    defb 3,211 ; 268
    defb 3,210 ; 269
    defb 3,209 ; 270
    defb 3,208 ; 271
    defb 3,207 ; 272
    defb 3,206 ; 273
    defb 3,205 ; 274
    defb 3,204 ; 275
    defb 3,202 ; 276
    defb 3,201 ; 277
    defb 3,200 ; 278
    defb 3,199 ; 279
    defb 3,198 ; 280
    defb 3,197 ; 281
    defb 3,196 ; 282
    defb 3,194 ; 283
    defb 3,194 ; 284
    defb 3,192 ; 285
    defb 3,191 ; 286
    defb 3,190 ; 287
    defb 3,189 ; 288
    defb 3,188 ; 289
    defb 3,187 ; 290
    defb 3,185 ; 291
    defb 3,185 ; 292
    defb 3,184 ; 293
    defb 3,182 ; 294
    defb 3,181 ; 295
    defb 3,180 ; 296
    defb 3,179 ; 297
    defb 3,178 ; 298
    defb 3,177 ; 299
    defb 3,176 ; 300
    defb 3,175 ; 301
    defb 3,173 ; 302
    defb 3,172 ; 303
    defb 3,171 ; 304
    defb 3,170 ; 305
    defb 3,169 ; 306
    defb 3,168 ; 307
    defb 3,167 ; 308
    defb 3,166 ; 309
    defb 3,165 ; 310
    defb 3,164 ; 311
    defb 3,163 ; 312
    defb 3,161 ; 313
    defb 3,160 ; 314
    defb 3,159 ; 315
    defb 3,158 ; 316
    defb 3,157 ; 317
    defb 3,156 ; 318
    defb 3,155 ; 319
    defb 3,154 ; 320
    defb 3,152 ; 321
    defb 3,151 ; 322
    defb 3,150 ; 323
    defb 3,149 ; 324
    defb 3,148 ; 325
    defb 3,147 ; 326
    defb 3,146 ; 327
    defb 3,144 ; 328
    defb 3,143 ; 329
    defb 3,142 ; 330
    defb 3,141 ; 331
    defb 3,140 ; 332
    defb 3,139 ; 333
    defb 3,138 ; 334
    defb 3,137 ; 335
    defb 3,136 ; 336
    defb 3,135 ; 337
    defb 3,133 ; 338
    defb 3,132 ; 339
    defb 3,131 ; 340
    defb 3,130 ; 341
    defb 3,129 ; 342
    defb 3,128 ; 343
    defb 3,126 ; 344
    defb 3,125 ; 345
    defb 3,124 ; 346
    defb 3,123 ; 347
    defb 3,122 ; 348
    defb 3,122 ; 349
    defb 3,120 ; 350
    defb 3,119 ; 351
    defb 3,118 ; 352
    defb 3,117 ; 353
    defb 3,116 ; 354
    defb 3,114 ; 355
    defb 3,113 ; 356
    defb 3,112 ; 357
    defb 3,110 ; 358
    defb 3,110 ; 359
    defb 3,109 ; 360
    defb 3,108 ; 361
    defb 3,107 ; 362
    defb 3,105 ; 363
    defb 3,104 ; 364
    defb 3,103 ; 365
    defb 3,103 ; 366
    defb 3,101 ; 367
    defb 3,100 ; 368
    defb 3, 99 ; 369
    defb 3, 97 ; 370
    defb 3, 97 ; 371
    defb 3, 96 ; 372
    defb 3, 95 ; 373
    defb 3, 93 ; 374
    defb 3, 92 ; 375
    defb 3, 92 ; 376
    defb 3, 90 ; 377
    defb 3, 89 ; 378
    defb 3, 87 ; 379
    defb 3, 86 ; 380
    defb 3, 86 ; 381
    defb 3, 85 ; 382
    defb 3, 83 ; 383
    defb 3, 82 ; 384
    defb 3, 82 ; 385
    defb 3, 80 ; 386
    defb 3, 79 ; 387
    defb 3, 77 ; 388
    defb 3, 77 ; 389
    defb 3, 76 ; 390
    defb 3, 74 ; 391
    defb 3, 73 ; 392
    defb 3, 73 ; 393
    defb 3, 71 ; 394
    defb 3, 70 ; 395
    defb 3, 68 ; 396
    defb 3, 68 ; 397
    defb 3, 66 ; 398
    defb 3, 65 ; 399
    defb 3, 65 ; 400
    defb 3, 63 ; 401
    defb 3, 62 ; 402
    defb 3, 62 ; 403
    defb 3, 60 ; 404
    defb 3, 58 ; 405
    defb 3, 58 ; 406
    defb 3, 57 ; 407
    defb 3, 55 ; 408
    defb 3, 53 ; 409
    defb 3, 53 ; 410
    defb 3, 52 ; 411
    defb 3, 52 ; 412
    defb 3, 50 ; 413
    defb 3, 48 ; 414
    defb 3, 48 ; 415
    defb 3, 47 ; 416
    defb 3, 45 ; 417
    defb 3, 45 ; 418
    defb 3, 43 ; 419
    defb 3, 41 ; 420
    defb 3, 41 ; 421
    defb 3, 40 ; 422
    defb 3, 38 ; 423
    defb 3, 38 ; 424
    defb 3, 36 ; 425
    defb 3, 36 ; 426
    defb 3, 34 ; 427
    defb 3, 32 ; 428
    defb 3, 32 ; 429
    defb 3, 31 ; 430
    defb 3, 31 ; 431
    defb 3, 29 ; 432
    defb 3, 27 ; 433
    defb 3, 27 ; 434
    defb 3, 25 ; 435
    defb 3, 25 ; 436
    defb 3, 23 ; 437
    defb 3, 21 ; 438
    defb 3, 21 ; 439
    defb 3, 19 ; 440
    defb 3, 19 ; 441
    defb 3, 17 ; 442
    defb 3, 17 ; 443
    defb 3, 15 ; 444
    defb 3, 13 ; 445
    defb 3, 13 ; 446
    defb 3, 11 ; 447
    defb 3, 11 ; 448
    defb 3,  9 ; 449
    defb 3,  9 ; 450
    defb 3,  7 ; 451
    defb 3,  5 ; 452
    defb 3,  5 ; 453
    defb 3,  3 ; 454
    defb 3,  3 ; 455
    defb 3,  1 ; 456
    defb 3,  1 ; 457
    defb 2,255 ; 458
    defb 2,255 ; 459
    defb 2,254 ; 460
    defb 2,254 ; 461
    defb 2,253 ; 462
    defb 2,253 ; 463
    defb 2,252 ; 464
    defb 2,252 ; 465
    defb 2,251 ; 466
    defb 2,251 ; 467
    defb 2,250 ; 468
    defb 2,250 ; 469
    defb 2,248 ; 470
    defb 2,247 ; 471
    defb 2,247 ; 472
    defb 2,246 ; 473
    defb 2,246 ; 474
    defb 2,245 ; 475
    defb 2,245 ; 476
    defb 2,245 ; 477
    defb 2,244 ; 478
    defb 2,244 ; 479
    defb 2,243 ; 480
    defb 2,243 ; 481
    defb 2,242 ; 482
    defb 2,242 ; 483
    defb 2,241 ; 484
    defb 2,241 ; 485
    defb 2,239 ; 486
    defb 2,239 ; 487
    defb 2,238 ; 488
    defb 2,238 ; 489
    defb 2,237 ; 490
    defb 2,237 ; 491
    defb 2,236 ; 492
    defb 2,236 ; 493
    defb 2,235 ; 494
    defb 2,235 ; 495
    defb 2,235 ; 496
    defb 2,233 ; 497
    defb 2,233 ; 498
    defb 2,232 ; 499
    defb 2,232 ; 500
    defb 2,231 ; 501
    defb 2,231 ; 502
    defb 2,230 ; 503
    defb 2,230 ; 504
    defb 2,230 ; 505
    defb 2,228 ; 506
    defb 2,228 ; 507
    defb 2,227 ; 508
    defb 2,227 ; 509
    defb 2,226 ; 510
    defb 2,226 ; 511
    defb 2,224 ; 512
    defb 2,224 ; 513
    defb 2,224 ; 514
    defb 2,223 ; 515
    defb 2,223 ; 516
    defb 2,222 ; 517
    defb 2,222 ; 518
    defb 2,222 ; 519
    defb 2,220 ; 520
    defb 2,220 ; 521
    defb 2,219 ; 522
    defb 2,219 ; 523
    defb 2,218 ; 524
    defb 2,218 ; 525
    defb 2,218 ; 526
    defb 2,216 ; 527
    defb 2,216 ; 528
    defb 2,215 ; 529
    defb 2,215 ; 530
    defb 2,215 ; 531
    defb 2,214 ; 532
    defb 2,214 ; 533
    defb 2,212 ; 534
    defb 2,212 ; 535
    defb 2,212 ; 536
    defb 2,211 ; 537
    defb 2,211 ; 538
    defb 2,211 ; 539
    defb 2,209 ; 540
    defb 2,209 ; 541
    defb 2,208 ; 542
    defb 2,208 ; 543
    defb 2,208 ; 544
    defb 2,206 ; 545
    defb 2,206 ; 546
    defb 2,205 ; 547
    defb 2,205 ; 548
    defb 2,205 ; 549
    defb 2,203 ; 550
    defb 2,203 ; 551
    defb 2,203 ; 552
    defb 2,202 ; 553
    defb 2,202 ; 554
    defb 2,202 ; 555
    defb 2,200 ; 556
    defb 2,200 ; 557
    defb 2,199 ; 558
    defb 2,199 ; 559
    defb 2,199 ; 560
    defb 2,197 ; 561
    defb 2,197 ; 562
    defb 2,197 ; 563
    defb 2,196 ; 564
    defb 2,196 ; 565
    defb 2,196 ; 566
    defb 2,194 ; 567
    defb 2,194 ; 568
    defb 2,194 ; 569
    defb 2,192 ; 570
    defb 2,192 ; 571
    defb 2,192 ; 572
    defb 2,191 ; 573
    defb 2,191 ; 574
    defb 2,191 ; 575
    defb 2,189 ; 576
    defb 2,189 ; 577
    defb 2,189 ; 578
    defb 2,188 ; 579
    defb 2,188 ; 580
    defb 2,188 ; 581
    defb 2,186 ; 582
    defb 2,186 ; 583
    defb 2,186 ; 584
    defb 2,184 ; 585
    defb 2,184 ; 586
    defb 2,184 ; 587
    defb 2,182 ; 588
    defb 2,182 ; 589
    defb 2,182 ; 590
    defb 2,181 ; 591
    defb 2,181 ; 592
    defb 2,181 ; 593
    defb 2,179 ; 594
    defb 2,179 ; 595
    defb 2,179 ; 596
    defb 2,177 ; 597
    defb 2,177 ; 598
    defb 2,177 ; 599
    defb 2,175 ; 600
    defb 2,175 ; 601
    defb 2,175 ; 602
    defb 2,175 ; 603
    defb 2,174 ; 604
    defb 2,174 ; 605
    defb 2,174 ; 606
    defb 2,172 ; 607
    defb 2,172 ; 608
    defb 2,172 ; 609
    defb 2,170 ; 610
    defb 2,170 ; 611
    defb 2,170 ; 612
    defb 2,168 ; 613
    defb 2,168 ; 614
    defb 2,168 ; 615
    defb 2,168 ; 616
    defb 2,166 ; 617
    defb 2,166 ; 618
    defb 2,166 ; 619
    defb 2,164 ; 620
    defb 2,164 ; 621
    defb 2,164 ; 622
    defb 2,164 ; 623
    defb 2,162 ; 624
    defb 2,162 ; 625
    defb 2,162 ; 626
    defb 2,160 ; 627
    defb 2,160 ; 628
    defb 2,160 ; 629
    defb 2,160 ; 630
    defb 2,158 ; 631
    defb 2,158 ; 632
    defb 2,158 ; 633
    defb 2,156 ; 634
    defb 2,156 ; 635
    defb 2,156 ; 636
    defb 2,156 ; 637
    defb 2,154 ; 638
    defb 2,154 ; 639
    defb 2,154 ; 640
    defb 2,154 ; 641
    defb 2,152 ; 642
    defb 2,152 ; 643
    defb 2,152 ; 644
    defb 2,150 ; 645
    defb 2,150 ; 646
    defb 2,150 ; 647
    defb 2,150 ; 648
    defb 2,148 ; 649
    defb 2,148 ; 650
    defb 2,148 ; 651
    defb 2,148 ; 652
    defb 2,146 ; 653
    defb 2,146 ; 654
    defb 2,146 ; 655
    defb 2,146 ; 656
    defb 2,144 ; 657
    defb 2,144 ; 658
    defb 2,144 ; 659
    defb 2,142 ; 660
    defb 2,142 ; 661
    defb 2,142 ; 662
    defb 2,142 ; 663
    defb 2,140 ; 664
    defb 2,140 ; 665
    defb 2,140 ; 666
    defb 2,140 ; 667
    defb 2,137 ; 668
    defb 2,137 ; 669
    defb 2,137 ; 670
    defb 2,137 ; 671
    defb 2,135 ; 672
    defb 2,135 ; 673
    defb 2,135 ; 674
    defb 2,135 ; 675
    defb 2,133 ; 676
    defb 2,133 ; 677
    defb 2,133 ; 678
    defb 2,133 ; 679
    defb 2,133 ; 680
    defb 2,131 ; 681
    defb 2,131 ; 682
    defb 2,131 ; 683
    defb 2,131 ; 684
    defb 2,128 ; 685
    defb 2,128 ; 686
    defb 2,128 ; 687
    defb 2,128 ; 688
    defb 2,126 ; 689
    defb 2,126 ; 690
    defb 2,126 ; 691
    defb 2,126 ; 692
    defb 2,124 ; 693
    defb 2,124 ; 694
    defb 2,124 ; 695
    defb 2,124 ; 696
    defb 2,121 ; 697
    defb 2,121 ; 698
    defb 2,121 ; 699
    defb 2,121 ; 700
    defb 2,121 ; 701
    defb 2,119 ; 702
    defb 2,119 ; 703
    defb 2,119 ; 704
    defb 2,119 ; 705
    defb 2,116 ; 706
    defb 2,116 ; 707
    defb 2,116 ; 708
    defb 2,116 ; 709
    defb 2,116 ; 710
    defb 2,114 ; 711
    defb 2,114 ; 712
    defb 2,114 ; 713
    defb 2,114 ; 714
    defb 2,111 ; 715
    defb 2,111 ; 716
    defb 2,111 ; 717
    defb 2,111 ; 718
    defb 2,111 ; 719
    defb 2,109 ; 720
    defb 2,109 ; 721
    defb 2,109 ; 722
    defb 2,109 ; 723
    defb 2,109 ; 724
    defb 2,106 ; 725
    defb 2,106 ; 726
    defb 2,106 ; 727
    defb 2,106 ; 728
    defb 2,103 ; 729
    defb 2,103 ; 730
    defb 2,103 ; 731
    defb 2,103 ; 732
    defb 2,103 ; 733
    defb 2,101 ; 734
    defb 2,101 ; 735
    defb 2,101 ; 736
    defb 2,101 ; 737
    defb 2,101 ; 738
    defb 2, 98 ; 739
    defb 2, 98 ; 740
    defb 2, 98 ; 741
    defb 2, 98 ; 742
    defb 2, 98 ; 743
    defb 2, 95 ; 744
    defb 2, 95 ; 745
    defb 2, 95 ; 746
    defb 2, 95 ; 747
    defb 2, 95 ; 748
    defb 2, 92 ; 749
    defb 2, 92 ; 750
    defb 2, 92 ; 751
    defb 2, 92 ; 752
    defb 2, 92 ; 753
    defb 2, 90 ; 754
    defb 2, 90 ; 755
    defb 2, 90 ; 756
    defb 2, 90 ; 757
    defb 2, 90 ; 758
    defb 2, 87 ; 759
    defb 2, 87 ; 760
    defb 2, 87 ; 761
    defb 2, 87 ; 762
    defb 2, 87 ; 763
    defb 2, 84 ; 764
    defb 2, 84 ; 765
    defb 2, 84 ; 766
    defb 2, 84 ; 767
    defb 2, 84 ; 768
    defb 2, 81 ; 769
    defb 2, 81 ; 770
    defb 2, 81 ; 771
    defb 2, 81 ; 772
    defb 2, 81 ; 773
    defb 2, 81 ; 774
    defb 2, 78 ; 775
    defb 2, 78 ; 776
    defb 2, 78 ; 777
    defb 2, 78 ; 778
    defb 2, 78 ; 779
    defb 2, 75 ; 780
    defb 2, 75 ; 781
    defb 2, 75 ; 782
    defb 2, 75 ; 783
    defb 2, 75 ; 784
    defb 2, 72 ; 785
    defb 2, 72 ; 786
    defb 2, 72 ; 787
    defb 2, 72 ; 788
    defb 2, 72 ; 789
    defb 2, 72 ; 790
    defb 2, 69 ; 791
    defb 2, 69 ; 792
    defb 2, 69 ; 793
    defb 2, 69 ; 794
    defb 2, 69 ; 795
    defb 2, 69 ; 796
    defb 2, 66 ; 797
    defb 2, 66 ; 798
    defb 2, 66 ; 799
    defb 2, 66 ; 800
    defb 2, 66 ; 801
    defb 2, 62 ; 802
    defb 2, 62 ; 803
    defb 2, 62 ; 804
    defb 2, 62 ; 805
    defb 2, 62 ; 806
    defb 2, 62 ; 807
    defb 2, 59 ; 808
    defb 2, 59 ; 809
    defb 2, 59 ; 810
    defb 2, 59 ; 811
    defb 2, 59 ; 812
    defb 2, 59 ; 813
    defb 2, 56 ; 814
    defb 2, 56 ; 815
    defb 2, 56 ; 816
    defb 2, 56 ; 817
    defb 2, 56 ; 818
    defb 2, 56 ; 819
    defb 2, 53 ; 820
    defb 2, 53 ; 821
    defb 2, 53 ; 822
    defb 2, 53 ; 823
    defb 2, 53 ; 824
    defb 2, 53 ; 825
    defb 2, 49 ; 826
    defb 2, 49 ; 827
    defb 2, 49 ; 828
    defb 2, 49 ; 829
    defb 2, 49 ; 830
    defb 2, 49 ; 831
    defb 2, 46 ; 832
    defb 2, 46 ; 833
    defb 2, 46 ; 834
    defb 2, 46 ; 835
    defb 2, 46 ; 836
    defb 2, 46 ; 837
    defb 2, 42 ; 838
    defb 2, 42 ; 839
    defb 2, 42 ; 840
    defb 2, 42 ; 841
    defb 2, 42 ; 842
    defb 2, 42 ; 843
    defb 2, 42 ; 844
    defb 2, 39 ; 845
    defb 2, 39 ; 846
    defb 2, 39 ; 847
    defb 2, 39 ; 848
    defb 2, 39 ; 849
    defb 2, 39 ; 850
    defb 2, 35 ; 851
    defb 2, 35 ; 852
    defb 2, 35 ; 853
    defb 2, 35 ; 854
    defb 2, 35 ; 855
    defb 2, 35 ; 856
    defb 2, 35 ; 857
    defb 2, 32 ; 858
    defb 2, 32 ; 859
    defb 2, 32 ; 860
    defb 2, 32 ; 861
    defb 2, 32 ; 862
    defb 2, 32 ; 863
    defb 2, 28 ; 864
    defb 2, 28 ; 865
    defb 2, 28 ; 866
    defb 2, 28 ; 867
    defb 2, 28 ; 868
    defb 2, 28 ; 869
    defb 2, 28 ; 870
    defb 2, 24 ; 871
    defb 2, 24 ; 872
    defb 2, 24 ; 873
    defb 2, 24 ; 874
    defb 2, 24 ; 875
    defb 2, 24 ; 876
    defb 2, 24 ; 877
    defb 2, 20 ; 878
    defb 2, 20 ; 879
    defb 2, 20 ; 880
    defb 2, 20 ; 881
    defb 2, 20 ; 882
    defb 2, 20 ; 883
    defb 2, 20 ; 884
    defb 2, 16 ; 885
    defb 2, 16 ; 886
    defb 2, 16 ; 887
    defb 2, 16 ; 888
    defb 2, 16 ; 889
    defb 2, 16 ; 890
    defb 2, 16 ; 891
    defb 2, 12 ; 892
    defb 2, 12 ; 893
    defb 2, 12 ; 894
    defb 2, 12 ; 895
    defb 2, 12 ; 896
    defb 2, 12 ; 897
    defb 2, 12 ; 898
    defb 2,  8 ; 899
    defb 2,  8 ; 900
    defb 2,  8 ; 901
    defb 2,  8 ; 902
    defb 2,  8 ; 903
    defb 2,  8 ; 904
    defb 2,  8 ; 905
    defb 2,  4 ; 906
    defb 2,  4 ; 907
    defb 2,  4 ; 908
    defb 2,  4 ; 909
    defb 2,  4 ; 910
    defb 2,  4 ; 911
    defb 2,  4 ; 912
    defb 2,  4 ; 913
    defb 2,  0 ; 914
    defb 2,  0 ; 915
    defb 2,  0 ; 916
    defb 2,  0 ; 917
    defb 2,  0 ; 918
    defb 2,  0 ; 919
    defb 2,  0 ; 920
    defb 1,253 ; 921
    defb 1,253 ; 922
    defb 1,253 ; 923
    defb 1,253 ; 924
    defb 1,253 ; 925
    defb 1,253 ; 926
    defb 1,253 ; 927
    defb 1,253 ; 928
    defb 1,251 ; 929
    defb 1,251 ; 930
    defb 1,251 ; 931
    defb 1,251 ; 932
    defb 1,251 ; 933
    defb 1,251 ; 934
    defb 1,251 ; 935
    defb 1,251 ; 936
    defb 1,249 ; 937
    defb 1,249 ; 938
    defb 1,249 ; 939
    defb 1,249 ; 940
    defb 1,249 ; 941
    defb 1,249 ; 942
    defb 1,249 ; 943
    defb 1,247 ; 944
    defb 1,247 ; 945
    defb 1,247 ; 946
    defb 1,247 ; 947
    defb 1,247 ; 948
    defb 1,247 ; 949
    defb 1,247 ; 950
    defb 1,247 ; 951
    defb 1,247 ; 952
    defb 1,245 ; 953
    defb 1,245 ; 954
    defb 1,245 ; 955
    defb 1,245 ; 956
    defb 1,245 ; 957
    defb 1,245 ; 958
    defb 1,245 ; 959
    defb 1,245 ; 960
    defb 1,242 ; 961
    defb 1,242 ; 962
    defb 1,242 ; 963
    defb 1,242 ; 964
    defb 1,242 ; 965
    defb 1,242 ; 966
    defb 1,242 ; 967
    defb 1,242 ; 968
    defb 1,240 ; 969
    defb 1,240 ; 970
    defb 1,240 ; 971
    defb 1,240 ; 972
    defb 1,240 ; 973
    defb 1,240 ; 974
    defb 1,240 ; 975
    defb 1,240 ; 976
    defb 1,238 ; 977
    defb 1,238 ; 978
    defb 1,238 ; 979
    defb 1,238 ; 980
    defb 1,238 ; 981
    defb 1,238 ; 982
    defb 1,238 ; 983
    defb 1,238 ; 984
    defb 1,238 ; 985
    defb 1,235 ; 986
    defb 1,235 ; 987
    defb 1,235 ; 988
    defb 1,235 ; 989
    defb 1,235 ; 990
    defb 1,235 ; 991
    defb 1,235 ; 992
    defb 1,235 ; 993
    defb 1,235 ; 994
    defb 1,233 ; 995
    defb 1,233 ; 996
    defb 1,233 ; 997
    defb 1,233 ; 998
    defb 1,233 ; 999
    defb 1,233 ; 1000
    defb 1,233 ; 1001
    defb 1,233 ; 1002
    defb 1,233 ; 1003
    defb 1,230 ; 1004
    defb 1,230 ; 1005
    defb 1,230 ; 1006
    defb 1,230 ; 1007
    defb 1,230 ; 1008
    defb 1,230 ; 1009
    defb 1,230 ; 1010
    defb 1,230 ; 1011
    defb 1,230 ; 1012
    defb 1,228 ; 1013
    defb 1,228 ; 1014
    defb 1,228 ; 1015
    defb 1,228 ; 1016
    defb 1,228 ; 1017
    defb 1,228 ; 1018
    defb 1,228 ; 1019
    defb 1,228 ; 1020
    defb 1,228 ; 1021
    defb 1,225 ; 1022
    defb 1,225 ; 1023

    assert $ <= ptr.snddir
