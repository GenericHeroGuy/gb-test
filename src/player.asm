.INCLUDE "memmap.inc"
.INCLUDE "gbapu.inc"
.INCLUDE "enums.inc"

.SECTION "player"

Player:
	ldh a, (<hPad1)
	ld d, a

	ldh a, (<hPlayerY)
	rlc d
	jr nc, +
	add $01

+:	rlc d
	jr nc, +
	sub $01
+:	ldh (<hPlayerY), a
	ld b, a

	ldh a, (<hPlayerX)
	rlc d
	jr nc, +
	sub $01

+:	rlc d
	jr nc, +
	add $01
+:	ldh (<hPlayerX), a
	ld c, a

	ld a, 0
	call DrawMetasprite

	ldh a, (<hPad1Pressed)
	and PAD_START
	ld de, SgbMusicTest
	ld bc, _sizeof_SgbMusicTest
	call nz, SgbTransferMusic

	ldh a, (<hPad1Pressed)
	and PAD_SELECT
	ret z
	ld a, C1SWEEP.F0
	ldh (<rC1SWEEP), a
	ld a, C1DUTY.25 | 0
	ldh (<rC1DUTY), a
	ld a, C1VOL.15 | C1VOL.DOWN | C1VOL.F0
	ldh (<rC1VOL), a
	ld a, 0
	ldh (<rC1FREQ), a
	ld a, C1CTRL.RESTART | $40 | 0
	ldh (<rC1CTRL), a
	ld a, APUMIX.1L | APUMIX.1R
	ldh (<rAPUMIX), a
	ret

.ENDS
