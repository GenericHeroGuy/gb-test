.INCLUDE "memmap.inc"
.INCLUDE "gameboy.inc"
.INCLUDE "enums.inc"
.INCLUDE "macros.inc"

.BANK 0 SLOT 0
.ORG 0

.SECTION "Main"

Main:
	;upload test
	ld hl, wUploadAddr
	ld a, $10
	ld (hl+), a
	ld a, $90
	ld (hl+), a
	ld a, <VblankUploadFill
	ld (hl+), a
	ld a, >VblankUploadFill
	ld (hl+), a
	;cut here

	;farcall test
	FarCall FarCallTest
	;cut here

	ld a, %11100100
	ldh (<rBGP), a
	ldh (<rOBP0), a

WriteCharset:
	ld hl, $8800
	ld de, CHR_CHARSET
	ld bc, CHR_CHARSET_size
	call MemCpy

WriteMessage1:
	ld hl, $9962
	ld de, Message1
	call MemCpyNull

WriteMessage2:
	ld hl, $9982
	ld de, Message2
	call MemCpyNull

End:
	ld a, LCDC_DEFAULT
	ldh (<rLCDC), a

	xor a
	ldh (<rIF), a ;acknowledge all interrupts
	ld a, IE.VBLANK
	ldh (<rIE), a

	ld a, Player.ID
	ld bc, 0
	ld de, 0
	call AddActor

Forever:
	ld hl, wUploadData
	inc (hl)
	call ReadInput
	call ClearSprites
	call Player
	call WaitVblank

	jr Forever

WaitVblank:
	halt
	nop

	ldh a, (<hVblankCount)
	or a
	jr z, WaitVblank ;not Vblank? keep waiting

	xor a
	ldh (<hVblankCount), a
	ret

Message1:
	.ASC "LOOK MOM, I CAN", 0

Message2:
	.ASC "WRITE MESSAGES", 0

.ENDS

.BANK 2 SLOT 1
.ORG $4000

.SECTION "FarCallTest"
FarCallTest:
	FarCall FarCallTest2
	ret
.ENDS

.BANK 3 SLOT 1
.ORG $4000

.SECTION "FarCallTest2"
FarCallTest2:
	ld de, $1234
	FarJp FarCallTest3
.ENDS

.BANK 1 SLOT 1
.ORG $4000

.SECTION "FarCallTest3"
FarCallTest3:
	ret
.ENDS
