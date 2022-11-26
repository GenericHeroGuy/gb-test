.INCLUDE "memmap.inc"
.INCLUDE "enums.inc"

.BANK ACTOR_BANK SLOT 1

.SECTION "Actor_Player"

Actor_Player:
	ld a, $01
	ret

Init_Player:
	ld a, $02
	ret

.ENDS
