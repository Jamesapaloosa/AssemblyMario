//Game Starts here

        .section .text
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
                JUMP    .req r7         // detects if jump is over. 1 is jump 0 is no jump
                JUMPBASE .req r8         //if a jump is initiated the base value of mario's top left corner is saved
                JUMPX   .req r9         //Time counter for the jump equation


test:
                bl      PrintGameScreen
                bl      InitializeScore
                ldr     r1,     =MarioStandRImg
                bl      MarioPrint

Test2:
        
                bl      PrintObjects             //UP TO HERE WORKS
Test3:

GameLoop:       bl      WinCond
                bl      SlideScreen
                bl      LifeLoss

                cmp     JUMP,   #0
                beq     noJump
                add     JUMPX,  JUMPX, #1
                mov     r1,     JUMPX
                cmp     r1,     #31
                blt     JumpCont
                mov     JUMP,   #0
                b       noJump
JumpCont:       mov     r2,     JUMPBASE
                bl      MarioJump
                cmp     r0,     #0
                beq     noJump
                mov     JUMP,   #0
                
//Code that exicutes after the jump is dealt with
noJump:	        bl	getInput
	        mov	BUTTON, r0
	
	        mov	r0, BUTTON	// arg 1: the user input
	        ldr	r1, =RIGHT	// arg 2: desired button
	        bl	checkButton	// check if user pressed A
	        cmp	r0, #1	
                bne     Left	
                mov     r1,     #16
                mov     r2,     JUMP
                bl      MoveMarioLR
Left:           mov     r0, BUTTON
                ldr     r1,     =LEFT
                bl      checkButton
                cmp     r0,     #1
                bne     Jump
                mov     r1,     #-16
                mov     r2,     JUMP
                bl      MoveMarioLR

//Deal with when the a button is pushed and choose to set jump check
Jump:           mov     r0,     BUTTON
                ldr     r1,     =A
                bl      checkButton
                cmp     r0, #1
                bne     start
                cmp     JUMP,     #1
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
                bl      startMenu

                

GameOverLoop:
                b       GameOverLoop


//====================================================
MarioPrint:     
                push    {r4 - r6, lr}

                mov     r6,     r1
                mov     r1,     #0b00001
                bl      Grab
                mov     r5,     r0
                ldr	r0,     [r5], #4        // initial x
	        ldr	r1,     [r5], #20	// initial y
	        ldr	r2,     [r5], #4 	// final x
	        ldr	r3,     [r5]	        // final
                bl      displayConvert
                cmp     r0,     #-1
                beq     EndMarioPrint
	        mov     r4,     r6
	        bl	CreateImage
                
EndMarioPrint:  
                pop     {r4 - r6, pc}   

//====================================================
//Draws over objects when the screen is moved
//inputs???
PrintScreenMove:
                push    {r3 - r10,    lr}
                mov     r4,     #1
POSCREEN:       
                add     r4,     #1
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
        
                bl displayConvert
                cmp     r0,     #-1
                beq     POSCREEN
                ldr     r4,     =sky
                bl      CreateImage
                b       POSCREEN

EndPOSCREEN:      pop     {r3 - r10,    pc} 





//====================================================
//Draws objects that are on the screen other than mario
PrintObjects:   push    {r4 - r10, lr}
                mov     r10,     #0b00001
POLoop:         
                add     r10,     r10,   #0b00001
                cmp      r10,    #0b01010
                bge     EndPOLoop
                mov     r1,     r10
                bl      Grab
                mov     r5,     r0
                ldr	r0,     [r5], #4        // initial x
	        ldr	r1,     [r5], #20	// initial y
	        ldr	r2,     [r5], #4 	// final x
	        ldr	r3,     [r5]	        // final y

                bl      displayConvert
                cmp     r0,     #-1
                beq     POLoop

                mov     r6,     r0
                mov     r7,     r1
                mov     r8,     r2
                mov     r9,     r3

                mov     r1,     r10
                bl      GrabImage
                mov     r4,     r0
                mov     r0,     r6
                mov     r1,     r7
                mov     r2,     r8
                mov     r3,     r9
                bl      CreateImage
                b       POLoop
                

EndPOLoop:                    pop     {r4 - r10, pc} 
        

//====================================================
//Prints sky over mario
EraseMario:     
                push    {r4 - r10, lr}
                mov     r1,     #0b00001
                bl      Grab
                mov     r5,     r0
                ldr	r0,     [r5], #4
	        ldr	r1,     [r5], #20	// initial y
	        ldr	r2,     [r5], #4 	// final x
	        ldr	r3,     [r5]	        // final y
                bl      displayConvert
	        ldr     r4,     =sky
	        bl	CreateImage
                
EndEraseMario:  
                pop     {r4 - r10, pc}
//===================================================
Wait:
                push    {r3 - r10,    lr}
                ldr     r0, =0x3f003004
                ldr     r2,     [r0]
                add     r1,     r2                      //Time to wait is added to current time

Checktime:      ldr     r2,     [r0]                    //loop that decides if the desired amount of time was waited
                cmp     r1,     r2
                bhi     Checktime

                pop     {r3 - r10, pc}
//===================================================
//Takes in the direction to move in r1
//Needs to take in if jump is true or not in r2 NOT DONE
//Nees to check if move out of screen
MoveMarioLR:
                push    {r3 - r10,    lr}
                mov     r1,     #0b00000
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
                bl      EraseMario
                mov     r1,     #0b00001
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
                b       MoveMario1
JumpLeft1:      
                ldr     r4,     =MarioJumpRightImg
                b       MoveMario1       
                

                //if not jumping, decide which way to face
NoJump1:        
                cmp     r7,     #0
                blt     WalkLeft1
                ldr     r4,     =MarioWalkRImg
                b       MoveMario1
WalkLeft1:      
                ldr     r4,     =MarioWalkLImg
MoveMario1:     
                bl      MarioPrint


//Print mario standing now
                mov     r1,     #0b00000
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
                //Check for collision again
                bl      objectCollision
                cmp     r0,     #0
                beq     nocol2
                mov     r1,     r7
                mov     r2,     r0
                bl      CollisionHandler
                b       EndMoveMarioLR

nocol2:         
                bl      EraseMario
                mov     r1,     #0b00001
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
                blt    JumpLeft2
                ldr     r4,     =MarioJumpLeftImg
                b       MoveMario2
JumpLeft2:      
                ldr     r4,     =MarioJumpRightImg
                b       MoveMario2       
                //if not jumping, decide which way to face
NoJump2:        
                cmp     r7,     #0
                blt     WalkLeft2
EndMoveMarioLR: 
                ldr     r4,     =MarioWalkRImg
                b       MoveMario2
WalkLeft2:      
                ldr     r4,     =MarioWalkLImg
MoveMario2:     
                bl      MarioPrint

                pop     {r3 - r10, pc}
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
                push    {r3 - r10,    lr}

                mov     r1,     r8
                mov     r2,     r9



                pop     {r3 - r10, pc}



//===================================================
//Based on the equation 30x - x^2
//Takes in the x value in r1 which represents time against the y value 
//Takes in the initial height of mario's top left corner in r2
//Returns if collision happend so that jump can end, 0 is no collision, -1 is collision
MarioJump:
                push    {r3 - r10,    lr}
                bl      EraseMario
                mov     r8,     r1                      //place the mario x value for the jump in r8
                mov     r9,     r2                      //place the mario initial y value in r9
//Calculate the new y coordinates of Mario
                lsl     r8,     #5
                sub     r8,     r1
                sub     r8,     r1
                mul     r1,     r1,     r1
                sub     r8,     r8,     r1

                sub     r8,     r9,     r8
//Try in temp to check for collisions
                mov     r1,     #0b00000
                bl      Grab
                mov     r5,     r0
                add     r5,     #4
                str     r8,     [r5],   #8
                str     r8,     [r5],   #8
                
                sub     r8,     r8,     #50             //sub 50 for the bottom two locations
                str     r8,     [r5],   #8
                str     r8,     [r5]

                bl      objectCollision
                cmp     r0,     #0
                beq     JumpNoCol
                mov     r2,     r0
                bl      CollisionHandler
                mov     r0,     #-1
                b       EndJump

JumpNoCol:      
                mov     r1,     #0b00001
                bl      Grab
                mov     r5,     r0
                add     r5,     #4
                str     r8,     [r5],   #8
                str     r8,     [r5],   #8
                
                sub     r8,     r8,     #50
                str     r8,     [r5],   #8
                str     r8,     [r5]
                
EndJump:        
                ldr     r1,     =MarioJumpRightImg
                bl      MarioPrint

                pop     {r3 - r10, pc}


//===================================================
//Takes in an input that tells whether jump is true or not. If jump is false then mario can fall. If
//Jump is true then mario will not fall. r0 = 1 is jump true, r0 = 0 is jump is false 
//NOT DONE - Nantong
MarioFall:




//===================================================
//Takes in no arguments, Determines if Mario has reached the end of the stage. If not, it does not need 
//to return anything, but if he has reached the end then the game can print a win screen.
//NOT DONE NEED TO PRINT BLANK PAGE
WinCond:        
                push    {r3 - r10,    lr}

                mov     r1,     #1
                bl      Grab
                ldr     r1,     [r0]
                ldr     r2,     =2772
                cmp     r1,     r2
                blt     EndWinCond
                bl      PrintGameScreen
                b       GameOverLoop

EndWinCond:     
                pop     {r3 - r10, pc}

//===================================================
//Takes in no parameters, detects if Mario has moved to close to the edge
//of the screen, and if so slides the screen by the same value that mario
//moves, which is hard coded to 20 at the moment. Gives no return type.
SlideScreen:    
                push    {r3 - r10,    lr}
                
                mov     r1,     #1
                bl      Grab    
                mov     r7,     r0
                ldr     r5,     [r7]

                bl      Grab_Screen
                mov     r8,     r0
                ldr     r4,     [r8]
                add     r4,     #200

                cmp     r4,     r5
                blt     SlideLeft

                ldr     r3,     [r8, #4]
                sub     r3,     #200
                cmp     r5,     r3
                bgt     SlideRight
                b       EndSlide

SlideLeft:      
                ldr     r4,     [r8]
                ldr     r3,     [r8, #4]

                mov     r6,     #0
                str     r6,     [r8]
                ldr     r6,     =1023
                str     r6,     [r8, #4]

                cmp     r4,     #0
                ble     EndSlide
                bl      PrintScreenMove
                sub     r4,     r4,     #20
                str     r4,     [r8]

                sub     r3,     r3,     #20
                str     r3,     [r8]
                b       RePrintOb

SlideRight:     
                bl      PrintScreenMove
                ldr     r4,     [r8] 
                add     r4,     r4,     #20
                str     r4,     [r8]

                ldr     r4,     [r8],   #4
                add     r4,     r4,     #20
                str     r4,     [r8]

RePrintOb:      
                bl      PrintObjects

EndSlide:       
                pop     {r3 - r10, pc}
//===================================================
//Check for life loss, Checks if the game is over due to loss of lives
//Jumps to end of game if lives equals zero
LifeLoss:       
                push    {r3 - r10,    lr}

                ldr     r0,     =Life
                cmp     r0,     #0
                bgt     LifeLossEnd
                bl      PrintGameScreen
                b       GameOverLoop
                
LifeLossEnd:    
                pop     {r3 - r10, pc}

//===================================================
//Pause Menu
//NOT DONE - Nantong

//===================================================
//Score Printer prints score, coins and lives
//Takes in no inputs, Gives no output, when score is changed, this method 
//should be called to update the screen
//NOT DONE - James
ScorePrinter:   
                push    {r2 - r10, lr}

                pop     {r2 - r10, pc}



//===================================================
//No Input no returns
//Initialize Score and Life and coins
InitializeScore:        
                        push    {r2 - r4, lr}

                        ldr     r0,     =Life
                        mov     r1,     #3
                        str     r1,     [r0],    #4
                        mov     r1,     #0
                        str     r1,     [r0],    #4
                        str     r1,     [r0]
                        bl      ScorePrinter

                pop     {r2 - r4, pc}
//===================================================
//Goomba logic
//NOT DONE
//===================================================
PrintGameScreen:        
                        push    {r2 - r10, lr}
                        ldr     r5,     =1023
                        ldr     r10,    =736
                        mov     r6,      #0     //x1
                        mov     r7,      #0     //y1
                        mov     r8,      #31    //x2
                        mov     r9,     #31     //y2  
      
GSLoop:                 
                        mov     r0,     r6
                        mov     r1,     r7
                        mov     r2,     r8
                        mov     r3,     r9
                        ldr     r4,     =sky
                        bl      CreateImage
                        add     r6,     #32
                        add     r8,     #32
                        cmp     r8,     r5
                        ble     GSLoop
                        add     r7,     #31
                        add     r9,     #31
                        mov     r6,     #0
                        mov     r8,     #31
                        cmp     r9,     r10
                        ble     GSLoop

                        ldr     r10,    =767
GSLoop1:                
                        mov     r0,     r6
                        mov     r1,     r7
                        mov     r2,     r8
                        mov     r3,     r9
                        ldr     r4,     =ground
                        bl      CreateImage
                        add     r6,     #32
                        add     r8,     #32
                        cmp     r8,     r5
                        ble     GSLoop1
                        add     r7,     #31
                        add     r9,     #31
                        mov     r6,     #0
                        mov     r8,     #31
                        cmp     r9,     r10
                        ble     GSLoop1


                pop     {r2 - r10, pc}
                        

	.unreq	BUTTON
	.unreq	JUMP
	.unreq	JUMPX
	.unreq	JUMPBASE

//===================================================
.section .data

Life:   .int            0
Score:  .int            0
Coins:  .int            0





