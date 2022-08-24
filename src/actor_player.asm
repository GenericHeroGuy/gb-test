.include "memmap.inc"
.include "enums.inc"

.bank ACTOR_BANK slot 1

.section "Actor_Player"

Actor_Player:
	LD A, $01
	RET

Init_Player:
	LD A, $02
	RET

.ends
