.INCLUDE "memmap.inc"
.INCLUDE "enums.inc"

.BANK ACTOR_BANK SLOT 1

.SECTION "Actor_Test"

Actor_Test:
	ld l, actor.y
	inc (hl)
	ld b, (hl)
	inc l ;actor.x
	ld c, (hl)
	ld hl, TestMetaSprite
	call DrawMetasprite
	ret

Init_Test:
	ld a, <Actor_Test
	ld (hl+), a
	ld a, >Actor_Test
	ld (hl+), a

	ld a, b
	ld (hl+), a
	ld a, c
	ld (hl), a
	ret

TestMetaSprite:
	.DB 1 ;number of sprites
	.DB 0, 0, ASC('W'), 0

.ENDS
