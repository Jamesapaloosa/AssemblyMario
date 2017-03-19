///Game Starts here

	.equ	SEL, 0b110111111111
	.equ	START, 0b111011111111
	.equ	UP, 0b111101111111
	.equ	DOWN, 0b111110111111
	.equ	LEFT, 0b111111011111
	.equ	RIGHT, 0b111111101111
	.equ	A, 0b111111110111
BeginGame:
                bl      init_Objects	        
                BUTTON  .req r6		// contains the button pressed
                JUMP    .req r7         // detects if jump is over.
                mov	r0, #0		// initial x
	        mov	r1, #0		// initial y
	        ldr	r2, =1023	// final x
	        ldr	r3, =767	// final y
	        ldr	r4, =GameScreen
	        bl	CreateImage
                ldr     r1,     =MarioStandRight
                bl      MarioPrint
                bl      PrintObjects
GameLoop:
	        bl	getInput
	        mov	BUTTON, r0
	
	        mov	r0, BUTTON	// arg 1: the user input
	        ldr	r1, =RIGHT	// arg 2: desired button
	        bl	checkButton	// check if user pressed A
	        cmp	r0, #1	
                bne     Left	
                mov     r1,     #10
                bl      MoveMarioLR
Left:           mov     r0, BUTTON
                ldr     r1,     =LEFT
                bl      checkButton
                cmp     r0,     #1
                bne     Jump
                mov     r1,     #-10
                bl      MoveMarioLR
Jump:           mov     r0,     BUTTON

                ldr     r1,     =A
                bl      checkButton
                cmp     r0, #1
                bne     start
                mov     r1,     #10
                bl      MarioJump
start:          mov     r0,     BUTTON
                movw     r1,     #START


                bl      checkButton     
                cmp     r0,     #1
                bne     GameLoop
                bl      StartMenu

                






                

//====================================================
//Draws over objects when the screen is moved
PrintScreenMove:
                push    {r4,    r10, lr}
                mov     r4,     #1
POLoop:         add     r4,     #1
                cmp      r4,    #10
                bge     EndPOLoop
                mov     r10,     r1
                mov     r0,     r4
                bl      Grab
                mov     r5,     r0
                ldr	r0,     [r5], #4
	        ldr	r1,     [r5], #20	// initial y
	        ldr	r2,     [r5], #4 	// final x
	        ldr	r3,     [r5]	        // final y

                mov     r6,     r0
                mov     r7,     r1
                mov     r8,     r2
                mov     r9,     r3

                //Branch and link to Victor's converter        
                //needs to provide two coordinates 

 
                bl displayConvert
                cmp     r0,     #-1
                beq     POLoop
                ldr     r4,     =blank

                mov     r0,     r6
                mov     r1,     r7
                mov     r2,     r8
                mov     r3,     r9
                bl      CreateImage
                

EndPOLoop:      pop     {r4,    r10,    lr}
                bx      lr   





//====================================================
//Draws objects that are on the screen other than mario
//Requires Converter NOT DONE
PrintObjects:   push    {r4,    r10, lr}
                mov     r4,     #1
POLoop2:         add     r4,     #1
                cmp      r4,    #10
                bge     EndPOLoop2

                mov     r10,     r1
                mov     r0,     r4
                bl      Grab
                mov     r5,     r0
                ldr	r0,     [r5], #4
	        ldr	r1,     [r5], #20	// initial y
	        ldr	r2,     [r5], #4 	// final x
	        ldr	r3,     [r5]	        // final y

                mov     r6,     r0
                mov     r7,     r1
                mov     r8,     r2
                mov     r9,     r3

                //Branch and link to Victor's converter        
                //needs to provide two coordinates 

                bl displayConvert
                cmp     r0,     #-1
                beq     POLoop2
 
                bl      GrabImage
                mov     r4,     r0
                mov     r0,     r6
                mov     r1,     r7
                mov     r2,     r8
                mov     r3,     r9
                bl      CreateImage
                

EndPOLoop2:      pop     {r4,    r10,    lr}


                bx      lr    
        





//====================================================
//Takes in one argument, that is which mario type to print.
MarioPrint:    push    {r4,    r10, lr}
                mov     r10,     r1
                mov     r0,     #0b00001
                bl      Grab
                mov     r5,     r0
                ldr	r0,     [r5], #4
	        ldr	r1,     [r5], #20	// initial y
	        ldr	r2,     [r5], #4 	// final x
	        ldr	r3,     [r5]	        // final y

                //Branch and link to Victor's converter        
                //needs to provide two coordinates 

                bl displayConvert

	        mov     r4,     r10
	        bl	CreateImage
                
EndMarioPrint:  pop     {r4,    r10, lr}
                bx      lr

//====================================================
//Prints sky over mario
EraseMario:     push    {r2,    r10, lr}
                mov     r0,     #0b00001
                bl      Grab
                mov     r5,     r0
                ldr	r0,     [r5], #4
	        ldr	r1,     [r5], #20	// initial y
	        ldr	r2,     [r5], #4 	// final x
	        ldr	r3,     [r5]	        // final y

                //Branch and link to Victor's converter        
                //needs to provide two coordinates 

                bl displayConvert
	        ldr     r4,     =blank
	        bl	CreateImage
                
EndMarioErase:  pop     {r2,    r10, lr}
               
                bx      lr
//===================================================
Wait:
                push    {r4-r10, lr}
                ldr     r0, =0x3f003004
                ldr     r2,     [r0]
                add     r1,     r2                      //Time to wait is added to current time

Checktime:      ldr     r2,     [r0]                    //loop that decides if the desired amount of time was waited
                cmp     r1,     r2
                bhi     Checktime

                pop     {r4-r10, lr}
                bx      lr
//===================================================
//Takes in the direction to move in r1
//Needs to take in if jump is true or not in r2 NOT DONE
MoveMarioLR:
                push    {r2,    r10,    lr}
                bl      EraseMario
                mov     r0,     #0b00000
                mov     r4,     r1              //put the direction value in a safe place
                mov     r8,     r2              //put the jump state in a safe place
                bl      Grab
                mov     r5,     r0
                ldr     r0,     [r5]
                add     r0,     r0,     r4
                str     r0,     [r5],   #8
                ldr     r1,     [r5]
                add     r1,     r1,     r4
                str     r1,     [r5],   #8
                ldr     r2,     [r5]
                add     r2,     r2,     r4
                str     r2,     [r5],   #8
                ldr     r3,     [r5]
                add     r3,     r3,     r4
                str     r3,     [r5],   #8
                //Check for collision and undo movement if so
                bl      objectCollision
                cmp     r0,     #0
                beq     nocol1
                mov     r1,     r4
                mov     r2,     r0
                bl      CollisionHandler
                b       EndMoveMario
                

 
nocol1:        
=======

 
                mov     r0,     #0b00001
                mov     r4,     r1              //put the direction value in a safe place
                mov     r8,     r2              //put the jump state in a safe place
                bl      Grab
                mov     r5,     r0
                ldr     r0,     [r5]
                add     r0,     r0,     r4
                str     r0,     [r5],   #8
                ldr     r1,     [r5]
                add     r1,     r1,     r4
                str     r1,     [r5],   #8
                ldr     r2,     [r5]
                add     r2,     r2,     r4
                str     r2,     [r5],   #8
                ldr     r3,     [r5]
                add     r3,     r3,     r4
                str     r3,     [r5],   #8
                cmp     r4,     #0
 
                blt    WalkLeft
                ldr     r1,     =MarioWalkRImg
                b       MoveMario2
WalkLeft:       ldr     r1,     =MarioWalkLImg
MoveMario2:      bl      MarioPrint


 

                bl      EraseMario
                mov     r0,     #0b00000
                bl      Grab
                mov     r5,     r0
                ldr     r1,     [r5]
                add     r1,     r1,     r4
                str     r1,     [r5],   #8
                ldr     r1,     [r5]
                add     r1,     r1,     r4
                str     r1,     [r5],   #8
                ldr     r1,     [r5]
                add     r1,     r1,     r4
                str     r1,     [r5],   #8
                ldr     r1,     [r5]
                add     r1,     r1,     r4
                str     r1,     [r5],   #8

                bl      objectCollision
                cmp     r0,     #0
                beq     nocol2
                mov     r1,     r4
                mov     r2,     r0
                bl      CollisionHandler
                b       EndMoveMario

nocol2:         mov     r0,     #0b00001
                mov     r4,     r1              //put the direction value in a safe place
                mov     r8,     r2              //put the jump state in a safe place
                bl      Grab
                mov     r5,     r0
                ldr     r0,     [r5]
                add     r0,     r0,     r4
                str     r0,     [r5],   #8
                ldr     r1,     [r5]
                add     r1,     r1,     r4
                str     r1,     [r5],   #8
                ldr     r2,     [r5]
                add     r2,     r2,     r4
                str     r2,     [r5],   #8
                ldr     r3,     [r5]
                add     r3,     r3,     r4
                str     r3,     [r5],   #8
EndMoveMarioLR:
                cmp     r4,     #0
 
                blt    WalkLeft2
                ldr     r1,     =MarioStandRImg
                b       MoveMario2
WalkLeft2:       ldr     r1,     =MariStandLImg
MoveMario:      bl      MarioPrint
EndMoveMarioLR2:


                pop     {r4,    r10,    lr}
                bx      lr
//===================================================
//Marios movement value in r1
//Object collided with in r2
//This method should check what kind of collision has occured. If it is with a question box,
//the question box needs to change to a brick box and mario is pushed back to his old location
//If it is with a brick then mario is moved back his movement amount. If it is with a goomba, 
//from the side, mario dies. If it is with a goomba from above, Mario kills the goomba, if it
//is a collision with ground, Mario is not moved NOT DONE
CollisionHandler:
                push    {r2,    r10,    lr}
                pop     {r4,    r10,    lr}
                bx      lr



//===================================================
//Not Done
MarioJump:



//===================================================
//Takes in an input that tells whether jump is true or not. If jump is false then mario can fall. If
//Jump is true then mario will not fall. r0 = 1 is jump true, r0 = 0 is jump is false NOT DONE
MarioFall:


























