.include "sgb/sgb_map.asm"

.bank 0 slot 0
.org 0

.section "Sgb SouTrnPatch" keep

Sgb_SouTrnPatch:

.ends

.org $900

.section "code Sgb SouTrnPatch" after "Sgb SouTrnPatch"

	.accu 8
	.index 8

	JMP +
+:	LDA $02C2
	CMP #$09	;check if command is $09 (SOU_TRN)
	BNE _end
	STZ $4200	;disable IRQs
	LDX #$09 * 2
	JSR ($8000,X)	;call SOU_TRN handler
	LDA #$31
	STA $4200	;enable IRQs (and auto joypad)
	PLA	;pull return addr from stack
	PLA	;to exit command handler
_end:
	RTS

.ends
