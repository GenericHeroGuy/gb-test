.include "memmap.inc"

.gbheader
	name "GB Test"
	licenseecodenew "NO"
	cartridgetype 1	;ROM+MBC1
	ramsize 0
	countrycode 1
	destinationcode 1
	version 0

	nintendologo
	romsgb
.endgb

.bank 0 slot 0
.orga $100
.section "ENTRYPOINT" size 4 force
	DI
	JP Reset
.ends
