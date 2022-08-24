.include "memmap.inc"
.include "enums.inc"
.include "macros.inc"

.bank 0 slot 0
.org 0

.section "Actor"

;A = ID of actor to add
;BC = argument to actor init code
;uses	AF BC DE HL
AddActor:
	PUSH AF
	LD HL, actorData
	LD DE, _sizeof_ACTOR

	.db $FE	;skip first ADD HL, DE. becomes CP A, $09
	_FindActor:
		ADD HL, DE
		LD A, (HL)
		OR A
		JR NZ, _FindActor

	POP AF
	LD (HL), A	;write ID
	PUSH HL	;save actor's address in RAM

;now get the index into ActorInitPointers...
	LD L, A
	LD H, 0
	ADD HL, HL
	LD DE, ActorInitPointers
	ADD HL, DE
	GetPointerToDE

	POP HL
	PushBank ACTOR_BANK
	CALL +
	PopBank
	RET

+:	PUSH DE
	RET

;uses	AF BC DE HL
RunActors:
	SetBank ACTOR_BANK
	LD HL, actorData

.ends

.section "ActorPointers"

ActorPointers:
	.dw 0
	.dw Actor_Player

.ends

.section "ActorInitPointers"

ActorInitPointers:
	.dw 0
	.dw Init_Player

.ends
