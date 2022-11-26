.INCLUDE "memmap.inc"
.INCLUDE "gameboy.inc"
.INCLUDE "enums.inc"
.INCLUDE "sgb.inc"

.BANK 0 SLOT 0
.ORG 0

.SECTION "SGB"

;input: HL = pointer to command
;uses:  AF BC DE HL
SgbSendCommand:
	call SgbSendCommandNoDelay
	ld bc, $0C00 ;magic delay value :)
-:		dec bc
	ld a, c
	or b
	jr nz, -
	ret

;input: HL = pointer to command
;uses:  AF BC DE HL
SgbSendCommandNoDelay:
	ld b, 16 ;number of bytes to transfer
	ld e, b  ;LD E, P1.KEYS
	xor a    ;LD A, P1.BOTH
	ld c, a  ;LD C, <rP1

	ldh (c), a ;send STOP command (aka start receiving)
	ld a, P1.NONE
	ldh (c), a

SgbSendByte:
	ld a, (hl+)
	ld d, a ;fetch byte to D

SgbSendBit:
	.REPT 8
		ld a, e    ;set bit to transfer to ZERO
		rrc d      ;shift out data bit
		jr c, +    ;if it's ONE,
		add a, a   ;shift A left, setting bit to transfer to ONE

	+:	ldh (c), a ;now transfer bit to SGB
		ld a, P1.NONE
		ldh (c), a
	.ENDR

	dec b ;bytes left to send?
	jr nz, SgbSendByte

SgbSendStop:
	ld a, P1.DPAD ;send stop bit (ONE)
	ldh (c), a
	add e         ;LD A, P1.NONE (disable joypad)
	ldh (c), a
	ret

;input: BC = size of data
;       DE = pointer to VRAM transfer data
;uses:  AF BC DE HL
SgbSendVram:
	ld hl, $8000
	inc b ;haha ugly hack
	call MemCpy

	;fill tilemap with incrementing tile ID
	ld hl, $9800
	ld de, 12
	xor a
	ld c, 13
--:		ld b, 20
	-:		ld (hl+), a
			inc a
		dec b
		jr nz, -
	add hl, de
	dec c
	jr nz, --
	ret

;input: BC = transfer size
;       DE = pointer to VRAM transfer data
;uses:  AF BC DE HL
SgbTransferMusic:
	di
	push bc ;save for delay
	push bc
	push de

	ld hl, CmdFreezeScreen
	call SgbSendCommand

	pop de
	pop bc

	call DisableLcd
	call SgbSendVram ;transfer sound data to VRAM

	ld a, LCDC_SGBVRAM ;turn on BG, disable sprites, use $8000-8FFF for BG tiles
	ldh (<rLCDC), a
	ld hl, CmdTransferMusic
	call SgbSendCommandNoDelay

	;custom delay function: transfer size * 16
	pop bc
	swap b
-:		dec bc
	ld a, c
	or b
	jr nz, -

	ld a, LCDC_DEFAULT
	ldh (<rLCDC), a
	ld hl, CmdPlayMusic
	call SgbSendCommand
	ld hl, CmdUnfreezeScreen
	call SgbSendCommandNoDelay

	xor a
	ldh (<rIF), a ;acknowledge interrupts
	reti

SgbDetectHle:
	;upload and run some code on the SNES that manually enables multiplayer mode
	;if it doesn't work, assume it's HLE
	ld hl, CmdTestHle1
	call SgbSendCommand
	ld hl, CmdTestHle2
	call SgbSendCommand
	ld hl, CmdTestHle3
	call SgbSendCommand

	ld hl, $9800 ;address to write message

	ldh a, (<rP1)
	cp $FF
	ld de, SgbFailMsg
	jr nz, _end ;i hope it's $FF...

	ld a, P1.KEYS ;(try to) switch to joypad 2
	ldh (<rP1), a
	ld a, P1.NONE
	ldh (<rP1), a

	ldh a, (<rP1)
	cp $FE           ;should be $FE now that joypad 2 is active
	ld de, SgbHleMsg ;if it's not, the SNES code didn't run
	jr nz, _end      ;or worse... it CRASHED!!!!!!

	ld de, SgbLleMsg
_end:
	call MemCpyNull
	ld hl, CmdResetMultiplayer ;disable multiplayer mode
	call SgbSendCommand
	ret

SgbHleMsg:
	.ASC "HLE", 0

SgbLleMsg:
	.ASC "LLE", 0

SgbFailMsg:
	.ASC "IDK", 0

.ENDS

.SECTION "SgbCommands"

CmdResetMultiplayer:
	.DB (MLT_REQ << 3) | 1
	.DB 0

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
	.DB (DATA_SND << 3) | 1
	.DL $001800
	.DB 11
	.HEX "ADEB02"   ;lda $02EB
	.HEX "2903"     ;and #$03
	.HEX "0990"     ;ora #$90
	.HEX "8F036000" ;sta $006003

CmdTestHle2:
	.DB (DATA_SND << 3) | 1
	.DL $00180B
	.DB 7
	.HEX "A9F0"     ;lda #$F0    ;good luck trying to press all
	.HEX "8F056000" ;sta $006005 ;directions on the dpad lmao
	.HEX "60"       ;rts

CmdTestHle3:
	.DB (JUMP << 3) | 1
	.DL $001800 ;jump addr
	.DL $123456 ;NMI addr

CmdFreezeScreen:
	.DB (MASK_EN << 3) | 1
	.DB 1

CmdUnfreezeScreen:
	.DB (MASK_EN << 3) | 1
	.DB 0

CmdTransferMusic:
	.DB (SOU_TRN << 3) | 1

CmdPlayMusic:
	.DB (SOUND << 3) | 1
	.DB $00 ;SFX A
	.DB $00 ;SFX B
	.DB $00 ;SFX options
	.DB $01 ;music ID

;I'm too lazy to get an '816 assembler so here's the patch.
;Disables interrupts before transferring sound data, to speed it up
;.ORG $0900
;	lda $02C2
;	cmp #$09      ;check if command is $09 (SOU_TRN)
;	bne end
;	stz $4200     ;disable IRQs
;	ldx #$09 * 2
;	jsr ($8000,X) ;call SOU_TRN handler
;	lda #$31
;	sta $4200     ;enable IRQs (and auto joypad)
;	pla           ;pull return addr from stack
;	pla           ;to exit command handler
;end:
;	rts

CmdPatchSouTrn1:
	.DB (DATA_SND << 3) | 1
	.DL $010900 ;destination
	.DB 11      ;number of bytes
	.HEX "ADC202" ;lda $02C2
	.HEX "C909"   ;cmp #$09
	.HEX "D00F"   ;bne end
	.HEX "9C0042" ;stz $4200
	.HEX "A2"     ;ldx #..

CmdPatchSouTrn2:
	.DB (DATA_SND << 3) | 1
	.DL $01090B ;destination
	.DB 11      ;number of bytes
	.HEX "12"     ;... $09 * 2
	.HEX "FC0080" ;jsr ($8000,X)
	.HEX "A931"   ;lda #$31
	.HEX "8D0042" ;sta $4200
	.HEX "68"     ;pla
	.HEX "68"     ;pla

CmdPatchSouTrn3:
	.DB (DATA_SND << 3) | 1
	.DL $010916 ;destination
	.DB 1       ;number of bytes
	.HEX "60" ;rts

CmdPatchSouTrn4:
	.DB (DATA_SND << 3) | 1
	.DL $010800 ;destination
	.DB 3       ;number of bytes
	.HEX "4C0009" ;jmp $0900

.ENDS

.SECTION "SgbData"

SgbMusicTest:
	.DW SgbMusicTest_size
	.DW $2B00
	.INCBIN "musictest.bin" FSIZE SgbMusicTest_size
	.DW $0000
	.DW $0400

.ENDS
