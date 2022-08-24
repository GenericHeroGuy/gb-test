.include "memmap.inc"
.include "gameboy.inc"
.include "macros.inc"

.bank 0 slot 0
.org 0

.section "Vblank" 

;A = data to fill
VblankUploadFill:
	.rept 400
		LD (HL+), A
	.endr
	INC DE	;next data byte
	JP Vblank_VramUpload

;the LD A, (DE) always comes first so the first load can be skipped (see Vblank_VramUpload)
VblankUploadDotted:
	.rept 32
		LD A, (DE)
		POP HL
		LD (HL), A
		INC DE
	.endr
	JP Vblank_VramUpload

/*
VblankUploadColumn:
	.rept 32
		LD A, (DE)
		LD (HL+), A
		INC DE
		ADD HL, BC
	.endr
	JR Vblank_VramUpload
*/

VblankUploadNormal:
	.rept 32
		LD A, (DE)
		LD (HL+), A
		INC DE
	.endr
	JR Vblank_VramUpload


Vblank:
	PUSH AF
	PUSH BC
	PUSH DE
	PUSH HL

Vblank_VramUploadStart:
	LD (spSave), SP
	LD SP, uploadAddr	;pointer to upload addresses
	LD DE, uploadData	;pointer to upload data
	LD BC, 32	;added to HL when writing columns of tiles

Vblank_VramUpload:
	POP HL ;target address
	LD A, (DE)	;load first data byte
	BIT 7, H	;exit if bit 15 of address is zero
	RET NZ	;otherwise, fetch and jump to upload routine

Vblank_VramUploadEnd:
	LD HL, spSave	;reload stack pointer
	GetPointerToHL
	LD SP, HL

Vblank_OamUpload:
	LD A, >spriteBuffer
	LD BC, $28 << 8 | <DMA
	CALL oamUpload

	LD HL, vblankCount
	INC (HL)
	INC HL	;LD HL, frameCount
	INC (HL)

	EI
	CALL AudioEntry

	POP HL
	POP DE
	POP BC
	POP AF
	RETI
	
.ends
