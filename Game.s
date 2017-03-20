//Game Starts here


        .global BeginGame

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
                JUMPBASE .req r8         //if a jump is initiated the base value of mario's top left corner is saved
                JUMPX   .req r9         //Time counter for the jump equation



                mov	r0, #0		// initial x
	        mov	r1, #0		// initial y
	        ldr	r2, =1023	// final x
	        ldr	r3, =767	// final y
	        ldr	r4, =GameScreen
	        bl	CreateImage
                ldr     r1,     =MarioStandRight
                bl      MarioPrint
                bl      PrintObjects
GameLoop:       bl      WinCond
                bl      SlideScreen
                

                cmp     JUMP,   #0
                bne     noJump
                add     JUMPX,  JUMPX
                mov     r1,     JUMPX
                cmp     r1,     #31
                blt     JumpCont
                mov     JUMP,   #0
                b       noJump
JumpCont:       mov     r2,     JUMPBASE
                bl      MarioJump
                
                
//Code that exicutes after the jump is dealt with
noJump:	        bl	getInput
	        mov	BUTTON, r0
	
	        mov	r0, BUTTON	// arg 1: the user input
	        ldr	r1, =RIGHT	// arg 2: desired button
	        bl	checkButton	// check if user pressed A
	        cmp	r0, #1	
                bne     Left	
                mov     r1,     #10
                mov     r2,     JUMP
                bl      MoveMarioLR
Left:           mov     r0, BUTTON
                ldr     r1,     =LEFT
                bl      checkButton
                cmp     r0,     #1
                bne     Jump
                mov     r1,     #-10
                mov     r2,     JUMP
                bl      MoveMarioLR

//Deal with when the a button is pushed and choose to set jump check
Jump:           mov     r0,     BUTTON
                ldr     r1,     =A
                bl      checkButton
                cmp     r0, #1
                bne     start
                cmp     r7,     #1
                b       start
                mov     JUMP,   #1
                mov     r1,     #1
                bl      Grab
                ldr     JUMPBASE,       [r0, #4]
                mov     JUMPX,  #0


start:          mov     r0,     BUTTON
                ldr     r1,     =START
                bl      checkButton     
                cmp     r0,     #1
                bne     GameLoop
                bl      StartMenu

                

GameOverLoop:
                b       GameOverLoop




                

//====================================================
//Draws over objects when the screen is moved
PrintScreenMove:
                push    {r4,    r10, lr}
                mov     r4,     #1
POSCREEN:       add     r4,     #1
                cmp      r4,    #10
                bge     EndPOSCREEN
                mov     r10,     r1
                mov     r1,     r4
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
        
                bl displayConvert
                cmp     r0,     #-1
                beq     POSCREEN
                ldr     r4,     =blank
                mov     r0,     r6
                mov     r1,     r7
                mov     r2,     r8
                mov     r3,     r9
                bl      CreateImage
                b       POSCREEN

EndPOSCREEN:      pop     {r4,    r10,    lr}
                bx      lr   





//====================================================
//Draws objects that are on the screen other than mario
//Requires Converter NOT DONE
PrintObjects:   push    {r4,    r10, lr}
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
                bl      displayConvert
                cmp     r0,     #-1
                beq     POLoop
                bl      GrabImage
                mov     r4,     r0
                mov     r0,     r6
                mov     r1,     r7
                mov     r2,     r8
                mov     r3,     r9
                bl      CreateImage
                

EndPOLoop:      pop     {r4,    r10,    lr}
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
                bl      displayConvert
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
                bl      displayConvert
	        ldr     r4,     =blank
	        bl	CreateImage
                
EndEraseMario:  pop     {r2,    r10, lr}
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
                push    {r4,    r10,    lr}
                bl      EraseMario
                mov     r0,     #0b00000
                mov     r7,     r1              //put the direction value in a safe place
                mov     r8,     r2              //put the jump state in a safe place
                bl      Grab
                mov     r5,     r0
                ldr     r0,     [r5]
                add     r0,     r0,     r7
                str     r0,     [r5],   #8
                ldr     r1,     [r5]
                add     r1,     r1,     r7
                str     r1,     [r5],   #8
                ldr     r2,     [r5]
                add     r2,     r2,     r7
                str     r2,     [r5],   #8
                ldr     r3,     [r5]
                add     r3,     r3,     r7
                str     r3,     [r5],   #8
                //check for move off of screen
                cmp     r0,     #0
                blt     EndMoveMarioLR

                //Check for collision and undo movement if so
                bl      objectCollision
                cmp     r0,     #0
                beq     nocol1
                mov     r1,     r7
                mov     r2,     r0
                bl      CollisionHandler
                b       EndMoveMarioLR
                

nocol1:          
                mov     r0,     #0b00001
                bl      Grab
                mov     r5,     r0
                ldr     r0,     [r5]
                add     r0,     r0,     r7
                str     r0,     [r5],   #8
                ldr     r1,     [r5]
                add     r1,     r1,     r7
                str     r1,     [r5],   #8
                ldr     r2,     [r5]
                add     r2,     r2,     r7
                str     r2,     [r5],   #8
                ldr     r3,     [r5]
                add     r3,     r3,     r7
                str     r3,     [r5],   #8
                bl      displayConvert
                cmp     r8,     #0
                beq     NoJump1
                cmp     r7,     #0
                blt    JumpLeft1
                ldr     r4,     =MarioJumpLeftImg
                b       MoveMario2
JumpLeft1:      ldr     r4,     =MarioJumpRightImg             
                

                //if not jumping, decide which way to face
NoJump1:        cmp     r7,     #0
                blt     WalkLeft1
                ldr     r4,     =MarioWalkRImg
                b       MoveMario1
WalkLeft1:      ldr     r4,     =MarioWalkLImg
MoveMario1:     bl      MarioPrint

                bl      EraseMario
                mov     r0,     #0b00000
                bl      Grab
                mov     r5,     r0
                ldr     r1,     [r5]
                add     r1,     r1,     r7
                str     r1,     [r5],   #8
                ldr     r1,     [r5]
                add     r1,     r1,     r7
                str     r1,     [r5],   #8
                ldr     r1,     [r5]
                add     r1,     r1,     r7
                str     r1,     [r5],   #8
                ldr     r1,     [r5]
                add     r1,     r1,     r7
                str     r1,     [r5],   #8
                //check for move off of screen
                cmp     r0,     #0
                blt     EndMoveMarioLR

                bl      objectCollision
                cmp     r0,     #0
                beq     nocol2
                mov     r1,     r7
                mov     r2,     r0
                bl      CollisionHandler
                b       EndMoveMarioLR

nocol2:         mov     r0,     #0b00001
                bl      Grab
                mov     r5,     r0
                ldr     r0,     [r5]
                add     r0,     r0,     r7
                str     r0,     [r5],   #8
                ldr     r1,     [r5]
                add     r1,     r1,     r7
                str     r1,     [r5],   #8
                ldr     r2,     [r5]
                add     r2,     r2,     r7
                str     r2,     [r5],   #8
                ldr     r3,     [r5]
                add     r3,     r3,     r7
                str     r3,     [r5],   #8
                bl      displayConvert

EndMoveMarioLR:
                cmp     r8,     #0
                beq     NoJump1
                cmp     r7,     #0
                blt    JumpLeft2
                ldr     r4,     =MarioJumpLeftImg
                b       MoveMario2
JumpLeft2:      ldr     r4,     =MarioJumpRightImg      
                cmp     r7,     #0
                blt    WalkLeft
                ldr     r4,     =MarioStandRImg
                b       MoveMario2
WalkLeft:       ldr     r4,     =MariStandLImg
MoveMario2:     bl      MarioPrint
                pop     {r4,    r10,    lr}
                bx      lr
//===================================================
//Marios movement value in r1
//Object collided with in r2
//This method should check what kind of collision has occured. If it is with a question box,
//the question box needs to change to a brick box and mario is pushed back to his old location
//If it is with a brick then mario is moved back his movement amount. If it is with a goomba, 
//from the side, mario dies. If it is with a goomba from above, Mario kills the goomba, if it
//is a collision with ground, Mario is not moved NOT DONE - Victor
//Can destroy wooden boxes
CollisionHandler:
                push    {r4,    r10,    lr}

                mov     r1,     r8
                mov     r2,     r9



                pop     {r4,    r10,    lr} 
                bx      lr



//===================================================
//Based on the equation 30x - x^2
//Takes in the x value in r1 which represents time against the y value 
//Takes in the initial height of mario's top left corner in r2
//Returns if collision happend so that jump can end
//YET TO DEAL WITH COLLISIONS
MarioJump:
                push    {r3,    r10,    lr}
                bl      EraseMario
                mov     r8,     r1                      //place the mario x value for the jump in r8
                mov     r9,     r2                      //place the mario initial y value in r9
//Calculate the new y coordinates of Mario
                lsl     r8,     #5
                sub     r8,     r1
                sub     r8,     r1
                mul     r1,     r1,     r1
                sub     r8,     r8,     r1
                add     r8,     r9,     r8

                mov     r0,     #0b00001
                bl      Grab
                mov     r5,     r0
                add     r5,     #4
                str     r8,     [r5],   #8
                str     r8,     [r5],   #8
                
                add     r8,     r8,     #100
                str     r8,     [r5],   #8
                str     r8,     [r5]


                ldr     r1,     =MarioJumpImg
                bl      MarioPrint


                pop     {r3,    r10,    lr}
                bx      lr


//===================================================
//Takes in an input that tells whether jump is true or not. If jump is false then mario can fall. If
//Jump is true then mario will not fall. r0 = 1 is jump true, r0 = 0 is jump is false NOT DONE - Nantong
MarioFall:




//===================================================
//Takes in no arguments, Determines if Mario has reached the end of the stage. If not, it does not need 
//to return anything, but if he has reached the end then the game can print a win screen.
WinCond:        push    {r3,    r10,    lr}

                mov     r1,     #1
                bl      Grab
                ldr     r1,     [r0]
                ldr     r2,     =2772
                cmp     r1,     r2
                blt     EndWinCond
                mov	r0, #0		// initial x
	        mov	r1, #0		// initial y
	        ldr	r2, =1023	// final x
	        ldr	r3, =767	// final y
	        ldr	r4, =GameWonImg
	        bl	CreateImage
                b       GameOverLoop

EndWinCond:     pop     {r3,    r10,    lr}
                bx      lr

//===================================================
//NOT DONE - James
SlideScreen:    push    {r3,    r10,    lr}
                
                mov     r1,     #1
                bl      Grab    
                mov     r7,     r0

                

                pop     {r3,    r10,    lr}
                bx      lr
//===================================================
//Check for life loss
//NOT DONE - James
LifeLoss:


//===================================================
//Pause Menu
//NOT DONE - Nantong

//===================================================
//Score Printer prints score, coins and lives
//NOT DONE - James






