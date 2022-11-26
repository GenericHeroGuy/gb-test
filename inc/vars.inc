.STRUCT ACTOR
	id      DB
	x       DW
	y       DW
	padding DSB 3
.ENDST

.EXPORT _sizeof_ACTOR

.RAMSECTION "hram_vars" SLOT 3
	hOamUpload: DSB 5

	hLoopCount: DB

	hPad1:        DB
	hPad1Pressed: DB

	hPlayerX: DB ;Hey! This should be in the actor system, and not hardcoded!
	hPlayerY: DB

	hCurBank:       DB
	hVblankCount:   DB
	hFrameCount:    DB
	hVblankSetting: DB

	hHwModel: DB ;bit 0: CGB  bit 1: SGB  bit 2: AGB  bit 3: SGB2  bit 4: MGB
.ENDS

.RAMSECTION "SpriteBuffer" SLOT 2 ALIGN 256
	wSpriteBuffer: DSB 160
	wUploadAddr:   DSB 32

	wSpSave: DW
.ENDS

.RAMSECTION "UploadData" SLOT 2 ALIGN 256
	wUploadData: DSB 256
.ENDS

.RAMSECTION "ActorData" SLOT 2 ALIGN 256
	wActorData: DSB 256
.ENDS
