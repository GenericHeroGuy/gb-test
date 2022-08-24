.include "memmap.inc"
.include "enums.inc"

.bank 0 slot 0
.org 0

.section "Metasprites"

MetaspritePointers:
	.dw Meta_TestSprite

;1-byte header: sprite count
;then Y, X, Tile, Attribute

Meta_TestSprite:
	.db 10
	.db 0, 0, asc('T'), 0
	.db 0, 8, asc('E'), 0
	.db 0, 16, asc('S'), 0
	.db 0, 24, asc('T'), 0

	.db 8, 0, asc('S'), 0
	.db 8, 8, asc('P'), 0
	.db 8, 16, asc('R'), 0
	.db 8, 24, asc('I'), 0
	.db 8, 32, asc('T'), 0
	.db 8, 40, asc('E'), 0

.ends
