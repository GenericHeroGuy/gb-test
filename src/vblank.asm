.INCLUDE "memmap.inc"
.INCLUDE "gameboy.inc"
.INCLUDE "macros.inc"

.BANK 0 SLOT 0
.ORG 0

.SECTION "Vblank"

;the LD A, (DE) always comes first so the first load can be skipped (see Vblank_VramUpload)

VblankUploadFill:
	.REPT 400
		ld (hl+), a
	.ENDR
	inc de
	jp Vblank_VramUpload

VblankUploadDotted:
	.REPT 32
		ld a, (de)
		pop hl
		ld (hl), a
		inc de
	.ENDR
	jp Vblank_VramUpload

/*
VblankUploadColumn:
	.REPT 32
		ld a, (de)
		ld (hl+), a
		inc de
		add hl, bc
	.ENDR
	jr Vblank_VramUpload
*/

VblankUploadNormal:
	.REPT 32
		ld a, (de)
		ld (hl+), a
		inc de
	.ENDR
	jr Vblank_VramUpload


Vblank:
	push af
	push bc
	push de
	push hl

Vblank_VramUploadStart:
	ld (wSpSave), sp
	ld sp, wUploadAddr ;pointer to upload addresses
	ld de, wUploadData ;pointer to upload data
	ld bc, 32          ;added to HL when writing columns of tiles

Vblank_VramUpload:
	pop hl     ;pop target address
	ld a, (de) ;load first data byte
	bit 7, h   ;if bit 15 of address is zero,
	ret nz     ;exit. otherwise, fetch and jump to upload routine

Vblank_VramUploadEnd:
	ld hl, wSpSave ;reload stack pointer
	GetPointerToHL
	ld sp, hl

Vblank_OamUpload:
	ld a, >wSpriteBuffer
	ld bc, $28 << 8 | <rDMA
	call hOamUpload

	ld hl, hVblankCount
	inc (hl)
	inc hl ;LD HL, hFrameCount
	inc (hl)

	ei
	call AudioEntry

	pop hl
	pop de
	pop bc
	pop af
	reti
	
.ENDS
