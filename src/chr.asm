.include "memmap.inc"

.section CHR

CHR_CHARSET:
	.incbin "chr/charset.chr" fsize CHR_CHARSET_size
	.export CHR_CHARSET_size

.ends
