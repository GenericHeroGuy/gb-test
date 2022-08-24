.include "memmap.inc"
.include "gameboy.inc"
.include "enums.inc"
.include "sgb.inc"

.bank 0 slot 0
.org 0

.section "SGB"

SgbSendCommand:
	CALL SgbSendCommandNoDelay
	LD BC, $0C00	;magic delay value :)
-:		DEC BC
	LD A, C
	OR B
	JR NZ, -
	RET

;HL = pointer to command
SgbSendCommandNoDelay:
;B = # of bytes to transfer
;C = P1
;D = data to transfer
;E = # of bits to transfer
	LD B, 16	;number of bytes to transfer
	LD E, B	;LD E, P1.KEYS
	XOR A	;LD A, P1.BOTH
	LD C, A	;LD C, <P1

	LDH (C), A	;send STOP command (aka start receiving)
	LD A, P1.NONE
	LDH (C), A

SgbSendByte:
	LD A, (HL+)
	LD D, A		;fetch byte to D

SgbSendBit:
	.rept 8
		LD A, E	;set bit to transfer to ZERO
		RRC D	;shift out data bit
		JR C, +	;if it's ONE,
		ADD A, A	;shift A left, setting bit to transfer to ONE

	+:	LDH (C), A	;now transfer bit to SGB
		LD A, P1.NONE
		LDH (C), A
	.endr

	DEC B	;bytes left to send?
	JR NZ, SgbSendByte

SgbSendStop:
	LD A, P1.DPAD	;send stop bit (ONE)
	LDH (C), A
	ADD E	;LD A, P1.NONE	;disable joypad
	LDH (C), A
	RET

;BC = size of data
;DE = pointer to VRAM transfer data
SgbSendVram:
;HL = VRAM pointer
	LD HL, $8000
	INC B	;haha ugly hack
	CALL MemCpy

;fill tilemap with incrementing tile ID
	LD HL, $9800
	LD DE, 12
	XOR A
	LD C, 13
--:		LD B, 20
	-:		LD (HL+), A
			INC A
		DEC B
		JR NZ, -
	ADD HL, DE
	DEC C
	JR NZ, --
	RET

;BC = transfer size
;DE = pointer to VRAM transfer data
SgbTransferMusic:
	DI
	PUSH BC	;save for delay
	PUSH BC
	PUSH DE

	LD HL, CmdFreezeScreen
	CALL SgbSendCommand

	POP DE
	POP BC

	CALL DisableLcd
	CALL SgbSendVram	;transfer sound data to VRAM

	LD A, LCDC_SGBVRAM	;turn on BG, disable sprites, use $8000-8FFF for BG tiles
	LDH (<LCDC), A
	LD HL, CmdTransferMusic
	CALL SgbSendCommandNoDelay

;custom delay function: transfer size * 16
	POP BC
	SWAP B
-:		DEC BC
	LD A, C
	OR B
	JR NZ, -

	LD A, LCDC_DEFAULT
	LDH (<LCDC), A
	LD HL, CmdPlayMusic
	CALL SgbSendCommand
	LD HL, CmdUnfreezeScreen
	CALL SgbSendCommandNoDelay

	XOR A
	LDH (<IF), A	;acknowledge interrupts
	RETI

SgbDetectHle:
;upload and run some code on the SNES that manually enables multiplayer mode
;if it doesn't work, assume it's HLE
	LD HL, CmdTestHle1
	CALL SgbSendCommand
	LD HL, CmdTestHle2
	CALL SgbSendCommand
	LD HL, CmdTestHle3
	CALL SgbSendCommand

	LD HL, $9800	;address to write message

	LDH A, (<P1)
	CP $FF
	LD DE, SgbFailMsg
	JR NZ, _end	;i hope it's $FF...

	LD A, P1.KEYS	;(try to) switch to joypad 2
	LDH (<P1), A
	LD A, P1.NONE
	LDH (<P1), A

	LDH A, (<P1)
	CP $FE	;should be $FE now that joypad 2 is active
	LD DE, SgbHleMsg	;if it's not, the SNES code didn't run
	JR NZ, _end	;or worse... it CRASHED!!!!!!

	LD DE, SgbLleMsg
_end:
	CALL MemCpyNull
	LD HL, CmdResetMultiplayer	;disable multiplayer mode
	CALL SgbSendCommand
	RET

SgbHleMsg:
	.asc "HLE", 0

SgbLleMsg:
	.asc "LLE", 0

SgbFailMsg:
	.asc "IDK", 0

.ends

.section "SgbCommands"

CmdResetMultiplayer:
	.db (MLT_REQ << 3) | 1
	.db 0

;ICD joypad port
;$006004 = player 1 joypad
;$006005 = player 2 joypad
;
;1 = not pressed  0 = pressed
;76543210
;|||||||+- right
;||||||+-- left
;|||||+--- up
;||||+---- down
;|||+----- A
;||+------ B
;|+------- Select
;+-------- Start

CmdTestHle1:
	.db (DATA_SND << 3) | 1
	.dl $001800
	.db 11
	.hex "ADEB02"	;LDA $02EB
	.hex "2903"	;AND #$03
	.hex "0990"	;ORA #$90
	.hex "8F036000"	;STA $006003

CmdTestHle2:
	.db (DATA_SND << 3) | 1
	.dl $001800 + 11
	.db 7
	.hex "A9F0"	;LDA #$F0	;good luck trying to press all
	.hex "8F056000"	;STA $006005	;directions on the dpad lmao
	.hex "60"	;RTS

CmdTestHle3:
	.db (JUMP << 3) | 1
	.dl $001800	;jump addr
	.dl $123456	;NMI addr

CmdFreezeScreen:
	.db (MASK_EN << 3) | 1
	.db 1

CmdUnfreezeScreen:
	.db (MASK_EN << 3) | 1
	.db 0

CmdTransferMusic:
	.db (SOU_TRN << 3) | 1

CmdPlayMusic:
	.db (SOUND << 3) | 1
	.db $00	;SFX A
	.db $00	;SFX B
	.db $00	;SFX options
	.db $01	;music ID

;I'm too lazy to get an '816 assembler so here's the patch.
;Disables interrupts before transferring sound data, to speed it up
;.org $0900
;	LDA $02C2
;	CMP #$09	;check if command is $09 (SOU_TRN)
;	BNE end
;	STZ $4200	;disable IRQs
;	LDX #$09 * 2
;	JSR ($8000,X)	;call SOU_TRN handler
;	LDA #$31
;	STA $4200	;enable IRQs (and auto joypad)
;	PLA	;pull return addr from stack
;	PLA	;to exit command handler
;end:
;	RTS

CmdPatchSouTrn1:
	.db (DATA_SND << 3) | 1
	.dl $010900 ;destination
	.db 11 ;number of bytes
	.hex "ADC202"	;LDA $02C2
	.hex "C909"	;CMP #$09
	.hex "D00F"	;BNE end
	.hex "9C0042"	;STZ $4200
	.hex "A2"	;LDX #..

CmdPatchSouTrn2:
	.db (DATA_SND << 3) | 1
	.dl $01090B ;destination
	.db 11 ;number of bytes
	.hex "12"	;... $09 * 2
	.hex "FC0080"	;JSR ($8000,X)
	.hex "A931"	;LDA #$31
	.hex "8D0042"	;STA $4200
	.hex "68"	;PLA
	.hex "68"	;PLA

CmdPatchSouTrn3:
	.db (DATA_SND << 3) | 1
	.dl $010916 ;destination
	.db 1 ;number of bytes
	.hex "60"	;RTS

CmdPatchSouTrn4:
	.db (DATA_SND << 3) | 1
	.dl $010800 ;destination
	.db 3 ;number of bytes
	.hex "4C0009"	;JMP $0900

.ends

.section "SgbData"

SgbMusicTest:
	.dw SgbMusicTest_size
	.dw $2B00
	.incbin "musictest.bin" fsize SgbMusicTest_size
	.dw $0000
	.dw $0400

.ends
