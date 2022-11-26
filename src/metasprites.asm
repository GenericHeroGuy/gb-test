.INCLUDE "memmap.inc"
.INCLUDE "enums.inc"

.BANK 0 SLOT 0
.ORG 0

.SECTION "Metasprites"

MetaspritePointers:
	.DW Meta_TestSprite

;1-byte header: sprite count
;then Y, X, Tile, Attribute

Meta_TestSprite:
	.DB 10
	.DB 0, 0, ASC('T'), 0
	.DB 0, 8, ASC('E'), 0
	.DB 0, 16, ASC('S'), 0
	.DB 0, 24, ASC('T'), 0

	.DB 8, 0, ASC('S'), 0
	.DB 8, 8, ASC('P'), 0
	.DB 8, 16, ASC('R'), 0
	.DB 8, 24, ASC('I'), 0
	.DB 8, 32, ASC('T'), 0
	.DB 8, 40, ASC('E'), 0

.ENDS
