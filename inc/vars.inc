.struct ACTOR
	id	db
	x	dw
	y	dw
	padding	dsb 3
.endst

.export _sizeof_ACTOR

.ramsection "hram_vars" slot 3
	oamUpload:	dsb 5

	loopCount: db

	pad1:	db
	pad1Pressed:	db

	playerX:	db	;Hey! This should be in the actor system, and not hardcoded!
	playerY:	db

	curBank:	db
	vblankCount:	db
	frameCount:	db
	vblankSetting:	db

	hwModel:	db	;bit 0: CGB  bit 1: SGB  bit 2: AGB  bit 3: SGB2  bit 4: MGB
.ends

.ramsection "SpriteBuffer" slot 2 align 256
	spriteBuffer:	dsb 160
	uploadAddr:	dsb 32
	spSave:	dw
.ends

.ramsection "UploadData" slot 2 align 256
	uploadData:	dsb 256
.ends

.ramsection "ActorData" slot 2 align 256
	actorData:	dsb 256
.ends

