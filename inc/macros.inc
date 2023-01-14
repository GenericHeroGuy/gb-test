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

;set bank to A
.MACRO SetBank
	rst $18
.ENDM

;push current bank on stack
.MACRO PushBank
	ldh a, (<hCurBank)
	push af
.ENDM

;restore pushed bank
.MACRO PopBank ARGS Bank
	pop af
	rst $18
.ENDM

.MACRO CallHL
	rst $20
.ENDM

.MACRO CallDE
	rst $28
.ENDM
