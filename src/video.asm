.INCLUDE "memmap.inc"
.INCLUDE "gameboy.inc"

.BANK 0 SLOT 0
.ORG 0

.SECTION "Video"

;uses:  AF
DisableLcd:
	ldh a, (<rLY)
	cp 144
	jr c, DisableLcd

	ldh a, (<rLCDC)
	and ~LCDC.ON
	ldh (<rLCDC), a
	ret

.ENDS
