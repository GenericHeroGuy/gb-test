.macro GetPointerToHL
	LD A, (HL+)
	LD H, (HL)
	LD L, A
.endm

.macro GetPointerToDE
	LD A, (HL+)
	LD D, (HL)
	LD E, A
.endm

.macro FarCall args Label
	LD B, :Label
	LD HL, Label
	RST $00	;see vectors.asm
.endm

.macro FarJp args Label
	LD A, :Label
	LD HL, Label
	RST $10
.endm

.macro SetBank args Bank
	LD A, Bank
	RST $18
.endm

;push current bank on stack, then set new bank
.macro PushBank args Bank
	LDH A, (<curBank)
	PUSH AF
	LD A, Bank
	RST $18
.endm

;restore pushed bank
.macro PopBank args Bank
	POP AF
	RST $18
.endm

.macro CallHl
	RST $20
.endm
