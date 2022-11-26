.INCLUDE "memmap.inc"
.INCLUDE "gameboy.inc"
.INCLUDE "gbapu.inc"
.INCLUDE "enums.inc"

.SECTION Reset

Reset:
	ld sp, $E000

	;keep HW model in E until RAM clearing is done
	ld e, $00

;Accumulator:
;$01 = DMG, SGB
;$11 = CGB, AGB
;$FF = MGB, SGB2

;B register:
;$00 = DMG, MGB, SGB, SGB2, CGB native
;$01 = AGB native

;sum of $0134 to $0143 (game title) = CGB compat
;CGB compat + 1 = AGB compat
;(AGB bootrom added an INC B before handing over control)

;C register:
;$00 = CGB, AGB
;$13 = DMG, MGB
;$14 = SGB, SGB2

;/-------\
;|is CGB?|
;\-------/
;    |          /-------\
;    +-No-------|is SGB?|
;    |          \-------/
;   Yes             |       /-------\
;    |              +-No----|is MGB?|
;/-------\          |       \-------/
;|is AGB?|         Yes          |
;\-------/          |           +-No- $00
;    |          /--------\      |
;    +-No- $01  |is SGB2?|     Yes
;    |          \--------/      |
;   Yes             |          $10
;    |              +-No- $02
;   $05             |
;                  Yes
;                   |
;                  $0A

DetectCgb:
	cp $11 ;CGB hardware?
	jr nz, DetectSgb
	set B_HW_CGB, e

	ld a, b
	cp $01 ;AGB?
	jr nz, ResetHardware
	set B_HW_AGB, e
	jr ResetHardware

DetectSgb:
	cp $FF
	push af ;push A = $FF test

	ld a, c
	cp $14 ;SGB?
	jr nz, DetectMgb
	set B_HW_SGB, e

	pop af ;SGB2?
	jr nz, ResetHardware
	set B_HW_SGB2, e
	jr ResetHardware

DetectMgb:
	pop af
	jr nz, ResetHardware ;MGB?
	set B_HW_MGB, e

	;hardware check complete

ResetHardware:
	call DisableLcd
	ld a, P1.NONE
	ldh (<rP1), a ;disable joypad
	ld a, 144
	ldh (<rWY), a ;set window offscreen
	ldh (<rWX), a
	ld a, $E4
	ldh (<rBGP), a
	ldh (<rOBP0), a
	ldh (<rOBP1), a

	xor a
	ldh (<rAPUSTAT), a ;disable APU
	ldh (<rSTAT), a    ;disable STAT IRQ
	ldh (<rSCX), a     ;reset scroll
	ldh (<rSCY), a

	;clear WRAM
	ld hl, sp-1
-:		ld (hl-), a
	bit 6, h
	jr nz, -

	;load OAM upload routine into HRAM
	ld hl, OamUpload
	ld bc, _sizeof_OamUpload << 8 | <hOamUpload
-:		ld a, (hl+)
		ldh (c), a
		inc c
	dec b
	jr nz, -

	;clear HRAM and IE
	xor a
-:		ldh (c), a
	inc c
	jr nz, -

	;reset mapper
	inc a
	ld (MBC_BANK), a
	ldh (<hCurBank), a

	;write HW model to memory
	ld a, e
	ldh (<hHwModel), a

SgbPatches:
	bit B_HW_SGB, a
	jr z, ResetApu ;skip if not SGB

	ld hl, CmdPatchSouTrn1
	call SgbSendCommand
	ld hl, CmdPatchSouTrn2
	call SgbSendCommand
	ld hl, CmdPatchSouTrn3
	call SgbSendCommand
	ld hl, CmdPatchSouTrn4
	call SgbSendCommand

	call SgbDetectHle

ResetApu:
	ld a, APUSTAT.ON
	ldh (<rAPUSTAT), a
	ld a, APUVOL.7L | APUVOL.7R
	ldh (<rAPUVOL), a

	ld hl, WaveSquare
	call SetWaveRam

	;done! now we jump to main
	ei
	jp Main


;input: A = >oamBuffer
;       B = $28
;       C = <rDMA
OamUpload:
	ldh (c), a
-:		dec b
	jr nz, -
	ret z ;Z adds 1 Mcycle delay to prevent crashing
OamUpload_end:
	
.ENDS
