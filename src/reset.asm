.include "memmap.inc"
.include "gameboy.inc"
.include "gbapu.inc"
.include "enums.inc"

.section Reset

Reset:
	LD SP, $E000

;keep HW model in E until RAM clearing is done
	LD E, $00

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
	CP $11	;CGB hardware?
	JR NZ, DetectSgb
	SET B_HW_CGB, E

	LD A, B
	CP $01	;AGB?
	JR NZ, ResetHardware
	SET B_HW_AGB, E
	JR ResetHardware

DetectSgb:
	CP $FF
	PUSH AF	;push A = $FF test

	LD A, C
	CP $14	;SGB?
	JR NZ, DetectMgb
	SET B_HW_SGB, E

	POP AF	;SGB2?
	JR NZ, ResetHardware
	SET B_HW_SGB2, E
	JR ResetHardware

DetectMgb:
	POP AF
	JR NZ, ResetHardware	;MGB?
	SET B_HW_MGB, E

;hardware check complete

ResetHardware:
	CALL DisableLcd
	LD A, P1.NONE
	LDH (<P1), A	;disable joypad
	LD A, 144
	LDH (<WY), A	;set window offscreen
	LDH (<WX), A
	LD A, $E4
	LDH (<BGP), A
	LDH (<OBP0), A
	LDH (<OBP1), A

	XOR A
	LDH (<APUSTAT), A	;disable APU
	LDH (<STAT), A	;disable STAT IRQ
	LDH (<SCX), A	;reset scroll
	LDH (<SCY), A

;clear WRAM
	LD HL, SP-1
-:		LD (HL-), A
	BIT 6, H
	JR NZ, -

;load OAM upload routine into HRAM
	LD HL, OamUpload
	LD BC, _sizeof_OamUpload << 8 | <oamUpload
-:		LD A, (HL+)
		LDH (C), A
		INC C
	DEC B
	JR NZ, -

;clear HRAM and IE
	XOR A
-:		LDH (C), A
	INC C
	JR NZ, -

;reset mapper
	INC A
	LD (MBC_BANK), A
	LDH (<curBank), A

;write HW model to memory
	LD A, E
	LDH (<hwModel), A

SgbPatches:
	BIT B_HW_SGB, A
	JR Z, ResetApu	;skip if not SGB

	LD HL, CmdPatchSouTrn1
	CALL SgbSendCommand
	LD HL, CmdPatchSouTrn2
	CALL SgbSendCommand
	LD HL, CmdPatchSouTrn3
	CALL SgbSendCommand
	LD HL, CmdPatchSouTrn4
	CALL SgbSendCommand

	CALL SgbDetectHle

	LD HL, Sgb_SouTrnPatch

ResetApu:
	LD A, APUSTAT.ON
	LDH (<APUSTAT), A
	LD A, APUVOL.7L | APUVOL.7R
	LDH (<APUVOL), A

	LD HL, WaveSquare
	CALL SetWaveRam

;done! now we jump to main
	EI
	JP Main


;A = >oamBuffer
;B = $28
;C = <DMA
OamUpload:
	LDH (C), A
-:		DEC B
	JR NZ, -
	RET Z	;Z adds 1 Mcycle delay to prevent crashing
OamUpload_end:
	
.ends
