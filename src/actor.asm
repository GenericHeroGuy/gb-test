.INCLUDE "memmap.inc"
.INCLUDE "enums.inc"
.INCLUDE "macros.inc"

.BANK 0 SLOT 0
.ORG 0

.SECTION "Actor"

;input: A = ID of actor to add
;       BC = argument to actor init code
;uses:  AF BC DE HL
AddActor:
	push af
	ld hl, wActorData
	ld de, _sizeof_ACTOR

	.DB $FE ;skip first ADD HL, DE. becomes CP A, $09
	_FindActor:
		add hl, de
		ld a, (hl)
	or a
	jr nz, _FindActor

	pop af
	ld (hl), a ;write ID
	push hl    ;save actor's address in RAM

	;now get the index into ActorInitPointers...
	ld l, a
	ld h, 0
	add hl, hl
	ld de, ActorInitPointers
	add hl, de
	GetPointerToDE

	pop hl
	PushBank ACTOR_BANK
	call +
	PopBank
	ret

+:	push de
	ret

;uses:	AF BC DE HL
RunActors:
	SetBank ACTOR_BANK
	ld hl, wActorData

.ENDS

.SECTION "ActorPointers"

ActorPointers:
	.DW 0
	.DW Actor_Player

.ENDS

.SECTION "ActorInitPointers"

ActorInitPointers:
	.DW 0
	.DW Init_Player

.ENDS
