.include "memmap.inc"
.include "enums.inc"

.RAMSECTION "hram_vars" SLOT 3
	hOamUpload DSB 5

	hLoopCount DB

	hPad1        DB
	hPad1Pressed DB

	hOamIndex   DB
	hActorCount DB

	hCurBank       DB
	hVblankCount   DB
	hFrameCount    DB
	hVblankSetting DB

	hHwModel DB ;bit 0: CGB  bit 1: SGB  bit 2: AGB  bit 3: SGB2  bit 4: MGB
.ENDS

.RAMSECTION "Sprite buffer" SLOT 2 ALIGN 256
	wSpriteBuffer DSB 160
	wUploadAddr   DSB 48

	wSpSave DW
.ENDS

.RAMSECTION "Upload data" SLOT 2 ALIGN 256
	wUploadData DSB 256
.ENDS

.REPEAT NUM_ACTORS INDEX count
	.RAMSECTION "Actor #{count}" SLOT 2 ALIGN 256
		wActor{count} INSTANCEOF Actor
	.ENDS
.ENDR

;sentinel byte to mark the end of the actor list
;should always be $FF
.RAMSECTION "Actor sentinel" SLOT 2 ALIGN 256
	wActorSentinel DB
.ENDS
