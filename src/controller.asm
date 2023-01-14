.INCLUDE "memmap.inc"
.INCLUDE "gameboy.inc"
.INCLUDE "macros.inc"

.SECTION "Controller"

;uses:  AF B HL
ReadInput:
	ld hl, rP1

	ld (hl), P1.DPAD
	ld a, (hl) ;wait 20 Tcycles before reading
	ld a, (hl)
	ld a, (hl)
	swap a     ;set bits 7-4 to D-pad, set bits 3-0 to ~P1.DPAD

	ld (hl), P1.KEYS
	ld b, 4  ;wait 72 Tcycles before reading
-:	dec b
	jr nz, -
	xor (hl) ;XOR bits 3-0 with buttons, XOR bits 7-4 with ~P1.KEYS

	ld (hl), P1.NONE ;disable joypad

	xor (P1.DPAD & $F0) | (P1.KEYS >> 4) ;unmask joypad bits
	;meaning of joypad bits depends on the XOR mask
	;no ~   = 0 not pressed, 1 pressed
	;with ~ = 0 pressed, 1 not pressed

	ld l, <hPad1
	ld b, a
	ld a, (hl+) ;get last frame's joypad data
	xor b       ;get buttons that changed state
	and b       ;mask unpressed buttons
	ld (hl-), a ;set newly pressed buttons in hPad1Pressed
	ld (hl), b  ;set currently pressed buttons in hPad1
	ret

.ENDS
