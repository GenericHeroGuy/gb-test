.INCLUDE "memmap.inc"
.INCLUDE "enums.inc"

.BANK 0 SLOT 0

;FarCall macro
.ORGA $00
.SECTION "INT_RST00" SIZE 16 FORCE
	ldh a, (<hCurBank)
	push af
	ld a, b
	call FarCall_jump
	pop af
	ldh (<hCurBank), a
	ld (MBC_BANK), a
	ret
.ENDS

;FarJp macro
.ORGA $10
.SECTION "INT_RST10" SIZE 8 FORCE
	add sp, 2 ;skip over return address
FarCall_jump:
	ldh (<hCurBank), a
	ld (MBC_BANK), a
	jp hl
.ENDS

;SetBank macro
.ORGA $18
.SECTION "INT_RST18" SIZE 8 FORCE
	ldh (<hCurBank), a
	ld (MBC_BANK), a
	ret
.ENDS

;CallHL macro
.ORGA $20
.SECTION "INT_RST20" SIZE 8 FORCE
	jp hl
.ENDS

;CallDE macro
.ORGA $28
.SECTION "INT_RST28" SIZE 8 FORCE
	push de
	ret
.ENDS

.ORGA $30
.SECTION "INT_RST30" SIZE 8 FORCE
	jp Reset
.ENDS

.ORGA $38
.SECTION "INT_RST38" SIZE 8 FORCE
	jp Reset
.ENDS

.ORGA $40
.SECTION "INT_VBLANK" SIZE 8 FORCE
	jp Vblank
.ENDS

.ORGA $48
.SECTION "INT_STAT" SIZE 8 FORCE
	jp Reset
.ENDS

.ORGA $50
.SECTION "INT_TIMER" SIZE 8 FORCE
	jp Reset
.ENDS

.ORGA $58
.SECTION "INT_SERIAL" SIZE 8 FORCE
	jp Reset
.ENDS

.ORGA $60
.SECTION "INT_JOYPAD" SIZE 8 FORCE
	jp Reset
.ENDS
