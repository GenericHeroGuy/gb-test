.include "memmap.inc"
.include "enums.inc"

.bank 0 slot 0

;FarCall macro
.orga $00
.section "INT_RST00" size 16 force
	LDH A, (<curBank)
	PUSH AF
	LD A, B
	CALL FarCall_jump
	POP AF
	LDH (<curBank), A
	LD (MBC_BANK), A
	RET
.ends

;FarJp macro
.orga $10
.section "INT_RST10" size 8 force
	ADD SP, 2	;get rid of return address on stack
FarCall_jump:
	LDH (<curBank), A
	LD (MBC_BANK), A
	JP HL
.ends

;SetBank macro
.orga $18
.section "INT_RST18" size 8 force
	LDH (<curBank), A
	LD (MBC_BANK), A
	RET
.ends

;CallHl macro
.orga $20
.section "INT_RST20" size 8 force
	JP HL
.ends

.orga $28
.section "INT_RST28" size 8 force
	JP Reset
.ends

.orga $30
.section "INT_RST30" size 8 force
	JP Reset
.ends

.orga $38
.section "INT_RST38" size 8 force
	JP Reset
.ends

.orga $40
.section "INT_VBLANK" size 8 force
	JP Vblank
.ends

.orga $48
.section "INT_STAT" size 8 force
	JP Reset
.ends

.orga $50
.section "INT_TIMER" size 8 force
	JP Reset
.ends

.orga $58
.section "INT_SERIAL" size 8 force
	JP Reset
.ends

.orga $60
.section "INT_JOYPAD" size 8 force
	JP Reset
.ends
