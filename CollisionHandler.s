//Marios movement value in r1
//Object collided with in r2
//This method should check what kind of collision has occured. If it is with a question box,
//the question box needs to change to a brick box and mario is pushed back to his old location
//If it is with a brick then mario is moved back his movement amount. If it is with a goomba, 
//from the side, mario dies. If it is with a goomba from above, Mario kills the goomba, if it
//is a collision with ground, Mario is not moved NOT DONE
.globl CollisionHandler
.globl killMario
CollisionHandler:
		push    {r4,    r10,    lr}
       
		cmp	r2, #0b00010
		beq	goombaHandler
		
		cmp	r2, #0b00011
		beq	questionBlockHandler

		cmp 	r2, #0b00100
		beq	woodenBlockHandler
		cmp 	r2, #0b00101
		beq	woodenBlockHandler
		cmp 	r2, #0b00110
		beq	woodenBlockHandler
		cmp 	r2, #0b00111
		beq	woodenBlockHandler
		
		cmp	r2, #0b01000
		beq	pipeHandler

		cmp	r2, #0b01001
		beq	goombaHandler
		cmp	r2, #0b01010
		beq	questionBlockHandler
		cmp	r2, #0b01011
		beq	questionBlockHandler

                cmp     r2,     #0b01011
                beq     ValueHandler


ValueHandler:           mov     r2,     #5
                        b       incCoin

//=============================================================		
goombaHandler:

	mov r4, r1
	mov r1, r2
	bl Grab
	
	ldr r5, [r0], #4
	ldr r6, [r0]		//load in top left point of goomba
	
	mov r2, #0b00001
	bl Grab
	ldr r9, [r0, #4]
	
	mov r2, #0b00000
	bl Grab
	ldr r7, [r0, #4]


	cmp     r7,     r9
	beq     killMario
		
	cmp     r7,     r9
	bgt     killGoomba
	
	b killMario
	
killGoomba:
	mov r1, #0b00010
	bl Grab
        mov     r11,    r0
	
	ldr r0, [r11], #4
	ldr r1, [r11], #20
	ldr r2, [r11], #4
	ldr r3, [r11]
	
	ldr r4, =sky
	bl CreateImage		//draw blank over the goomba
	
	mov r1, #0b00010
	bl Grab
	mov     r11,    r0
	ldr     r0,     =5000
	mov r1, #50
	ldr     r2,     =5031
	mov r3, #19
	
	str r0, [r11], #4
	str r0, [r11], #4
	str r3, [r11], #4
	str r0, [r11], #4
	str r0, [r11], #4
	str r3, [r11], #4
	str r3, [r11], #4
	str r3, [r11], #4

	b incScore
//=============================================================
questionBlockHandler:

        mov r1, r2
	
	mov r1, #1
	bl Grab
	
	ldr r9, [r0],	 #4
	ldr r10, [r0]		//load top left point of Mario_loc

	mov r1, #0b00000
	bl Grab
	
	ldr r7, [r0]
	ldr r8, [r0,#4]	//load top left point of Mario_Temp

	cmp r8, r10
	bge exit		//to the BR point of mario, if >= then do nothing.
        mov     r2,     #1
	b incCoin
 //=============================================================

woodenBlockHandler:
        mov r1, r2
	
	mov r1, #1
	bl Grab
	
	ldr r9, [r0],	 #4
	ldr r10, [r0]		//load top left point of Mario_loc

	mov r1, #0b00000
	bl Grab
	
	ldr r7, [r0]
	ldr r8, [r0,#4]	//load top left point of Mario_Temp

	cmp r8, r10
	bge exit
	
destroyWoodBlock:
	mov r5, r4
	mov r1, r2
	bl Grab
        mov     r11,    r0
	
	ldr r0, [r11], #4
	ldr r1, [r11], #20
	ldr r2, [r11], #4
	ldr r3, [r11]
	
	ldr r4, =sky
	bl CreateImage		//draw blank over the wood block
	
	mov r1, r5
	bl Grab
        mov     r11,    r0
	
	ldr     r0,     =5000
	mov r1, #50
	ldr     r2,     =5031
	mov r3, #19
	
	str r0, [r11], #4
	str r0, [r11], #4
	str r3, [r11], #4
	str r0, [r11], #4
	str r0, [r11], #4
	str r3, [r11], #4
	str r3, [r11], #4
	str r3, [r11], #4

	b exit
//=============================================================
pipeHandler:		//treated as an obstacle without any other function, nothing to do
	b exit
//=============================================================
holeHandler:
	mov r1, r2
	bl Grab
	
	ldr r5, [r0]
	ldr r6, [r0, #4]		//load top left point of hole
	ldr r9, [r0, #8]
	ldr r10, [r0, #12]	//load top right point of hole
	
	
	mov r1, #0b00000
	bl Grab
	
	ldr r7, [r0, #16]
	ldr r8, [r0, #20]	//load bottom left point of Mario_temp
	ldr r11, [r0, #24]
	ldr r12, [r0, #28]	//load bottom right point of Mario_temp
	
	cmp r5, r7
	blt exit
		
	cmp r9, r11
	bgt exit
	
	b killMario
	
//=============================================================	

killMario:

	mov r5, #0b00001
	mov r1, r5
	bl Grab
        mov     r11,    r0
	
	ldr r0, [r11], #4
	ldr r1, [r11], #20
	ldr r2, [r11], #4
	ldr r3, [r11]
	
	ldr r4, =sky
	bl CreateImage		
	
	mov r1, r5
	bl Grab
        mov     r11,    r0
	
	ldr     r0,     =5000
	mov r1, #50
	ldr     r2,     =5031
	mov r3, #19
	str r0, [r11], #4
	str r1, [r11], #4
	str r2, [r11], #4
	str r3, [r11], #4
	str r0, [r11], #4
	str r1, [r11], #4
	str r2, [r11], #4
	str r3, [r11], #4
	
	ldr r0, =Life
	ldr r1, [r0]
	sub r1, r1, #1
	str r1, [r0]
	b NewLife

incScore:
ldr r0, =Score
	ldr r1, [r0]
	add r1, r1, #1
	str r1, [r0]
        bl      ScorePrinter
        b       exit
	
incCoin:
	ldr r0, =Coins
	ldr r1, [r0]
	add r1, r1, r2
	str r1, [r0]
        bl      ScorePrinter
        b       exit
//=============================================================
exit:
		pop     {r4,    r10,    lr}
      bx      lr
