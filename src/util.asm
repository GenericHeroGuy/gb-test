.INCLUDE "memmap.inc"

.BANK 0 SLOT 0
.ORG 0

.SECTION "Util"

;input: BC = byte count
;       DE = source addr
;       HL = target addr
;uses:  AF BC DE HL
MemCpy:
		ld a, (de)
		ld (hl+), a
		inc de
	dec c
	jr nz, MemCpy
	dec b
	jr nz, MemCpy
	ret

;input: DE = source addr
;       HL = target addr
;uses:  AF DE HL
;like StrCpy, but doesn't copy the last null byte
;useful for VRAM transfers
MemCpyNull:
	ld a, (de)
	or a
	ret z ;exit on null byte
	ld (hl+), a
	inc de
	jr MemCpyNull

;input: DE = source addr
;       HL = target addr
;uses:  AF DE HL
StrCpy:
		ld a, (de)
		ld (hl+), a
		inc de
	or a
	jr nz, StrCpy ;exit on null byte
	ret

.ENDS
