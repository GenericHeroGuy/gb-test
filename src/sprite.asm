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

;input: HL = pointer to metasprite data
;       B = metasprite Y
;       C = metasprite X
;uses:  AF BC DE HL
DrawMetasprite:
	ld d, >wSpriteBuffer
	ldh a, (<hOamIndex)
	ld e, a

	ld a, (hl+) ;number of sprites
	ldh (<hLoopCount), a

	ld a, b ;add 16 to Y position
	add 16
	ld b, a
	ld a, c ;add 8 to X position
	add 8
	ld c, a

SpriteLoop:
	ld a, e
	cp $A0
	jr z, SpriteOverflow

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

	ld a, e
	ldh (<hOamIndex), a
	ret

SpriteOverflow:
	ld e, 0
	jr SpriteLoop

.ENDS
