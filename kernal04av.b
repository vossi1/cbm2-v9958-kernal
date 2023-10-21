; cbm2 kernal 04av.b
; modified for v9958-cart at $D900-$D907, ROM at $1000
; comments & copyright Vossi 02/2019
; version 1.2
; - renamed labels
;
!cpu 6502
!ct scr		; standard text/char conversion table -> Screencode (pet = PETSCII, raw)
; switches:
PAL = 1		; PAL=1, NTSC=0		selects V9938/58 PAL RGB-output, NTSC has a higher picture
; constants:
FILL			= $00		; fills free memory areas with $00
VDPREG18		= $0d		; VDP reg 18 value (V/H screen adjust, $0d = Sony PVM 9")
VDPREG9			= $80|PAL*2	; VDP reg 9 value ($80 = NTSC, $82 = PAL / 212 lines)
CRTCCURSOR		= $00		; init crtc cursor type $00 = solid, $60 = blink 1/32
COLREG1			= $16		; color / background+backdrop color
; C64:		0=black		1=white		2=red		3=cyan		4=violet	5=green		6=blue		7=yellow
; Colors	8=orange	9=brown		a=lightred	b=darkgrey	c=grey		d=litegreen	e=lightblue	f=lightgrey
; init-colors: 	0 transparent, 1 black, 2 green, 3 light-green, 4 blue, 5 light-blue, 6 dark-red, 7 cyan
; (TMS compatible)	8 red, 9 light-red, a yellow, b light-yellow, c dark-green, d pink, e grey, f white 
; addresses:
VDPAddress		= $d900
PatternTable		= $1000
ColorTable		= $0a00
ScreenTable		= $0000
FontData		= $1800
FontSize		= $0400

!addr VDPRamWrite	= VDPAddress	; VDP ports
!addr VDPControl	= VDPAddress+1
!addr VDPPalette	= VDPAddress+2
!addr VDPIndirect	= VDPAddress+3
!addr VDPRamRead	= VDPAddress+4
!addr VDPStatus		= VDPAddress+5
; zero page $f0-$ff free space
!addr vdp_copy_pointer	= $f0;+$f1	; pointer for VdpFont
!addr vdp_reverse	= $f2		; reverse flag for VdpFont
!addr vdp_fontaddress	= $f3		; font address for VdpFont
!addr vdp_color		= $f4		; color register 7 mirror
!addr vdp_cursor_flag	= $f5		; > $00 = cursor already reverse
!addr vdp_cursor_char	= $f6		; character under cursor

!initmem FILL
*= $e000			; ***** jump-table *****
jmonon:	jmp monoff			; sub: monitor cold-boot (basic off)
	nop
jcint:	jmp cint			; sub: initialize $e044
jlp2:	jmp lp2				; sub: get char from keybuffer in A
jloop5:	jmp loop5			; sub: get char from screen
jprt:	jmp prt				; sub: print char from A to screen
jscror:	jmp scrorg			; sub: max count of columns = X, lines = Y
jkey:	jmp key				; sub: read keyboard to buffer
jmvcur:	jmp movcur			; sub: write cursor pos to 6845 reg 14/15
jplot:	jmp plot			; sub: read/write x/y cursor position
jiobas:	jmp iobase			; sub: i/o base-address to X/Y
jescrt:	jmp escape			; sub: escape functions
jfunky:	jmp keyfun			; sub: vector for F-keys
plot:	bcs rdplt
	stx $ca
	stx $cf
	sty $cb
	sty $ce
	jsr stupt
	jsr movcur
rdplt:	ldx $ca
	ldy $cb
	rts
iobase:	ldx #$00
	ldy #$dc
	rts
scrorg:	ldx #$50
	ldy #$19
	rts
cint:	lda #$00			; ***** initialize F-keys & screen *****			
	ldx #$23
cloop1:	sta $c2,x			; clear key-buffer
	dex
	bpl cloop1
	ldx #$20
cloop2:	sta $0397,x			; clear reverse flags
	dex
	bpl cloop2
	lda #$0c			; reset repeat, cursor
	sta $d8
	lda # CRTCCURSOR	; ***** PATCHED ***** cursor type $00 = solid / kernal 04a: $60
	sta $d4
	lda #$2a
	sta $03b5			; reset address F-keys
	lda #$e9
	sta $03b6
	lda $c0
	ora $c1
	bne noroom
	lda $0355
	sta $0380
	lda $0356
	sta $0381
	lda #$40
	ldx #$00
	ldy #$02
	jsr lff81
	bcs noroom
	sta $0382
	inx
	stx $c0
	bne room10
	iny
room10:	sty $c1
	ldy #$39
	jsr le282
kyset1:	lda keydef-1,y			; reset all 10 F-keys to standard
	dey
	sta ($c0),y
	bne kyset1
	jsr pagres
	ldy #$0a
kyset2:	lda keylen-2+1,y
	sta $0382,y
	dey
	bne kyset2
noroom:	jsr sreset			; sub: home-home screen window full size
	jsr txcrt			; set text-mode / sub: switch crt text/graphics
	jsr crtint		; ***** PATCHED ***** sub VDP init -> sub: init crt-controller
clsr:	jsr nxtd		
cls10:	jsr scrset
	jsr le227
	cpx $dd
	inx
	bcc cls10
nxtd:	ldx $dc
	stx $ca
	stx $cf
stu10:	ldy $de
	sty $cb
	sty $ce
stupt:	ldx $ca
scrset:	lda ldtb2,x
	sta $c8
	lda ldtb1,x
	sta $c9
	rts
movcur:	ldy #$0f
	clc
	lda $c8
	adc $cb
	sty $d800
	sta $d801
	dey
	sty $d800
	lda $d801
	and #$f8
	sta $d9
	lda $c9
	adc #$00
	and #$07
	ora $d9
	sta $d801
	rts
lp2:	ldx $d6
	beq lp3
	ldy $039d
	jsr le282
	lda ($c2),y
	jsr pagres
	dec $d6
	inc $039d
	cli
	rts
lp3:	ldy $03ab
	ldx #$00
lp1:	lda $03ac,x
	sta $03ab,x
	inx
	cpx $d1
	bne lp1
	dec $d1
	tya
	cli
	rts
loop4:	jsr prt				; print char and move cursor
loop3:	ldy #$0a			; reg 10 of 6845
	lda $d4				; load cursor config
	sty $d800			; switch 6845 cursor on 
	jsr VdpCursorSet	; ***** PATCHED ***** write cursor (reverse char) to VRAM
loop3a:	lda $d1				; count of keys in keybuffer
	ora $d6				; count of pgm key-command
	beq loop3a			; wait for key
	sei
	lda vdp_cursor_char		; load original char under cursor
	jsr VdpCursorClear	; ***** PATCHED ***** restore char under cursor position
	jsr lp2				; sub: get char from keybuffer
	cmp #$0d			; cariage return?
	bne loop4			; if not cr print char and wait again
	jsr patch4			; kernal 04a patch - switch 6845 cursor off only after return 
				; ***** PATCHED ***** removed nop's to insert lda vdp_c+jsr VdpCursorChar
					; kernal 04a has here 5 nops and moved some lines to patch4
	sta $d0
	jsr le544
	stx $0398
	jsr patch1
	sta $d3
	sta $d2
	ldy $de
	lda $cf
	bmi lp80
	cmp $ca
	bcc lp80
	ldy $ce
	cmp $0398
	bne lp70
	cpy $d5
	beq lp75
lp70:	bcs clp2
lp75:	sta $ca
lp80:	sty $cb
	jmp lop5
loop5:	tya
	pha
	txa
	pha
	lda $d0
	beq loop3
	bpl lop5
clp2:	lda #$00
	sta $d0
	lda #$0d
	bne le1c4
lop5:	jsr stupt
	jsr le242
	sta $db
	and #$3f
	asl $db
	bit $db
	bpl le19d
	ora #$80
le19d:	bcc le1a3
	ldx $d2
	bne le1a7
le1a3:	bvs le1a7
	ora #$40
le1a7:	jsr le1cd
	ldy $ca
	cpy $0398
	bcc le1bb
	ldy $cb
	cpy $d5
	bcc le1bb
	ror $d0
	bmi le1be
le1bb:	jsr le574
le1be:	cmp #$de
	bne le1c4
	lda #$ff
le1c4:	sta $db
	pla
	tax
	pla
	tay
	lda $db
	rts
le1cd:	cmp #$22
	bne le1dd
	lda $d3
	bne le1db
	lda $d2
	eor #$01
	sta $d2
le1db:	lda #$22
le1dd:	rts
le1de:	bit $0397
	bpl le1e5
	ora #$80
le1e5:	ldx $d3
	beq le1eb
	dec $d3
le1eb:	bit $039a
	bpl le1f9
	pha
	jsr le5e4
	ldx #$00
	stx $d3
	pla
le1f9:	jsr dspp
	cpy #$45
	bne le203
	jsr le48d
le203:	jsr le62e
le206:	lda $db
	sta $0399
	jsr movcur
	pla
	tay
	lda $d3
	beq le216
	lsr $d2
le216:	pla
	tax
	pla
	rts
le21a:	lda #$20
				; ***** char at cursor position *****
dspp:	ldy $cb				; load cursor column in Y
	jsr pagset			; safe indirect bank
	sta ($c8),y			; write char to screen ($c8 = line start pointer)
	jmp VdpPrint		; ***** PATCHED ***** print char to VDP screen -> pagres restore bank
	rts

le227:	ldy $de
	jsr le505
le22c:	txa
	pha
	lda $cb
	pha
	dey
le232:	iny
	sty $cb
	jsr le21a
	cpy $df
	bne le232
	pla
	sta $cb
	pla
	tax
	rts
le242:	ldy $cb
le244:	jsr pagset
	lda ($c8),y
	jsr pagres
	rts

ctext:	ldy #$10
	bcs crtset
txcrt:	ldy #$00			; set text-mode
crtset:	sty $cc			; ***** switch crt text/graphics *****
	lda $de06
	and #$ef
	ora $cc
	jsr VdpFontSwitch		; load font set to VRAM 
	rts

crtint:	jsr VdpInit		; ***** PATCHED ***** sub VDP init
	nop
	nop
	bmi crt10
	ldy #$23
	bvs crt10
	ldy #$35
crt10:	ldx #$11
crt20:	lda atext,y			; codetab 1 for crtc
	stx $d800			; 6845 address reg
	sta $d801			; 6845 data reg
	dey
	dex
	bpl crt20
	rts
				; ***** safe indirect bank *****
pagset:	pha
	lda #$3f
	bne le286
le282:	pha
	lda $0382
le286:	pha
	lda $01
	sta $03a0
	pla
	sta $01
	pla
	rts

pagres:	pha
	lda $03a0
	sta $01
	pla
	rts
prt:	pha
	cmp #$ff
	bne le2a0
	lda #$de
le2a0:	sta $db
	txa
	pha
	tya
	pha
	lda #$00
	sta $d0
	ldy $cb
	lda $db
	and #$7f
	cmp #$20
	bcc le2cf
	ldx $0399
	cpx #$1b
	bne le2c1
	jsr le655
	jmp le303
le2c1:	and #$3f
le2c3:	bit $db
	bpl le2c9
	ora #$40
le2c9:	jsr le1cd
	jmp le1de
le2cf:	cmp #$0d
	beq le2fc
	cmp #$14
	beq le2fc
	cmp #$1b
	bne le2ec
	bit $db
	bmi le2ec
	lda $d2
	ora $d3
	beq le2fc
	jsr le3a2
	sta $db
	beq le2fc
le2ec:	cmp #$03
	beq le2fc
	ldy $d3
	bne le2f8
	ldy $d2
	beq le2fc
le2f8:	ora #$80
	bne le2c3
le2fc:	lda $db
	asl
	tax
	jsr le306
le303:	jmp le206
le306:	lda ctable+1,x
	pha
	lda ctable,x
	pha
	lda $db
	rts
	jmp ($0322)
	bcs le323
	jsr le37a
le319:	jsr le4f5
	bcs le321
	sec
	ror $cf
le321:	clc
	rts
le323:	ldx $dc
	cpx $ca
	bcs le338
le329:	jsr le319
	dec $ca
	jmp stupt
	bcs le339
	jsr le574
	bcs le319
le338:	rts
le339:	jsr le587
	bcs le338
	bne le321
	inc $ca
	bne le329
	eor #$80
	sta $0397
	rts
	bcc le34f
	jmp clsr
le34f:	cmp $0399
	bne le357
	jsr sreset
le357:	jmp nxtd
	ldy $cb
	bcs le370
le35e:	cpy $df
	bcc le367
	lda $df
	sta $cb
	rts
le367:	iny
	jsr le95a
	beq le35e
	sty $cb
	rts
le370:	jsr le95a
	eor $039c
	sta $03a1,x
	rts
le37a:	ldx $ca
	cpx $dd
	bcc le38f
	bit $039b
	bpl le38b
	lda $dc
	sta $ca
	bcs le391
le38b:	jsr le3f6
	clc
le38f:	inc $ca
le391:	jmp stupt
	jsr le544
	inx
	jsr le505
	ldy $de
	sty $cb
	jsr le37a
le3a2:	lda #$00
	sta $d3
	sta $0397
	sta $d2
	cmp $039f
	bne le3b3
	sta $da18
le3b3:	rts
le3b4:	lda ldtb2,x
	sta $c4
	lda ldtb1,x
	sta $c5
	jsr pagset
le3c1:	lda ($c4),y
	sta ($c8),y
	cpy $df
	iny
	bcc le3c1
	jmp VdpMoveLine		; ***** PATCHED ***** move line on VDP screen -> pagres restore bank	
le3cd:	ldx $cf
	bmi le3d7
	cpx $ca
	bcc le3d7
	inc $cf
le3d7:	ldx $dd
le3d9:	jsr scrset
	ldy $de
	cpx $ca
	beq le3f0
	dex
	jsr le4f7
	inx
	jsr le503
	dex
	jsr le3b4
	bcs le3d9
le3f0:	jsr le227
	jmp le512
le3f6:	ldx $dc
le3f8:	inx
	jsr le4f7
	bcc le408
	cpx $dd
	bcc le3f8
	ldx $dc
	inx
	jsr le505
le408:	dec $ca
	bit $cf
	bmi le410
	dec $cf
le410:	ldx $dc
	cpx $da
	bcs le418
	dec $da
le418:	jsr le42d
	ldx $dc
	jsr le4f7
	php
	jsr le505
	plp
	bcc le42c
	bit $039e
	bmi le408
le42c:	rts
le42d:	jsr scrset
	ldy $de
	cpx $dd
	bcs le444
	inx
	jsr le4f7
	dex
	jsr le503
	inx
	jsr le3b4
	bcs le42d
le444:	jsr le227
	ldx #$ff
	ldy #$fe
	jsr le480
	and #$20
	bne le45f
le452:	nop
	nop
	dex
	bne le452
	dey
	bne le452
le45a:	sty $d1
le45c:	jmp le8f7
le45f:	ldx #$f7
	ldy #$ff
	jsr le480
	and #$10
	bne le45c
le46a:	jsr le480
	and #$10
	beq le46a
le471:	ldy #$00
	ldx #$00
	jsr le480
	and #$3f
	eor #$3f
	beq le471
	bne le45a
le480:	php
	sei
	stx $df00
	sty $df01
	jsr le91e
	plp
	rts
le48d:	lda $039f
	bne le4b9
	lda #$0f
	sta $da18
	ldy #$00
	sty $da05
	lda #$0a
	sta $da06
	lda #$30
	sta $da01
	lda #$60
	sta $da0f
	ldx #$15
	stx $da04
le4b0:	nop
	nop
	iny
	bne le4b0
	dex
	stx $da04
le4b9:	rts
	lda $cb
	pha
le4bd:	ldy $cb
	dey
	jsr le244
	cmp #$2b
	beq le4cb
	cmp #$2d
	bne le4d3
le4cb:	dey
	jsr le244
	cmp #$05
	bne le4ed
le4d3:	cmp #$05
	bne le4db
	dey
	jsr le244
le4db:	cmp #$2e
	bcc le4ed
	cmp #$2f
	beq le4ed
	cmp #$3a
	bcs le4ed
	jsr le5b0
	jmp le4bd
le4ed:	pla
	cmp $cb
	bne le4b9
	jmp le5b0
le4f5:	ldx $ca
le4f7:	jsr le51e
	and $e2,x
	cmp #$01
	jmp le50e
le501:	ldx $ca
le503:	bcs le512
le505:	jsr le51e
	eor #$ff
	and $e2,x
le50c:	sta $e2,x
le50e:	ldx $039c
	rts
le512:	bit $039b
	bvs le4f7
	jsr le51e
	ora $e2,x
	bne le50c
le51e:	stx $039c
	txa
	and #$07
	tax
	lda keyend,x
	pha
	lda $039c
	lsr
	lsr
	lsr
	tax
	pla
	rts
	ldy $de
	sty $cb
le536:	jsr le4f5
	bcc le541
	dec $ca
	bpl le536
	inc $ca
le541:	jmp stupt
le544:	lda $ca
	cmp $dd
	bcs le553
	inc $ca
	jsr le4f5
	bcs le544
	dec $ca
le553:	jsr stupt
	ldy $df
	sty $cb
	bpl le561
le55c:	jsr le587
	bcs le571
le561:	jsr le242
	cmp #$20
	bne le571
	cpy $de
	bne le55c
	jsr le4f5
	bcs le55c
le571:	sty $d5
	rts
le574:	pha
	ldy $cb
	cpy $df
	bcc le582
	jsr le37a
	ldy $de
	dey
	sec
le582:	iny
	sty $cb
	pla
	rts
le587:	ldy $cb
	dey
	bmi le590
	cpy $de
	bcs le59f
le590:	ldy $dc
	cpy $ca
	bcs le5a4
	dec $ca
	pha
	jsr stupt
	pla
	ldy $df
le59f:	sty $cb
	cpy $df
	clc
le5a4:	rts
le5a5:	ldy $cb
	sty $d9
	ldx $ca
	stx $da
	rts
	bcs le5e4
le5b0:	jsr le339
	jsr le5a5
	bcs le5c7
le5b8:	cpy $df
	bcc le5d2
	ldx $ca
	inx
	jsr le4f7
	bcs le5d2
	jsr le21a
le5c7:	lda $d9
	sta $cb
	lda $da
	sta $ca
	jmp stupt
le5d2:	jsr le574
	jsr le242
	jsr le587
	jsr dspp
	jsr le574
	jmp le5b8
le5e4:	jsr le5a5
	jsr le544
	cpx $da
	bne le5f0
	cpy $d9
le5f0:	bcc le613
	jsr le62e
	bcs le619
le5f7:	jsr le587
	jsr le242
	jsr le574
	jsr dspp
	jsr le587
	ldx $ca
	cpx $da
	bne le5f7
	cpy $d9
	bne le5f7
	jsr le21a
le613:	inc $d3
	bne le619
	dec $d3
le619:	jmp le5c7
	bcc le62d
	sei
	ldx #$09
	stx $d1
le623:	lda runtb-1,x
	sta $03aa,x
	dex
	bne le623
	cli
le62d:	rts
le62e:	cpy $df
	bcc le63d
	ldx $ca
	cpx $dd
	bcc le63d
	bit $039b
	bmi le654
le63d:	jsr stupt
	jsr le574
	bcc le654
	jsr le4f5
	bcs le653
	jsr bszei1
	sec
	bvs le654
	jsr le3cd
le653:	clc
le654:	rts
le655:	jmp ($0320)
	jsr le3cd
	jsr stu10
	inx
	jsr le4f7
	php
	jsr le501
	plp
	bcs le66c
	sec
	ror $cf
le66c:	rts
	jsr le536
	lda $dc
	pha
	lda $ca
	sta $dc
	lda $039e
	pha
	lda #$80
	sta $039e
	jsr le408
	pla
	sta $039e
	lda $dc
	sta $ca
	pla
	sta $dc
	sec
	ror $cf
	jmp stu10
	jsr le5a5
le697:	jsr le22c
	inc $ca
	jsr stupt
	ldy $de
	jsr le4f5
	bcs le697
le6a6:	jmp le5c7
	jsr le5a5
le6ac:	jsr le21a
	cpy $de
	bne le6b8
	jsr le4f5
	bcc le6a6
le6b8:	jsr le587
	bcc le6ac
	jsr le5a5
	txa
	pha
	jsr le3f6
	pla
	sta $da
	jmp le6a6
	jsr le5a5
	jsr le4f5
	bcs le6d6
	sec
	ror $cf
le6d6:	lda $dc
	sta $ca
	jsr le3cd
	jsr le505
	jmp le6a6
	clc
	bit $38
	lda #$00
	ror
	sta $039b
	rts
	clc
	bcc le6f1
	sec
le6f1:	lda #$00
	ror
	sta $039e
	rts
keyfun:	sei
	dey
	bmi le6ff
	jmp addkey
le6ff:	ldy #$00
le701:	iny
	sty $03b7
	dey
	lda $0383,y
	beq le777
	sta $039d
	jsr le949
	sta $c2
	stx $c3
	ldx #$03
le717:	lda keword,x
	jsr lffd2
	dex
	bpl le717
le720:	ldx #$2f
	lda $03b7
	sec
le726:	inx
	sbc #$0a
	bcs le726
	adc #$3a
	cpx #$30
	beq le737
	pha
	txa
	jsr lffd2
	pla
le737:	jsr lffd2
	ldy #$00
	lda #$2c
le73e:	jsr lffd2
	ldx #$07
le743:	jsr le282
	lda ($c2),y
	jsr pagres
	cmp #$0d
	beq le781
	cmp #$8d
	beq le784
	cmp #$22
	beq le787
	cpx #$09
	beq le762
	pha
	lda #$22
	jsr lffd2
	pla
le762:	jsr lffd2
	ldx #$09
	iny
	cpy $039d
	bne le743
	lda #$22
	jsr lffd2
le772:	lda #$0d
	jsr lffd2
le777:	ldy $03b7
	cpy #$14
	bne le701
	cli
	clc
	rts
le781:	ldx #$0a
	!byte $2c
le784:	ldx #$13
	!byte $2c
le787:	ldx #$0e
	txa
	pha
	ldx #$06
le78d:	lda cdword,x
	beq le79c
	jsr lffd2
	dex
	bpl le78d
	pla
	tax
	bne le78d
le79c:	iny
	cpy $039d
	beq le772
	lda #$2b
	bne le73e

keword:	!pet " yek"
cdword:	!pet "($rhc+",$22,$00
	!pet ")31",$00
	!pet ")43",$00
	!pet ")141"

addkey:	pha
	tax
	sty $d9
	lda $00,x
	sec
	sbc $0383,y
	sta $da
	ror $039c
	iny
	jsr le949
	sta $c4
	stx $c5
	ldy #$14
	jsr le949
	sta $c6
	stx $c7
	ldy $039c
	bpl le7f6
	clc
	sbc $0380
	tay
	txa
	sbc $0381
	tax
	tya
	clc
	adc $da
	txa
	adc #$00
	bcs le862
le7f6:	jsr le282
le7f9:	lda $c6
	clc
	sbc $c4
	lda $c7
	sbc $c5
	bcc le82e
	ldy #$00
	lda $039c
	bpl le81c
	lda $c6
	bne le811
	dec $c7
le811:	dec $c6
	lda ($c6),y
	ldy $da
	sta ($c6),y
	jmp le7f9
le81c:	lda ($c4),y
	ldy $da
	dec $c5
	sta ($c4),y
	inc $c5
	inc $c4
	bne le7f9
	inc $c5
	bne le7f9
le82e:	ldy $d9
	jsr le949
	sta $c4
	stx $c5
	ldy $d9
	pla
	pha
	tax
	lda $00,x
	sta $0383,y
	tay
	beq le85e
	lda $01,x
	sta $c6
	lda $02,x
	sta $c7
le84c:	dey
	lda $03,x
	sta $01
	lda ($c6),y
	jsr pagres
	jsr le282
	sta ($c4),y
	tya
	bne le84c
le85e:	jsr pagres
	clc
le862:	pla
	cli
	rts
key:	ldy #$ff
	sty $e0
	sty $e1
	iny
	sty $df01
	sty $df00
	jsr le91e
	and #$3f
	eor #$3f
	bne le87e
	jmp le8f3
le87e:	lda #$ff
	sta $df00
	asl
	sta $df01
	jsr le91e
	pha
	sta $e0
	ora #$30
	bne le894
le891:	jsr le91e
le894:	ldx #$05
le896:	lsr
	bcc le8a9
	iny
	dex
	bpl le896
	sec
	rol $df01
	rol $df00
	bcs le891
	pla
	bcc le8f3
le8a9:	sty $e1
	ldx normtb,y
	pla
	asl
	asl
	asl
	bcc le8c2
	bmi le8c5
	ldx shfttb,y
	lda $cc
	beq le8c5
	ldx leae9,y
	bne le8c5
le8c2:	ldx ctltbl,y
le8c5:	cpx #$ff
	beq le8f5
	cpx #$e0
	bcc le8d6
	tya
	pha
	jsr le927
	pla
	tay
	bcs le8f5
le8d6:	txa
	cpy $cd
	beq le902
	ldx #$13
	stx $d8
	ldx $d1
	cpx #$09
	beq le8f3
	cpy #$59
	bne le912
	cpx #$08
	beq le8f3
	sta $03ab,x
	inx
	bne le912
le8f3:	ldy #$ff
le8f5:	sty $cd
le8f7:	ldx #$7f
	stx $df00
	ldx #$ff
	stx $df01
	rts
le902:	dec $d8
	bpl le8f7
	inc $d8
	dec $d7
	bpl le8f7
	inc $d7
	ldx $d1
	bne le8f7
le912:	sta $03ab,x
	inx
	stx $d1
	ldx #$03
	stx $d7
	bne le8f5
le91e:	lda $df02
	cmp $df02
	bne le91e
	rts
le927:	jmp ($03b5)
	cpy $cd
	beq le947
	lda $d1
	ora $d6
	bne le947
	sta $039d
	txa
	and #$1f
	tay
	lda $0383,y
	sta $d6
	jsr le949
	sta $c2
	stx $c3
le947:	sec
	rts
le949:	lda $c0
	ldx $c1
le94d:	clc
	dey
	bmi le959
	adc $0383,y
	bcc le94d
	inx
	bne le94d
le959:	rts
le95a:	tya
	and #$07
	tax
	lda keyend,x
	sta $039c
	tya
	lsr
	lsr
	lsr
	tax
	lda $03a1,x
	bit $039c
	rts
escape:	and #$7f
	sec
	sbc #$41
	cmp #$1a
	bcc le97a
	rts
le97a:	asl
	tax
	lda escvct+1,x
	pha
	lda escvct,x
	pha
	rts
				; ***** escape-routines table *****		
escvct:	!byte $22,$ea			; esc, a
	!byte $ba,$e9			; esc, b
	!byte $1f,$ea
	!byte $6c,$e6
	!byte $ee,$e9
	!byte $e5,$e9
	!byte <(VdpTextColor-1),>(VdpTextColor-1)		; ***** PATCHED ***** esc, g $d5,$e9
	!byte <(VdpBackgroundColor-1),>(VdpBackgroundColor-1)	; ***** PATCHED ***** esc, h $d7,$e9
	!byte $57,$e6
	!byte $31,$e5
	!byte $43,$e5
	!byte $e2,$e6
	!byte $e4,$e6
	!byte $04,$ea
	!byte $a1,$e3
	!byte $a8,$e6
	!byte $93,$e6
	!byte $f5,$e9
	!byte $eb,$e9
	!byte $b8,$e9
	!byte $db,$e9
	!byte $bc,$e6
	!byte $ca,$e6
	!byte <(VdpIdent-1),>(VdpIdent-1)			; ***** PATCHED ***** esc, x $78,$e9
	!byte $07,$ea
	!byte $f8,$e9

sethtt:	clc
	!byte $24			; skip one byte - bit $xx
sethtb:	sec
window:	ldx $cb
	lda $ca
	bcc settps
setbts:	sta $dd
	stx $df
	rts
sreset:	lda #$18		; ***** home-home screen window full size *****
	ldx #$4f
	jsr setbts
	lda #$00
	tax
settps:	sta $dc
	stx $de
	rts
	lda #$00
	sta $039f
	rts
	lda #$0b
	bit $df02
	bmi le9e8
	lda #$06
	bit $60a9
le9e8:	ora $d4
	bne le9f3
	lda #$f0
	bit $0fa9
	and $d4
le9f3:	sta $d4
	rts
	lda #$20
	bit $10a9
	ldx #$0e
	stx $d800
	ora $d801
	bne lea12
	lda #$df
	!byte $2c
	lda #$ef
	ldx #$0e
	stx $d800
	and $d801
lea12:	sta $d801
	and #$30
	ldx #$0c
	stx $d800
	sta $d801
	rts
	lda #$00
	!byte $2c
	lda #$ff
	sta $039a
	rts

normtb:	!byte $e0,$1b,$09,$ff,$00,$01,$e1,$31		; ***** keyboard code table -shift ***** 
	!byte $51,$41,$5a,$ff,$e2,$32,$57,$53
	!byte $58,$43,$e3,$33,$45,$44,$46,$56
	!byte $e4,$34,$52,$54,$47,$42,$e5,$35
	!byte $36,$59,$48,$4e,$e6,$37,$55,$4a
	!byte $4d,$20,$e7,$38,$49,$4b,$2c,$2e
	!byte $e8,$39,$4f,$4c,$3b,$2f,$e9,$30
	!byte $2d,$50,$5b,$27,$11,$3d,$5f,$5d
	!byte $0d,$de,$91,$9d,$1d,$14,$02,$ff
	!byte $13,$3f,$37,$34,$31,$30,$12,$04
	!byte $38,$35,$32,$2e,$8e,$2a,$39,$36
	!byte $33,$30,$03,$2f,$2d,$2b,$0d,$ff

shfttb:	!byte $ea,$1b,$89,$ff,$00,$01,$eb,$21		; ***** keyboard code table +shift ***** 
	!byte $d1,$c1,$da,$ff,$ec,$40,$d7,$d3
	!byte $d8,$c3,$ed,$23,$c5,$c4,$c6,$d6
	!byte $ee,$24,$d2,$d4,$c7,$c2,$ef,$25
	!byte $5e,$d9,$c8,$ce,$f0,$26,$d5,$ca
	!byte $cd,$a0,$f1,$2a,$c9,$cb,$3c,$3e
	!byte $f2,$28,$cf,$cc,$3a,$3f,$f3,$29
	!byte $2d,$d0,$5b,$22,$11,$2b,$5c,$5d
	!byte $8d,$de,$91,$9d,$1d,$94,$82,$ff
	!byte $93,$3f,$37,$34,$31,$30,$92,$84
	!byte $38,$35,$32,$2e,$0e,$2a,$39,$36
	!byte $33,$30,$83,$2f,$2d,$2b,$8d,$ff

leae9:	!byte $ea,$1b,$89,$ff,$00,$01,$eb,$21		; ***** keyboard code table graphics+shift ***** 
	!byte $d1,$c1,$da,$ff,$ec,$40,$d7,$d3
	!byte $d8,$c0,$ed,$23,$c5,$c4,$c6,$c3
	!byte $ee,$24,$d2,$d4,$c7,$c2,$ef,$25
	!byte $5e,$d9,$c8,$dd,$f0,$26,$d5,$ca
	!byte $cd,$a0,$f1,$2a,$c9,$cb,$3c,$3e
	!byte $f2,$28,$cf,$d6,$3a,$3f,$f3,$29
	!byte $2d,$d0,$5b,$22,$11,$2b,$5c,$5d
	!byte $8d,$de,$91,$9d,$1a,$94,$82,$ff
	!byte $93,$3f,$37,$34,$31,$30,$92,$04
	!byte $38,$35,$32,$2e,$0e,$2a,$39,$36
	!byte $33,$30,$83,$2f,$2d,$2b,$8d,$ff

ctltbl:	!byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$a1		; ***** keyboard code table control-mode ***** 
	!byte $11,$01,$1a,$ff,$ff,$a2,$17,$13
	!byte $18,$03,$ff,$a3,$05,$04,$06,$16
	!byte $ff,$a4,$12,$14,$07,$02,$ff,$a5
	!byte $a7,$19,$08,$0e,$ff,$be,$15,$0a
	!byte $0d,$ff,$ff,$bb,$09,$0b,$ce,$ff
	!byte $ff,$bf,$0f,$0c,$dc,$ff,$ff,$ac
	!byte $bc,$10,$cc,$a8,$ff,$a9,$df,$ba
	!byte $ff,$a6,$ff,$ff,$ff,$ff,$ff,$ff
	!byte $ff,$b7,$b4,$b1,$b0,$ad,$ff,$b8
	!byte $b5,$b2,$ae,$bd,$ff,$b9,$b6,$b3
	!byte $db,$ff,$ff,$af,$aa,$ab,$ff,$ff

runtb:	!byte $44,$cc,$22,$2a,$0d,$52,$55,$4e,$0d	; ***** shift-run text: dload"* CR run CR *****

ldtb2:	!byte $00,$50,$a0,$f0,$40,$90,$e0,$30		; ***** start address-table  screen lines low *****
	!byte $80,$d0,$20,$70,$c0,$10,$60,$b0
	!byte $00,$50,$a0,$f0,$40,$90,$e0,$30
	!byte $80

ldtb1:	!byte $d0,$d0,$d0,$d0,$d1,$d1,$d1,$d2		; ***** start address-table  screen lines high *****
	!byte $d2,$d2,$d3,$d3,$d3,$d4,$d4,$d4
	!byte $d5,$d5,$d5,$d5,$d6,$d6,$d6,$d7
	!byte $d7

ctable:	!byte $10,$e3					; ***** address-table control routines *****
	!byte $10,$e3
	!byte $10,$e3
	!byte $1b,$e6
	!byte $b9,$e4
	!byte $10,$e3
	!byte $10,$e3
	!byte $8c,$e4
	!byte $10,$e3
	!byte $59,$e3
	!byte $10,$e3
	!byte $10,$e3
	!byte $10,$e3
	!byte $93,$e3
	!byte $4c,$e2
	!byte $bb,$e9
	!byte $10,$e3
	!byte $13,$e3
	!byte $43,$e3
	!byte $49,$e3
	!byte $ad,$e5
	!byte $10,$e3
	!byte $10,$e3
	!byte $10,$e3
	!byte $10,$e3
	!byte $10,$e3
	!byte $10,$e3
	!byte $10,$e3
	!byte $10,$e3
	!byte $30,$e3
	!byte $10,$e3
	!byte $10,$e3

keylen:	!byte $03,$04,$06,$06,$05,$05,$04,$09	; ***** PATCHED ***** table length of F-keys commands
	!byte $08,$07
						; ***** PATCHED ***** table F-key commands
keydef:	!pet "run"			; run
	!pet "list"			; list
	!pet "dload",$22		; dload"
	!pet "dsave",$22		; dsave"
	!pet "print"			; print
	!pet "chr$("			; chr$(
	!pet "bank"			; bank
	!pet "directory"		; directory
	!pet "scratch",$22		; scratch"
	!pet "header",$22		; header"

;keylen:!byte $05,$04,$06,$06,$05,$06,$04,$09	; ***** kernal 04a table length of F-keys commands *****
;	!byte $07,$05
						; ***** kernal04a table F-key commands *****
;keydef:!byte $50,$52,$49,$4e,$54			; print
;	!byte $4c,$49,$53,$54				; list
;	!byte $44,$4c,$4f,$41,$44,$22			; dload"
;	!byte $44,$53,$41,$56,$45,$22			; dsave"
;	!byte $44,$4f,$50,$45,$4e			; dopen
;	!byte $44,$43,$4c,$4f,$53,$45			; dclose
;	!byte $43,$4f,$50,$59				; copy
;	!byte $44,$49,$52,$45,$43,$54,$4f,$52,$59	; directory
;	!byte $53,$43,$52,$41,$54,$43,$48		; scratch
;	!byte $43,$48,$52,$24,$28			; chr$(
*= $ec67						; to prevent too long f-key texts!
keyend:	!byte $80		; ***** bit-table line-link *****	
	!byte $40
	!byte $20
	!byte $10
	!byte $08
	!byte $04
	!byte $02
	!byte $01

atext:	!byte $6b		; ***** codetab 1 for crtc *****   kernal03b: $6c - 6845 R0 hor. total
	!byte $50
	!byte $53
	!byte $0f
	!byte $19
	!byte $03
	!byte $19
	!byte $19
	!byte $00
	!byte $0d
	!byte $60
	!byte $0d
	!byte $00
	!byte $00
	!byte $00
	!byte $00
	!byte $00
	!byte $00

ntext:	!byte $7e		; ***** codetab 2 for crtc *****
	!byte $50
	!byte $62
	!byte $0a
	!byte $1f
	!byte $06
	!byte $19
	!byte $1c
	!byte $00
	!byte $07
	!byte $00
	!byte $07
	!byte $00
	!byte $00
	!byte $00
	!byte $00
	!byte $00
	!byte $00

ptext:	!byte $7f		; ***** codetab 3 for crtc *****
	!byte $50
	!byte $60
	!byte $0a
	!byte $26
	!byte $01
	!byte $19
	!byte $1e
	!byte $00
	!byte $07
	!byte $00
	!byte $07
	!byte $00
	!byte $00
	!byte $00
	!byte $00
	!byte $00
	!byte $00

cksume:	!byte $2e		; ***** checksum rom $e000-$ffff ***** kernal03b: $65
patch1:	jsr le536		; ***** kernal 04a patch routines - moved from $ecbo to $eca6 *****
	lda #$00
	rts
patch2:	ora $d0
	sta $d0
	lda $dd
	sta $0398
	lda $df
	rts
patch3:	bcc pat310
	jmp lf953
pat310:	php
	pha
	lda $a0
	and #$01
	beq pat320
	ldx $9e
	jsr lffc9
	jsr lffcc
	ldx $a6
pat320:	pla
	plp
	rts
patch4:	pha
	lda #$0a
	sta $d800
	lda #$20
	sta $d801
	pla
	rts				; end kernal 04a patches
bszei1:	ldx $dd				; unknown patch
	cpx $dc
	bne bszeib
	pla
	pla
bszeib:	bit $039b
	rts
; $eceb ********************************************************************************************
VdpInitData:						; ***** VDP init data table *****
	!byte $04,$80,$50,$81,$03,$82,$2f,$83
	!byte $02,$84,COLREG1,$87,$08,$88,VDPREG9,$89
	!byte $00,$8a,$00,$90,VDPREG18,$92,$00,$40		; last 2 bytes start VRAM write! 
	; reg  0: $04 mode control 1: text mode 2 (bit#1-3 = M3 - M5)
	; reg  1: $50 mode control 2: bit#1 16x16 sprites, bit#3-4 = M2-M1, #6 =1: display enable)
	; reg  2: $03 name (screen) table base address $0000 ( * $400 + bit#0+1 = 1)
	; reg  3: $2f color table base address $0A00 ( * $40 + bit#0-2 = 1)
	; reg  4: $02 pattern (character) generator table base address $1000 (* $800)
	; reg  7: $10 text/overscan-backdrop color 
	; reg  8: $08 bit#3 = 1: 64k VRAM chips, bit#1 = 0 sprites disable, bit#5 0=transparent
	; reg  9: $80 bit#1 = NTSC/PAL, #2 = EVEN/ODD, #3 = interlace, #7 = 192/212 lines
	; reg 10: $00 color table base address $0000 bit#0-2 = A14-A16
	; reg 12: $20 text/background blink color
	; reg 13: $f0 blink periods ON/OFF - f0 = blinking off
	; reg 14: $00 VRAM write addresss bit#0-2 = A14-A16
	; reg 16: $00 color palette pointer to color 0
VdpInitDataEnd:
VdpFontSwitch:				; ***** switch font text / graphics  *****
	sta $de06				; tri1 + creg (instruction moved from crtset)
VdpFont:				; ***** copy font to pattern generator table *****
	lda # >FontData				; load highbyte font data address
	ldx $cc					; check flag: $00 = text / $10 = graphic 
	beq +					; text -> ok
	clc
	adc # >FontSize				; graphic -> add highbyte fontsize for second fontset 
+	sta vdp_copy_pointer+1			; set highbyte font data
	sta vdp_fontaddress			; safe current font start address
	ldy #$00
	sty VDPControl				; write lowbyte pattern table to VDP, Y already $00
	lda # (>PatternTable) | $40		; highbyte pattern table or $40 to start VRAM write 
	sta VDPControl				; write highbyte pattern table to VDP
	sty vdp_reverse				; resert data reverse byte
	sty vdp_copy_pointer			; set lowbyte font data to $00 
	ldx # (>FontSize) * 2			; copy 2 x font (normal+reverse)
-	lda vdp_reverse				; reverse second half of font with eor
	eor(vdp_copy_pointer),y			; load font data
	sta VDPRamWrite				; write to VDP
	iny
	bne -
	inc vdp_copy_pointer+1			; increase higbyte font pointer
	dex
	beq +					; end of 2 x font data reached?
	cpx # >FontSize				; first "not reverse" font finished? 
	bne -
	lda vdp_fontaddress			; start reverse font at current font start address agin
	sta vdp_copy_pointer+1			; set highbyte font data start for second "reverse font"
	lda #$ff
	sta vdp_reverse				; set reverse xor byte
	bne -
+	rts
VdpCopyPalette				; ***** copy color-palette *****
-	lda VdpPaletteData,x			; X already 0, palette pointer already 0 from init-data
	sta VDPPalette
	inx
	cpx # VdpPaletteDataEnd - VdpPaletteData
	bne - 
	lda # COLREG1
	sta vdp_color				; write color mirror
	rts
VdpPrint:				; ***** print char to VRAM *****
	jsr VdpWriteChar			; sub write char to screen - char in A, column in $cb
	jmp pagres				; forward -> sub: bank restore
VdpCursorSet:				; ***** print cursor - inserted in input routine  $e133 *****
	sta $d801				; 6845 data-reg (instruction moved from input rotine)
	lda vdp_cursor_flag			; cursor char already reverse
	bne +					; skip if reverse 
	ldy $cb					; load cursor column
	lda #$00
	ora($c8),y				; load char under cursur from screen memory
	sta vdp_cursor_char			; safe char under cursor
	eor #$80				; reverse char
	jsr VdpWriteChar			; sub write char to screen - char in A, column in $cb
	inc vdp_cursor_flag			; set cursor reverse flag
+	rts
VdpCursorClear:				; ***** restore char under old cursor position 
	jsr VdpWriteChar			; sub write char to screen - char in A, column in $cb
	lda #$00
	sta vdp_cursor_flag			; clear cursor reverse flag
	rts
VdpWriteChar:				; ***** sub: write char to VRAM for VdpPrint, VdpCursor *****
	pha					; safe char on stack
	lda $cb					; load cursor column
	clc
	adc $c8					; add lowbyte screen line pointer
	sta VDPControl				; write VRAM address lowbyte
	lda #$00
	adc $c9					; load highbyte screen line pointer + carry
	and #$4f				; isolate low nibble + $dx to $4x for VRAM write
	sta VDPControl				; write VRAM address highbyte
	pla					; get char back from stack
;	pha					; 7cycles = 3.5us wait for VDP
;	pla					; ok without, if no problems (7cycles = 3.5us wait for VDP)
	nop
	sta VDPRamWrite				; write char to VRAM
	rts
VdpMoveLine:				; ***** move screen line (for scrolling) *****
	ldy $de					; left screen border
	lda $c8					; load lowbyte screen line pointer
	sta VDPControl				; write VRAM address lowbyte
	lda $c9					; load highbyte screen line pointer
	and #$4f				; isolate low nibble + $dx to $4x for VRAM write
	sta VDPControl				; write VRAM address highbyte
;	pha					; ok without, if no problems (7cycles = 3.5us wait for VDP)
;	pla
-	lda($c4),y				; load char from source line pointer
	sta VDPRamWrite				; write to new line in VRAM
	cpy $df					; right screen border reached?
	iny
	bcc -
	jmp pagres				; forward -> sub: bank restore
VdpTextColor:				; ***** ESC-G rotate text-color *****
	lda vdp_color				; load color mirror
	clc
	adc #$10				; increase high nibble = textxcolor
	sta vdp_color				; write to mirror
	!byte $2c				; skips two bytes! bit $xxxx
VdpBackgroundColor:			; ***** ESC-H rotate text-color *****
	inc vdp_color				; increase low nibble = background color
	lda vdp_color				; load color mirror
	sta VDPControl				; write new color value
	lda # (7 | $80)				; 
	sta VDPControl				; write register 7
	rts
VdpIdent:				; ***** ESC-X read status register / vdp ident and print chip-type *****
	lda # 1
	sta VDPControl				; write new color value
	lda # (15 | $80)			; 
	sta VDPControl				; write register 7
	ldx # '3'				; preload char '3' for V9938
	pha					; wait for DVP
	pla
	lda VDPStatus				; read status
	and #$3e				; isolate vdp-ident-number bit#1-5 - $00=v9938, $04=v9958 
	beq prntid				; chip is v9938 - prints a '3'
	cmp #$04				; chip is v9958 - prints a '5'
	bne ++		
	ldx # '5'
prntid:	stx $d04f
	rts
++	tax					; chip is unknown - prints a 'x'
	bne prntid
; ***** Color Palette - 16 colors, 2 byte/color: RB, 0G each 3bit -> C64 VICII-colors *****
VdpPaletteData:
	!byte $00,$00,$77,$07,$70,$01,$17,$06	;	0=black		1=white		2=red		3=cyan
	!byte $56,$02,$32,$06,$06,$02,$72,$07	;	4=violet	5=green		6=blue		7=yellow
	!byte $70,$03,$60,$02,$72,$03,$11,$01	;	8=orange	9=brown		a=lightred	b=darkgrey
	!byte $33,$03,$54,$07,$27,$04,$55,$05	;	c=grey		d=litegreen	e=lightblue	f=lightgrey
VdpPaletteDataEnd:
; 278-24(init.p)-62(font)-17(palette)-8(t.color)-13(b.color)-6(print)-23(c.set)-8(c.clear)
; -24(writechar)-27(moveline)-32(pal.data)-ident(34) 0 bytes free
*= $ee00
	jsr ioinit
	jsr restor
	jsr jcint
monoff:	jsr lffcc		; ***** monitor cold-boot (no basic) *****
	lda #$5a
	ldx #$00
	ldy #$ee
	jsr lfbca
	cli
timc:	lda #$c0		; ***** monitor start sys 60950 *****
	sta $0361
	lda #$40
	sta $bd
	bne lee31
timb:	jsr lffcc		; ***** monitor - break-vector *****
	lda #$53
	sta $bd
	cld
	ldx #$05
lee2b:	pla
	sta $ae,x
	dex
	bpl lee2b
lee31:	lda $01
	sta $b5
	lda $0300
	sta $b8
	lda $0301
	sta $b7
	tsx
	stx $b4
	cli
	lda #$08
	sta $bf
	ldy $bd
	jsr lf21c
	lda #$52
	bne lee77
lee50:	jsr lef22
	pla
	pla
	lda #$c0
	sta $0361
	lda #$00
	sta $90
	lda #$02
	sta $91
	lda #$0f
	sta $92
	jsr lef27
lee69:	jsr lffcf
	cmp #$2e
	beq lee69
	cmp #$20
	beq lee69
	jmp ($031e)
lee77:	ldx #$00
	stx $9d
	tay
	lda #$ee
	pha
	lda #$54
	pha
	tya
lee83:	cmp leed5,x
	bne lee98
	sta $0366
	lda leed6,x
	sta $b9
	lda leed7,x
	sta $ba
	jmp ($00b9)
lee98:	inx
	inx
	inx
	cpx #$24
	bcc lee83
	ldx #$00
leea1:	cmp #$0d
	beq leeb2
	cmp #$20
	beq leeb2
	sta $0200,x
	jsr lffcf
	inx
	bne leea1
leeb2:	sta $bd
	txa
	beq leed4
	sta $9d
	lda #$40
	sta $0361
	lda $bf
	sta $9f
	lda #$0f
	sta $01
	ldx #$ff
	ldy #$ff
	jsr lffd5
	bcs leed4
	lda $bd
	jmp ($0099)
leed4:	rts
leed5:	!byte $3a
leed6:	!byte $f5
leed7:	!byte $ef
	!byte $3b
	!byte $cb
	!byte $ef
	!byte $52
	jmp $4def
	!byte $8f
	!byte $ef
	!byte $47
	bpl leed4
	jmp lf04a
	!byte $53
	!byte $4a,$f0
	!byte $56
	sbc ($ef,x)
	rti
	adc $f1
	!byte $5a
	!byte $72
	!byte $ff
	cli
	sbc $55ee,y
	!byte $eb
	!byte $ef
	pla
	pla
	sei
	jmp ($03f8)
leeff:	lda $b9
	sta $af
	lda $ba
	sta $ae
	rts
lef08:	lda #$b0
	sta $b9
	lda #$00
	sta $ba
	lda #$0f
	sta $01
	lda #$05
	rts
lef17:	pha
	jsr lef27
	pla
	jsr lffd2
lef1f:	lda #$20
	!byte $2c
lef22:	lda #$3f
	jmp lffd2
lef27:	lda #$0d
	jsr lffd2
	lda #$2e
	jmp lffd2
lef31:	ora $2020
	jsr $4350
	jsr $4920
	!byte $52
	eor ($20),y
	jsr $5253
	jsr $4341
	jsr $5258
	jsr $5259
	jsr $5053
	ldx #$00
lef4e:	lda lef31,x
	jsr lffd2
	inx
	cpx #$1b
	bne lef4e
	lda #$3b
	jsr lef17
	ldx $ae
	ldy $af
	jsr lf0f6
	jsr lef1f
	ldx $b7
	ldy $b8
	jsr lf0f6
	jsr lef08
lef72:	sta $bd
	ldy #$00
	sty $9d
lef78:	jsr lef1f
	lda ($b9),y
	jsr lf0fb
	inc $b9
	bne lef8a
	inc $ba
	bne lef8a
	dec $9d
lef8a:	dec $bd
	bne lef78
	rts
	jsr lf040
	jsr lf113
	jsr lf123
	bcc lefa2
	lda $bb
	sta $b9
	lda $bc
	sta $ba
lefa2:	jsr lf113
lefa5:	jsr lffe1
	beq lefca
	lda #$3a
	jsr lef17
	ldx $ba
	ldy $b9
	jsr lf0f6
	lda #$10
	jsr lef72
	lda $9d
	bne lefca
	sec
	lda $bb
	sbc $b9
	lda $bc
	sbc $ba
	bcs lefa5
lefca:	rts
	jsr lf040
	jsr leeff
	jsr lf040
	lda $b9
	sta $b8
	lda $ba
	sta $b7
	jsr lef08
	bne leffa
	jsr lf03a
	cmp #$10
	bcs lf047
	sta $01
	rts
	jsr lf03a
	cmp #$20
	bcs lf047
	sta $bf
	rts
	jsr lf040
	lda #$10
leffa:	sta $bd
leffc:	jsr lf130
	bcs lf00f
	ldy #$00
	sta ($b9),y
	inc $b9
	bne lf00b
	inc $ba
lf00b:	dec $bd
	bne leffc
lf00f:	rts
	jsr lf15f
	beq lf01b
	jsr lf040
	jsr leeff
lf01b:	ldx $b4
	txs
	sei
	lda $b7
	sta $0301
	lda $b8
	sta $0300
	lda $b5
	sta $01
	ldx #$00
lf02f:	lda $ae,x
	pha
	inx
	cpx #$06
	bne lf02f
	jmp lfca5
lf03a:	jsr lf130
	bcs lf045
lf03f:	rts
lf040:	jsr lf123
	bcc lf03f
lf045:	pla
	pla
lf047:	jmp lee50
lf04a:	ldy #$01
	sty $9f
	dey
	lda #$ff
	sta $b9
	sta $ba
	lda $01
	sta $be
	lda #$0f
	sta $01
lf05d:	jsr lf15f
	beq lf07e
	cmp #$20
	beq lf05d
	cmp #$22
lf068:	bne lf047
lf06a:	jsr lf15f
	beq lf07e
	cmp #$22
	beq lf090
	sta ($90),y
	inc $9d
	iny
	cpy #$10
	beq lf047
	bne lf06a
lf07e:	lda $0366
	cmp #$4c
	bne lf068
	lda $be
	and #$0f
	ldx $b9
	ldy $ba
	jmp lffd5
lf090:	jsr lf15f
	beq lf07e
	cmp #$2c
lf097:	bne lf068
	jsr lf03a
	sta $9f
	jsr lf15f
	beq lf07e
	cmp #$2c
lf0a5:	bne lf097
	jsr lf03a
	cmp #$10
	bcs lf0f3
	sta $be
	sta $9b
	jsr lf040
	lda $b9
	sta $99
	lda $ba
	sta $9a
	jsr lf15f
	beq lf07e
	cmp #$2c
	bne lf0f3
	jsr lf03a
	cmp #$10
	bcs lf0f3
	sta $98
	jsr lf040
	lda $b9
	sta $96
	lda $ba
	sta $97
lf0da:	jsr lffcf
	cmp #$20
	beq lf0da
	cmp #$0d
lf0e3:	bne lf0a5
	lda $0366
	cmp #$53
	bne lf0e3
	ldx #$99
	ldy #$96
	jmp lffd8
lf0f3:	jmp lee50
lf0f6:	txa
	jsr lf0fb
	tya
lf0fb:	pha
	lsr
	lsr
	lsr
	lsr
	jsr lf107
	tax
	pla
	and #$0f
lf107:	clc
	adc #$f6
	bcc lf10e
	adc #$06
lf10e:	adc #$3a
	jmp lffd2
lf113:	ldx #$02
lf115:	lda $b8,x
	pha
	lda $ba,x
	sta $b8,x
	pla
	sta $ba,x
	dex
	bne lf115
	rts
lf123:	jsr lf130
	bcs lf12f
	sta $ba
	jsr lf130
	sta $b9
lf12f:	rts
lf130:	lda #$00
	sta $0100
	jsr lf15f
	beq lf153
	cmp #$20
	beq lf130
	jsr lf154
	asl
	asl
	asl
	asl
	sta $0100
	jsr lf15f
	beq lf153
	jsr lf154
	ora $0100
lf153:	rts
lf154:	cmp #$3a
	php
	and #$0f
	plp
	bcc lf15e
	adc #$08
lf15e:	rts
lf15f:	jsr lffcf
	cmp #$0d
	rts
	lda #$00
	sta $9c
	sta $9d
	ldx $bf
	ldy #$0f
	jsr lfb43
	clc
	jsr lffc0
	bcs lf1ba
	jsr lf15f
	beq lf19a
	pha
	ldx #$00
	jsr lffc9
	pla
	bcs lf1ba
	bcc lf18b
lf188:	jsr lffcf
lf18b:	cmp #$0d
	php
	jsr lffd2
	lda $9c
	bne lf1b6
	plp
	bne lf188
	beq lf1ba
lf19a:	jsr lef27
	ldx #$00
	jsr lffc6
	bcs lf1ba
lf1a4:	jsr lf15f
	php
	jsr lffd2
	lda $9c
	and #$bf
	bne lf1b6
	plp
	bne lf1a4
	beq lf1ba
lf1b6:	pla
	jsr lf945
lf1ba:	jsr lffcc
	lda #$00
	clc
	jmp lffc3

ms1:	!byte $0d			; ***** system-messages table *****
	!pet "i/o error ",$a3,$0d
	!pet "searching",$a0
	!pet "for",$a0,$0d
	!pet "loadin",$c7,$0d
	!pet "saving",$a0,$0d
	!pet "verifyin",$c7,$0d
	!pet "found",$a0,$0d
	!pet "ok",$8d,$0d
	!pet "** monitor 1.0 **",$8d,$0d
	!pet "brea",$cb

lf21c:	bit $0361
	bpl lf22e
lf221:	lda ms1,y
	php
	and #$7f
	jsr lffd2
	iny
	plp
	bpl lf221
lf22e:	clc
	rts
	ora #$40
	bne lf236
	ora #$20
lf236:	pha
	lda #$3f
	sta $de03
	lda #$ff
	sta $dc00
	sta $dc02
	lda #$fa
	sta $de00
	lda $aa
	bpl lf268
	lda $de00
	and #$df
	sta $de00
	lda $ab
	jsr lf2b9
	lda $aa
	and #$7f
	sta $aa
	lda $de00
	ora #$20
	sta $de00
lf268:	lda $de00
	and #$f7
	sta $de00
	pla
	jmp lf2b9
	jsr lf2b9
lf277:	lda $de00
	ora #$08
	sta $de00
	rts
	jsr lf2b9
lf283:	lda #$39
	and $de00
lf288:	sta $de00
	lda #$c7
	sta $de03
	lda #$00
	sta $dc02
	beq lf277
	pha
	lda $aa
	bpl lf2a3
	lda $ab
	jsr lf2b9
	lda $aa
lf2a3:	ora #$80
	sta $aa
	pla
	sta $ab
	rts
	lda #$5f
	bne lf2b1
	lda #$3f
lf2b1:	jsr lf236
	lda #$f8		; changed from 03b:$f9 unlisten IEC bus parameter
	jmp lf288
lf2b9:	eor #$ff
	sta $dc00
	lda $de00
	ora #$12
	sta $de00
	bit $de00
	bvc lf2d4
	bpl lf2d4
	lda #$80
	jsr lfb5f
	bne lf304
lf2d4:	lda $de00
	bpl lf2d4
	and #$ef
	sta $de00
lf2de:	jsr lf36f
	bcc lf2e4
lf2e3:	sec
lf2e4:	bit $de00
	bvs lf2fc
	lda $dc0d
	and #$02
	beq lf2e4
	lda $035e
	bmi lf2de
	bcc lf2e3
	lda #$01
	jsr lfb5f
lf2fc:	lda $de00
	ora #$10
	sta $de00
lf304:	lda #$ff
	sta $dc00
	rts
	lda $de00
	and #$b9
	ora #$80		; changed from 03b:$81 unlisten IEC bus or value
	sta $de00
lf314:	jsr lf36f
	bcc lf31a
lf319:	sec
lf31a:	lda $de00
	and #$10
	beq lf33f
	lda $dc0d
	and #$02
	beq lf31a
	lda $035e
	bmi lf314
	bcc lf319
	lda #$02
	jsr lfb5f
	lda $de00
	and #$3d
	sta $de00
	lda #$0d
	rts
lf33f:	lda $de00
	and #$7f
	sta $de00
	and #$20
	bne lf350
	lda #$40
	jsr lfb5f
lf350:	lda $dc00
	eor #$ff
	pha
	lda $de00
	ora #$40
	sta $de00
lf35e:	lda $de00
	and #$10
	beq lf35e
	lda $de00
	and #$bf
	sta $de00
	pla
	rts
lf36f:	lda #$ff
	sta $dc07
	lda #$11
	sta $dc0f
	lda $dc0d
	clc
	rts
	jmp lf951
lf381:	jsr lf42e
	ldy #$00
lf386:	cpy $9d
	beq lf395
	jsr lfe92
	sta $0376,y
	iny
	cpy #$04
	bne lf386
lf395:	lda $0376
	sta $dd03
	lda $0377
	and #$f2
	ora #$02
	sta $dd02
	clc
	lda $a0
	and #$02
	beq lf3c1
	lda $037d
	sta $037c
	lda $a8
	and #$f0
	beq lf3c1
	jsr lf3fc
	sta $a8
	stx $a6
	sty $a7
lf3c1:	jmp patch3		; jmp to 04a patch - output IO error
	nop
	nop
	rts
lf3c7:	cmp #$41
	bcc lf3db
	cmp #$5b
	bcs lf3d1
	ora #$20
lf3d1:	cmp #$c1
	bcc lf3db
	cmp #$db
	bcs lf3db
	and #$7f
lf3db:	rts
lf3dc:	cmp #$41
	bcc lf3f0
	cmp #$5b
	bcs lf3e6
	ora #$80
lf3e6:	cmp #$61
	bcc lf3f0
	cmp #$7b
	bcs lf3f0
	and #$df
lf3f0:	rts
lf3f1:	lda $dd02
	ora #$09
	and #$fb
	sta $dd02
	rts
lf3fc:	ldx #$00
	ldy #$01
lf400:	txa
	sec
	eor #$ff
	adc $0355
	tax
	tya
	eor #$ff
	adc $0356
	tay
	lda $0357
	bcs lf41a
	lda #$ff
lf416:	ora #$40
	sec
	rts
lf41a:	cpy $035c
	bcc lf416
	bne lf426
	cpx $035b
	bcc lf416
lf426:	stx $0355
	sty $0356
	clc
	rts
lf42e:	php
	sei
	lda $dd01
	and #$60
	sta $037a
	sta $037b
	plp
	rts
lf43d:	lda $a1
	bne lf44d
	lda $d1
	ora $d6
	beq lf49a
	sei
	jsr jlp2
	clc
	rts
lf44d:	cmp #$02
	beq lf454
	jmp lffcf
lf454:	sty $0365
	stx $0366
	ldy $037c
	cpy $037d
	bne lf478
	lda $dd02
	and #$fd
	ora #$01
	sta $dd02
	lda $037a
	ora #$10
	sta $037a
	lda #$00
	beq lf494
lf478:	lda $037a
	and #$ef
	sta $037a
	ldx $01
	lda $a8
	sta $01
	lda ($a6),y
	stx $01
	inc $037c
	bit $a0
	bpl lf494
	jsr lf3dc
lf494:	ldy $0365
	ldx $0366
lf49a:	clc
	rts
	lda $a1
	bne lf4ab
	lda $cb
	sta $ce
	lda $ca
	sta $cf
	jmp lf4b5
lf4ab:	cmp #$03
	bne lf4ba
	jsr patch2		; jmp to 04a patch - RS232 input
	nop
	sta $d5
lf4b5:	jsr jloop5
	clc
	rts
lf4ba:	bcs lf4c3
	cmp #$02
	beq lf4d0
	jsr lfe5a
lf4c3:	lda $9c
	beq lf4cb
lf4c7:	lda #$0d
lf4c9:	clc
lf4ca:	rts
lf4cb:	jsr lffa5
	clc
	rts
lf4d0:	jsr lffe4
	bcs lf4ca
	cmp #$00
	bne lf4c9
	lda $037a
	and #$10
	beq lf4c9
	lda $037a
	and #$60
	bne lf4c7
	jsr lffe1
	bne lf4d0
	sec
	rts
	pha
	lda $a2
	cmp #$03
	bne lf4fb
	pla
	jsr jprt
	clc
	rts
lf4fb:	bcc lf503
	pla
	jsr lffa8
	clc
	rts
lf503:	cmp #$02
	beq lf511
	pla
	jsr lfe5a
lf50b:	pla
	bcc lf510
	lda #$00
lf510:	rts
lf511:	stx $0363
	sty $0364
	lda $037a
	and #$60
	bne lf540
	pla
	bit $a0
	bpl lf526
	jsr lf3c7
lf526:	sta $dd00
	pha
lf52a:	lda $037a
	and #$60
	bne lf540
	lda $dd01
	and #$10
	bne lf540
	jsr lffe1
	bne lf52a
	sec
	bcs lf50b
lf540:	pla
	ldx $0363
	ldy $0364
	clc
	rts
	jsr lf63e
	beq lf551
	jmp lf93f
lf551:	jsr lf650
	lda $9f
	beq lf586
	cmp #$03
	beq lf586
	bcs lf58a
	cmp #$02
	bne lf580
	lda $a0
	and #$02
	beq lf583
	and $dd02
	beq lf57c
	eor #$ff
	and $dd02
	ora #$01
	pha
	jsr lf42e
	pla
	sta $dd02
lf57c:	lda #$02
	bne lf586
lf580:	jsr lfe5a
lf583:	jmp lf948
lf586:	sta $a1
	clc
	rts
lf58a:	tax
	jsr lffb4
	lda $a0
	bpl lf598
	jsr lf283
	jmp lf59b
lf598:	jsr lff96
lf59b:	txa
	bit $9c
	bpl lf586
	jmp lf945
	jsr lf63e
	beq lf5ab
	jmp lf93f
lf5ab:	jsr lf650
	lda $9f
	bne lf5b5
lf5b2:	jmp lf94b
lf5b5:	cmp #$03
	beq lf5d1
	bcs lf5d5
	cmp #$02
	bne lf5ce
	lda $a0
	lsr
	bcc lf5b2
	jsr lf42e
	jsr lf3f1
	lda #$02
	bne lf5d1
lf5ce:	jsr lfe5a
lf5d1:	sta $a2
	clc
	rts
lf5d5:	tax
	jsr lffb1
	lda $a0
	bpl lf5e2
	jsr lf277
	bne lf5e5
lf5e2:	jsr lff93
lf5e5:	txa
	bit $9c
	bpl lf5d1
	jmp lf945
	php
	jsr lf643
	beq lf5f6
	plp
	clc
	rts
lf5f6:	jsr lf650
	plp
	txa
	pha
	bcc lf61d
	lda $9f
	beq lf61d
	cmp #$03
	beq lf61d
	bcs lf61a
	cmp #$02
	bne lf613
	lda #$00
	sta $dd02
	beq lf61d
lf613:	pla
	jsr lf61e
	jsr lfe5a
lf61a:	jsr lf8bf
lf61d:	pla
lf61e:	tax
	dec $0360
	cpx $0360
	beq lf63c
	ldy $0360
	lda $0334,y
	sta $0334,x
	lda $033e,y
	sta $033e,x
	lda $0348,y
	sta $0348,x
lf63c:	clc
	rts
lf63e:	lda #$00
	sta $9c
	txa
lf643:	ldx $0360
lf646:	dex
	bmi lf676
	cmp $0334,x
	bne lf646
	clc
	rts
lf650:	lda $0334,x
	sta $9e
	lda $033e,x
	sta $9f
	lda $0348,x
	sta $a0
	rts
lf660:	tya
	ldx $0360
lf664:	dex
	bmi lf676
	cmp $0348,x
	bne lf664
	clc
lf66d:	jsr lf650
	tay
	lda $9e
	ldx $9f
	rts
lf676:	sec
	rts
lf678:	tax
	jsr lf63e
	bcc lf66d
	rts
	ror $0365
	sta $0366
lf685:	ldx $0360
lf688:	dex
	bmi lf6a6
	bit $0365
	bpl lf698
	lda $0366
	cmp $033e,x
	bne lf688
lf698:	lda $0334,x
	sec
	jsr lffc3
	bcc lf685
	lda #$00
	sta $0360
lf6a6:	ldx #$03
	cpx $a2
	bcs lf6af
	jsr lffae
lf6af:	cpx $a1
	bcs lf6b6
	jsr lffab
lf6b6:	ldx #$03
	stx $a2
	lda #$00
	sta $a1
	rts
	bcc lf6c4
	jmp lf73a
lf6c4:	ldx $9e
	jsr lf63e
	bne lf6ce
	jmp lf93c
lf6ce:	ldx $0360
	cpx #$0a
	bcc lf6d8
	jmp lf939
lf6d8:	inc $0360
	lda $9e
	sta $0334,x
	lda $a0
	ora #$60
	sta $a0
	sta $0348,x
	lda $9f
	sta $033e,x
	beq lf705
	cmp #$03
	beq lf705
	bcc lf6fb
	jsr lf707
	bcc lf705
lf6fb:	cmp #$02
	bne lf702
	jmp lf381
lf702:	jsr lfe5a
lf705:	clc
	rts
lf707:	lda $a0
	bmi lf738
	ldy $9d
	beq lf738
	lda $9f
	jsr lffb1
	lda $a0
	ora #$f0
lf718:	jsr lff93
	lda $9c
	bpl lf724
	pla
	pla
	jmp lf945
lf724:	lda $9d
	beq lf735
	ldy #$00
lf72a:	jsr lfe92
	jsr lffa8
	iny
	cpy $9d
	bne lf72a
lf735:	jsr lffae
lf738:	clc
	rts
lf73a:	lda $9f
	jsr lffb1
	lda #$6f
	sta $a0
	jmp lf718
	stx $036f
	sty $0370
	sta $035f
	sta $0371
	lda #$00
	sta $9c
	lda $9f
	bne lf75d
lf75a:	jmp lf951
lf75d:	cmp #$03
	beq lf75a
	bcs lf766
	jmp lf810
lf766:	lda #$60
	sta $a0
	ldy $9d
	bne lf771
	jmp lf94e
lf771:	jsr lf81b
	jsr lf707
	lda $9f
	jsr lffb4
	lda $a0
	jsr lff96
	jsr lffa5
	sta $96
	sta $99
	lda $9c
	lsr
	lsr
	bcc lf791
	jmp lf942
lf791:	jsr lffa5
	sta $97
	sta $9a
	jsr lf840
	lda $0371
	sta $98
	sta $9b
	lda $036f
	and $0370
	cmp #$ff
	beq lf7ba
	lda $036f
	sta $96
	sta $99
	lda $0370
	sta $97
	sta $9a
lf7ba:	lda #$fd
	and $9c
	sta $9c
	jsr lffe1
	bne lf7c8
	jmp lf8b3
lf7c8:	jsr lffa5
	tax
	lda $9c
	lsr
	lsr
	bcs lf7ba
	txa
	ldx $01
	ldy $98
	sty $01
	ldy #$00
	bit $035f
	bpl lf7f0-2
	sta $93
	lda ($96),y
	cmp $93
	beq lf7f0
	lda #$10
	jsr lfb5f
	lda $9691
lf7f0:	stx $01
	inc $96
	bne lf800
	inc $97
	bne lf800
	inc $98
	lda #$02
	sta $96
lf800:	bit $9c
	bvc lf7ba
	jsr lffab
	jsr lf8bf
	jmp lf813
	jmp lf942
lf810:	jsr lfe5a
lf813:	clc
	lda $98
	ldx $96
	ldy $97
	rts
lf81b:	bit $0361
	bpl lf83f
	ldy #$0c
	jsr lf21c
	lda $9d
	beq lf83f
	ldy #$17
	jsr lf21c
lf82e:	ldy $9d
	beq lf83f
	ldy #$00
lf834:	jsr lfe92
	jsr lffd2
	iny
	cpy $9d
	bne lf834
lf83f:	rts
lf840:	ldy #$1b
	lda $035f
	bpl lf849
	ldy #$2b
lf849:	jmp lf21c
	lda $00,x
	sta $99
	lda $01,x
	sta $9a
	lda $02,x
	sta $9b
	tya
	tax
	lda $00,x
	sta $96
	lda $01,x
	sta $97
	lda $02,x
	sta $98
	lda $9f
	bne lf86d
lf86a:	jmp lf951
lf86d:	cmp #$03
	beq lf86a
	bcc lf8d6
	lda #$61
	sta $a0
	ldy $9d
	bne lf87e
	jmp lf94e
lf87e:	jsr lf707
	jsr lf8d9
	lda $9f
	jsr lffb1
	lda $a0
	jsr lff93
	ldx $01
	jsr lfe62
	lda $93
	jsr lffa8
	lda $94
	jsr lffa8
	ldy #$00
lf89f:	jsr lfe71
	bcs lf8ba
	lda ($93),y
	jsr lffa8
	jsr lfe7f
	jsr lffe1
	bne lf89f
	stx $01
lf8b3:	jsr lf8bf
	lda #$00
	sec
	rts
lf8ba:	stx $01
	jsr lffae
lf8bf:	bit $a0
	bmi lf8d4
	lda $9f
	jsr lffb1
	lda $a0
	and #$ef
	ora #$e0
	jsr lff93
	jsr lffae
lf8d4:	clc
lf8d5:	rts
lf8d6:	jsr lfe5a
lf8d9:	lda $0361
	bpl lf8d5
	ldy #$23
	jsr lf21c
	jmp lf82e
lf8e6:	lda $dc08
	pha
	pha
	asl
	asl
	asl
	and #$60
	ora $dc0b
	tay
	pla
	ror
	ror
	and #$80
	ora $dc09
	sta $93
	ror
	and #$80
	ora $dc0a
	tax
	pla
	cmp $dc08
	bne lf8e6
	lda $93
	rts
lf90e:	pha
	pha
	ror
	and #$80
	ora $dc0f
	sta $dc0f
	tya
	rol
	rol
	rol $93
	rol
	rol $93
	txa
	rol
	rol $93
	pla
	rol
	rol $93
	sty $dc0b
	stx $dc0a
	pla
	sta $dc09
	lda $93
	sta $dc08
	rts
lf939:	lda #$01
	!byte $2c
lf93c:	lda #$02
	!byte $2c
lf93f:	lda #$03
	!byte $2c
lf942:	lda #$04
	!byte $2c
lf945:	lda #$05
	!byte $2c
lf948:	lda #$06
	!byte $2c
lf94b:	lda #$07
	!byte $2c
lf94e:	lda #$08
	!byte $2c
lf951:	lda #$09
lf953:	pha
	jsr lffcc
	ldy #$00
	bit $0361
	bvc lf968
	jsr lf221
	pla
	pha
	ora #$30
	jsr lffd2
lf968:	pla
	sec
	rts
	lda $a9
	and #$01
	bne lf978
	php
	jsr lffcc
	sta $d1
	plp
lf978:	rts
lf979:	lda $df02
	lsr
	bcs lf991
	lda #$fe
	sta $df01
	lda #$10
	and $df02
	bne lf98c
	sec
lf98c:	lda #$ff
	sta $df01
lf991:	rol
	sta $a9
	rts
patall:	!byte $c2,$cd			; test-bytes cbm-rom
start:	ldx #$fe		; ***** system reset *****
	sei				; disable interrrupts
	txs				; init stack
	cld				; clear decimal flag
	lda #$a5
	cmp $03fa			; compare warm start flag
	bne scold			; jump to cold start
	lda $03fb			; load warm start flag
	cmp #$5a
	beq swarm			; jump to warm start
scold:	lda #$06		; ***** system cold start *****
	sta $96				; init 96/97 to $0006 = position rom ident bytes
	lda #$00
	sta $97
	sta $03f8			; set warm start lowbyte to $00
	ldx #$30			; init 4. rom ident byte compare value to $30 = '0'
sloop0:	ldy #$03			; init start compare counter to 4th rom ident byte
	lda $97
	bmi sloop2			; no rom found -> monitor cold boot
	clc
	adc #$10			; next rom position to check highbyte +$10
	sta $97
	inx				; next 4. byte compare value $31, $32, $33...
	txa
	cmp ($96),y			; compare if 4. byte $31 at address $1006+3...
	bne sloop0			; 4. byte does not mach - > next rom pos. $2000, $3000...
	dey				; check next byte backwards if 4th byte matches
sloop1:	lda ($96),y			; load 3., 2., 1. byte
	dey
	bmi sloop3			; 2. + 3. byte matches - autostart rom found!
	cmp patall,y			; compare test bytes 'M', 'B'
	beq sloop1			; 3. byte OK -> check 2. byte
	bne sloop0			; 2. or 3. ident byte does not mach -> next rom position
sloop2:	ldy #$e0			; set warm start to $e000 = monitor cold boot
	!byte $2c
sloop3:	ldy $97
	sty $03f9			; store rom address highbyte to warm start vector
	tax				; move 1. ident byte to x to set N-flag
	bpl swarm			; jump to warm start if value is positive ('c'=$43)
	jsr ioinit			; sub: i/o register init $f9fb
	lda #$f0
	sta $c1				; start F-keys
	jsr jcint			; sub: initialize $e044
	jsr ramtas			; sub: ram-test $fa88
	jsr restor			; sub: init standard-vectors $fba2
	jsr jcint			; sub: initialize $e044
	lda #$a5
	sta $03fa			; save warm start flag
swarm:	jmp ($03f8)			; jump to basic warm start $bbcc
ioinit:	lda #$f3		; ***** i/o register init *****
	sta $de06
	ldy #$ff
	sty $de05
	lda #$5c
	sta $de01
	lda #$7d
	sta $de04
	lda #$38		; changed from 03b:$3d 6525 1 init ddr B
	sta $de00
	lda #$3f
	sta $de03
	sty $df00
	sty $de01
	sty $df03
	sty $df04
	lsr $df00
	iny
	sty $df02
	sty $df05
	lda #$7f
	sta $dc0d
	sty $dc02
	sty $dc03
	sty $dc0f
	sta $dc08
	sty $de02
lfa43:	lda $de02
	ror
	bcc lfa43
	sty $de02
	ldx #$00
lfa4e:	inx
	bne lfa4e
	iny
	lda $de02
	ror
	bcc lfa4e
	cpy #$1b
	bcc lfa5f
	lda #$88
	!byte $2c
lfa5f:	lda #$08
	sta $dc0e
	lda $db0d
	lda #$90
	sta $db0d
	lda #$40
	sta $db01
	stx $db02
	stx $db0f
	stx $db0e
	lda #$48
	sta $db03
	lda #$01
	ora $de01
	sta $de01
	rts
ramtas:	lda #$00		; ***** ram-test / vector init *****
	tax
lfa8b:	sta $0002,x
	sta $0200,x
	sta $02f8,x
	inx
	bne lfa8b
	lda #$01
	sta $01
	sta $035a
	sta $0354
	lda #$02
	sta $0358
	sta $0352
	dec $01
lfaab:	inc $01
	lda $01
	cmp #$0f
	beq lfad7
	ldy #$02
lfab5:	lda ($93),y
	tax
	lda #$55
	sta ($93),y
	lda ($93),y
	cmp #$55
	bne lfad7
	asl
	sta ($93),y
	lda ($93),y
	cmp #$aa
	bne lfad7
	txa
	sta ($93),y
	iny
	bne lfab5
	inc $94
	bne lfab5
	beq lfaab
lfad7:	ldx $01
	dex
	txa
	ldx #$ff
	ldy #$fd
	sta $0357
	sty $0356
	stx $0355
	ldy #$fa
	clc
	jsr lfb78
	dec $a8
	dec $a5
	lda #$5d
	sta $036a
	lda #$fe
	sta $036b
	rts

jmptab:	!byte $e9, $fb		; ***** standard vector table *****
	!byte $21, $ee
	!byte $aa, $fc
	!byte $bf, $f6
	!byte $ed, $f5
	!byte $49, $f5
	!byte $a3, $f5
	!byte $a6, $f6
	!byte $9c, $f4
	!byte $ee, $f4
	!byte $6b, $f9
	!byte $3d, $f4
	!byte $7f, $f6
	!byte $46, $f7
	!byte $4c, $f8
	!byte $77, $ee
	!byte $1f, $e0
	!byte $1f, $e0
	!byte $74, $f2
	!byte $80, $f2
	!byte $0a, $f3
	!byte $97, $f2
	!byte $ab, $f2
	!byte $af, $f2
	!byte $34, $f2
	!byte $30, $f2
tabend:	jmp ($0304)
lfb34:	sta $9d
	lda $00,x
	sta $90
	lda $01,x
	sta $91
	lda $02,x
	sta $92
	rts
lfb43:	sta $9e
	stx $9f
	sty $a0
	rts
lfb4a:	bcc lfb64
	lda $9f
	cmp #$02
	bne lfb5d
	lda $037a
	pha
	lda #$00
	beq lfb6b
lfb5a:	sta $0361
lfb5d:	lda $9c
lfb5f:	ora $9c
	sta $9c
	rts
lfb64:	pha
	lda $9f
	cmp #$02
	bne lfb70
lfb6b:	pla
	sta $037a
	rts
lfb70:	pla
	sta $9c
	rts
lfb74:	sta $035e
	rts
lfb78:	bcc lfb83
	lda $035d
	ldx $035b
	ldy $035c
lfb83:	stx $035b
	sty $035c
	sta $035d
	rts
lfb8d:	bcc lfb98
	lda $035a
	ldx $0358
	ldy $0359
lfb98:	stx $0358
	sty $0359
	sta $035a
	rts
restor:	ldx #$fd
	ldy #$fa
	lda #$0f
	clc
lfba9:	stx $93
	sty $94
	ldx $01
	sta $01
	bcc lfbbd
	ldy #$33
lfbb5:	lda $0300,y
	sta ($93),y
	dey
	bpl lfbb5
lfbbd:	ldy #$33
lfbbf:	lda ($93),y
	sta $0300,y
	dey
	bpl lfbbf
	stx $01
	rts
lfbca:	stx $03f8
	sty $03f9
	lda #$5a
	sta $03fb
	rts
nirq:	pha			; ***** irq-routine *****
	txa
	pha
	tya
	pha
	tsx
	lda $0104,x
	and #$10
	bne brkirq
	jmp ($0300)			; jump to irq vector (yirq = $fbe9)
brkirq:	jmp ($0302)			; jump to break vector (timb = $ee21)
yirq:	lda $01			; ***** irq-routine (irq-vector) *****
	pha
	cld
	lda $de07
	bne lfbf5
	jmp lfca2
lfbf5:	cmp #$10
	beq lfbfc
	jmp lfc5b
lfbfc:	lda $dd01
	tax
	and #$60
	tay
	eor $037b
	beq lfc15
	tya
	sta $037b
	ora $037a
	sta $037a
	jmp irq900
lfc15:	txa
	and #$08
	beq lfc40
	ldy $037d
	iny
	cpy $037c
	bne lfc27
	lda #$08
	bne lfc3a
lfc27:	sty $037d
	dey
	ldx $a8
	stx $01
	ldx $dd01
	lda $dd00
	sta ($a6),y
	txa
	and #$07
lfc3a:	ora $037a
	sta $037a
lfc40:	lda $dd01
	and #$10
	beq lfc58
	lda $dd02
	and #$0c
	cmp #$04
	bne lfc58
	lda #$f3
	and $dd02
	sta $dd02
lfc58:	jmp irq900
lfc5b:	cmp #$08
	bne lfc69
	lda $db0d
	cli
	jsr lfd48
	jmp irq900
lfc69:	cli
	cmp #$04
	bne lfc7a
	lda $dc0d
	ora $0369
	sta $0369
	jmp irq900
lfc7a:	cmp #$02
	bne lfc81
	jmp irq900
lfc81:	jsr jkey
	jsr lf979
	lda $de01
	bpl lfc95
	ldy #$00
	sty $0375
	ora #$40
	bne lfc9c
lfc95:	ldy $0375
	bne irq900
	and #$bf
lfc9c:	sta $de01
irq900:	sta $de07
lfca2:	pla
	sta $01
lfca5:	pla
	tay
	pla
	tax
	pla
	rti
lfcab:	lda $0800
	and #$7f
	tay
	jsr lfe21
	lda #$04
	and $db01
	bne lfcab
	lda #$08
	ora $db01
	sta $db01
	nop
	lda $db01
	tax
	and #$04
	beq lfcd8
	txa
	eor #$08
	sta $db01
	txa
	nop
	nop
	nop
	bne lfcab
lfcd8:	lda #$ff
	sta $db02
	lda $0800
	sta $db00
	jsr lfe08
	lda $db01
	and #$bf
	sta $db01
	ora #$40
	cli
	nop
	nop
	nop
	sta $db01
	jsr lfdee
	lda #$00
	sta $db02
	jsr lfdf6
	jsr lfde6
	ldy #$00
	beq lfd26
lfd09:	lda #$ff
	sta $db02
	lda $0805,y
	sta $db00
	jsr lfdff
	jsr lfdee
	lda #$00
	sta $db02
	jsr lfdf6
	jsr lfde6
	iny
lfd26:	cpy $0803
	bne lfd09
	ldy #$00
	beq lfd42
lfd2f:	jsr lfdff
	jsr lfdee
	lda $db00
	sta $0805,y
	jsr lfdf6
	jsr lfde6
	iny
lfd42:	cpy $0804
	bne lfd2f
	rts
lfd48:	lda #$00
	sta $db02
	lda $db00
	sta $0800
	and #$7f
	tay
	jsr lfe21
	tya
	asl
	tay
	lda $0810,y
	sta $0801
	iny
	lda $0810,y
	sta $0802
	jsr lfdff
	jsr lfde6
	ldy #$00
lfd71:	cpy $0803
	beq lfd8b
	jsr lfdf6
	jsr lfdee
	lda $db00
	sta $0805,y
	jsr lfdff
	jsr lfde6
	iny
	bne lfd71
lfd8b:	bit $0800
	bmi lfdc3
	lda #$fd
	pha
	lda #$98
	pha
	jmp ($0801)
	jsr lfdf6
	ldy #$00
	beq lfdbd
lfda0:	jsr lfdee
	lda #$ff
	sta $db02
	lda $0805,y
	sta $db00
	jsr lfdff
	jsr lfde6
	lda #$00
	sta $db02
	jsr lfdf6
	iny
lfdbd:	cpy $0804
	bne lfda0
lfdc2:	rts
lfdc3:	lda #$fd
	pha
	lda #$ce
	pha
	jsr lfe11
	jmp ($0801)
	jsr lfe08
	lda $0804
	sta $0803
	sta $0800
	lda #$00
	sta $0804
	jsr lfcab
	jmp lfdc2
lfde6:	lda $db01
	and #$04
	bne lfde6
	rts
lfdee:	lda $db01
	and #$04
	beq lfdee
	rts
lfdf6:	lda $db01
	and #$f7
	sta $db01
	rts
lfdff:	lda #$08
	ora $db01
	sta $db01
	rts
lfe08:	lda $de01
	and #$ef
	sta $de01
	rts
lfe11:	lda $db01
	and #$02
	beq lfe11
	lda $de01
	ora #$10
	sta $de01
	rts
lfe21:	lda $0910,y
	pha
	and #$0f
	sta $0803
	pla
	lsr
	lsr
	lsr
	lsr
	sta $0804
	rts
lfe33:	ldx #$ff
	stx $01
	lda $de01
	and #$ef
	sta $de01
	nop
	lda $db01
	ror
	bcs lfe47
	rts
lfe47:	lda #$00
	sei
	sta $db01
	lda #$40
	nop
	nop
	nop
	nop
	sta $db01
	cli
lfe57:	jmp lfe57
lfe5a:	jmp ($036a)
	pla
	pla
	jmp lf945
lfe62:	lda $9a
	sta $94
	lda $99
	sta $93
	lda $9b
	sta $95
	sta $01
	rts
lfe71:	sec
	lda $93
	sbc $96
	lda $94
	sbc $97
	lda $95
	sbc $98
	rts
lfe7f:	inc $93
	bne lfe91
	inc $94
	bne lfe91
	inc $95
	lda $95
	sta $01
	lda #$02
	sta $93
lfe91:	rts
lfe92:	ldx $01
	lda $92
	sta $01
	lda ($90),y
	stx $01
	rts
lfe9d:	sta $01
	txa
	clc
	adc #$02
	bcc lfea6
	iny
lfea6:	tax
	tya
	pha
	txa
	pha
	jsr lff19
	lda #$fe
	sta ($ac),y
	php
	sei
	pha
	txa
	pha
	tya
	pha
	jsr lff19
	tay
	lda $00
	jsr lff2a
	lda #$04
	ldx #$ff
	jsr lff24
	tsx
	lda $0105,x
	sec
	sbc #$03
	pha
	lda $0106,x
	sbc #$00
	tax
	pla
	jsr lff24
	tya
lfedc:	sec
	sbc #$04
	sta $01ff
	tay
	ldx #$04
lfee5:	pla
	iny
	sta ($ac),y
	dex
	bne lfee5
	ldy $01ff
	lda #$2d
	ldx #$ff
	jsr lff24
	pla
	pla
	tsx
	stx $01ff
	tya
	tax
	txs
	lda $01
	jmp lfff6
	nop
	php
	php
	sei
	pha
	txa
	pha
	tya
	pha
	tsx
	lda $0106,x
	sta $01
	jsr lff19
	jmp lfedc
lff19:	ldy #$01
	sty $ad
	dey
	sty $ac
	dey
	lda ($ac),y
	rts
lff24:	pha
	txa
	sta ($ac),y
	dey
	pla
lff2a:	sta ($ac),y
	dey
	rts
	pla
	tay
	pla
	tax
	pla
	plp
	rts
	php
	jmp (lfffa)
	brk
	nop
	rts
	cli
	rts
; $ff3e ********************************** cbm2 v9938/58 graphics card *****************************
VdpInit:				; ***** init VDP - write register and clear VRAM *****
	ldx #$00				; reset X to first data
	stx vdp_cursor_flag			; clear cursor flag to show cursor after warm start
-	lda VdpInitData,x			; load data from table
	sta VDPControl				; write to control port - first value, second reg|80
	inx
	cpx # VdpInitDataEnd - VdpInitData	; $20 = end of table reached?
	bne -					; last 2 bytes $00,$40 inits VRAM write at $0000
	tay					; move last value $40 to Y as $4000 VRAM counter
	lsr					; shift $40 right for screen table init value=$20 'space'
-	sta VDPRamWrite				; write to VRAM
	pha 
	pla					; wait 3+4 cycles = 3.5us for VDP (minimum CS high = 8us)
	inx
	bne -
	cpy #$38				; $900-$20 end of screen table reached 
	bne + 
	txa					; clear color table and rest of VRAM with $00
+	dey
	bne -					; $40 reached? X starts at $20 -> clears only $3fdf bytes
	jsr VdpCopyPalette			; sub copy color palette (X already $00)
	jsr VdpFont				; copy font to VRAM

	ldy #$11				; two instructions moved from crtint to place the jsr
	bit $df02				; triport 2: port reg c
	rts
; 1 byte free (46 total)
*= $ff6c
	jmp lfe9d
	jmp lfbca
	jmp lfe33
	jmp jfunky
	jmp lfcab
	jmp ioinit
	jmp jcint
lff81:	jmp lf400
	jmp lfba9
	jmp restor
	jmp lf660
	jmp lf678
	jmp lfb5a
lff93:	jmp ($0324)
lff96:	jmp ($0326)
	jmp lfb78
	jmp lfb8d
	jmp jkey
	jmp lfb74
lffa5:	jmp ($0328)
lffa8:	jmp ($032a)
lffab:	jmp ($032c)
lffae:	jmp ($032e)
lffb1:	jmp ($0330)
lffb4:	jmp ($0332)
	jmp lfb4a
	jmp lfb43
	jmp lfb34
lffc0:	jmp ($0306)
lffc3:	jmp ($0308)
lffc6:	jmp ($030a)
lffc9:	jmp ($030c)
lffcc:	jmp ($030e)
lffcf:	jmp ($0310)
lffd2:	jmp ($0312)
lffd5:	jmp ($031a)
lffd8:	jmp ($031c)
	jmp lf90e
	jmp lf8e6
lffe1:	jmp ($0314)
lffe4:	jmp ($0316)
	jmp ($0318)
	jmp lf979
	jmp jscror
	jmp jplot
	jmp jiobas
lfff6:	sta $00
	rts
	!byte $01
lfffa:	!byte $31,$fb		; NMI vector
	!byte $97,$f9		; RESET vector -> start
	!byte $d6,$fb		; IRQ vector
