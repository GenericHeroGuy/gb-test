.include "memmap.inc"
.include "gbapu.inc"
.include "enums.inc"

.section "player"

Player:
	LDH A, (<pad1)
	LD D, A

	LDH A, (<playerY)
	RLC D
	JR NC, +
	ADD $01

+:	RLC D
	JR NC, +
	SUB $01
+:	LDH (<playerY), A
	LD B, A

	LDH A, (<playerX)
	RLC D
	JR NC, +
	SUB $01

+:	RLC D
	JR NC, +
	ADD $01
+:	LDH (<playerX), A
	LD C, A

	LD A, 0
	CALL DrawMetasprite

	LDH A, (<pad1Pressed)
	AND PAD_START
	LD DE, SgbMusicTest
	LD BC, _sizeof_SgbMusicTest
	CALL NZ, SgbTransferMusic

	LDH A, (<pad1Pressed)
	AND PAD_SELECT
	RET Z
	LD A, C1SWEEP.F0
	LDH (<C1SWEEP), A
	LD A, C1DUTY.25 | 0
	LDH (<C1DUTY), A
	LD A, C1VOL.15 | C1VOL.DOWN | C1VOL.F0
	LDH (<C1VOL), A
	LD A, 0
	LDH (<C1FREQ), A
	LD A, C1CTRL.RESTART | $40 | 0
	LDH (<C1CTRL), A
	LD A, APUMIX.1L | APUMIX.1R
	LDH (<APUMIX), A
	RET

.ends
