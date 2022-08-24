.memorymap
	defaultslot 0
	slot 0 start $0000 size $4000	;MBC fixed bank
	slot 1 start $4000 size $4000	;MBC switched bank
	slot 2 start $C000 size $2000 name "WRAM"	;Work RAM
	slot 3 start $FF80 size $007F name "HRAM"	;High RAM
.endme

WRAM = $C000
HRAM = $FF80

.rombankmap
	bankstotal 4
	banksize $4000
	banks 4
.endro

.emptyfill $FF
