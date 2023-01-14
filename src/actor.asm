.INCLUDE "memmap.inc"
.INCLUDE "enums.inc"
.INCLUDE "macros.inc"

.BANK 0 SLOT 0
.ORG 0

.SECTION "Add actor"

;input: A = bank of actor to add
;       BC = argument to actor init code
;       DE = jump address
;uses:  AF BC DE HL
AddActor:
	push af
	ld hl, wActor0 - 256

_FindActor:
		inc h
		ld a, (hl)
		inc a ;end of actor list? (bank = $FF)
		jr z, ActorOverflow
	dec a
	jr nz, _FindActor

	pop af
	ld l, a
	PushBank
	ld a, l
	ldh (<hCurBank), a
	ld (MBC_BANK), a

	ld l, actor.bank
	ld (hl+), a ;set bank
	CallDE

	pop af
	ldh (<hCurBank), a
	ld (MBC_BANK), a
	ret

ActorOverflow:
	pop af
	ret

.ENDS

.SECTION "Run actors"

;uses:  AF BC DE HL
;       HL = RAM address of actor
;       DE = jump address
;       E =  num of actors
RunActors:
	ld hl, wActor0 - 256

_FindActor:
		inc h
		ld a, (hl)
	or a
	jr z, _FindActor

;set bank
	ldh (<hCurBank), a
	ld (MBC_BANK), a
;end of actor list? (bank = $FF)
	inc a
	ret z
;get actor's jump address
	push hl
	inc l
	ld a, (hl+)
	ld d, (hl)
	ld e, a
	CallDE

	pop hl
	jr _FindActor

.ENDS
