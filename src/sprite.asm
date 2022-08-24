.include "memmap.inc"
.include "gameboy.inc"
.include "macros.inc"

.bank 0 slot 0
.org 0

.section "Sprite"

;uses	AF BC HL
ClearSprites:
	LD HL, spriteBuffer
	LD BC, 4
	XOR A
	.rept 39
		LD (HL), A
		ADD HL, BC
	.endr
	LD (HL), A
	RET

;A = metasprite ID
;B = metasprite Y
;C = metasprite X
;uses	AF BC DE HL
DrawMetasprite:
	LD L, A	;load into HL, multiply by 2 (left shit), add MetaspritePointers
	LD H, 0
	ADD HL, HL
	LD DE, MetaspritePointers
	ADD HL, DE	;HL = pointer to metasprite pointer
	GetPointerToHL

	LD DE, spriteBuffer

	LD A, (HL+)	;number of sprites
	LDH (<loopCount), A

	LD A, B ;add 16 to Y position
	ADD 16
	LD B, A
	LD A, C	;add 8 to X position
	ADD 8
	LD C, A

SpriteLoop:
	LD A, (HL+)	;get sprite Y
	ADD B	;add metasprite Y
	LD (DE), A
	INC DE

	LD A, (HL+)	;get sprite X
	ADD C	;add metasprite X
	LD (DE), A
	INC DE

	LD A, (HL+)	;get sprite tile
	LD (DE), A
	INC DE

	LD A, (HL+)	;get sprite attrib
	LD (DE), A
	INC DE

	LDH A, (<loopCount)
	DEC A
	LDH (<loopCount), A
	JR NZ, SpriteLoop
	RET

.ends
