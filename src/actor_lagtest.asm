.INCLUDE "memmap.inc"
.INCLUDE "enums.inc"

.BANK ACTOR_BANK SLOT 1

.SECTION "Actor_LagTest"

Actor_LagTest:
	ld l, actor.y
	ld b, (hl)
	inc l ;actor.x
	inc (hl)
	ld c, (hl)
	ld hl, LagTestMetaSprite
	call DrawMetasprite

;make some lag
	xor a
-:	dec a
	jr nz, -
-:	dec a
	jr nz, -
	ret

Init_LagTest:
	ld a, <Actor_LagTest
	ld (hl+), a
	ld a, >Actor_LagTest
	ld (hl+), a

	ld a, b
	ld (hl+), a
	ld a, c
	ld (hl), a
	ret

LagTestMetaSprite:
	.DB 1 ;number of sprites
	.DB 0, 0, ASC('L'), 0

.ENDS
