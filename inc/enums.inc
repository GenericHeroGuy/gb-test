MBC_BANK = $2000

PAD_A      = $01
PAD_B      = $02
PAD_SELECT = $04
PAD_START  = $08
PAD_RIGHT  = $10
PAD_LEFT   = $20
PAD_UP     = $40
PAD_DOWN   = $80

HW_CGB  = %00000001
HW_SGB  = %00000010
HW_AGB  = %00000100
HW_SGB2 = %00001000
HW_MGB  = %00010000

B_HW_CGB  = 0
B_HW_SGB  = 1
B_HW_AGB  = 2
B_HW_SGB2 = 3
B_HW_MGB  = 4

ACTOR_BANK = 1

.IFDEF rLCDC
	LCDC_DEFAULT = LCDC.ON | LCDC.WIN9C00 | LCDC.WINON | LCDC.CHR8800 | LCDC.BG9800 | LCDC.OBJ8 | LCDC.OBJON | LCDC.BGON
	LCDC_SGBVRAM = LCDC.ON | LCDC.WIN9C00 | LCDC.WINOFF | LCDC.CHR8000 | LCDC.BG9800 | LCDC.OBJ8 | LCDC.OBJOFF | LCDC.BGON
.ENDIF

.ASCIITABLE
	map "A" to "Z" = $8A
	map "0" to "9" = $80
	map " " = $A4
	map "," = $A5
	map "." = $A6
.ENDA

.ENUMID 1
	.ENUMID Player.ID
