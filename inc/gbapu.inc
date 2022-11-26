;Wave RAM (r/w) (can only access when channel is disabled)
rWAVERAM = $FF30

;/-------------------\
;| Channel 1 (Pulse) |
;\-------------------/

;Channel 1 sweep (r/w)
rC1SWEEP = $FF10
;6-4: sweep frequency
;frequency = f / 128
C1SWEEP.F0 = %00000000 ;disable sweep
C1SWEEP.F1 = %00010000 ;every 7.8ms
C1SWEEP.F2 = %00100000 ;every 15.6ms
C1SWEEP.F3 = %00110000 ;every 23.4ms
C1SWEEP.F4 = %01000000 ;every 31.3ms
C1SWEEP.F5 = %01010000 ;every 39.1ms
C1SWEEP.F6 = %01100000 ;every 46.9ms
C1SWEEP.F7 = %01110000 ;every 54.7ms
;3: sweep direction
C1SWEEP.UP   = %00000000 ;sweep increases frequency
C1SWEEP.DOWN = %00001000 ;sweep decreases frequency
;2-0: sweep shift count
C1SWEEP.S0 = %00000000 ;no shift
C1SWEEP.S1 = %00000001 ;shift 1
C1SWEEP.S2 = %00000010 ;shift 2
C1SWEEP.S3 = %00000011 ;shift 3
C1SWEEP.S4 = %00000100 ;shift 4
C1SWEEP.S5 = %00000101 ;shift 5
C1SWEEP.S6 = %00000110 ;shift 6
C1SWEEP.S7 = %00000111 ;shift 7

;Channel 1 duty & length (r/w)
rC1DUTY = $FF11
;7-6: duty cycle (r/w)
C1DUTY.12 = %00000000 ;12.5% duty
C1DUTY.25 = %01000000 ;25% duty
C1DUTY.50 = %10000000 ;50% duty
C1DUTY.75 = %11000000 ;75% duty (phase inverted 25%)
;5-0: length counter (w)
;larger value = shorter sound
;sound length: (1/256) * 64 - len

;Channel 1 volume & envelope (r/w)
rC1VOL = $FF12
;7-4: initial volume
;0..15 = low..high
C1VOL.0  = %00000000
C1VOL.1  = %00010000
C1VOL.2  = %00100000
C1VOL.3  = %00110000
C1VOL.4  = %01000000
C1VOL.5  = %01010000
C1VOL.6  = %01100000
C1VOL.7  = %01110000
C1VOL.8  = %10000000
C1VOL.9  = %10010000
C1VOL.10 = %10100000
C1VOL.11 = %10110000
C1VOL.12 = %11000000
C1VOL.13 = %11010000
C1VOL.14 = %11100000
C1VOL.15 = %11110000
;3: envelope direction
C1VOL.UP   = %00001000 ;envelope increases volume
C1VOL.DOWN = %00000000 ;envelope decreases volume
;2-0: envelope frequency
;frequency = f * (1/64)
C1VOL.F0 = %00000000 ;disable envelope
C1VOL.F1 = %00000001 ;every 15.6ms
C1VOL.F2 = %00000010 ;every 31.3ms
C1VOL.F3 = %00000011 ;every 46.9ms
C1VOL.F4 = %00000100 ;every 62.5ms
C1VOL.F5 = %00000101 ;every 78.1ms
C1VOL.F6 = %00000110 ;every 93.8ms
C1VOL.F7 = %00000111 ;every 109.4ms

;Channel 1 frequency low (w)
rC1FREQ = $FF13
;7-0: bits 7-0 of 11-bit frequency

;Channel 1 frequency high & control (r/w)
rC1CTRL = $FF14
;7: restart sound (w)
C1CTRL.RESTART = %10000000 ;restart length counter, envelope & phase
;6: enable length counter (r/w)
C1CTRL.LENGTH = %01000000 ;enable length counter
;2-0: bits 10-8 of 11-bit frequency (w)

;/-------------------\
;| Channel 2 (Pulse) |
;\-------------------/

;Channel 2 duty & length (r/w)
rC2DUTY = $FF16
;7-6: duty cycle (r/w)
C2DUTY.12 = %00000000 ;12.5% duty
C2DUTY.25 = %01000000 ;25% duty
C2DUTY.50 = %10000000 ;50% duty
C2DUTY.75 = %11000000 ;75% duty (phase inverted 25%)
;5-0: length counter (w)
;larger value = shorter sound
;sound length: (1/256) * 64 - len

;Channel 2 volume & envelope (r/w)
rC2VOL = $FF17
;7-4: initial volume
;0..15 = low..high
C2VOL.0  = %00000000
C2VOL.1  = %00010000
C2VOL.2  = %00100000
C2VOL.3  = %00110000
C2VOL.4  = %01000000
C2VOL.5  = %01010000
C2VOL.6  = %01100000
C2VOL.7  = %01110000
C2VOL.8  = %10000000
C2VOL.9  = %10010000
C2VOL.10 = %10100000
C2VOL.11 = %10110000
C2VOL.12 = %11000000
C2VOL.13 = %11010000
C2VOL.14 = %11100000
C2VOL.15 = %11110000
;3: envelope direction
C2VOL.UP   = %00001000 ;envelope increases volume
C2VOL.DOWN = %00000000 ;envelope decreases volume
;2-0: envelope frequency
;frequency = f * (1/64)
C2VOL.F0 = %00000000 ;disable envelope
C2VOL.F1 = %00000001 ;every 15.6ms
C2VOL.F2 = %00000010 ;every 31.3ms
C2VOL.F3 = %00000011 ;every 46.9ms
C2VOL.F4 = %00000100 ;every 62.5ms
C2VOL.F5 = %00000101 ;every 78.1ms
C2VOL.F6 = %00000110 ;every 93.8ms
C2VOL.F7 = %00000111 ;every 109.4ms

;Channel 2 frequency low (w)
rC2FREQ = $FF18
;7-0: bits 7-0 of 11-bit frequency

;Channel 2 frequency high & control (r/w)
rC2CTRL = $FF19
;7: restart sound (w)
C2CTRL.RESTART = %10000000 ;restart length counter, envelope & phase
;6: enable length counter (r/w)
C2CTRL.LENGTH = %01000000 ;enable length counter
;2-0: bits 10-8 of 11-bit frequency (w)

;/-------------------\
;| Channel 3 (Wave) |
;\-------------------/

;Channel 3 enable (r/w)
rC3EN = $FF1A
;7: enable/disable wave channel
;must be disabled to access wave RAM
C3EN.ON  = %10000000
C3EN.OFF = %00000000

;Channel 3 length counter (w)
rC3LEN = $FF1B
;7-0: length counter
;larger value = shorter sound
;sound length: (1/256) * 256 - len

;Channel 3 shift count (pseudo-volume) (r/w)
rC3VOL = $FF1C
;6-5: shift count for wave data
C3VOL.0 = %00000000 ;mute sound (0%)
C3VOL.1 = %00100000 ;normal (100%)
C3VOL.2 = %01000000 ;shift right once (50%)
C3VOL.3 = %01100000 ;shift right twice (25%)

;Channel 3 frequency low (w)
rC3FREQ = $FF1D
;7-0: bits 7-0 of 11-bit frequency

;Channel 3 frequency high & control (r/w)
rC3CTRL = $FF1E
;7: restart sound (w)
C3CTRL.RESTART = %10000000 ;restart length counter & phase
;6: enable length counter (r/w)
C3CTRL.LENGTH = %01000000 ;enable length counter
;2-0: bits 10-8 of 11-bit frequency (w)


;/-------------------\
;| Channel 4 (Noise) |
;\-------------------/

;Channel 4 length counter (w)
rC4LEN = $FF20
;5-0: length counter
;larger value = shorter sound
;sound length: 3.9ms (1/256) * 64 - len

;Channel 4 volume & envelope (r/w)
rC4VOL = $FF21
;7-4: initial volume
;0..15 = low..high
C4VOL.0  = %00000000
C4VOL.1  = %00010000
C4VOL.2  = %00100000
C4VOL.3  = %00110000
C4VOL.4  = %01000000
C4VOL.5  = %01010000
C4VOL.6  = %01100000
C4VOL.7  = %01110000
C4VOL.8  = %10000000
C4VOL.9  = %10010000
C4VOL.10 = %10100000
C4VOL.11 = %10110000
C4VOL.12 = %11000000
C4VOL.13 = %11010000
C4VOL.14 = %11100000
C4VOL.15 = %11110000
;3: envelope direction
C4VOL.UP   = %00001000 ;envelope increases volume
C4VOL.DOWN = %00000000 ;envelope decreases volume
;2-0: envelope frequency
;frequency = f * (1/64)
C4VOL.F0 = %00000000 ;disable envelope
C4VOL.F1 = %00000001 ;every 15.6ms
C4VOL.F2 = %00000010 ;every 31.3ms
C4VOL.F3 = %00000011 ;every 46.9ms
C4VOL.F4 = %00000100 ;every 62.5ms
C4VOL.F5 = %00000101 ;every 78.1ms
C4VOL.F6 = %00000110 ;every 93.8ms
C4VOL.F7 = %00000111 ;every 109.4ms

;Channel 4 shift register control (r/w)
rC4FREQ = $FF22
;7-5: shift frequency
;0..15 = low..high
C4FREQ.0  = %00000000
C4FREQ.1  = %00010000
C4FREQ.2  = %00100000
C4FREQ.3  = %00110000
C4FREQ.4  = %01000000
C4FREQ.5  = %01010000
C4FREQ.6  = %01100000
C4FREQ.7  = %01110000
C4FREQ.8  = %10000000
C4FREQ.9  = %10010000
C4FREQ.10 = %10100000
C4FREQ.11 = %10110000
C4FREQ.12 = %11000000
C4FREQ.13 = %11010000
C4FREQ.14 = %11100000
C4FREQ.15 = %11110000
;3: shift register length
C4FREQ.L = %00000000 ;15 bits
C4FREQ.S = %00001000 ;7 bits
;2-0: shift frequency
;0..7 = high..low
C4FREQ.F0 = %00000000
C4FREQ.F1 = %00000001
C4FREQ.F2 = %00000010
C4FREQ.F3 = %00000011
C4FREQ.F4 = %00000100
C4FREQ.F5 = %00000101
C4FREQ.F6 = %00000110
C4FREQ.F7 = %00000111

;Channel 4 control (r/w)
rC4CTRL = $FF23
;7: restart sound (w)
C4CTRL.RESTART = %10000000 ;restart length counter & phase
;6: enable length counter (r/w)
C4CTRL.LENGTH = %01000000 ;enable length counter

;/--------------------------\
;| Master control registers |
;\--------------------------/

;Master volume & external audio r/w)
rAPUVOL = $FF24
APUVOL.EXTL = %10000000 ;enable external audio on left speaker
APUVOL.EXTR = %00001000 ;enable external audio on right speaker

APUVOL.7L = %01110000
APUVOL.6L = %01100000
APUVOL.5L = %01010000
APUVOL.4L = %01000000
APUVOL.3L = %00110000
APUVOL.2L = %00100000
APUVOL.1L = %00010000
APUVOL.0L = %00000000

APUVOL.7R = %00000111
APUVOL.6R = %00000110
APUVOL.5R = %00000101
APUVOL.4R = %00000100
APUVOL.3R = %00000011
APUVOL.2R = %00000010
APUVOL.1R = %00000001
APUVOL.0R = %00000000

;Mixer control (r/w)
rAPUMIX = $FF25
APUMIX.4L = %10000000
APUMIX.3L = %01000000
APUMIX.2L = %00100000
APUMIX.1L = %00010000
APUMIX.4R = %00001000
APUMIX.3R = %00000100
APUMIX.2R = %00000010
APUMIX.1R = %00000001

;Master enable & length counter (r/w)
;Length counter bits set when channel is restarted/enabled,
;cleared when length counter expires
rAPUSTAT = $FF26
;7: master enable (r/w)
APUSTAT.ON  = %10000000 ;enable APU
APUSTAT.OFF = %00000000 ;disable APU
;3-0: length counter status (r)
APUSTAT.4 = %00001000 ;length counter ch.4
APUSTAT.3 = %00000100 ;length counter ch.3
APUSTAT.2 = %00000010 ;length counter ch.2
APUSTAT.1 = %00000001 ;length counter ch.1
