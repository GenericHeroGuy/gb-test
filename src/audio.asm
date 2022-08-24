.include "memmap.inc"
.include "gbapu.inc"

.bank 0 slot 0
.org 0

.section "Audio"

AudioEntry:
	RET

SetWaveRam:
	XOR A
	LDH (<C3EN), A
	LD BC, 16 << 8 | <WAVERAM
-:	LD A, (HL+)
	LDH (C), A
	INC C
	DEC B
	JR NZ, -
	RET

WaveSquare:
	.db 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255

.ends
