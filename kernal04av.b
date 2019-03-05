; kernal 04av.b
; cbm2 kernal modified for the v9958 color-graphics-card
; version 0.1
; free some memory
;
!cpu 6502
!ct scr		; standard text/char conversion table -> Screencode (pet = PETSCII, raw)
!initmem $aa
*= $e000
le000:	jmp $ee09
le003:	nop
jcint:	jmp cint		; sub initialize $e044
le007:	jmp $e0fe
le00a:	jmp $e179
le00d:	jmp $e299
le010:	jmp $e03f
le013:	jmp $e865
le016:	jmp $e0da
le019:	jmp $e025
le01c:	jmp $e03a
le01f:	jmp $e970
le022:	jmp $e6f8
le025:	bcs le035
le027:	stx $ca
le029:	stx $cf
le02b:	sty $cb
le02d:	sty $ce
le02f:	jsr $e0cd
le032:	jsr $e0da
le035:	ldx $ca
le037:	ldy $cb
le039:	rts
le03a:	ldx #$00
le03c:	ldy #$dc
le03e:	rts
le03f:	ldx #$50
le041:	ldy #$19
le043:	rts
cint:	lda #$00
le046:	ldx #$23
le048:	sta $c2,x
le04a:	dex
le04b:	bpl le048
le04d:	ldx #$20
le04f:	sta $0397,x
le052:	dex
le053:	bpl le04f
le055:	lda #$0c
le057:	sta $d8
le059:	lda #$60
le05b:	sta $d4
le05d:	lda #$2a
le05f:	sta $03b5
le062:	lda #$e9
le064:	sta $03b6
le067:	lda $c0
le069:	ora $c1
le06b:	bne le0aa
le06d:	lda $0355
le070:	sta $0380
le073:	lda $0356
le076:	sta $0381
le079:	lda #$40
le07b:	ldx #$00
le07d:	ldy #$02
le07f:	jsr $ff81
le082:	bcs le0aa
le084:	sta $0382
le087:	inx
le088:	stx $c0
le08a:	bne le08d
le08c:	iny
le08d:	sty $c1
le08f:	ldy #$39
le091:	jsr $e282
le094:	lda $ec2d,y
le097:	dey
le098:	sta ($c0),y
le09a:	bne le094
le09c:	jsr $e291
le09f:	ldy #$0a
le0a1:	lda $ec23,y
le0a4:	sta $0382,y
le0a7:	dey
le0a8:	bne le0a1
le0aa:	jsr $e9c7
le0ad:	jsr $e251
le0b0:	jsr $e260
le0b3:	jsr $e0c1
le0b6:	jsr $e0cf
le0b9:	jsr $e227
le0bc:	cpx $dd
le0be:	inx
le0bf:	bcc le0b6
le0c1:	ldx $dc
le0c3:	stx $ca
le0c5:	stx $cf
le0c7:	ldy $de
le0c9:	sty $cb
le0cb:	sty $ce
le0cd:	ldx $ca
le0cf:	lda $ebb2,x
le0d2:	sta $c8
le0d4:	lda $ebcb,x
le0d7:	sta $c9
le0d9:	rts
le0da:	ldy #$0f
le0dc:	clc
le0dd:	lda $c8
le0df:	adc $cb
le0e1:	sty $d800
le0e4:	sta $d801
le0e7:	dey
le0e8:	sty $d800
le0eb:	lda $d801
le0ee:	and #$f8
le0f0:	sta $d9
le0f2:	lda $c9
le0f4:	adc #$00
le0f6:	and #$07
le0f8:	ora $d9
le0fa:	sta $d801
le0fd:	rts
le0fe:	ldx $d6
le100:	beq le114
le102:	ldy $039d
le105:	jsr $e282
le108:	lda ($c2),y
le10a:	jsr $e291
le10d:	dec $d6
le10f:	inc $039d
le112:	cli
le113:	rts
le114:	ldy $03ab
le117:	ldx #$00
le119:	lda $03ac,x
le11c:	sta $03ab,x
le11f:	inx
le120:	cpx $d1
le122:	bne le119
le124:	dec $d1
le126:	tya
le127:	cli
le128:	rts
le129:	jsr $e299
le12c:	ldy #$0a
le12e:	lda $d4
le130:	sty $d800
le133:	sta $d801
le136:	lda $d1
le138:	ora $d6
le13a:	beq le136
le13c:	sei
le13d:	jsr $e0fe		; moved to patch - input keyboard buffer
le140:	cmp #$0d
le142:	bne le129
le144:	jsr $ecdc		; jmp to 04a patch
le147:	nop
le148:	nop
le149:	nop
le14a:	nop
le14b:	nop
le14c:	sta $d0
le14e:	jsr $e544
le151:	stx $0398
le154:	jsr $ecb0
le157:	sta $d3
le159:	sta $d2
le15b:	ldy $de
le15d:	lda $cf
le15f:	bmi le174
le161:	cmp $ca
le163:	bcc le174
le165:	ldy $ce
le167:	cmp $0398
le16a:	bne le170
le16c:	cpy $d5
le16e:	beq le172
le170:	bcs le183
le172:	sta $ca
le174:	sty $cb
le176:	jmp $e18b
le179:	tya
le17a:	pha
le17b:	txa
le17c:	pha
le17d:	lda $d0
le17f:	beq le12c
le181:	bpl le18b
le183:	lda #$00
le185:	sta $d0
le187:	lda #$0d
le189:	bne le1c4
le18b:	jsr $e0cd
le18e:	jsr $e242
le191:	sta $db
le193:	and #$3f
le195:	asl $db
le197:	bit $db
le199:	bpl le19d
le19b:	ora #$80
le19d:	bcc le1a3
le19f:	ldx $d2
le1a1:	bne le1a7
le1a3:	bvs le1a7
le1a5:	ora #$40
le1a7:	jsr $e1cd
le1aa:	ldy $ca
le1ac:	cpy $0398
le1af:	bcc le1bb
le1b1:	ldy $cb
le1b3:	cpy $d5
le1b5:	bcc le1bb
le1b7:	ror $d0
le1b9:	bmi le1be
le1bb:	jsr $e574
le1be:	cmp #$de
le1c0:	bne le1c4
le1c2:	lda #$ff
le1c4:	sta $db
le1c6:	pla
le1c7:	tax
le1c8:	pla
le1c9:	tay
le1ca:	lda $db
le1cc:	rts
le1cd:	cmp #$22
le1cf:	bne le1dd
le1d1:	lda $d3
le1d3:	bne le1db
le1d5:	lda $d2
le1d7:	eor #$01
le1d9:	sta $d2
le1db:	lda #$22
le1dd:	rts
le1de:	bit $0397
le1e1:	bpl le1e5
le1e3:	ora #$80
le1e5:	ldx $d3
le1e7:	beq le1eb
le1e9:	dec $d3
le1eb:	bit $039a
le1ee:	bpl le1f9
le1f0:	pha
le1f1:	jsr $e5e4
le1f4:	ldx #$00
le1f6:	stx $d3
le1f8:	pla
le1f9:	jsr $e21c
le1fc:	cpy #$45
le1fe:	bne le203
le200:	jsr $e48d
le203:	jsr $e62e
le206:	lda $db
le208:	sta $0399
le20b:	jsr $e0da
le20e:	pla
le20f:	tay
le210:	lda $d3
le212:	beq le216
le214:	lsr $d2
le216:	pla
le217:	tax
le218:	pla
le219:	rts
le21a:	lda #$20
le21c:	ldy $cb
le21e:	jsr $e27d
le221:	sta ($c8),y
le223:	jsr $e291
le226:	rts
le227:	ldy $de
le229:	jsr $e505
le22c:	txa
le22d:	pha
le22e:	lda $cb
le230:	pha
le231:	dey
le232:	iny
le233:	sty $cb
le235:	jsr $e21a
le238:	cpy $df
le23a:	bne le232
le23c:	pla
le23d:	sta $cb
le23f:	pla
le240:	tax
le241:	rts
le242:	ldy $cb
le244:	jsr $e27d
le247:	lda ($c8),y
le249:	jsr $e291
le24c:	rts
le24d:	ldy #$10
le24f:	bcs le253
le251:	ldy #$00
le253:	sty $cc
le255:	lda $de06
le258:	and #$ef
le25a:	ora $cc
le25c:	sta $de06
le25f:	rts
le260:	ldy #$11
le262:	bit $df02
le265:	bmi le26d
le267:	ldy #$23
le269:	bvs le26d
le26b:	ldy #$35
le26d:	ldx #$11
le26f:	lda $ec6f,y
le272:	stx $d800
le275:	sta $d801
le278:	dey
le279:	dex
le27a:	bpl le26f
le27c:	rts
le27d:	pha
le27e:	lda #$3f
le280:	bne le286
le282:	pha
le283:	lda $0382
le286:	pha
le287:	lda $01
le289:	sta $03a0
le28c:	pla
le28d:	sta $01
le28f:	pla
le290:	rts
le291:	pha
le292:	lda $03a0
le295:	sta $01
le297:	pla
le298:	rts
le299:	pha
le29a:	cmp #$ff
le29c:	bne le2a0
le29e:	lda #$de
le2a0:	sta $db
le2a2:	txa
le2a3:	pha
le2a4:	tya
le2a5:	pha
le2a6:	lda #$00
le2a8:	sta $d0
le2aa:	ldy $cb
le2ac:	lda $db
le2ae:	and #$7f
le2b0:	cmp #$20
le2b2:	bcc le2cf
le2b4:	ldx $0399
le2b7:	cpx #$1b
le2b9:	bne le2c1
le2bb:	jsr $e655
le2be:	jmp $e303
le2c1:	and #$3f
le2c3:	bit $db
le2c5:	bpl le2c9
le2c7:	ora #$40
le2c9:	jsr $e1cd
le2cc:	jmp $e1de
le2cf:	cmp #$0d
le2d1:	beq le2fc
le2d3:	cmp #$14
le2d5:	beq le2fc
le2d7:	cmp #$1b
le2d9:	bne le2ec
le2db:	bit $db
le2dd:	bmi le2ec
le2df:	lda $d2
le2e1:	ora $d3
le2e3:	beq le2fc
le2e5:	jsr $e3a2
le2e8:	sta $db
le2ea:	beq le2fc
le2ec:	cmp #$03
le2ee:	beq le2fc
le2f0:	ldy $d3
le2f2:	bne le2f8
le2f4:	ldy $d2
le2f6:	beq le2fc
le2f8:	ora #$80
le2fa:	bne le2c3
le2fc:	lda $db
le2fe:	asl
le2ff:	tax
le300:	jsr $e306
le303:	jmp $e206
le306:	lda $ebe5,x
le309:	pha
le30a:	lda $ebe4,x
le30d:	pha
le30e:	lda $db
le310:	rts
le311:	jmp ($0322)
le314:	bcs le323
le316:	jsr $e37a
le319:	jsr $e4f5
le31c:	bcs le321
le31e:	sec
le31f:	ror $cf
le321:	clc
le322:	rts
le323:	ldx $dc
le325:	cpx $ca
le327:	bcs le338
le329:	jsr $e319
le32c:	dec $ca
le32e:	jmp $e0cd
le331:	bcs le339
le333:	jsr $e574
le336:	bcs le319
le338:	rts
le339:	jsr $e587
le33c:	bcs le338
le33e:	bne le321
le340:	inc $ca
le342:	bne le329
le344:	eor #$80
le346:	sta $0397
le349:	rts
le34a:	bcc le34f
le34c:	jmp $e0b3
le34f:	cmp $0399
le352:	bne le357
le354:	jsr $e9c7
le357:	jmp $e0c1
le35a:	ldy $cb
le35c:	bcs le370
le35e:	cpy $df
le360:	bcc le367
le362:	lda $df
le364:	sta $cb
le366:	rts
le367:	iny
le368:	jsr $e95a
le36b:	beq le35e
le36d:	sty $cb
le36f:	rts
le370:	jsr $e95a
le373:	eor $039c
le376:	sta $03a1,x
le379:	rts
le37a:	ldx $ca
le37c:	cpx $dd
le37e:	bcc le38f
le380:	bit $039b
le383:	bpl le38b
le385:	lda $dc
le387:	sta $ca
le389:	bcs le391
le38b:	jsr $e3f6
le38e:	clc
le38f:	inc $ca
le391:	jmp $e0cd
le394:	jsr $e544
le397:	inx
le398:	jsr $e505
le39b:	ldy $de
le39d:	sty $cb
le39f:	jsr $e37a
le3a2:	lda #$00
le3a4:	sta $d3
le3a6:	sta $0397
le3a9:	sta $d2
le3ab:	cmp $039f
le3ae:	bne le3b3
le3b0:	sta $da18
le3b3:	rts
le3b4:	lda $ebb2,x
le3b7:	sta $c4
le3b9:	lda $ebcb,x
le3bc:	sta $c5
le3be:	jsr $e27d
le3c1:	lda ($c4),y
le3c3:	sta ($c8),y
le3c5:	cpy $df
le3c7:	iny
le3c8:	bcc le3c1
le3ca:	jmp $e291
le3cd:	ldx $cf
le3cf:	bmi le3d7
le3d1:	cpx $ca
le3d3:	bcc le3d7
le3d5:	inc $cf
le3d7:	ldx $dd
le3d9:	jsr $e0cf
le3dc:	ldy $de
le3de:	cpx $ca
le3e0:	beq le3f0
le3e2:	dex
le3e3:	jsr $e4f7
le3e6:	inx
le3e7:	jsr $e503
le3ea:	dex
le3eb:	jsr $e3b4
le3ee:	bcs le3d9
le3f0:	jsr $e227
le3f3:	jmp $e512
le3f6:	ldx $dc
le3f8:	inx
le3f9:	jsr $e4f7
le3fc:	bcc le408
le3fe:	cpx $dd
le400:	bcc le3f8
le402:	ldx $dc
le404:	inx
le405:	jsr $e505
le408:	dec $ca
le40a:	bit $cf
le40c:	bmi le410
le40e:	dec $cf
le410:	ldx $dc
le412:	cpx $da
le414:	bcs le418
le416:	dec $da
le418:	jsr $e42d
le41b:	ldx $dc
le41d:	jsr $e4f7
le420:	php
le421:	jsr $e505
le424:	plp
le425:	bcc le42c
le427:	bit $039e
le42a:	bmi le408
le42c:	rts
le42d:	jsr $e0cf
le430:	ldy $de
le432:	cpx $dd
le434:	bcs le444
le436:	inx
le437:	jsr $e4f7
le43a:	dex
le43b:	jsr $e503
le43e:	inx
le43f:	jsr $e3b4
le442:	bcs le42d
le444:	jsr $e227
le447:	ldx #$ff
le449:	ldy #$fe
le44b:	jsr $e480
le44e:	and #$20
le450:	bne le45f
le452:	nop
le453:	nop
le454:	dex
le455:	bne le452
le457:	dey
le458:	bne le452
le45a:	sty $d1
le45c:	jmp $e8f7
le45f:	ldx #$f7
le461:	ldy #$ff
le463:	jsr $e480
le466:	and #$10
le468:	bne le45c
le46a:	jsr $e480
le46d:	and #$10
le46f:	beq le46a
le471:	ldy #$00
le473:	ldx #$00
le475:	jsr $e480
le478:	and #$3f
le47a:	eor #$3f
le47c:	beq le471
le47e:	bne le45a
le480:	php
le481:	sei
le482:	stx $df00
le485:	sty $df01
le488:	jsr $e91e
le48b:	plp
le48c:	rts
le48d:	lda $039f
le490:	bne le4b9
le492:	lda #$0f
le494:	sta $da18
le497:	ldy #$00
le499:	sty $da05
le49c:	lda #$0a
le49e:	sta $da06
le4a1:	lda #$30
le4a3:	sta $da01
le4a6:	lda #$60
le4a8:	sta $da0f
le4ab:	ldx #$15
le4ad:	stx $da04
le4b0:	nop
le4b1:	nop
le4b2:	iny
le4b3:	bne le4b0
le4b5:	dex
le4b6:	stx $da04
le4b9:	rts
le4ba:	lda $cb
le4bc:	pha
le4bd:	ldy $cb
le4bf:	dey
le4c0:	jsr $e244
le4c3:	cmp #$2b
le4c5:	beq le4cb
le4c7:	cmp #$2d
le4c9:	bne le4d3
le4cb:	dey
le4cc:	jsr $e244
le4cf:	cmp #$05
le4d1:	bne le4ed
le4d3:	cmp #$05
le4d5:	bne le4db
le4d7:	dey
le4d8:	jsr $e244
le4db:	cmp #$2e
le4dd:	bcc le4ed
le4df:	cmp #$2f
le4e1:	beq le4ed
le4e3:	cmp #$3a
le4e5:	bcs le4ed
le4e7:	jsr $e5b0
le4ea:	jmp $e4bd
le4ed:	pla
le4ee:	cmp $cb
le4f0:	bne le4b9
le4f2:	jmp $e5b0
le4f5:	ldx $ca
le4f7:	jsr $e51e
le4fa:	and $e2,x
le4fc:	cmp #$01
le4fe:	jmp $e50e
le501:	ldx $ca
le503:	bcs le512
le505:	jsr $e51e
le508:	eor #$ff
le50a:	and $e2,x
le50c:	sta $e2,x
le50e:	ldx $039c
le511:	rts
le512:	bit $039b
le515:	bvs le4f7
le517:	jsr $e51e
le51a:	ora $e2,x
le51c:	bne le50c
le51e:	stx $039c
le521:	txa
le522:	and #$07
le524:	tax
le525:	lda $ec67,x
le528:	pha
le529:	lda $039c
le52c:	lsr
le52d:	lsr
le52e:	lsr
le52f:	tax
le530:	pla
le531:	rts
le532:	ldy $de
le534:	sty $cb
le536:	jsr $e4f5
le539:	bcc le541
le53b:	dec $ca
le53d:	bpl le536
le53f:	inc $ca
le541:	jmp $e0cd
le544:	lda $ca
le546:	cmp $dd
le548:	bcs le553
le54a:	inc $ca
le54c:	jsr $e4f5
le54f:	bcs le544
le551:	dec $ca
le553:	jsr $e0cd
le556:	ldy $df
le558:	sty $cb
le55a:	bpl le561
le55c:	jsr $e587
le55f:	bcs le571
le561:	jsr $e242
le564:	cmp #$20
le566:	bne le571
le568:	cpy $de
le56a:	bne le55c
le56c:	jsr $e4f5
le56f:	bcs le55c
le571:	sty $d5
le573:	rts
le574:	pha
le575:	ldy $cb
le577:	cpy $df
le579:	bcc le582
le57b:	jsr $e37a
le57e:	ldy $de
le580:	dey
le581:	sec
le582:	iny
le583:	sty $cb
le585:	pla
le586:	rts
le587:	ldy $cb
le589:	dey
le58a:	bmi le590
le58c:	cpy $de
le58e:	bcs le59f
le590:	ldy $dc
le592:	cpy $ca
le594:	bcs le5a4
le596:	dec $ca
le598:	pha
le599:	jsr $e0cd
le59c:	pla
le59d:	ldy $df
le59f:	sty $cb
le5a1:	cpy $df
le5a3:	clc
le5a4:	rts
le5a5:	ldy $cb
le5a7:	sty $d9
le5a9:	ldx $ca
le5ab:	stx $da
le5ad:	rts
le5ae:	bcs le5e4
le5b0:	jsr $e339
le5b3:	jsr $e5a5
le5b6:	bcs le5c7
le5b8:	cpy $df
le5ba:	bcc le5d2
le5bc:	ldx $ca
le5be:	inx
le5bf:	jsr $e4f7
le5c2:	bcs le5d2
le5c4:	jsr $e21a
le5c7:	lda $d9
le5c9:	sta $cb
le5cb:	lda $da
le5cd:	sta $ca
le5cf:	jmp $e0cd
le5d2:	jsr $e574
le5d5:	jsr $e242
le5d8:	jsr $e587
le5db:	jsr $e21c
le5de:	jsr $e574
le5e1:	jmp $e5b8
le5e4:	jsr $e5a5
le5e7:	jsr $e544
le5ea:	cpx $da
le5ec:	bne le5f0
le5ee:	cpy $d9
le5f0:	bcc le613
le5f2:	jsr $e62e
le5f5:	bcs le619
le5f7:	jsr $e587
le5fa:	jsr $e242
le5fd:	jsr $e574
le600:	jsr $e21c
le603:	jsr $e587
le606:	ldx $ca
le608:	cpx $da
le60a:	bne le5f7
le60c:	cpy $d9
le60e:	bne le5f7
le610:	jsr $e21a
le613:	inc $d3
le615:	bne le619
le617:	dec $d3
le619:	jmp $e5c7
le61c:	bcc le62d
le61e:	sei
le61f:	ldx #$09
le621:	stx $d1
le623:	lda $eba8,x
le626:	sta $03aa,x
le629:	dex
le62a:	bne le623
le62c:	cli
le62d:	rts
le62e:	cpy $df
le630:	bcc le63d
le632:	ldx $ca
le634:	cpx $dd
le636:	bcc le63d
le638:	bit $039b
le63b:	bmi le654
le63d:	jsr $e0cd
le640:	jsr $e574
le643:	bcc le654
le645:	jsr $e4f5
le648:	bcs le653
le64a:	jsr $ed00
le64d:	sec
le64e:	bvs le654
le650:	jsr $e3cd
le653:	clc
le654:	rts
le655:	jmp ($0320)
le658:	jsr $e3cd
le65b:	jsr $e0c7
le65e:	inx
le65f:	jsr $e4f7
le662:	php
le663:	jsr $e501
le666:	plp
le667:	bcs le66c
le669:	sec
le66a:	ror $cf
le66c:	rts
le66d:	jsr $e536
le670:	lda $dc
le672:	pha
le673:	lda $ca
le675:	sta $dc
le677:	lda $039e
le67a:	pha
le67b:	lda #$80
le67d:	sta $039e
le680:	jsr $e408
le683:	pla
le684:	sta $039e
le687:	lda $dc
le689:	sta $ca
le68b:	pla
le68c:	sta $dc
le68e:	sec
le68f:	ror $cf
le691:	jmp $e0c7
le694:	jsr $e5a5
le697:	jsr $e22c
le69a:	inc $ca
le69c:	jsr $e0cd
le69f:	ldy $de
le6a1:	jsr $e4f5
le6a4:	bcs le697
le6a6:	jmp $e5c7
le6a9:	jsr $e5a5
le6ac:	jsr $e21a
le6af:	cpy $de
le6b1:	bne le6b8
le6b3:	jsr $e4f5
le6b6:	bcc le6a6
le6b8:	jsr $e587
le6bb:	bcc le6ac
le6bd:	jsr $e5a5
le6c0:	txa
le6c1:	pha
le6c2:	jsr $e3f6
le6c5:	pla
le6c6:	sta $da
le6c8:	jmp $e6a6
le6cb:	jsr $e5a5
le6ce:	jsr $e4f5
le6d1:	bcs le6d6
le6d3:	sec
le6d4:	ror $cf
le6d6:	lda $dc
le6d8:	sta $ca
le6da:	jsr $e3cd
le6dd:	jsr $e505
le6e0:	jmp $e6a6
le6e3:	clc
le6e4:	bit $38
le6e6:	lda #$00
le6e8:	ror
le6e9:	sta $039b
le6ec:	rts
le6ed:	clc
le6ee:	bcc le6f1
le6f0:	sec
le6f1:	lda #$00
le6f3:	ror
le6f4:	sta $039e
le6f7:	rts
le6f8:	sei
le6f9:	dey
le6fa:	bmi le6ff
le6fc:	jmp $e7be
le6ff:	ldy #$00
le701:	iny
le702:	sty $03b7
le705:	dey
le706:	lda $0383,y
le709:	beq le777
le70b:	sta $039d
le70e:	jsr $e949
le711:	sta $c2
le713:	stx $c3
le715:	ldx #$03
le717:	lda $e7a6,x
le71a:	jsr $ffd2
le71d:	dex
le71e:	bpl le717
le720:	ldx #$2f
le722:	lda $03b7
le725:	sec
le726:	inx
le727:	sbc #$0a
le729:	bcs le726
le72b:	adc #$3a
le72d:	cpx #$30
le72f:	beq le737
le731:	pha
le732:	txa
le733:	jsr $ffd2
le736:	pla
le737:	jsr $ffd2
le73a:	ldy #$00
le73c:	lda #$2c
le73e:	jsr $ffd2
le741:	ldx #$07
le743:	jsr $e282
le746:	lda ($c2),y
le748:	jsr $e291
le74b:	cmp #$0d
le74d:	beq le781
le74f:	cmp #$8d
le751:	beq le784
le753:	cmp #$22
le755:	beq le787
le757:	cpx #$09
le759:	beq le762
le75b:	pha
le75c:	lda #$22
le75e:	jsr $ffd2
le761:	pla
le762:	jsr $ffd2
le765:	ldx #$09
le767:	iny
le768:	cpy $039d
le76b:	bne le743
le76d:	lda #$22
le76f:	jsr $ffd2
le772:	lda #$0d
le774:	jsr $ffd2
le777:	ldy $03b7
le77a:	cpy #$14
le77c:	bne le701
le77e:	cli
le77f:	clc
le780:	rts
le781:	ldx #$0a
le783:	!byte $2c
le784:	ldx #$13
le786:	!byte $2c
le787:	ldx #$0e
le789:	txa
le78a:	pha
le78b:	ldx #$06
le78d:	lda $e7aa,x
le790:	beq le79c
le792:	jsr $ffd2
le795:	dex
le796:	bpl le78d
le798:	pla
le799:	tax
le79a:	bne le78d
le79c:	iny
le79d:	cpy $039d
le7a0:	beq le772
le7a2:	lda #$2b
le7a4:	bne le73e
le7a6:	jsr $4559
le7a9:	!byte $4b
le7aa:	plp
le7ab:	bit $52
le7ad:	pha
le7ae:	!byte $43
le7af:	!byte $2b
le7b0:	!byte $22
le7b1:	brk
le7b2:	and #$33
le7b4:	and ($00),y
le7b6:	and #$34
le7b8:	!byte $33
le7b9:	brk
le7ba:	and #$31
le7bc:	!byte $34
le7bd:	and ($48),y
le7bf:	tax
le7c0:	sty $d9
le7c2:	lda $00,x
le7c4:	sec
le7c5:	sbc $0383,y
le7c8:	sta $da
le7ca:	ror $039c
le7cd:	iny
le7ce:	jsr $e949
le7d1:	sta $c4
le7d3:	stx $c5
le7d5:	ldy #$14
le7d7:	jsr $e949
le7da:	sta $c6
le7dc:	stx $c7
le7de:	ldy $039c
le7e1:	bpl le7f6
le7e3:	clc
le7e4:	sbc $0380
le7e7:	tay
le7e8:	txa
le7e9:	sbc $0381
le7ec:	tax
le7ed:	tya
le7ee:	clc
le7ef:	adc $da
le7f1:	txa
le7f2:	adc #$00
le7f4:	bcs le862
le7f6:	jsr $e282
le7f9:	lda $c6
le7fb:	clc
le7fc:	sbc $c4
le7fe:	lda $c7
le800:	sbc $c5
le802:	bcc le82e
le804:	ldy #$00
le806:	lda $039c
le809:	bpl le81c
le80b:	lda $c6
le80d:	bne le811
le80f:	dec $c7
le811:	dec $c6
le813:	lda ($c6),y
le815:	ldy $da
le817:	sta ($c6),y
le819:	jmp $e7f9
le81c:	lda ($c4),y
le81e:	ldy $da
le820:	dec $c5
le822:	sta ($c4),y
le824:	inc $c5
le826:	inc $c4
le828:	bne le7f9
le82a:	inc $c5
le82c:	bne le7f9
le82e:	ldy $d9
le830:	jsr $e949
le833:	sta $c4
le835:	stx $c5
le837:	ldy $d9
le839:	pla
le83a:	pha
le83b:	tax
le83c:	lda $00,x
le83e:	sta $0383,y
le841:	tay
le842:	beq le85e
le844:	lda $01,x
le846:	sta $c6
le848:	lda $02,x
le84a:	sta $c7
le84c:	dey
le84d:	lda $03,x
le84f:	sta $01
le851:	lda ($c6),y
le853:	jsr $e291
le856:	jsr $e282
le859:	sta ($c4),y
le85b:	tya
le85c:	bne le84c
le85e:	jsr $e291
le861:	clc
le862:	pla
le863:	cli
le864:	rts
le865:	ldy #$ff
le867:	sty $e0
le869:	sty $e1
le86b:	iny
le86c:	sty $df01
le86f:	sty $df00
le872:	jsr $e91e
le875:	and #$3f
le877:	eor #$3f
le879:	bne le87e
le87b:	jmp $e8f3
le87e:	lda #$ff
le880:	sta $df00
le883:	asl
le884:	sta $df01
le887:	jsr $e91e
le88a:	pha
le88b:	sta $e0
le88d:	ora #$30
le88f:	bne le894
le891:	jsr $e91e
le894:	ldx #$05
le896:	lsr
le897:	bcc le8a9
le899:	iny
le89a:	dex
le89b:	bpl le896
le89d:	sec
le89e:	rol $df01
le8a1:	rol $df00
le8a4:	bcs le891
le8a6:	pla
le8a7:	bcc le8f3
le8a9:	sty $e1
le8ab:	ldx $ea29,y
le8ae:	pla
le8af:	asl
le8b0:	asl
le8b1:	asl
le8b2:	bcc le8c2
le8b4:	bmi le8c5
le8b6:	ldx $ea89,y
le8b9:	lda $cc
le8bb:	beq le8c5
le8bd:	ldx $eae9,y
le8c0:	bne le8c5
le8c2:	ldx $eb49,y
le8c5:	cpx #$ff
le8c7:	beq le8f5
le8c9:	cpx #$e0
le8cb:	bcc le8d6
le8cd:	tya
le8ce:	pha
le8cf:	jsr $e927
le8d2:	pla
le8d3:	tay
le8d4:	bcs le8f5
le8d6:	txa
le8d7:	cpy $cd
le8d9:	beq le902
le8db:	ldx #$13
le8dd:	stx $d8
le8df:	ldx $d1
le8e1:	cpx #$09
le8e3:	beq le8f3
le8e5:	cpy #$59
le8e7:	bne le912
le8e9:	cpx #$08
le8eb:	beq le8f3
le8ed:	sta $03ab,x
le8f0:	inx
le8f1:	bne le912
le8f3:	ldy #$ff
le8f5:	sty $cd
le8f7:	ldx #$7f
le8f9:	stx $df00
le8fc:	ldx #$ff
le8fe:	stx $df01
le901:	rts
le902:	dec $d8
le904:	bpl le8f7
le906:	inc $d8
le908:	dec $d7
le90a:	bpl le8f7
le90c:	inc $d7
le90e:	ldx $d1
le910:	bne le8f7
le912:	sta $03ab,x
le915:	inx
le916:	stx $d1
le918:	ldx #$03
le91a:	stx $d7
le91c:	bne le8f5
le91e:	lda $df02
le921:	cmp $df02
le924:	bne le91e
le926:	rts
le927:	jmp ($03b5)
le92a:	cpy $cd
le92c:	beq le947
le92e:	lda $d1
le930:	ora $d6
le932:	bne le947
le934:	sta $039d
le937:	txa
le938:	and #$1f
le93a:	tay
le93b:	lda $0383,y
le93e:	sta $d6
le940:	jsr $e949
le943:	sta $c2
le945:	stx $c3
le947:	sec
le948:	rts
le949:	lda $c0
le94b:	ldx $c1
le94d:	clc
le94e:	dey
le94f:	bmi le959
le951:	adc $0383,y
le954:	bcc le94d
le956:	inx
le957:	bne le94d
le959:	rts
le95a:	tya
le95b:	and #$07
le95d:	tax
le95e:	lda $ec67,x
le961:	sta $039c
le964:	tya
le965:	lsr
le966:	lsr
le967:	lsr
le968:	tax
le969:	lda $03a1,x
le96c:	bit $039c
le96f:	rts
le970:	and #$7f
le972:	sec
le973:	sbc #$41
le975:	cmp #$1a
le977:	bcc le97a
le979:	rts
le97a:	asl
le97b:	tax
le97c:	lda $e986,x
le97f:	pha
le980:	lda $e985,x
le983:	pha
le984:	rts
le985:	!byte $22
le986:	nop
le987:	tsx
le988:	sbc #$1f
le98a:	nop
le98b:	jmp ($eee6)
le98e:	sbc #$e5
le990:	sbc #$d5
le992:	sbc #$d7
le994:	sbc #$57
le996:	inc $31
le998:	sbc $43
le99a:	sbc $e2
le99c:	inc $e4
le99e:	inc $04
le9a0:	nop
le9a1:	lda ($e3,x)
le9a3:	tay
le9a4:	inc $93
le9a6:	inc $f5
le9a8:	sbc #$eb
le9aa:	sbc #$b8
le9ac:	sbc #$db
le9ae:	sbc #$bc
le9b0:	inc $ca
le9b2:	inc $78
le9b4:	sbc #$07
le9b6:	nop
le9b7:	sed
le9b8:	sbc #$18
le9ba:	bit $38
le9bc:	ldx $cb
le9be:	lda $ca
le9c0:	bcc le9d1
le9c2:	sta $dd
le9c4:	stx $df
le9c6:	rts
le9c7:	lda #$18
le9c9:	ldx #$4f
le9cb:	jsr $e9c2
le9ce:	lda #$00
le9d0:	tax
le9d1:	sta $dc
le9d3:	stx $de
le9d5:	rts
le9d6:	lda #$00
le9d8:	sta $039f
le9db:	rts
le9dc:	lda #$0b
le9de:	bit $df02
le9e1:	bmi le9e8
le9e3:	lda #$06
le9e5:	bit $60a9
le9e8:	ora $d4
le9ea:	bne le9f3
le9ec:	lda #$f0
le9ee:	bit $0fa9
le9f1:	and $d4
le9f3:	sta $d4
le9f5:	rts
le9f6:	lda #$20
le9f8:	bit $10a9
le9fb:	ldx #$0e
le9fd:	stx $d800
lea00:	ora $d801
lea03:	bne lea12
lea05:	lda #$df
lea07:	bit $efa9
lea0a:	ldx #$0e
lea0c:	stx $d800
lea0f:	and $d801
lea12:	sta $d801
lea15:	and #$30
lea17:	ldx #$0c
lea19:	stx $d800
lea1c:	sta $d801
lea1f:	rts
lea20:	lda #$00
lea22:	bit $ffa9
lea25:	sta $039a
lea28:	rts
lea29:	cpx #$1b
lea2b:	ora #$ff
lea2d:	brk
lea2e:	ora ($e1,x)
lea30:	and ($51),y
lea32:	eor ($5a,x)
lea34:	!byte $ff
lea35:	!byte $e2
lea36:	!byte $32
lea37:	!byte $57
lea38:	!byte $53
lea39:	cli
lea3a:	!byte $43
lea3b:	!byte $e3
lea3c:	!byte $33
lea3d:	eor $44
lea3f:	lsr $56
lea41:	cpx $34
lea43:	!byte $52
lea44:	!byte $54
lea45:	!byte $47
lea46:	!byte $42
lea47:	sbc $35
lea49:	rol $59,x
lea4b:	pha
lea4c:	lsr $37e6
lea4f:	eor $4a,x
lea51:	eor $e720
lea54:	sec
lea55:	eor #$4b
lea57:	bit $e82e
lea5a:	and $4c4f,y
lea5d:	!byte $3b
lea5e:	!byte $2f
lea5f:	sbc #$30
lea61:	and $5b50
lea64:	!byte $27
lea65:	ora ($3d),y
lea67:	!byte $5f
lea68:	eor $de0d,x
lea6b:	sta ($9d),y
lea6d:	ora $0214,x
lea70:	!byte $ff
lea71:	!byte $13
lea72:	!byte $3f
lea73:	!byte $37
lea74:	!byte $34
lea75:	and ($30),y
lea77:	!byte $12
lea78:	!byte $04
lea79:	sec
lea7a:	and $32,x
lea7c:	rol $2a8e
lea7f:	and $3336,y
lea82:	bmi lea87
lea84:	!byte $2f
lea85:	!byte $2d
lea86:	!byte $2b
lea87:	!byte $0d
lea88:	!byte $ff
lea89:	nop
lea8a:	!byte $1b
lea8b:	!byte $89
lea8c:	!byte $ff
lea8d:	brk
lea8e:	ora ($eb,x)
lea90:	and ($d1,x)
lea92:	cmp ($da,x)
lea94:	!byte $ff
lea95:	cpx $d740
lea98:	!byte $d3
lea99:	cld
lea9a:	!byte $c3
lea9b:	sbc $c523
lea9e:	cpy $c6
leaa0:	dec $ee,x
leaa2:	bit $d2
leaa4:	!byte $d4
leaa5:	!byte $c7
leaa6:	!byte $c2
leaa7:	!byte $ef
leaa8:	and $5e
leaaa:	cmp $cec8,y
leaad:	beq lead5
leaaf:	cmp $ca,x
leab1:	cmp $f1a0
leab4:	rol
leab5:	cmp #$cb
leab7:	!byte $3c
leab8:	rol $28f2,x
leabb:	!byte $cf
leabc:	cpy $3f3a
leabf:	!byte $f3
leac0:	and #$2d
leac2:	bne leb1f
leac4:	!byte $22
leac5:	ora ($2b),y
leac7:	!byte $5c
leac8:	eor $de8d,x
leacb:	sta ($9d),y
leacd:	ora $8294,x
lead0:	!byte $ff
lead1:	!byte $93
lead2:	!byte $3f
lead3:	!byte $37
lead4:	!byte $34
lead5:	and ($30),y
lead7:	!byte $92
lead8:	sty $38
leada:	and $32,x
leadc:	rol $2a0e
leadf:	and $3336,y
leae2:	bmi lea67
leae4:	!byte $2f
leae5:	and $8d2b
leae8:	!byte $ff
leae9:	nop
leaea:	!byte $1b
leaeb:	!byte $89
leaec:	!byte $ff
leaed:	brk
leaee:	ora ($eb,x)
leaf0:	and ($d1,x)
leaf2:	cmp ($da,x)
leaf4:	!byte $ff
leaf5:	cpx $d740
leaf8:	!byte $d3
leaf9:	cld
leafa:	cpy #$ed
leafc:	!byte $23
leafd:	cmp $c4
leaff:	dec $c3
leb01:	inc $d224
leb04:	!byte $d4
leb05:	!byte $c7
leb06:	!byte $c2
leb07:	!byte $ef
leb08:	and $5e
leb0a:	cmp $ddc8,y
leb0d:	beq leb35
leb0f:	cmp $ca,x
leb11:	cmp $f1a0
leb14:	rol
leb15:	cmp #$cb
leb17:	!byte $3c
leb18:	rol $28f2,x
leb1b:	!byte $cf
leb1c:	dec $3a,x
leb1e:	!byte $3f
leb1f:	!byte $f3
leb20:	and #$2d
leb22:	bne leb7f
leb24:	!byte $22
leb25:	ora ($2b),y
leb27:	!byte $5c
leb28:	eor $de8d,x
leb2b:	sta ($9d),y
leb2d:	!byte $1a
leb2e:	sty $82,x
leb30:	!byte $ff
leb31:	!byte $93
leb32:	!byte $3f
leb33:	!byte $37
leb34:	!byte $34
leb35:	and ($30),y
leb37:	!byte $92
leb38:	!byte $04
leb39:	sec
leb3a:	!byte $35
leb3b:	!byte $32
leb3c:	rol $2a0e
leb3f:	and $3336,y
leb42:	bmi leac7
leb44:	!byte $2f
leb45:	and $8d2b
leb48:	!byte $ff
leb49:	!byte $ff
leb4a:	!byte $ff
leb4b:	!byte $ff
leb4c:	!byte $ff
leb4d:	!byte $ff
leb4e:	!byte $ff
leb4f:	!byte $ff
leb50:	lda ($11,x)
leb52:	ora ($1a,x)
leb54:	!byte $ff
leb55:	!byte $ff
leb56:	ldx #$17
leb58:	!byte $13
leb59:	clc
leb5a:	!byte $03
leb5b:	!byte $ff
leb5c:	!byte $a3
leb5d:	ora $04
leb5f:	asl $16
leb61:	!byte $ff
leb62:	ldy $12
leb64:	!byte $14
leb65:	!byte $07
leb66:	!byte $02
leb67:	!byte $ff
leb68:	lda $a7
leb6a:	ora $0e08,y
leb6d:	!byte $ff
leb6e:	ldx $0a15,y
leb71:	ora $ffff
leb74:	!byte $bb
leb75:	ora #$0b
leb77:	dec $ffff
leb7a:	!byte $bf
leb7b:	!byte $0f
leb7c:	!byte $0c
leb7d:	!byte $dc
leb7e:	!byte $ff
leb7f:	!byte $ff
leb80:	ldy $10bc
leb83:	cpy $ffa8
leb86:	lda #$df
leb88:	tsx
leb89:	!byte $ff
leb8a:	ldx $ff
leb8c:	!byte $ff
leb8d:	!byte $ff
leb8e:	!byte $ff
leb8f:	!byte $ff
leb90:	!byte $ff
leb91:	!byte $ff
leb92:	!byte $b7
leb93:	ldy $b1,x
leb95:	bcs leb44
leb97:	!byte $ff
leb98:	clv
leb99:	lda $b2,x
leb9b:	ldx $ffbd
leb9e:	lda $b3b6,y
leba1:	!byte $db
leba2:	!byte $ff
leba3:	!byte $ff
leba4:	!byte $af
leba5:	tax
leba6:	!byte $ab
leba7:	!byte $ff
leba8:	!byte $ff
leba9:	!byte $44,$cc,$22,$2a,$0d,$52,$55,$4e,$0d	; shift-run text: dload"* CR run CR
lebb2:	!byte $00,$50,$a0,$f0,$40,$90,$e0,$30		; start address-table  screen lines low
		!byte $80,$d0,$20,$70,$c0,$10,$60,$b0
		!byte $00,$50,$a0,$f0,$40,$90,$e0,$30
		!byte $80
lebcb:	!byte $d0,$d0,$d0,$d0,$d1,$d1,$d1,$d2		; start address-table  screen lines high
		!byte $d2,$d2,$d3,$d3,$d3,$d4,$d4,$d4
		!byte $d5,$d5,$d5,$d5,$d6,$d6,$d6,$d7
		!byte $d7
lebe4:	!byte $10,$e3								; address-table control routines
lebe6:	!byte $10,$e3
lebe8:	!byte $10,$e3
lebea:	!byte $1b,$e6
lebec:	!byte $b9,$e4
lebee:	!byte $10,$e3
lebf0:	!byte $10,$e3
lebf2:	!byte $8c,$e4
lebf4:	!byte $10,$e3
lebf6:	!byte $59,$e3
lebf8:	!byte $10,$e3
lebfa:	!byte $10,$e3
lebfc:	!byte $10,$e3
lebfe:	!byte $93,$e3
lec00:	!byte $4c,$e2
lec02:	!byte $bb,$e9
lec04:	!byte $10,$e3
lec06:	!byte $13,$e3
lec08:	!byte $43,$e3
lec0a:	!byte $49,$e3
lec0c:	!byte $ad,$e5
lec0e:	!byte $10,$e3
lec10:	!byte $10,$e3
lec12:	!byte $10,$e3
lec14:	!byte $10,$e3
lec16:	!byte $10,$e3
lec18:	!byte $10,$e3
lec1a:	!byte $10,$e3
lec1c:	!byte $10,$e3
lec1e:	!byte $30,$e3
lec20:	!byte $10,$e3
lec22:	!byte $10,$e3
lec24:	!byte $05,$04,$06,$06,$05,$06,$04,$09		; table length of F-keys commands
		!byte $07,$05
lec2e:	!byte $50
lec2f:	!byte $52
lec30:	eor #$4e
lec32:	!byte $54
lec33:	jmp $5349
lec36:	!byte $54
lec37:	!byte $44
lec38:	jmp $414f
lec3b:	!byte $44
lec3c:	!byte $22
lec3d:	!byte $44
lec3e:	!byte $53
lec3f:	eor ($56,x)
lec41:	eor $22
lec43:	!byte $44
lec44:	!byte $4f
lec45:	bvc lec8c
lec47:	lsr $4344
lec4a:	jmp $534f
lec4d:	eor $43
lec4f:	!byte $4f
lec50:	bvc lecab
lec52:	!byte $44
lec53:	eor #$52
lec55:	eor $43
lec57:	!byte $54
lec58:	!byte $4f
lec59:	!byte $52
lec5a:	eor $4353,y
lec5d:	!byte $52
lec5e:	eor ($54,x)
lec60:	!byte $43
lec61:	pha
lec62:	!byte $43
lec63:	pha
lec64:	!byte $52
lec65:	bit $28
lec67:	!byte $80
lec68:	rti
lec69:	jsr $0810
lec6c:	!byte $04
lec6d:	!byte $02
lec6e:	!byte $01
lec6f:	!byte $6b		; 6f changed from 03b:$6c 6845 R0 hor. total
lec70:	!byte $50
lec71:	!byte $53
lec72:	!byte $0f
lec73:	ora $1903,y
lec76:	ora $0d00,y
lec79:	rts
lec7a:	ora $0000
lec7d:	brk
lec7e:	brk
lec7f:	brk
lec80:	brk
lec81:	ror $6250,x
lec84:	asl
lec85:	!byte $1f
lec86:	asl $19
lec88:	!byte $1c
lec89:	brk
lec8a:	!byte $07
lec8b:	brk
lec8c:	!byte $07
lec8d:	brk
lec8e:	brk
lec8f:	brk
lec90:	brk
lec91:	brk
lec92:	brk
lec93:	!byte $7f
lec94:	!byte $50
		!byte $60
lec96:	asl
lec97:	rol $01
lec99:	ora $001e,y
lec9c:	!byte $07
lec9d:	brk
lec9e:	!byte $07
lec9f:	brk
leca0:	brk
leca1:	brk
leca2:	brk
leca3:	brk
leca4:	brk
leca5:	!byte $2e		; changed from 03b:$65 not documented
leca6:	tax
leca7:	tax
leca8:	tax
leca9:	tax
lecaa:	tax
lecab:	tax
lecac:	tax
lecad:	tax
lecae:	tax
lecaf:	tax
lecb0:	jsr $e536		; new code in 04a 
lecb3:	lda #$00		; some additional  patch subroutines
lecb5:	rts
lecb6:	ora $d0
lecb8:	sta $d0
lecba:	lda $dd
lecbc:	sta $0398
lecbf:	lda $df
lecc1:	rts
lecc2:	bcc lecc7
lecc4:	jmp $f953
lecc7:	php
lecc8:	pha
lecc9:	lda $a0
leccb:	and #$01
leccd:	beq lecd9
leccf:	ldx $9e
lecd1:	jsr $ffc9
lecd4:	jsr $ffcc
lecd7:	ldx $a6
lecd9:	pla
lecda:	plp
lecdb:	rts
lecdc:	pha
lecdd:	lda #$0a
lecdf:	sta $d800
lece2:	lda #$20
lece4:	sta $d801
lece7:	pla
lece8:	rts				; end new code

; **************************************************************************************************

*= $ed00
led00:	ldx $dd
led02:	cpx $dc
led04:	bne led08
led06:	pla
led07:	pla
led08:	bit $039b
led0b:	rts

; **************************************************************************************************

*= $ee00
lee00:	jsr ioinit
lee03:	jsr restor
lee06:	jsr jcint
lee09:	jsr $ffcc
lee0c:	lda #$5a
lee0e:	ldx #$00
lee10:	ldy #$ee
lee12:	jsr $fbca
lee15:	cli
lee16:	lda #$c0
lee18:	sta $0361
lee1b:	lda #$40
lee1d:	sta $bd
lee1f:	bne lee31
lee21:	jsr $ffcc
lee24:	lda #$53
lee26:	sta $bd
lee28:	cld
lee29:	ldx #$05
lee2b:	pla
lee2c:	sta $ae,x
lee2e:	dex
lee2f:	bpl lee2b
lee31:	lda $01
lee33:	sta $b5
lee35:	lda $0300
lee38:	sta $b8
lee3a:	lda $0301
lee3d:	sta $b7
lee3f:	tsx
lee40:	stx $b4
lee42:	cli
lee43:	lda #$08
lee45:	sta $bf
lee47:	ldy $bd
lee49:	jsr $f21c
lee4c:	lda #$52
lee4e:	bne lee77
lee50:	jsr $ef22
lee53:	pla
lee54:	pla
lee55:	lda #$c0
lee57:	sta $0361
lee5a:	lda #$00
lee5c:	sta $90
lee5e:	lda #$02
lee60:	sta $91
lee62:	lda #$0f
lee64:	sta $92
lee66:	jsr $ef27
lee69:	jsr $ffcf
lee6c:	cmp #$2e
lee6e:	beq lee69
lee70:	cmp #$20
lee72:	beq lee69
lee74:	jmp ($031e)
lee77:	ldx #$00
lee79:	stx $9d
lee7b:	tay
lee7c:	lda #$ee
lee7e:	pha
lee7f:	lda #$54
lee81:	pha
lee82:	tya
lee83:	cmp $eed5,x
lee86:	bne lee98
lee88:	sta $0366
lee8b:	lda $eed6,x
lee8e:	sta $b9
lee90:	lda $eed7,x
lee93:	sta $ba
lee95:	jmp ($00b9)
lee98:	inx
lee99:	inx
lee9a:	inx
lee9b:	cpx #$24
lee9d:	bcc lee83
lee9f:	ldx #$00
leea1:	cmp #$0d
leea3:	beq leeb2
leea5:	cmp #$20
leea7:	beq leeb2
leea9:	sta $0200,x
leeac:	jsr $ffcf
leeaf:	inx
leeb0:	bne leea1
leeb2:	sta $bd
leeb4:	txa
leeb5:	beq leed4
leeb7:	sta $9d
leeb9:	lda #$40
leebb:	sta $0361
leebe:	lda $bf
leec0:	sta $9f
leec2:	lda #$0f
leec4:	sta $01
leec6:	ldx #$ff
leec8:	ldy #$ff
leeca:	jsr $ffd5
leecd:	bcs leed4
leecf:	lda $bd
leed1:	jmp ($0099)
leed4:	rts
leed5:	!byte $3a
leed6:	sbc $ef,x
leed8:	!byte $3b
leed9:	!byte $cb
leeda:	!byte $ef
leedb:	!byte $52
leedc:	jmp $4def
leedf:	!byte $8f
leee0:	!byte $ef
leee1:	!byte $47
leee2:	bpl leed4
leee4:	jmp $f04a
leee7:	!byte $53
leee8:	!byte $4a,$f0
leeea:	!byte $56
leeeb:	sbc ($ef,x)
leeed:	rti
leeee:	adc $f1
leef0:	!byte $5a
leef1:	!byte $72
leef2:	!byte $ff
leef3:	cli
leef4:	sbc $55ee,y
leef7:	!byte $eb
leef8:	!byte $ef
leef9:	pla
leefa:	pla
leefb:	sei
leefc:	jmp ($03f8)
leeff:	lda $b9
lef01:	sta $af
lef03:	lda $ba
lef05:	sta $ae
lef07:	rts
lef08:	lda #$b0
lef0a:	sta $b9
lef0c:	lda #$00
lef0e:	sta $ba
lef10:	lda #$0f
lef12:	sta $01
lef14:	lda #$05
lef16:	rts
lef17:	pha
lef18:	jsr $ef27
lef1b:	pla
lef1c:	jsr $ffd2
lef1f:	lda #$20
lef21:	bit $3fa9
lef24:	jmp $ffd2
lef27:	lda #$0d
lef29:	jsr $ffd2
lef2c:	lda #$2e
lef2e:	jmp $ffd2
lef31:	ora $2020
lef34:	jsr $4350
lef37:	jsr $4920
lef3a:	!byte $52
lef3b:	eor ($20),y
lef3d:	jsr $5253
lef40:	jsr $4341
lef43:	jsr $5258
lef46:	jsr $5259
lef49:	jsr $5053
lef4c:	ldx #$00
lef4e:	lda $ef31,x
lef51:	jsr $ffd2
lef54:	inx
lef55:	cpx #$1b
lef57:	bne lef4e
lef59:	lda #$3b
lef5b:	jsr $ef17
lef5e:	ldx $ae
lef60:	ldy $af
lef62:	jsr $f0f6
lef65:	jsr $ef1f
lef68:	ldx $b7
lef6a:	ldy $b8
lef6c:	jsr $f0f6
lef6f:	jsr $ef08
lef72:	sta $bd
lef74:	ldy #$00
lef76:	sty $9d
lef78:	jsr $ef1f
lef7b:	lda ($b9),y
lef7d:	jsr $f0fb
lef80:	inc $b9
lef82:	bne lef8a
lef84:	inc $ba
lef86:	bne lef8a
lef88:	dec $9d
lef8a:	dec $bd
lef8c:	bne lef78
lef8e:	rts
lef8f:	jsr $f040
lef92:	jsr $f113
lef95:	jsr $f123
lef98:	bcc lefa2
lef9a:	lda $bb
lef9c:	sta $b9
lef9e:	lda $bc
lefa0:	sta $ba
lefa2:	jsr $f113
lefa5:	jsr $ffe1
lefa8:	beq lefca
lefaa:	lda #$3a
lefac:	jsr $ef17
lefaf:	ldx $ba
lefb1:	ldy $b9
lefb3:	jsr $f0f6
lefb6:	lda #$10
lefb8:	jsr $ef72
lefbb:	lda $9d
lefbd:	bne lefca
lefbf:	sec
lefc0:	lda $bb
lefc2:	sbc $b9
lefc4:	lda $bc
lefc6:	sbc $ba
lefc8:	bcs lefa5
lefca:	rts
lefcb:	jsr $f040
lefce:	jsr $eeff
lefd1:	jsr $f040
lefd4:	lda $b9
lefd6:	sta $b8
lefd8:	lda $ba
lefda:	sta $b7
lefdc:	jsr $ef08
lefdf:	bne leffa
lefe1:	jsr $f03a
lefe4:	cmp #$10
lefe6:	bcs lf047
lefe8:	sta $01
lefea:	rts
lefeb:	jsr $f03a
lefee:	cmp #$20
leff0:	bcs lf047
leff2:	sta $bf
leff4:	rts
leff5:	jsr $f040
leff8:	lda #$10
leffa:	sta $bd
leffc:	jsr $f130
lefff:	bcs lf00f
lf001:	ldy #$00
lf003:	sta ($b9),y
lf005:	inc $b9
lf007:	bne lf00b
lf009:	inc $ba
lf00b:	dec $bd
lf00d:	bne leffc
lf00f:	rts
lf010:	jsr $f15f
lf013:	beq lf01b
lf015:	jsr $f040
lf018:	jsr $eeff
lf01b:	ldx $b4
lf01d:	txs
lf01e:	sei
lf01f:	lda $b7
lf021:	sta $0301
lf024:	lda $b8
lf026:	sta $0300
lf029:	lda $b5
lf02b:	sta $01
lf02d:	ldx #$00
lf02f:	lda $ae,x
lf031:	pha
lf032:	inx
lf033:	cpx #$06
lf035:	bne lf02f
lf037:	jmp $fca5
lf03a:	jsr $f130
lf03d:	bcs lf045
lf03f:	rts
lf040:	jsr $f123
lf043:	bcc lf03f
lf045:	pla
lf046:	pla
lf047:	jmp $ee50
lf04a:	ldy #$01
lf04c:	sty $9f
lf04e:	dey
lf04f:	lda #$ff
lf051:	sta $b9
lf053:	sta $ba
lf055:	lda $01
lf057:	sta $be
lf059:	lda #$0f
lf05b:	sta $01
lf05d:	jsr $f15f
lf060:	beq lf07e
lf062:	cmp #$20
lf064:	beq lf05d
lf066:	cmp #$22
lf068:	bne lf047
lf06a:	jsr $f15f
lf06d:	beq lf07e
lf06f:	cmp #$22
lf071:	beq lf090
lf073:	sta ($90),y
lf075:	inc $9d
lf077:	iny
lf078:	cpy #$10
lf07a:	beq lf047
lf07c:	bne lf06a
lf07e:	lda $0366
lf081:	cmp #$4c
lf083:	bne lf068
lf085:	lda $be
lf087:	and #$0f
lf089:	ldx $b9
lf08b:	ldy $ba
lf08d:	jmp $ffd5
lf090:	jsr $f15f
lf093:	beq lf07e
lf095:	cmp #$2c
lf097:	bne lf068
lf099:	jsr $f03a
lf09c:	sta $9f
lf09e:	jsr $f15f
lf0a1:	beq lf07e
lf0a3:	cmp #$2c
lf0a5:	bne lf097
lf0a7:	jsr $f03a
lf0aa:	cmp #$10
lf0ac:	bcs lf0f3
lf0ae:	sta $be
lf0b0:	sta $9b
lf0b2:	jsr $f040
lf0b5:	lda $b9
lf0b7:	sta $99
lf0b9:	lda $ba
lf0bb:	sta $9a
lf0bd:	jsr $f15f
lf0c0:	beq lf07e
lf0c2:	cmp #$2c
lf0c4:	bne lf0f3
lf0c6:	jsr $f03a
lf0c9:	cmp #$10
lf0cb:	bcs lf0f3
lf0cd:	sta $98
lf0cf:	jsr $f040
lf0d2:	lda $b9
lf0d4:	sta $96
lf0d6:	lda $ba
lf0d8:	sta $97
lf0da:	jsr $ffcf
lf0dd:	cmp #$20
lf0df:	beq lf0da
lf0e1:	cmp #$0d
lf0e3:	bne lf0a5
lf0e5:	lda $0366
lf0e8:	cmp #$53
lf0ea:	bne lf0e3
lf0ec:	ldx #$99
lf0ee:	ldy #$96
lf0f0:	jmp $ffd8
lf0f3:	jmp $ee50
lf0f6:	txa
lf0f7:	jsr $f0fb
lf0fa:	tya
lf0fb:	pha
lf0fc:	lsr
lf0fd:	lsr
lf0fe:	lsr
lf0ff:	lsr
lf100:	jsr $f107
lf103:	tax
lf104:	pla
lf105:	and #$0f
lf107:	clc
lf108:	adc #$f6
lf10a:	bcc lf10e
lf10c:	adc #$06
lf10e:	adc #$3a
lf110:	jmp $ffd2
lf113:	ldx #$02
lf115:	lda $b8,x
lf117:	pha
lf118:	lda $ba,x
lf11a:	sta $b8,x
lf11c:	pla
lf11d:	sta $ba,x
lf11f:	dex
lf120:	bne lf115
lf122:	rts
lf123:	jsr $f130
lf126:	bcs lf12f
lf128:	sta $ba
lf12a:	jsr $f130
lf12d:	sta $b9
lf12f:	rts
lf130:	lda #$00
lf132:	sta $0100
lf135:	jsr $f15f
lf138:	beq lf153
lf13a:	cmp #$20
lf13c:	beq lf130
lf13e:	jsr $f154
lf141:	asl
lf142:	asl
lf143:	asl
lf144:	asl
lf145:	sta $0100
lf148:	jsr $f15f
lf14b:	beq lf153
lf14d:	jsr $f154
lf150:	ora $0100
lf153:	rts
lf154:	cmp #$3a
lf156:	php
lf157:	and #$0f
lf159:	plp
lf15a:	bcc lf15e
lf15c:	adc #$08
lf15e:	rts
lf15f:	jsr $ffcf
lf162:	cmp #$0d
lf164:	rts
lf165:	lda #$00
lf167:	sta $9c
lf169:	sta $9d
lf16b:	ldx $bf
lf16d:	ldy #$0f
lf16f:	jsr $fb43
lf172:	clc
lf173:	jsr $ffc0
lf176:	bcs lf1ba
lf178:	jsr $f15f
lf17b:	beq lf19a
lf17d:	pha
lf17e:	ldx #$00
lf180:	jsr $ffc9
lf183:	pla
lf184:	bcs lf1ba
lf186:	bcc lf18b
lf188:	jsr $ffcf
lf18b:	cmp #$0d
lf18d:	php
lf18e:	jsr $ffd2
lf191:	lda $9c
lf193:	bne lf1b6
lf195:	plp
lf196:	bne lf188
lf198:	beq lf1ba
lf19a:	jsr $ef27
lf19d:	ldx #$00
lf19f:	jsr $ffc6
lf1a2:	bcs lf1ba
lf1a4:	jsr $f15f
lf1a7:	php
lf1a8:	jsr $ffd2
lf1ab:	lda $9c
lf1ad:	and #$bf
lf1af:	bne lf1b6
lf1b1:	plp
lf1b2:	bne lf1a4
lf1b4:	beq lf1ba
lf1b6:	pla
lf1b7:	jsr $f945
lf1ba:	jsr $ffcc
lf1bd:	lda #$00
lf1bf:	clc
lf1c0:	jmp $ffc3
lf1c3:	ora $2f49
lf1c6:	!byte $4f
lf1c7:	jsr $5245
lf1ca:	!byte $52
lf1cb:	!byte $4f
lf1cc:	!byte $52
lf1cd:	jsr $0da3
lf1d0:	!byte $53
lf1d1:	eor $41
lf1d3:	!byte $52
lf1d4:	!byte $43
lf1d5:	pha
lf1d6:	eor #$4e
lf1d8:	!byte $47
lf1d9:	ldy #$46
lf1db:	!byte $4f
lf1dc:	!byte $52
lf1dd:	ldy #$0d
lf1df:	jmp $414f
lf1e2:	!byte $44
lf1e3:	eor #$4e
lf1e5:	!byte $c7
lf1e6:	ora $4153
lf1e9:	lsr $49,x
lf1eb:	lsr $a047
lf1ee:	ora $4556
lf1f1:	!byte $52
lf1f2:	eor #$46
lf1f4:	eor $4e49,y
lf1f7:	!byte $c7
lf1f8:	ora $4f46
lf1fb:	eor $4e,x
lf1fd:	!byte $44
lf1fe:	ldy #$0d
lf200:	!byte $4f
lf201:	!byte $4b
lf202:	sta $2a0d
lf205:	rol
lf206:	jsr $4f4d
lf209:	lsr $5449
lf20c:	!byte $4f
lf20d:	!byte $52
lf20e:	jsr $2e31
lf211:	!byte $30,$20
lf213:	rol
lf214:	rol
lf215:	sta $420d
lf218:	!byte $52
lf219:	eor $41
lf21b:	!byte $cb
lf21c:	bit $0361
lf21f:	bpl lf22e
lf221:	lda $f1c3,y
lf224:	php
lf225:	and #$7f
lf227:	jsr $ffd2
lf22a:	iny
lf22b:	plp
lf22c:	bpl lf221
lf22e:	clc
lf22f:	rts
lf230:	ora #$40
lf232:	bne lf236
lf234:	ora #$20
lf236:	pha
lf237:	lda #$3f
lf239:	sta $de03
lf23c:	lda #$ff
lf23e:	sta $dc00
lf241:	sta $dc02
lf244:	lda #$fa
lf246:	sta $de00
lf249:	lda $aa
lf24b:	bpl lf268
lf24d:	lda $de00
lf250:	and #$df
lf252:	sta $de00
lf255:	lda $ab
lf257:	jsr $f2b9
lf25a:	lda $aa
lf25c:	and #$7f
lf25e:	sta $aa
lf260:	lda $de00
lf263:	ora #$20
lf265:	sta $de00
lf268:	lda $de00
lf26b:	and #$f7
lf26d:	sta $de00
lf270:	pla
lf271:	jmp $f2b9
lf274:	jsr $f2b9
lf277:	lda $de00
lf27a:	ora #$08
lf27c:	sta $de00
lf27f:	rts
lf280:	jsr $f2b9
lf283:	lda #$39
lf285:	and $de00
lf288:	sta $de00
lf28b:	lda #$c7
lf28d:	sta $de03
lf290:	lda #$00
lf292:	sta $dc02
lf295:	beq lf277
lf297:	pha
lf298:	lda $aa
lf29a:	bpl lf2a3
lf29c:	lda $ab
lf29e:	jsr $f2b9
lf2a1:	lda $aa
lf2a3:	ora #$80
lf2a5:	sta $aa
lf2a7:	pla
lf2a8:	sta $ab
lf2aa:	rts
lf2ab:	lda #$5f
lf2ad:	bne lf2b1
lf2af:	lda #$3f
lf2b1:	jsr $f236
lf2b4:	lda #$f8		; changed from 03b:$f9 unlisten IEC bus parameter
lf2b6:	jmp $f288
lf2b9:	eor #$ff
lf2bb:	sta $dc00
lf2be:	lda $de00
lf2c1:	ora #$12
lf2c3:	sta $de00
lf2c6:	bit $de00
lf2c9:	bvc lf2d4
lf2cb:	bpl lf2d4
lf2cd:	lda #$80
lf2cf:	jsr $fb5f
lf2d2:	bne lf304
lf2d4:	lda $de00
lf2d7:	bpl lf2d4
lf2d9:	and #$ef
lf2db:	sta $de00
lf2de:	jsr $f36f
lf2e1:	bcc lf2e4
lf2e3:	sec
lf2e4:	bit $de00
lf2e7:	bvs lf2fc
lf2e9:	lda $dc0d
lf2ec:	and #$02
lf2ee:	beq lf2e4
lf2f0:	lda $035e
lf2f3:	bmi lf2de
lf2f5:	bcc lf2e3
lf2f7:	lda #$01
lf2f9:	jsr $fb5f
lf2fc:	lda $de00
lf2ff:	ora #$10
lf301:	sta $de00
lf304:	lda #$ff
lf306:	sta $dc00
lf309:	rts
lf30a:	lda $de00
lf30d:	and #$b9
lf30f:	ora #$80		; changed from 03b:$81 unlisten IEC bus or value
lf311:	sta $de00
lf314:	jsr $f36f
lf317:	bcc lf31a
lf319:	sec
lf31a:	lda $de00
lf31d:	and #$10
lf31f:	beq lf33f
lf321:	lda $dc0d
lf324:	and #$02
lf326:	beq lf31a
lf328:	lda $035e
lf32b:	bmi lf314
lf32d:	bcc lf319
lf32f:	lda #$02
lf331:	jsr $fb5f
lf334:	lda $de00
lf337:	and #$3d
lf339:	sta $de00
lf33c:	lda #$0d
lf33e:	rts
lf33f:	lda $de00
lf342:	and #$7f
lf344:	sta $de00
lf347:	and #$20
lf349:	bne lf350
lf34b:	lda #$40
lf34d:	jsr $fb5f
lf350:	lda $dc00
lf353:	eor #$ff
lf355:	pha
lf356:	lda $de00
lf359:	ora #$40
lf35b:	sta $de00
lf35e:	lda $de00
lf361:	and #$10
lf363:	beq lf35e
lf365:	lda $de00
lf368:	and #$bf
lf36a:	sta $de00
lf36d:	pla
lf36e:	rts
lf36f:	lda #$ff
lf371:	sta $dc07
lf374:	lda #$11
lf376:	sta $dc0f
lf379:	lda $dc0d
lf37c:	clc
lf37d:	rts
lf37e:	jmp $f951
lf381:	jsr $f42e
lf384:	ldy #$00
lf386:	cpy $9d
lf388:	beq lf395
lf38a:	jsr $fe92
lf38d:	sta $0376,y
lf390:	iny
lf391:	cpy #$04
lf393:	bne lf386
lf395:	lda $0376
lf398:	sta $dd03
lf39b:	lda $0377
lf39e:	and #$f2
lf3a0:	ora #$02
lf3a2:	sta $dd02
lf3a5:	clc
lf3a6:	lda $a0
lf3a8:	and #$02
lf3aa:	beq lf3c1
lf3ac:	lda $037d
lf3af:	sta $037c
lf3b2:	lda $a8
lf3b4:	and #$f0
lf3b6:	beq lf3c1
lf3b8:	jsr $f3fc
lf3bb:	sta $a8
lf3bd:	stx $a6
lf3bf:	sty $a7
lf3c1:	jmp $ecc2		; jmp to 04a patch - output IO error
lf3c4:	nop
lf3c5:	nop
lf3c6:	rts
lf3c7:	cmp #$41
lf3c9:	bcc lf3db
lf3cb:	cmp #$5b
lf3cd:	bcs lf3d1
lf3cf:	ora #$20
lf3d1:	cmp #$c1
lf3d3:	bcc lf3db
lf3d5:	cmp #$db
lf3d7:	bcs lf3db
lf3d9:	and #$7f
lf3db:	rts
lf3dc:	cmp #$41
lf3de:	bcc lf3f0
lf3e0:	cmp #$5b
lf3e2:	bcs lf3e6
lf3e4:	ora #$80
lf3e6:	cmp #$61
lf3e8:	bcc lf3f0
lf3ea:	cmp #$7b
lf3ec:	bcs lf3f0
lf3ee:	and #$df
lf3f0:	rts
lf3f1:	lda $dd02
lf3f4:	ora #$09
lf3f6:	and #$fb
lf3f8:	sta $dd02
lf3fb:	rts
lf3fc:	ldx #$00
lf3fe:	ldy #$01
lf400:	txa
lf401:	sec
lf402:	eor #$ff
lf404:	adc $0355
lf407:	tax
lf408:	tya
lf409:	eor #$ff
lf40b:	adc $0356
lf40e:	tay
lf40f:	lda $0357
lf412:	bcs lf41a
lf414:	lda #$ff
lf416:	ora #$40
lf418:	sec
lf419:	rts
lf41a:	cpy $035c
lf41d:	bcc lf416
lf41f:	bne lf426
lf421:	cpx $035b
lf424:	bcc lf416
lf426:	stx $0355
lf429:	sty $0356
lf42c:	clc
lf42d:	rts
lf42e:	php
lf42f:	sei
lf430:	lda $dd01
lf433:	and #$60
lf435:	sta $037a
lf438:	sta $037b
lf43b:	plp
lf43c:	rts
lf43d:	lda $a1
lf43f:	bne lf44d
lf441:	lda $d1
lf443:	ora $d6
lf445:	beq lf49a
lf447:	sei
lf448:	jsr $e007
lf44b:	clc
lf44c:	rts
lf44d:	cmp #$02
lf44f:	beq lf454
lf451:	jmp $ffcf
lf454:	sty $0365
lf457:	stx $0366
lf45a:	ldy $037c
lf45d:	cpy $037d
lf460:	bne lf478
lf462:	lda $dd02
lf465:	and #$fd
lf467:	ora #$01
lf469:	sta $dd02
lf46c:	lda $037a
lf46f:	ora #$10
lf471:	sta $037a
lf474:	lda #$00
lf476:	beq lf494
lf478:	lda $037a
lf47b:	and #$ef
lf47d:	sta $037a
lf480:	ldx $01
lf482:	lda $a8
lf484:	sta $01
lf486:	lda ($a6),y
lf488:	stx $01
lf48a:	inc $037c
lf48d:	bit $a0
lf48f:	bpl lf494
lf491:	jsr $f3dc
lf494:	ldy $0365
lf497:	ldx $0366
lf49a:	clc
lf49b:	rts
lf49c:	lda $a1
lf49e:	bne lf4ab
lf4a0:	lda $cb
lf4a2:	sta $ce
lf4a4:	lda $ca
lf4a6:	sta $cf
lf4a8:	jmp $f4b5
lf4ab:	cmp #$03
lf4ad:	bne lf4ba
lf4af:	jsr $ecb6		; jmp to 04a patch - RS232 input
lf4b2:	nop
lf4b3:	sta $d5
lf4b5:	jsr $e00a
lf4b8:	clc
lf4b9:	rts
lf4ba:	bcs lf4c3
lf4bc:	cmp #$02
lf4be:	beq lf4d0
lf4c0:	jsr $fe5a
lf4c3:	lda $9c
lf4c5:	beq lf4cb
lf4c7:	lda #$0d
lf4c9:	clc
lf4ca:	rts
lf4cb:	jsr $ffa5
lf4ce:	clc
lf4cf:	rts
lf4d0:	jsr $ffe4
lf4d3:	bcs lf4ca
lf4d5:	cmp #$00
lf4d7:	bne lf4c9
lf4d9:	lda $037a
lf4dc:	and #$10
lf4de:	beq lf4c9
lf4e0:	lda $037a
lf4e3:	and #$60
lf4e5:	bne lf4c7
lf4e7:	jsr $ffe1
lf4ea:	bne lf4d0
lf4ec:	sec
lf4ed:	rts
lf4ee:	pha
lf4ef:	lda $a2
lf4f1:	cmp #$03
lf4f3:	bne lf4fb
lf4f5:	pla
lf4f6:	jsr $e00d
lf4f9:	clc
lf4fa:	rts
lf4fb:	bcc lf503
lf4fd:	pla
lf4fe:	jsr $ffa8
lf501:	clc
lf502:	rts
lf503:	cmp #$02
lf505:	beq lf511
lf507:	pla
lf508:	jsr $fe5a
lf50b:	pla
lf50c:	bcc lf510
lf50e:	lda #$00
lf510:	rts
lf511:	stx $0363
lf514:	sty $0364
lf517:	lda $037a
lf51a:	and #$60
lf51c:	bne lf540
lf51e:	pla
lf51f:	bit $a0
lf521:	bpl lf526
lf523:	jsr $f3c7
lf526:	sta $dd00
lf529:	pha
lf52a:	lda $037a
lf52d:	and #$60
lf52f:	bne lf540
lf531:	lda $dd01
lf534:	and #$10
lf536:	bne lf540
lf538:	jsr $ffe1
lf53b:	bne lf52a
lf53d:	sec
lf53e:	bcs lf50b
lf540:	pla
lf541:	ldx $0363
lf544:	ldy $0364
lf547:	clc
lf548:	rts
lf549:	jsr $f63e
lf54c:	beq lf551
lf54e:	jmp $f93f
lf551:	jsr $f650
lf554:	lda $9f
lf556:	beq lf586
lf558:	cmp #$03
lf55a:	beq lf586
lf55c:	bcs lf58a
lf55e:	cmp #$02
lf560:	bne lf580
lf562:	lda $a0
lf564:	and #$02
lf566:	beq lf583
lf568:	and $dd02
lf56b:	beq lf57c
lf56d:	eor #$ff
lf56f:	and $dd02
lf572:	ora #$01
lf574:	pha
lf575:	jsr $f42e
lf578:	pla
lf579:	sta $dd02
lf57c:	lda #$02
lf57e:	bne lf586
lf580:	jsr $fe5a
lf583:	jmp $f948
lf586:	sta $a1
lf588:	clc
lf589:	rts
lf58a:	tax
lf58b:	jsr $ffb4
lf58e:	lda $a0
lf590:	bpl lf598
lf592:	jsr $f283
lf595:	jmp $f59b
lf598:	jsr $ff96
lf59b:	txa
lf59c:	bit $9c
lf59e:	bpl lf586
lf5a0:	jmp $f945
lf5a3:	jsr $f63e
lf5a6:	beq lf5ab
lf5a8:	jmp $f93f
lf5ab:	jsr $f650
lf5ae:	lda $9f
lf5b0:	bne lf5b5
lf5b2:	jmp $f94b
lf5b5:	cmp #$03
lf5b7:	beq lf5d1
lf5b9:	bcs lf5d5
lf5bb:	cmp #$02
lf5bd:	bne lf5ce
lf5bf:	lda $a0
lf5c1:	lsr
lf5c2:	bcc lf5b2
lf5c4:	jsr $f42e
lf5c7:	jsr $f3f1
lf5ca:	lda #$02
lf5cc:	bne lf5d1
lf5ce:	jsr $fe5a
lf5d1:	sta $a2
lf5d3:	clc
lf5d4:	rts
lf5d5:	tax
lf5d6:	jsr $ffb1
lf5d9:	lda $a0
lf5db:	bpl lf5e2
lf5dd:	jsr $f277
lf5e0:	bne lf5e5
lf5e2:	jsr $ff93
lf5e5:	txa
lf5e6:	bit $9c
lf5e8:	bpl lf5d1
lf5ea:	jmp $f945
lf5ed:	php
lf5ee:	jsr $f643
lf5f1:	beq lf5f6
lf5f3:	plp
lf5f4:	clc
lf5f5:	rts
lf5f6:	jsr $f650
lf5f9:	plp
lf5fa:	txa
lf5fb:	pha
lf5fc:	bcc lf61d
lf5fe:	lda $9f
lf600:	beq lf61d
lf602:	cmp #$03
lf604:	beq lf61d
lf606:	bcs lf61a
lf608:	cmp #$02
lf60a:	bne lf613
lf60c:	lda #$00
lf60e:	sta $dd02
lf611:	beq lf61d
lf613:	pla
lf614:	jsr $f61e
lf617:	jsr $fe5a
lf61a:	jsr $f8bf
lf61d:	pla
lf61e:	tax
lf61f:	dec $0360
lf622:	cpx $0360
lf625:	beq lf63c
lf627:	ldy $0360
lf62a:	lda $0334,y
lf62d:	sta $0334,x
lf630:	lda $033e,y
lf633:	sta $033e,x
lf636:	lda $0348,y
lf639:	sta $0348,x
lf63c:	clc
lf63d:	rts
lf63e:	lda #$00
lf640:	sta $9c
lf642:	txa
lf643:	ldx $0360
lf646:	dex
lf647:	bmi lf676
lf649:	cmp $0334,x
lf64c:	bne lf646
lf64e:	clc
lf64f:	rts
lf650:	lda $0334,x
lf653:	sta $9e
lf655:	lda $033e,x
lf658:	sta $9f
lf65a:	lda $0348,x
lf65d:	sta $a0
lf65f:	rts
lf660:	tya
lf661:	ldx $0360
lf664:	dex
lf665:	bmi lf676
lf667:	cmp $0348,x
lf66a:	bne lf664
lf66c:	clc
lf66d:	jsr $f650
lf670:	tay
lf671:	lda $9e
lf673:	ldx $9f
lf675:	rts
lf676:	sec
lf677:	rts
lf678:	tax
lf679:	jsr $f63e
lf67c:	bcc lf66d
lf67e:	rts
lf67f:	ror $0365
lf682:	sta $0366
lf685:	ldx $0360
lf688:	dex
lf689:	bmi lf6a6
lf68b:	bit $0365
lf68e:	bpl lf698
lf690:	lda $0366
lf693:	cmp $033e,x
lf696:	bne lf688
lf698:	lda $0334,x
lf69b:	sec
lf69c:	jsr $ffc3
lf69f:	bcc lf685
lf6a1:	lda #$00
lf6a3:	sta $0360
lf6a6:	ldx #$03
lf6a8:	cpx $a2
lf6aa:	bcs lf6af
lf6ac:	jsr $ffae
lf6af:	cpx $a1
lf6b1:	bcs lf6b6
lf6b3:	jsr $ffab
lf6b6:	ldx #$03
lf6b8:	stx $a2
lf6ba:	lda #$00
lf6bc:	sta $a1
lf6be:	rts
lf6bf:	bcc lf6c4
lf6c1:	jmp $f73a
lf6c4:	ldx $9e
lf6c6:	jsr $f63e
lf6c9:	bne lf6ce
lf6cb:	jmp $f93c
lf6ce:	ldx $0360
lf6d1:	cpx #$0a
lf6d3:	bcc lf6d8
lf6d5:	jmp $f939
lf6d8:	inc $0360
lf6db:	lda $9e
lf6dd:	sta $0334,x
lf6e0:	lda $a0
lf6e2:	ora #$60
lf6e4:	sta $a0
lf6e6:	sta $0348,x
lf6e9:	lda $9f
lf6eb:	sta $033e,x
lf6ee:	beq lf705
lf6f0:	cmp #$03
lf6f2:	beq lf705
lf6f4:	bcc lf6fb
lf6f6:	jsr $f707
lf6f9:	bcc lf705
lf6fb:	cmp #$02
lf6fd:	bne lf702
lf6ff:	jmp $f381
lf702:	jsr $fe5a
lf705:	clc
lf706:	rts
lf707:	lda $a0
lf709:	bmi lf738
lf70b:	ldy $9d
lf70d:	beq lf738
lf70f:	lda $9f
lf711:	jsr $ffb1
lf714:	lda $a0
lf716:	ora #$f0
lf718:	jsr $ff93
lf71b:	lda $9c
lf71d:	bpl lf724
lf71f:	pla
lf720:	pla
lf721:	jmp $f945
lf724:	lda $9d
lf726:	beq lf735
lf728:	ldy #$00
lf72a:	jsr $fe92
lf72d:	jsr $ffa8
lf730:	iny
lf731:	cpy $9d
lf733:	bne lf72a
lf735:	jsr $ffae
lf738:	clc
lf739:	rts
lf73a:	lda $9f
lf73c:	jsr $ffb1
lf73f:	lda #$6f
lf741:	sta $a0
lf743:	jmp $f718
lf746:	stx $036f
lf749:	sty $0370
lf74c:	sta $035f
lf74f:	sta $0371
lf752:	lda #$00
lf754:	sta $9c
lf756:	lda $9f
lf758:	bne lf75d
lf75a:	jmp $f951
lf75d:	cmp #$03
lf75f:	beq lf75a
lf761:	bcs lf766
lf763:	jmp $f810
lf766:	lda #$60
lf768:	sta $a0
lf76a:	ldy $9d
lf76c:	bne lf771
lf76e:	jmp $f94e
lf771:	jsr $f81b
lf774:	jsr $f707
lf777:	lda $9f
lf779:	jsr $ffb4
lf77c:	lda $a0
lf77e:	jsr $ff96
lf781:	jsr $ffa5
lf784:	sta $96
lf786:	sta $99
lf788:	lda $9c
lf78a:	lsr
lf78b:	lsr
lf78c:	bcc lf791
lf78e:	jmp $f942
lf791:	jsr $ffa5
lf794:	sta $97
lf796:	sta $9a
lf798:	jsr $f840
lf79b:	lda $0371
lf79e:	sta $98
lf7a0:	sta $9b
lf7a2:	lda $036f
lf7a5:	and $0370
lf7a8:	cmp #$ff
lf7aa:	beq lf7ba
lf7ac:	lda $036f
lf7af:	sta $96
lf7b1:	sta $99
lf7b3:	lda $0370
lf7b6:	sta $97
lf7b8:	sta $9a
lf7ba:	lda #$fd
lf7bc:	and $9c
lf7be:	sta $9c
lf7c0:	jsr $ffe1
lf7c3:	bne lf7c8
lf7c5:	jmp $f8b3
lf7c8:	jsr $ffa5
lf7cb:	tax
lf7cc:	lda $9c
lf7ce:	lsr
lf7cf:	lsr
lf7d0:	bcs lf7ba
lf7d2:	txa
lf7d3:	ldx $01
lf7d5:	ldy $98
lf7d7:	sty $01
lf7d9:	ldy #$00
lf7db:	bit $035f
lf7de:	bpl lf7f0-2
lf7e0:	sta $93
lf7e2:	lda ($96),y
lf7e4:	cmp $93
lf7e6:	beq lf7f0
lf7e8:	lda #$10
lf7ea:	jsr $fb5f
lf7ed:	lda $9691
lf7f0:	stx $01
lf7f2:	inc $96
lf7f4:	bne lf800
lf7f6:	inc $97
lf7f8:	bne lf800
lf7fa:	inc $98
lf7fc:	lda #$02
lf7fe:	sta $96
lf800:	bit $9c
lf802:	bvc lf7ba
lf804:	jsr $ffab
lf807:	jsr $f8bf
lf80a:	jmp $f813
lf80d:	jmp $f942
lf810:	jsr $fe5a
lf813:	clc
lf814:	lda $98
lf816:	ldx $96
lf818:	ldy $97
lf81a:	rts
lf81b:	bit $0361
lf81e:	bpl lf83f
lf820:	ldy #$0c
lf822:	jsr $f21c
lf825:	lda $9d
lf827:	beq lf83f
lf829:	ldy #$17
lf82b:	jsr $f21c
lf82e:	ldy $9d
lf830:	beq lf83f
lf832:	ldy #$00
lf834:	jsr $fe92
lf837:	jsr $ffd2
lf83a:	iny
lf83b:	cpy $9d
lf83d:	bne lf834
lf83f:	rts
lf840:	ldy #$1b
lf842:	lda $035f
lf845:	bpl lf849
lf847:	ldy #$2b
lf849:	jmp $f21c
lf84c:	lda $00,x
lf84e:	sta $99
lf850:	lda $01,x
lf852:	sta $9a
lf854:	lda $02,x
lf856:	sta $9b
lf858:	tya
lf859:	tax
lf85a:	lda $00,x
lf85c:	sta $96
lf85e:	lda $01,x
lf860:	sta $97
lf862:	lda $02,x
lf864:	sta $98
lf866:	lda $9f
lf868:	bne lf86d
lf86a:	jmp $f951
lf86d:	cmp #$03
lf86f:	beq lf86a
lf871:	bcc lf8d6
lf873:	lda #$61
lf875:	sta $a0
lf877:	ldy $9d
lf879:	bne lf87e
lf87b:	jmp $f94e
lf87e:	jsr $f707
lf881:	jsr $f8d9
lf884:	lda $9f
lf886:	jsr $ffb1
lf889:	lda $a0
lf88b:	jsr $ff93
lf88e:	ldx $01
lf890:	jsr $fe62
lf893:	lda $93
lf895:	jsr $ffa8
lf898:	lda $94
lf89a:	jsr $ffa8
lf89d:	ldy #$00
lf89f:	jsr $fe71
lf8a2:	bcs lf8ba
lf8a4:	lda ($93),y
lf8a6:	jsr $ffa8
lf8a9:	jsr $fe7f
lf8ac:	jsr $ffe1
lf8af:	bne lf89f
lf8b1:	stx $01
lf8b3:	jsr $f8bf
lf8b6:	lda #$00
lf8b8:	sec
lf8b9:	rts
lf8ba:	stx $01
lf8bc:	jsr $ffae
lf8bf:	bit $a0
lf8c1:	bmi lf8d4
lf8c3:	lda $9f
lf8c5:	jsr $ffb1
lf8c8:	lda $a0
lf8ca:	and #$ef
lf8cc:	ora #$e0
lf8ce:	jsr $ff93
lf8d1:	jsr $ffae
lf8d4:	clc
lf8d5:	rts
lf8d6:	jsr $fe5a
lf8d9:	lda $0361
lf8dc:	bpl lf8d5
lf8de:	ldy #$23
lf8e0:	jsr $f21c
lf8e3:	jmp $f82e
lf8e6:	lda $dc08
lf8e9:	pha
lf8ea:	pha
lf8eb:	asl
lf8ec:	asl
lf8ed:	asl
lf8ee:	and #$60
lf8f0:	ora $dc0b
lf8f3:	tay
lf8f4:	pla
lf8f5:	ror
lf8f6:	ror
lf8f7:	and #$80
lf8f9:	ora $dc09
lf8fc:	sta $93
lf8fe:	ror
lf8ff:	and #$80
lf901:	ora $dc0a
lf904:	tax
lf905:	pla
lf906:	cmp $dc08
lf909:	bne lf8e6
lf90b:	lda $93
lf90d:	rts
lf90e:	pha
lf90f:	pha
lf910:	ror
lf911:	and #$80
lf913:	ora $dc0f
lf916:	sta $dc0f
lf919:	tya
lf91a:	rol
lf91b:	rol
lf91c:	rol $93
lf91e:	rol
lf91f:	rol $93
lf921:	txa
lf922:	rol
lf923:	rol $93
lf925:	pla
lf926:	rol
lf927:	rol $93
lf929:	sty $dc0b
lf92c:	stx $dc0a
lf92f:	pla
lf930:	sta $dc09
lf933:	lda $93
lf935:	sta $dc08
lf938:	rts
lf939:	lda #$01
lf93b:	bit $02a9
lf93e:	bit $03a9
lf941:	bit $04a9
lf944:	bit $05a9
lf947:	bit $06a9
lf94a:	bit $07a9
lf94d:	bit $08a9
lf950:	bit $09a9
lf953:	pha
lf954:	jsr $ffcc
lf957:	ldy #$00
lf959:	bit $0361
lf95c:	bvc lf968
lf95e:	jsr $f221
lf961:	pla
lf962:	pha
lf963:	ora #$30
lf965:	jsr $ffd2
lf968:	pla
lf969:	sec
lf96a:	rts
lf96b:	lda $a9
lf96d:	and #$01
lf96f:	bne lf978
lf971:	php
lf972:	jsr $ffcc
lf975:	sta $d1
lf977:	plp
lf978:	rts
lf979:	lda $df02
lf97c:	lsr
lf97d:	bcs lf991
lf97f:	lda #$fe
lf981:	sta $df01
lf984:	lda #$10
lf986:	and $df02
lf989:	bne lf98c
lf98b:	sec
lf98c:	lda #$ff
lf98e:	sta $df01
lf991:	rol
lf992:	sta $a9
lf994:	rts
patall:	!byte $c2,$cd		; test-bytes cbm-rom
start:	ldx #$fe		; ***** system reset *****
lf999:	sei					; disable interrrupts
lf99a:	txs					; init stack
lf99b:	cld					; clear decimal flag
lf99c:	lda #$a5
lf99e:	cmp $03fa			; compare warm start flag
lf9a1:	bne scold			; jump to cold start
lf9a3:	lda $03fb			; load warm start flag
lf9a6:	cmp #$5a
lf9a8:	beq swarm			; jump to warm start
scold:	lda #$06		; ***** system cold start *****
lf9ac:	sta $96				; init load/store variables
lf9ae:	lda #$00
lf9b0:	sta $97
lf9b2:	sta $03f8
lf9b5:	ldx #$30
sloop0:	ldy #$03
lf9b9:	lda $97
lf9bb:	bmi sloop2
lf9bd:	clc
lf9be:	adc #$10
lf9c0:	sta $97
lf9c2:	inx
lf9c3:	txa
lf9c4:	cmp ($96),y
lf9c6:	bne sloop0
lf9c8:	dey
sloop1:	lda ($96),y
lf9cb:	dey
lf9cc:	bmi sloop3
lf9ce:	cmp patall,y		; compare cbm-rom test-bytes
lf9d1:	beq sloop1
lf9d3:	bne sloop0
sloop2:	ldy #$e0
lf9d7:	!byte $2c
sloop3:	ldy $97
lf9da:	sty $03f9
lf9dd:	tax
lf9de:	bpl swarm			; jump to warm start
lf9e0:	jsr ioinit			; sub: I/O register init $f9fb
lf9e3:	lda #$f0
lf9e5:	sta $c1				; start F-keys
lf9e7:	jsr jcint			; sub: initialize $e044
lf9ea:	jsr ramtas			; sub: ram-test $fa88
lf9ed:	jsr restor			; sub: init standard-vectors $fba2
lf9f0:	jsr jcint			; sub: initialize $e044
lf9f3:	lda #$a5
lf9f5:	sta $03fa			; save warm start flag
swarm:	jmp ($03f8)			; jump to basic warm start $bbcc
ioinit:	lda #$f3		; ***** i/o register init *****
lf9fd:	sta $de06
lfa00:	ldy #$ff
lfa02:	sty $de05
lfa05:	lda #$5c
lfa07:	sta $de01
lfa0a:	lda #$7d
lfa0c:	sta $de04
lfa0f:	lda #$38		; changed from 03b:$3d 6525 1 init ddr B
lfa11:	sta $de00
lfa14:	lda #$3f
lfa16:	sta $de03
lfa19:	sty $df00
lfa1c:	sty $de01
lfa1f:	sty $df03
lfa22:	sty $df04
lfa25:	lsr $df00
lfa28:	iny
lfa29:	sty $df02
lfa2c:	sty $df05
lfa2f:	lda #$7f
lfa31:	sta $dc0d
lfa34:	sty $dc02
lfa37:	sty $dc03
lfa3a:	sty $dc0f
lfa3d:	sta $dc08
lfa40:	sty $de02
lfa43:	lda $de02
lfa46:	ror
lfa47:	bcc lfa43
lfa49:	sty $de02
lfa4c:	ldx #$00
lfa4e:	inx
lfa4f:	bne lfa4e
lfa51:	iny
lfa52:	lda $de02
lfa55:	ror
lfa56:	bcc lfa4e
lfa58:	cpy #$1b
lfa5a:	bcc lfa5f
lfa5c:	lda #$88
lfa5e:	!byte $2c
lfa5f:	lda #$08
lfa61:	sta $dc0e
lfa64:	lda $db0d
lfa67:	lda #$90
lfa69:	sta $db0d
lfa6c:	lda #$40
lfa6e:	sta $db01
lfa71:	stx $db02
lfa74:	stx $db0f
lfa77:	stx $db0e
lfa7a:	lda #$48
lfa7c:	sta $db03
lfa7f:	lda #$01
lfa81:	ora $de01
lfa84:	sta $de01
lfa87:	rts
ramtas:	lda #$00			; ***** ram-test / vector init *****
lfa8a:	tax
lfa8b:	sta $0002,x
lfa8e:	sta $0200,x
lfa91:	sta $02f8,x
lfa94:	inx
lfa95:	bne lfa8b
lfa97:	lda #$01
lfa99:	sta $01
lfa9b:	sta $035a
lfa9e:	sta $0354
lfaa1:	lda #$02
lfaa3:	sta $0358
lfaa6:	sta $0352
lfaa9:	dec $01
lfaab:	inc $01
lfaad:	lda $01
lfaaf:	cmp #$0f
lfab1:	beq lfad7
lfab3:	ldy #$02
lfab5:	lda ($93),y
lfab7:	tax
lfab8:	lda #$55
lfaba:	sta ($93),y
lfabc:	lda ($93),y
lfabe:	cmp #$55
lfac0:	bne lfad7
lfac2:	asl
lfac3:	sta ($93),y
lfac5:	lda ($93),y
lfac7:	cmp #$aa
lfac9:	bne lfad7
lfacb:	txa
lfacc:	sta ($93),y
lface:	iny
lfacf:	bne lfab5
lfad1:	inc $94
lfad3:	bne lfab5
lfad5:	beq lfaab
lfad7:	ldx $01
lfad9:	dex
lfada:	txa
lfadb:	ldx #$ff
lfadd:	ldy #$fd
lfadf:	sta $0357
lfae2:	sty $0356
lfae5:	stx $0355
lfae8:	ldy #$fa
lfaea:	clc
lfaeb:	jsr $fb78
lfaee:	dec $a8
lfaf0:	dec $a5
lfaf2:	lda #$5d
lfaf4:	sta $036a
lfaf7:	lda #$fe
lfaf9:	sta $036b
lfafc:	rts
lfafd:	sbc #$fb
lfaff:	and ($ee,x)
lfb01:	tax
lfb02:	!byte $fc
lfb03:	!byte $bf
lfb04:	inc $ed,x
lfb06:	sbc $49,x
lfb08:	sbc $a3,x
lfb0a:	sbc $a6,x
lfb0c:	inc $9c,x
lfb0e:	!byte $f4
lfb0f:	inc $6bf4
lfb12:	sbc $f43d,y
lfb15:	!byte $7f
lfb16:	inc $46,x
lfb18:	!byte $f7
lfb19:	jmp $77f8
lfb1c:	inc $e01f
lfb1f:	!byte $1f
lfb20:	cpx #$74
lfb22:	!byte $f2
lfb23:	!byte $80
lfb24:	!byte $f2
lfb25:	asl
lfb26:	!byte $f3
lfb27:	!byte $97
lfb28:	!byte $f2
lfb29:	!byte $ab
lfb2a:	!byte $f2
lfb2b:	!byte $af
lfb2c:	!byte $f2
lfb2d:	!byte $34
lfb2e:	!byte $f2
lfb2f:	bmi lfb23
lfb31:	jmp ($0304)
lfb34:	sta $9d
lfb36:	lda $00,x
lfb38:	sta $90
lfb3a:	lda $01,x
lfb3c:	sta $91
lfb3e:	lda $02,x
lfb40:	sta $92
lfb42:	rts
lfb43:	sta $9e
lfb45:	stx $9f
lfb47:	sty $a0
lfb49:	rts
lfb4a:	bcc lfb64
lfb4c:	lda $9f
lfb4e:	cmp #$02
lfb50:	bne lfb5d
lfb52:	lda $037a
lfb55:	pha
lfb56:	lda #$00
lfb58:	beq lfb6b
lfb5a:	sta $0361
lfb5d:	lda $9c
lfb5f:	ora $9c
lfb61:	sta $9c
lfb63:	rts
lfb64:	pha
lfb65:	lda $9f
lfb67:	cmp #$02
lfb69:	bne lfb70
lfb6b:	pla
lfb6c:	sta $037a
lfb6f:	rts
lfb70:	pla
lfb71:	sta $9c
lfb73:	rts
lfb74:	sta $035e
lfb77:	rts
lfb78:	bcc lfb83
lfb7a:	lda $035d
lfb7d:	ldx $035b
lfb80:	ldy $035c
lfb83:	stx $035b
lfb86:	sty $035c
lfb89:	sta $035d
lfb8c:	rts
lfb8d:	bcc lfb98
lfb8f:	lda $035a
lfb92:	ldx $0358
lfb95:	ldy $0359
lfb98:	stx $0358
lfb9b:	sty $0359
lfb9e:	sta $035a
lfba1:	rts
restor:	ldx #$fd
lfba4:	ldy #$fa
lfba6:	lda #$0f
lfba8:	clc
lfba9:	stx $93
lfbab:	sty $94
lfbad:	ldx $01
lfbaf:	sta $01
lfbb1:	bcc lfbbd
lfbb3:	ldy #$33
lfbb5:	lda $0300,y
lfbb8:	sta ($93),y
lfbba:	dey
lfbbb:	bpl lfbb5
lfbbd:	ldy #$33
lfbbf:	lda ($93),y
lfbc1:	sta $0300,y
lfbc4:	dey
lfbc5:	bpl lfbbf
lfbc7:	stx $01
lfbc9:	rts
lfbca:	stx $03f8
lfbcd:	sty $03f9
lfbd0:	lda #$5a
lfbd2:	sta $03fb
lfbd5:	rts
lfbd6:	pha
lfbd7:	txa
lfbd8:	pha
lfbd9:	tya
lfbda:	pha
lfbdb:	tsx
lfbdc:	lda $0104,x
lfbdf:	and #$10
lfbe1:	bne lfbe6
lfbe3:	jmp ($0300)
lfbe6:	jmp ($0302)
lfbe9:	lda $01
lfbeb:	pha
lfbec:	cld
lfbed:	lda $de07
lfbf0:	bne lfbf5
lfbf2:	jmp $fca2
lfbf5:	cmp #$10
lfbf7:	beq lfbfc
lfbf9:	jmp $fc5b
lfbfc:	lda $dd01
lfbff:	tax
lfc00:	and #$60
lfc02:	tay
lfc03:	eor $037b
lfc06:	beq lfc15
lfc08:	tya
lfc09:	sta $037b
lfc0c:	ora $037a
lfc0f:	sta $037a
lfc12:	jmp $fc9f
lfc15:	txa
lfc16:	and #$08
lfc18:	beq lfc40
lfc1a:	ldy $037d
lfc1d:	iny
lfc1e:	cpy $037c
lfc21:	bne lfc27
lfc23:	lda #$08
lfc25:	bne lfc3a
lfc27:	sty $037d
lfc2a:	dey
lfc2b:	ldx $a8
lfc2d:	stx $01
lfc2f:	ldx $dd01
lfc32:	lda $dd00
lfc35:	sta ($a6),y
lfc37:	txa
lfc38:	and #$07
lfc3a:	ora $037a
lfc3d:	sta $037a
lfc40:	lda $dd01
lfc43:	and #$10
lfc45:	beq lfc58
lfc47:	lda $dd02
lfc4a:	and #$0c
lfc4c:	cmp #$04
lfc4e:	bne lfc58
lfc50:	lda #$f3
lfc52:	and $dd02
lfc55:	sta $dd02
lfc58:	jmp $fc9f
lfc5b:	cmp #$08
lfc5d:	bne lfc69
lfc5f:	lda $db0d
lfc62:	cli
lfc63:	jsr $fd48
lfc66:	jmp $fc9f
lfc69:	cli
lfc6a:	cmp #$04
lfc6c:	bne lfc7a
lfc6e:	lda $dc0d
lfc71:	ora $0369
lfc74:	sta $0369
lfc77:	jmp $fc9f
lfc7a:	cmp #$02
lfc7c:	bne lfc81
lfc7e:	jmp $fc9f
lfc81:	jsr $e013
lfc84:	jsr $f979
lfc87:	lda $de01
lfc8a:	bpl lfc95
lfc8c:	ldy #$00
lfc8e:	sty $0375
lfc91:	ora #$40
lfc93:	bne lfc9c
lfc95:	ldy $0375
lfc98:	bne lfc9f
lfc9a:	and #$bf
lfc9c:	sta $de01
lfc9f:	sta $de07
lfca2:	pla
lfca3:	sta $01
lfca5:	pla
lfca6:	tay
lfca7:	pla
lfca8:	tax
lfca9:	pla
lfcaa:	rti
lfcab:	lda $0800
lfcae:	and #$7f
lfcb0:	tay
lfcb1:	jsr $fe21
lfcb4:	lda #$04
lfcb6:	and $db01
lfcb9:	bne lfcab
lfcbb:	lda #$08
lfcbd:	ora $db01
lfcc0:	sta $db01
lfcc3:	nop
lfcc4:	lda $db01
lfcc7:	tax
lfcc8:	and #$04
lfcca:	beq lfcd8
lfccc:	txa
lfccd:	eor #$08
lfccf:	sta $db01
lfcd2:	txa
lfcd3:	nop
lfcd4:	nop
lfcd5:	nop
lfcd6:	bne lfcab
lfcd8:	lda #$ff
lfcda:	sta $db02
lfcdd:	lda $0800
lfce0:	sta $db00
lfce3:	jsr $fe08
lfce6:	lda $db01
lfce9:	and #$bf
lfceb:	sta $db01
lfcee:	ora #$40
lfcf0:	cli
lfcf1:	nop
lfcf2:	nop
lfcf3:	nop
lfcf4:	sta $db01
lfcf7:	jsr $fdee
lfcfa:	lda #$00
lfcfc:	sta $db02
lfcff:	jsr $fdf6
lfd02:	jsr $fde6
lfd05:	ldy #$00
lfd07:	beq lfd26
lfd09:	lda #$ff
lfd0b:	sta $db02
lfd0e:	lda $0805,y
lfd11:	sta $db00
lfd14:	jsr $fdff
lfd17:	jsr $fdee
lfd1a:	lda #$00
lfd1c:	sta $db02
lfd1f:	jsr $fdf6
lfd22:	jsr $fde6
lfd25:	iny
lfd26:	cpy $0803
lfd29:	bne lfd09
lfd2b:	ldy #$00
lfd2d:	beq lfd42
lfd2f:	jsr $fdff
lfd32:	jsr $fdee
lfd35:	lda $db00
lfd38:	sta $0805,y
lfd3b:	jsr $fdf6
lfd3e:	jsr $fde6
lfd41:	iny
lfd42:	cpy $0804
lfd45:	bne lfd2f
lfd47:	rts
lfd48:	lda #$00
lfd4a:	sta $db02
lfd4d:	lda $db00
lfd50:	sta $0800
lfd53:	and #$7f
lfd55:	tay
lfd56:	jsr $fe21
lfd59:	tya
lfd5a:	asl
lfd5b:	tay
lfd5c:	lda $0810,y
lfd5f:	sta $0801
lfd62:	iny
lfd63:	lda $0810,y
lfd66:	sta $0802
lfd69:	jsr $fdff
lfd6c:	jsr $fde6
lfd6f:	ldy #$00
lfd71:	cpy $0803
lfd74:	beq lfd8b
lfd76:	jsr $fdf6
lfd79:	jsr $fdee
lfd7c:	lda $db00
lfd7f:	sta $0805,y
lfd82:	jsr $fdff
lfd85:	jsr $fde6
lfd88:	iny
lfd89:	bne lfd71
lfd8b:	bit $0800
lfd8e:	bmi lfdc3
lfd90:	lda #$fd
lfd92:	pha
lfd93:	lda #$98
lfd95:	pha
lfd96:	jmp ($0801)
lfd99:	jsr $fdf6
lfd9c:	ldy #$00
lfd9e:	beq lfdbd
lfda0:	jsr $fdee
lfda3:	lda #$ff
lfda5:	sta $db02
lfda8:	lda $0805,y
lfdab:	sta $db00
lfdae:	jsr $fdff
lfdb1:	jsr $fde6
lfdb4:	lda #$00
lfdb6:	sta $db02
lfdb9:	jsr $fdf6
lfdbc:	iny
lfdbd:	cpy $0804
lfdc0:	bne lfda0
lfdc2:	rts
lfdc3:	lda #$fd
lfdc5:	pha
lfdc6:	lda #$ce
lfdc8:	pha
lfdc9:	jsr $fe11
lfdcc:	jmp ($0801)
lfdcf:	jsr $fe08
lfdd2:	lda $0804
lfdd5:	sta $0803
lfdd8:	sta $0800
lfddb:	lda #$00
lfddd:	sta $0804
lfde0:	jsr $fcab
lfde3:	jmp $fdc2
lfde6:	lda $db01
lfde9:	and #$04
lfdeb:	bne lfde6
lfded:	rts
lfdee:	lda $db01
lfdf1:	and #$04
lfdf3:	beq lfdee
lfdf5:	rts
lfdf6:	lda $db01
lfdf9:	and #$f7
lfdfb:	sta $db01
lfdfe:	rts
lfdff:	lda #$08
lfe01:	ora $db01
lfe04:	sta $db01
lfe07:	rts
lfe08:	lda $de01
lfe0b:	and #$ef
lfe0d:	sta $de01
lfe10:	rts
lfe11:	lda $db01
lfe14:	and #$02
lfe16:	beq lfe11
lfe18:	lda $de01
lfe1b:	ora #$10
lfe1d:	sta $de01
lfe20:	rts
lfe21:	lda $0910,y
lfe24:	pha
lfe25:	and #$0f
lfe27:	sta $0803
lfe2a:	pla
lfe2b:	lsr
lfe2c:	lsr
lfe2d:	lsr
lfe2e:	lsr
lfe2f:	sta $0804
lfe32:	rts
lfe33:	ldx #$ff
lfe35:	stx $01
lfe37:	lda $de01
lfe3a:	and #$ef
lfe3c:	sta $de01
lfe3f:	nop
lfe40:	lda $db01
lfe43:	ror
lfe44:	bcs lfe47
lfe46:	rts
lfe47:	lda #$00
lfe49:	sei
lfe4a:	sta $db01
lfe4d:	lda #$40
lfe4f:	nop
lfe50:	nop
lfe51:	nop
lfe52:	nop
lfe53:	sta $db01
lfe56:	cli
lfe57:	jmp $fe57
lfe5a:	jmp ($036a)
lfe5d:	pla
lfe5e:	pla
lfe5f:	jmp $f945
lfe62:	lda $9a
lfe64:	sta $94
lfe66:	lda $99
lfe68:	sta $93
lfe6a:	lda $9b
lfe6c:	sta $95
lfe6e:	sta $01
lfe70:	rts
lfe71:	sec
lfe72:	lda $93
lfe74:	sbc $96
lfe76:	lda $94
lfe78:	sbc $97
lfe7a:	lda $95
lfe7c:	sbc $98
lfe7e:	rts
lfe7f:	inc $93
lfe81:	bne lfe91
lfe83:	inc $94
lfe85:	bne lfe91
lfe87:	inc $95
lfe89:	lda $95
lfe8b:	sta $01
lfe8d:	lda #$02
lfe8f:	sta $93
lfe91:	rts
lfe92:	ldx $01
lfe94:	lda $92
lfe96:	sta $01
lfe98:	lda ($90),y
lfe9a:	stx $01
lfe9c:	rts
lfe9d:	sta $01
lfe9f:	txa
lfea0:	clc
lfea1:	adc #$02
lfea3:	bcc lfea6
lfea5:	iny
lfea6:	tax
lfea7:	tya
lfea8:	pha
lfea9:	txa
lfeaa:	pha
lfeab:	jsr $ff19
lfeae:	lda #$fe
lfeb0:	sta ($ac),y
lfeb2:	php
lfeb3:	sei
lfeb4:	pha
lfeb5:	txa
lfeb6:	pha
lfeb7:	tya
lfeb8:	pha
lfeb9:	jsr $ff19
lfebc:	tay
lfebd:	lda $00
lfebf:	jsr $ff2a
lfec2:	lda #$04
lfec4:	ldx #$ff
lfec6:	jsr $ff24
lfec9:	tsx
lfeca:	lda $0105,x
lfecd:	sec
lfece:	sbc #$03
lfed0:	pha
lfed1:	lda $0106,x
lfed4:	sbc #$00
lfed6:	tax
lfed7:	pla
lfed8:	jsr $ff24
lfedb:	tya
lfedc:	sec
lfedd:	sbc #$04
lfedf:	sta $01ff
lfee2:	tay
lfee3:	ldx #$04
lfee5:	pla
lfee6:	iny
lfee7:	sta ($ac),y
lfee9:	dex
lfeea:	bne lfee5
lfeec:	ldy $01ff
lfeef:	lda #$2d
lfef1:	ldx #$ff
lfef3:	jsr $ff24
lfef6:	pla
lfef7:	pla
lfef8:	tsx
lfef9:	stx $01ff
lfefc:	tya
lfefd:	tax
lfefe:	txs
lfeff:	lda $01
lff01:	jmp $fff6
lff04:	nop
lff05:	php
lff06:	php
lff07:	sei
lff08:	pha
lff09:	txa
lff0a:	pha
lff0b:	tya
lff0c:	pha
lff0d:	tsx
lff0e:	lda $0106,x
lff11:	sta $01
lff13:	jsr $ff19
lff16:	jmp $fedc
lff19:	ldy #$01
lff1b:	sty $ad
lff1d:	dey
lff1e:	sty $ac
lff20:	dey
lff21:	lda ($ac),y
lff23:	rts
lff24:	pha
lff25:	txa
lff26:	sta ($ac),y
lff28:	dey
lff29:	pla
lff2a:	sta ($ac),y
lff2c:	dey
lff2d:	rts
lff2e:	pla
lff2f:	tay
lff30:	pla
lff31:	tax
lff32:	pla
lff33:	plp
lff34:	rts
lff35:	php
lff36:	jmp ($fffa)
lff39:	brk
lff3a:	nop
lff3b:	rts
lff3c:	cli
lff3d:	rts

; *************************************************************************************************

*= $ff6c
lff6c:	jmp $fe9d
lff6f:	jmp $fbca
lff72:	jmp $fe33
lff75:	jmp $e022
lff78:	jmp $fcab
lff7b:	jmp ioinit
lff7e:	jmp jcint
lff81:	jmp $f400
lff84:	jmp $fba9
lff87:	jmp restor
lff8a:	jmp $f660
lff8d:	jmp $f678
lff90:	jmp $fb5a
lff93:	jmp ($0324)
lff96:	jmp ($0326)
lff99:	jmp $fb78
lff9c:	jmp $fb8d
lff9f:	jmp $e013
lffa2:	jmp $fb74
lffa5:	jmp ($0328)
lffa8:	jmp ($032a)
lffab:	jmp ($032c)
lffae:	jmp ($032e)
lffb1:	jmp ($0330)
lffb4:	jmp ($0332)
lffb7:	jmp $fb4a
lffba:	jmp $fb43
lffbd:	jmp $fb34
lffc0:	jmp ($0306)
lffc3:	jmp ($0308)
lffc6:	jmp ($030a)
lffc9:	jmp ($030c)
lffcc:	jmp ($030e)
lffcf:	jmp ($0310)
lffd2:	jmp ($0312)
lffd5:	jmp ($031a)
lffd8:	jmp ($031c)
lffdb:	jmp $f90e
lffde:	jmp $f8e6
lffe1:	jmp ($0314)
lffe4:	jmp ($0316)
lffe7:	jmp ($0318)
lffea:	jmp $f979
lffed:	jmp $e010
lfff0:	jmp $e019
lfff3:	jmp $e01c
lfff6:	sta $00
lfff8:	rts
		!byte $01
		!byte $31,$fb		; NMI vector
		!byte $97,$f9		; RESET vector -> start
		!byte $d6,$fb		; IRQ vector
