.include "memmap.inc"

.bank 0 slot 0
.org 0

.section "Util"

;BC = byte count
;DE = source addr
;HL = target addr
;uses AF
MemCpy:
		LD A, (DE)
		LD (HL+), A
		INC DE
	DEC C
	JR NZ, MemCpy
	DEC B
	JR NZ, MemCpy
	RET

;DE = source addr
;HL = target addr
;uses AF
;like StrCpy, but doesn't copy the last null byte
;useful for VRAM transfers
MemCpyNull:
	LD A, (DE)
	OR A
	RET Z ;exit on null byte
	LD (HL+), A
	INC DE
	JR MemCpyNull

;DE = source addr
;HL = target addr
;uses AF
StrCpy:
	LD A, (DE)
	LD (HL+), A
	INC DE
	OR A
	JR NZ, StrCpy
	RET

.ends
