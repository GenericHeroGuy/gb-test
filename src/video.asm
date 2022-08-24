.include "memmap.inc"
.include "gameboy.inc"

.bank 0 slot 0
.org 0

.section "Video"

;uses AF
DisableLcd:
	LDH A, (<LY)
	CP 144
	JR C, DisableLcd

	LDH A, (<LCDC)
	AND ~LCDC.ON
	LDH (<LCDC), A
	RET

.ends