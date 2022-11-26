.INCLUDE "memmap.inc"
.INCLUDE "gameboy.inc"
.INCLUDE "vars.inc"

.SECTION "Controller"

;uses:  AF BC
ReadInput:
	ld c, <rP1

	ld a, P1.DPAD
	ldh (c), a ;enable D-pad

	ldh a, (c) ;must wait 24 Tcycles
	ldh a, (c)
	ldh a, (c)

	and $0F
	ld b, a ;save D-pad in B

	ld a, P1.KEYS
	ldh (c), a ;enable buttons

	push af ;must wait 72 Tcycles
	pop af
	push af
	pop af
	ldh a, (c)
	ldh a, (c)

	and $0F
	jp z, Reset ;A+B+Select+Start = Reset game
	swap b
	or b        ;set D-pad bits
	cpl         ;now joypad data is in A

	ld b, a         ;save in B...
	ldh a, (<hPad1) ;get last frame's joypad data
	xor b           ;do some magic stuff
	and b
	ldh (<hPad1Pressed), a ;set newly pressed buttons

	ld a, b
	ldh (<hPad1), a ;and now, save the joypad values

	ld a, P1.NONE
	ldh (c), a ;disable joypad
	ret

.ENDS
