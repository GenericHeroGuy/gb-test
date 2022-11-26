.INCLUDE "sgb/sgb_map.asm"

.BANK 0 SLOT 0
.ORG 0

.SECTION "Sgb SouTrnPatch" KEEP

Sgb_SouTrnPatch:

.ENDS

.ORG $900

.SECTION "code Sgb SouTrnPatch" AFTER "Sgb SouTrnPatch"

	.ACCU 8
	.INDEX 8

	jmp +
+:	lda $02C2
	cmp #$09      ;check if command is $09 (SOU_TRN)
	bne _end
	stz $4200     ;disable IRQs
	ldx #$09 * 2
	jsr ($8000,X) ;call SOU_TRN handler
	lda #$31
	sta $4200     ;enable IRQs (and auto joypad)
	pla           ;pull return addr from stack
	pla           ;to exit command handler
_end:
	rts

.ENDS
