.INCLUDE "memmap.inc"
.INCLUDE "gameboy.inc"
.INCLUDE "macros.inc"

.BANK 0 SLOT 0
.ORG 0

.SECTION "Sprite"

;uses:  AF BC HL
ClearSprites:
	ld hl, wSpriteBuffer
	ld bc, 4
	xor a
	.REPT 39
		ld (hl), a
		add hl, bc
	.ENDR
	ld (hl), a
	ret

;input: A = metasprite ID
;       B = metasprite Y
;       C = metasprite X
;uses:  AF BC DE HL
DrawMetasprite:
	ld l, a    ;load into HL, multiply by 2 (left shit), add MetaspritePointers
	ld h, 0
	add hl, hl
	ld de, MetaspritePointers
	add hl, de ;HL = pointer to metasprite pointer
	GetPointerToHL
	ld de, wSpriteBuffer

	ld a, (hl+) ;number of sprites
	ldh (<hLoopCount), a

	ld a, b ;add 16 to Y position
	add 16
	ld b, a
	ld a, c ;add 8 to X position
	add 8
	ld c, a

SpriteLoop:
	ld a, (hl+) ;get sprite Y
	add b       ;add metasprite Y
	ld (de), a
	inc e

	ld a, (hl+) ;get sprite X
	add c       ;add metasprite X
	ld (de), a
	inc e

	ld a, (hl+) ;get sprite tile
	ld (de), a
	inc e

	ld a, (hl+) ;get sprite attrib
	ld (de), a
	inc e

	ldh a, (<hLoopCount)
	dec a
	ldh (<hLoopCount), a
	jr nz, SpriteLoop
	ret

.ENDS
