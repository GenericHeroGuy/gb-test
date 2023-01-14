.INCLUDE "memmap.inc"
.INCLUDE "enums.inc"

.BANK ACTOR_BANK SLOT 1

.SECTION "Actor_Player"

Actor_Player:
	ld l, actor.y
	ldh a, (<hPad1)
	ld d, a

	rlc d ;moving down?
	jr nc, +
	inc (hl)

+:	rlc d ;moving up?
	jr nc, +
	dec (hl)

+:	ld b, (hl)

	inc l ;X pos

	rlc d ;moving left?
	jr nc, +
	dec (hl)

+:	rlc d ;moving right?
	jr nc, +
	inc (hl)

+:	ld c, (hl)

	push bc
	ld hl, PlayerMetaSprite
	call DrawMetasprite
	pop bc

	ldh a, (<hPad1Pressed)
	and PAD_A
	ld a, ACTOR_BANK
	ld de, Init_Test
	call nz, AddActor

	ldh a, (<hPad1Pressed)
	and PAD_B
	ld a, ACTOR_BANK
	ld de, Init_LagTest
	call nz, AddActor

	ret

Init_Player:
	ld a, <Actor_Player
	ld (hl+), a
	ld a, >Actor_Player
	ld (hl+), a

	xor a
	ld (hl+), a
	ld (hl), a
	ret

PlayerMetaSprite:
	.DB 10 ;number of sprites
	.DB 0, 0, ASC('T'), 0
	.DB 0, 8, ASC('E'), 0
	.DB 0, 16, ASC('S'), 0
	.DB 0, 24, ASC('T'), 0

	.DB 8, 0, ASC('S'), 0
	.DB 8, 8, ASC('P'), 0
	.DB 8, 16, ASC('R'), 0
	.DB 8, 24, ASC('I'), 0
	.DB 8, 32, ASC('T'), 0
	.DB 8, 40, ASC('E'), 0

.ENDS
