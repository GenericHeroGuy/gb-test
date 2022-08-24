.include "memmap.inc"
.include "gameboy.inc"
.include "vars.inc"

.section "Controller"

;uses	AF BC
ReadInput:
	LD C, <P1

	LD A, P1.DPAD
	LDH (C), A	;enable D-pad

	LDH A, (C)	;must wait 24 Tcycles
	LDH A, (C)
	LDH A, (C)

	AND $0F
	LD B, A	;save D-pad in B

	LD A, P1.KEYS
	LDH (C), A	;enable buttons

	PUSH AF	;must wait 72 Tcycles
	POP AF
	PUSH AF
	POP AF
	LDH A, (C)
	LDH A, (C)

	AND $0F
	JP Z, Reset	;A+B+Select+Start = Reset game
	SWAP B
	OR B	;set D-pad bits
	CPL	;now joypad data is in A

	LD B, A	;save in B...
	LDH A, (<pad1)	;get last frame's joypad data
	XOR B	;do some magic stuff
	AND B
	LDH (<pad1Pressed), A	;set newly pressed buttons

	LD A, B
	LDH (<pad1), A	;and now, save the joypad values

	LD A, P1.NONE
	LDH (C), A	;disable joypad

	RET

.ends
