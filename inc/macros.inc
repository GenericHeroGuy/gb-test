.MACRO GetPointerToHL
	ld a, (hl+)
	ld h, (hl)
	ld l, a
.ENDM

.MACRO GetPointerToDE
	ld a, (hl+)
	ld d, (hl)
	ld e, a
.ENDM

.MACRO FarCall ARGS Label
	ld b, :Label
	ld hl, Label
	rst $00	;see vectors.asm
.ENDM

.MACRO FarJp ARGS Label
	ld a, :Label
	ld hl, Label
	rst $10
.ENDM

.MACRO SetBank ARGS Bank
	ld a, Bank
	rst $18
.ENDM

;push current bank on stack, then set new bank
.MACRO PushBank ARGS Bank
	ldh a, (<hCurBank)
	push af
	ld a, Bank
	rst $18
.ENDM

;restore pushed bank
.MACRO PopBank ARGS Bank
	pop af
	rst $18
.ENDM

.MACRO CallHl
	rst $20
.ENDM
