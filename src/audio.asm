.INCLUDE "memmap.inc"
.INCLUDE "gbapu.inc"

.BANK 0 SLOT 0
.ORG 0

.SECTION "Audio"

AudioEntry:
	ret

;input: HL = Waveform address
;uses:  AF BC HL
SetWaveRam:
	xor a
	ldh (<rC3EN), a
	ld bc, 16 << 8 | <rWAVERAM
-:		ld a, (hl+)
		ldh (c), a
		inc c
	dec b
	jr nz, -
	ret

WaveSquare:
	.DB 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255

.ENDS
