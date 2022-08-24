.include "memmap.inc"
.include "gameboy.inc"
.include "enums.inc"
.include "macros.inc"

.bank 0 slot 0
.org 0

.section "Main"

Main:
;upload test
	LD HL, uploadAddr
	LD A, $10
	LD (HL+), A
	LD A, $90
	LD (HL+), A
	LD A, <VblankUploadFill
	LD (HL+), A
	LD A, >VblankUploadFill
	LD (HL+), A
;cut here

;farcall test
	FarCall FarCallTest
;cut here

	LD A, %11100100
	LDH (<BGP), A
	LDH (<OBP0), A

WriteCharset:
	LD HL, $8800
	LD DE, CHR_CHARSET
	LD BC, CHR_CHARSET_size
	CALL MemCpy

WriteMessage1:
	LD HL, $9962
	LD DE, Message1

	CALL MemCpyNull

WriteMessage2:
	LD HL, $9982
	LD DE, Message2

	CALL MemCpyNull

End:
	LD A, LCDC_DEFAULT
	LDH (<LCDC), A

	XOR A
	LDH (<IF), A	;acknowledge all interrupts
	LD A, IE.VBLANK
	LDH (<IE), A

	LD A, Player.ID
	LD BC, 0
	LD DE, 0
	CALL AddActor

Forever:
	LD HL, uploadData
	INC (HL)
	CALL ReadInput
	CALL ClearSprites
	CALL Player
	CALL WaitVblank

	JR Forever

WaitVblank:
	HALT
	NOP

	LDH A, (<vblankCount)
	OR A
	JR Z, WaitVblank	;not Vblank? keep waiting

	XOR A
	LDH (<vblankCount), A
	RET

Message1:
	.asc "LOOK MOM, I CAN", 0

Message2:
	.asc "WRITE MESSAGES", 0

.ends

.bank 2 slot 1
.org $4000

.section "FarCallTest"
FarCallTest:
	FarCall FarCallTest2
	RET
.ends

.bank 3 slot 1
.org $4000

.section "FarCallTest2"
FarCallTest2:
	LD DE, $1234
	FarJp FarCallTest3
.ends

.bank 1 slot 1
.org $4000

.section "FarCallTest3"
FarCallTest3:
	RET
.ends
