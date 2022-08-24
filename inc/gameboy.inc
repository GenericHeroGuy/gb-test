;comment here so this dumbass OS stops thinking this is a "PBM image"

P1 = $FF00
P1.DPAD = %00100000
P1.KEYS = %00010000
P1.NONE = %00110000
P1.BOTH = %00000000 ;SGB

;Serial Byte (data)
SB = $FF01

;Serial Control
SC = $FF02

;Divider (r/w)
;DIV is actually 16-bit, but only upper 8 bits can be accessed.
;writing resets low byte to 0.
DIV = $FF04

;Timer (r/w)
;increments at a rate specified by TAC.
;when the value overflows, a timer interrupt is triggered,
;and the value in TMA is loaded
TIMA = $FF05

;Timer reload value (r/w)
TMA = $FF06

;Timer control (r/w)
TAC = $FF07
;0-1: timer frequency (CPU clock / x)
TAC.1024 =	%00000000
TAC.16 =	%00000001
TAC.64 =	%00000010
TAC.256 =	%00000011
;2: timer enable
TAC.OFF =	%00000000
TAC.ON =	%00000100

;Interrupt Flags (r/w)
IF = $FF0F


;LCD Control (r/w)
LCDC = $FF40
;LCD enable
LCDC.OFF =	%00000000
LCDC.ON =	%10000000
;window tilemap address
LCDC.WIN9800 =	%00000000
LCDC.WIN9C00 =	%01000000
;window enable
LCDC.WINOFF =	%00000000
LCDC.WINON =	%00100000
;background tileset address
LCDC.CHR8800 =	%00000000
LCDC.CHR8000 =	%00010000
;background tilemap address
LCDC.BG9800 =	%00000000
LCDC.BG9C00 =	%00001000
;sprite size
LCDC.OBJ8 =	%00000000
LCDC.OBJ16 =	%00000100
;sprite enable
LCDC.OBJOFF =	%00000000
LCDC.OBJON =	%00000010
;background enable (CGB: can't disable BG, only forces sprites on top of BG)
LCDC.BGOFF =	%00000000
LCDC.BGON =	%00000001

;Status (r/w)
STAT = $FF41
;PPU mode (r)
STAT.MODE =	%00000011
STAT.MODE0 =	%00000000 ;(hblank)
STAT.MODE1 =	%00000001 ;(vblank)
STAT.MODE2 =	%00000010 ;(oam scan)
STAT.MODE3 =	%00000011 ;(active)
;LY = LYC coincidence flag (r) (asserts IRQ when set)
STAT.LYC = %00000100
;Mode 0 IRQ (w)
STAT.IRQ0 = %00001000
;Mode 1 IRQ (w)
STAT.IRQ1 = %00010000
;Mode 2 IRQ (w)
STAT.IRQ2 = %00100000
;LY=LYC IRQ (w)
STAT.IRQC = %01000000

;Scroll Y (w)
SCY = $FF42

;Scroll X (w)
SCX = $FF43

;Line Y (r) (current scanline)
LY = $FF44

;Line Y Compare (w) (see STAT IRQ)
LYC = $FF45

;OAM DMA address + start (w)
DMA = $FF46

;BG Palette	(w) (DMG only)
BGP = $FF47

;OBJ Palette 0 (w) (DMG only)
OBP0 = $FF48

;OBJ Palette 1 (w) (DMG only)
OBP1 = $FF49

;Window X (w) (X coord + 7)
WY = $FF4A

;Window Y (w)
WX = $FF4B

;Interrupt Enable
IE = $FFFF
;Mode 1 IRQ ($0040)
IE.VBLANK = %00000001
;STAT IRQ ($0048)
IE.STAT = %00000010
;Timer IRQ ($0050)
IE.TIMER = %00000100
;Serial IRQ ($0058)
IE.SERIAL = %00001000
;Joypad IRQ ($0060)
IE.JOYPAD = %00010000
