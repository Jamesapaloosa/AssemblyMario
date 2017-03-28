//Game Starts here

        .section .text
        .globl BeginGame
        .globl PrintGameScreen
        .globl Life
        .globl Score
        .globl Coins
        .globl NewLife
        .globl ScorePrinter
        .globl InitializeValuePack
        .globl MarioPrint
        .globl PrintObjects
        .globl Resume

	.equ	SEL, 0b110111111111
	.equ	START, 0b111011111111
	.equ	UP, 0b111101111111
	.equ	DOWN, 0b111110111111
	.equ	LEFT, 0b111111011111
	.equ	RIGHT, 0b111111101111
	.equ	A, 0b111111110111
BeginGame:      
                bl      Init_Boxes        
                BUTTON  .req r6		// contains the button pressed
                JUMP    .req r7         // detects if jump is over. 1 is jump 0 is no jump
                JUMPBASE .req r8         //if a jump is initiated the base value of mario's top left corner is saved
                JUMPX   .req r9         //Time counter for the jump equation
                bl      InitializeScore  

NewLife:        bl      init_Objects
                bl      PrintGameScreen
                bl      LifeLoss
                ldr     r1,     =MarioStandRImg
                bl      MarioPrint
                bl      PrintObjects
                bl      ScorePrinter
Resume:         mov     JUMP,   #0
                mov     JUMPX,   #0


GameLoop:       mov     r1,     JUMP
                mov     r4,     JUMPX
                bl	getInputGame           //UP TO HERE WORKS
                mov     JUMPX,  r1
	        mov	BUTTON, r0
                mov     JUMP,   #0
TEST:	
	        mov	r0, BUTTON	// arg 1: the user input
	        ldr	r1, =RIGHT	// arg 2: desired button
	        bl	checkButton	// check if user pressed A
	        cmp	r0, #1	
                bne     Left	
                mov     r1,     #4
                mov     r2,     JUMP
                bl      MoveMarioLR
Left:           mov     r0, BUTTON
                ldr     r1,     =LEFT
                bl      checkButton
                cmp     r0,     #1
                bne     Jump
                mov     r1,     #-4
                mov     r2,     JUMP
                bl      MoveMarioLR

//Deal with when the a button is pushed and choose to set jump check
Jump:           mov     r0,     BUTTON
                ldr     r1,     =A
                bl      checkButton
                cmp     r0, #1
                bne     start
                mov     JUMP,  #1


start:          mov     r0,     BUTTON
                ldr     r1,     =START
                bl      checkButton     
                cmp     r0,     #1
                bne     GameLoop
                bl      pauseMenu

                

GameOverLoop:
                b       GameOverLoop


//====================================================
MarioPrint:     
                push    {r4 - r10, lr}

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
                pop     {r4 - r10, pc}   

//====================================================
//Draws over objects when the screen is moved
PrintScreenMove:
                push    {r3 - r10,    lr}
                mov     r10,     #0
POSCREEN:       
                add     r10,     #1
                cmp     r10,    #16
                bge     EndPOSCREEN
                mov     r1,     r10
                bl      Grab
                mov     r5,     r0
                ldr	r0,     [r5], #4
	        ldr	r1,     [r5], #20	// initial y
	        ldr	r2,     [r5], #4 	// final x
	        ldr	r3,     [r5]	        // final y
        
                bl displayConvert
                cmp     r0,     #-1
                beq     POSCREEN
                
                cmp     r10,    #13
                blt     drawSky
                ldr     r4,     =ground
                b       PaintOver
drawSky:        ldr     r4,     =sky

PaintOver:       
                bl      CreateImage
                b       POSCREEN

EndPOSCREEN:      pop     {r3 - r10,    pc} 





//====================================================
//Draws objects that are on the screen other than mario
PrintObjects:   push    {r4 - r10, lr}
                mov     r10,     #0b00001
POLoop:         
                add     r10,     r10,   #0b00001
                cmp      r10,    #17
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
//Takes in the direction to move in r1
//Needs to take in if jump is true or not in r2 NOT DONE
//Nees to check if move out of screen
MoveMarioLR:
                push    {r3 - r10,    lr}
                mov     r7,     r1              //put the direction value in a safe place
                mov     r8,     r2              //put the jump state in a safe place
                mov     r1,     #0b00000
                bl      Grab
                mov     r5,     r0
                mov     r1,     #0b00001
                bl      Grab
                mov     r6,     r0
                ldr     r0,     [r6]
                add     r0,     r0,     r7
                str     r0,     [r5],   #8
                ldr     r1,     [r6]
                add     r1,     r1,     r7
                str     r1,     [r5],   #8
                ldr     r2,     [r6]
                add     r2,     r2,     r7
                str     r2,     [r5],   #8
                ldr     r3,     [r6]
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
                cmp     r8,     #0
                beq     NoJump1
                cmp     r7,     #0
                blt    JumpLeft1
                ldr     r1,     =MarioJumpLeftImg
                b       MoveMario1
JumpLeft1:      
                ldr     r1,     =MarioJumpRightImg
                b       MoveMario1       
                

                //if not jumping, decide which way to face
NoJump1:        
                cmp     r7,     #0
                blt     WalkLeft1
                ldr     r1,     =MarioWalkRImg
                b       MoveMario1
WalkLeft1:      
                ldr     r1,     =MarioWalkLImg
MoveMario1:     
                bl      MarioPrint


//Print mario standing now
                mov     r1,     #0b00000
                bl      Grab
                mov     r5,     r0
                mov     r1,     #0b00001
                bl      Grab
                mov     r6,     r0
                ldr     r0,     [r6]
                add     r0,     r0,     r7
                str     r0,     [r5],   #8
                ldr     r1,     [r6]
                add     r1,     r1,     r7
                str     r1,     [r5],   #8
                ldr     r2,     [r6]
                add     r2,     r2,     r7
                str     r2,     [r5],   #8
                ldr     r3,     [r6]
                add     r3,     r3,     r7
                str     r3,     [r5],   #8
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
                mov     r0,     #200     
                bl      Wait         
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

                bl      SlideScreen  

                cmp     r8,     #0
                beq     NoJump2
                cmp     r7,     #0
                blt    JumpLeft2
                ldr     r1,     =MarioJumpLeftImg
                b       MoveMario2
JumpLeft2:      
                ldr     r1,     =MarioJumpRightImg
                b       MoveMario2       
                //if not jumping, decide which way to face
NoJump2:        
                cmp     r7,     #0
                blt     WalkLeft2
EndMoveMarioLR: 
                ldr     r1,     =MarioStandRImg
                b       MoveMario2
                mov     r10,    #1
WalkLeft2:      
                ldr     r1,     =MarioStandLImg
                mov     r10,    #0
MoveMario2:     
                bl      MarioPrint
                mov     r0,     #200   
                bl      Wait         
                pop     {r3 - r10, pc}



//===================================================
//Mario Jump
//Takes in the x value in r1 which represents time against the y value 
//Takes in the initial height of mario's top left corner in r2
//Returns if collision happend so that jump can end, 0 is no collision, -1 is collision


MarioJump:
               push    {r3 - r10,    lr}
               bl EraseMario
               mov r1, #0b00000
               bl Grab
                mov     r5,     r0
                mov     r1,     #0b00001
                bl      Grab
                mov     r6,     r0
                ldr	r0,     [r6,#4]            // initial x
	        ldr	r1,     [r6, #12]	// initial y
	        ldr	r2,     [r6, #20] 	// final x
	        ldr	r3,     [r6, #28]	// final

                sub     r0,     #8
                sub     r1,     #8
                sub     r2,     #8
                sub     r3,     #8

                str	r0,     [r5,#4]            // initial x
	        str	r1,     [r5, #12]	// initial y
	        str	r2,     [r5, #20] 	// final x
	        str	r3,     [r5, #28]	// final
                
               bl objectCollision
               cmp r0, #0
               beq      NoJumpCol
                mov     r2,     r0
                bl      CollisionHandler
                ldr     r1,     =MarioJumpRightImg
                bl      MarioPrint
                b       endJump

NoJumpCol:     mov r1, #0b00001
               bl Grab
                mov     r5,     r0
                bl      Grab
                mov     r6,     r0
                ldr	r0,     [r5,#4]            // initial x
	        ldr	r1,     [r5, #12]	// initial y
	        ldr	r2,     [r5, #20] 	// final x
	        ldr	r3,     [r5, #28]	// final

                sub     r0,     #8
                sub     r1,     #8
                sub     r2,     #8
                sub     r3,     #8

                str	r0,     [r5,#4]            // initial x
	        str	r1,     [r5, #12]	// initial y
	        str	r2,     [r5, #20] 	// final x
	        str	r3,     [r5, #28]	// final
                ldr     r1,     =MarioJumpRightImg
                bl      MarioPrint
endJump:               
                pop     {r3 - r10, pc}

//===================================================
//Goomba Logic
//Goomba takes mario's location and tries to chase him but will stop at the hole
GoombaLogic:
                push {r3 - r10, lr}
                mov     r1,     #2
                bl      Grab
                mov     r5,     r0
                ldr     r6,     =1152

                mov     r1,     #1
                bl      Grab
                ldr     r4,     [r0]
                ldr     r3,     [r5]
                cmp     r3,     r6
                bge     EndGoomba
                cmp     r3,     r4
                bgt     GoombaLeft
                mov     r7,     #1
                b       MoveGoomba
                

GoombaLeft:     mov     r7,     #-1
                
MoveGoomba:     mov     r1,     #0b00010
                bl      Grab
                mov     r5,     r0
                ldr	r0,     [r5], #4
	        ldr	r1,     [r5], #20	// initial y
	        ldr	r2,     [r5], #4 	// final x
	        ldr	r3,     [r5]	        // final y
                bl      displayConvert
	        ldr     r4,     =sky
	        bl	CreateImage
                mov     r1,     #0b00010
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
                mov     r1,     #0b00010
                bl      Grab
                mov     r5,     r0
                ldr	r0,     [r5], #4
	        ldr	r1,     [r5], #20	// initial y
	        ldr	r2,     [r5], #4 	// final x
	        ldr	r3,     [r5]	        // final y
                bl      displayConvert
	        ldr     r4,     =goomba
	        bl	CreateImage


EndGoomba:      pop     {r3 - r10, pc}

//===================================================
//Bill Logic
//should scroll across the screen and kill mario
BillLogic:      push    {r3 - r10, lr}

                
                
                mov     r7,     #-5

                mov     r1,     #0b001001
                bl      Grab
                mov     r5,     r0
                ldr	r0,     [r5], #4
                cmp     r0,     #32
                blt     InitBill
	        ldr	r1,     [r5], #20	// initial y
	        ldr	r2,     [r5], #4 	// final x
	        ldr	r3,     [r5]	        // final y
                bl      displayConvert
	        ldr     r4,     =sky
	        bl	CreateImage
                mov     r1,     #0b001001
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
                mov     r1,     #0b001001
                bl      Grab
                mov     r5,     r0
                ldr	r0,     [r5], #4
	        ldr	r1,     [r5], #20	// initial y
	        ldr	r2,     [r5], #4 	// final x
	        ldr	r3,     [r5]	        // final y
                bl      displayConvert
	        ldr     r4,     =bullet
	        bl	CreateImage
                b       EndBillLogic
                
InitBill:       bl      displayConvert
                ldr     r4,     =sky
                bl      CreateImage
                mov     r1,     #0b001001
                bl      Grab
                ldr     r1,     =2772
                str     r1,     [r0], #4
                ldr     r1,     =155
                str     r1,     [r0], #4
                ldr     r1,     =2803
                str     r1,     [r0], #4
                ldr     r1,     =155
                str     r1,     [r0], #4
                ldr     r1,     =2772
                str     r1,     [r0], #4
                ldr     r1,     =186
                str     r1,     [r0], #4
                ldr     r1,     =2803
                str     r1,     [r0], #4
                ldr     r1,     =186
                str     r1,     [r0], #4

EndBillLogic:   
                pop     {r3 - r10, pc}

//===================================================
//Takes in an input that tells whether jump is true or not. If jump is false then mario can fall. If
//Jump is true then mario will not fall. r0 = 1 is jump true, r0 = 0 is jump is false 
MarioFall:
                push    {r4 - r10,    lr}
                mov      r9,     #0
                mov r1, #0b00001
                bl Grab
                mov     r5,     r0
                ldr     r6,     [r5]
                ldr     r7,     =1183
                cmp     r6,     r7
                bgt     CheckHole1
                b       NotOverHole
                
CheckHole1:     ldr     r7,     =1245
                ldr     r6,     [r5, #8]
                cmp     r6,     r7
                bge     NotOverHole
                ldr     r6,     [r5,#4]
                ldr     r7,     =713
                cmp     r6,     r7
                bge     killMario
                bl      EraseMario
                b       NofallCol




NotOverHole:    ldr	r0,     [r5,#4]         
	        ldr	r1,     [r5, #12]	
	        ldr	r2,     [r5, #20] 	
	        ldr r8, =713
	        cmp r2, r8
	        bge endfall
	        ldr	r3,     [r5, #28]
	        bl EraseMario

                add     r0,     #8
                add     r1,     #8
                add     r2,     #8
                add     r3,     #8

               mov r1, #0b00000
               bl Grab
                mov     r5,     r0
                str	r0,     [r5,#4]            // initial x
	        str	r1,     [r5, #12]	// initial y
	        str	r2,     [r5, #20] 	// final x
	        str	r3,     [r5, #28]	// final
                
               bl objectCollision
               cmp r0, #0
               beq      NofallCol
                mov     r9,     #0
                mov     r2,     r0
                bl      CollisionHandler
                ldr     r1,     =MarioJumpRightImg
                bl      MarioPrint
                b       endfall

NofallCol:     mov r1, #0b00001
               bl Grab
                mov     r5,     r0
                ldr	r0,     [r5,#4]            // initial x
	        ldr	r1,     [r5, #12]	// initial y
	        ldr	r2,     [r5, #20] 	// final x
	        ldr	r3,     [r5, #28]	// final

                add     r0,     #8
                add     r1,     #8
                add     r2,     #8
                add     r3,     #8

                str	r0,     [r5,#4]            // initial x
	        str	r1,     [r5, #12]	// initial y
	        str	r2,     [r5, #20] 	// final x
	        str	r3,     [r5, #28]	// final
                mov     r9,     #1
                

 		ldr     r1,     =MarioStandRImg
                bl      MarioPrint
                mov     r0,     r9
   endfall:     pop     {r4 - r10,      pc}


//===================================================
//Takes in no arguments, Determines if Mario has reached the end of the stage. If not, it does not need 
//to return anything, but if he has reached the end then the game can print a win screen.
WinCond:        
                push    {r3 - r10,    lr}

                mov     r1,     #1
                bl      Grab
                ldr     r1,     [r0]
                ldr     r2,     =2772
                cmp     r1,     r2
                blt     EndWinCond
                bl      PrintGameScreen
                ldr	r0, =336		// initial x
	        ldr	r1, =299		// initial y
	        ldr	r2, =685	// final x
	        ldr	r3, =379	// final y
	        ldr	r4, =win_img
	        bl	CreateImage
                b       GameOverLoop

EndWinCond:     
                pop     {r3 - r10, pc}

//===================================================
//Takes in no parameters, detects if Mario has moved to close to the edge
//of the screen, and if so slides the screen by the same value that mario
//moves, which is hard coded to 31 at the moment. Gives no return type.
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

                cmp     r5,     r4
                blt     SlideLeft

                ldr     r3,     [r8, #4]
                sub     r3,     #200
                cmp     r5,     r3
                bgt     SlideRight
                b       RePrintOb

SlideLeft:      bl      PrintScreenMove
                ldr     r4,     [r8]
                ldr     r3,     [r8, #4]

                mov     r6,     #0
                str     r6,     [r8]
                ldr     r6,     =1023
                str     r6,     [r8, #4]

                cmp     r4,     #0
                ble     RePrintOb
                sub     r4,     r4,     #31
                str     r4,     [r8], #4

                sub     r3,     r3,     #31
                str     r3,     [r8]
                b       RePrintOb

SlideRight:     
                bl      PrintScreenMove
                ldr     r4,     [r8] 
                add     r4,     r4,     #31
                str     r4,     [r8],   #4

                ldr     r4,     [r8]
                add     r4,     r4,     #31
                str     r4,     [r8]

RePrintOb:      bl      PrintObjects

EndSlide:       
                pop     {r3 - r10, pc}
//===================================================
//Check for life loss, Checks if the game is over due to loss of lives
//Jumps to end of game if lives equals zero
LifeLoss:       
                push    {r3 - r10,    lr}

                ldr     r0,     =Life
                ldr     r1,     [r0]
                cmp     r1,     #0
                bgt     LifeLossEnd
                bl      PrintGameScreen
                ldr	r0, =336		// initial x
	        ldr	r1, =299		// initial y
	        ldr	r2, =685	// final x
	        ldr	r3, =379	// final y
	        ldr	r4, =lose_img
	        bl	CreateImage
                b       GameOverLoop
                
LifeLossEnd:    
                pop     {r3 - r10, pc}

//===================================================
//Pause Menu

//===================================================
//Score Printer prints score, coins and lives
//Takes in no inputs, Gives no output, when score is changed, this method 
//should be called to update the screen
ScorePrinter:   
                push    {r4 - r10, lr}

                ldr	r0, =31		// initial x
	        ldr	r1, =31		// initial y
	        ldr	r2, =158	// final x
	        ldr	r3, =62 	// final y
	        ldr	r4, =score
                bl      CreateImage
        
                bl      DrawChar
                
                ldr	r0, =772	// initial x
	        ldr	r1, =31		// initial y
	        ldr	r2, =899	// final x
	        ldr	r3, =62 	// final y
	        ldr	r4, =life
                bl      CreateImage
//prints the sign saying life                
      
                ldr	r0, =899	// initial x
	        ldr	r1, =31		// initial y
	        ldr	r2, =930	// final x
	        ldr	r3, =62 	// final y

                ldr     r5,     =Life
                ldr     r5,     [r5]

                mov     r6,     r0
                mov     r7,     r1
                mov     r8,     r2
                mov     r9,     r3
//responsible for printing the different mushrooms that represent life
LifeLoop:       cmp     r5,     #0
                ble     endLifeLoop

                mov     r0,     r6
                mov     r1,     r7
                mov     r2,     r8
                mov     r3,     r9               

	        ldr	r4, =mushroom
                bl      CreateImage
                sub     r5,     r5,     #1

                add     r6,     r6,     #31
                add     r8,     r8,     #31
                
                b       LifeLoop
//begins printing the coin label 
endLifeLoop:    ldr	r0, =31		// initial x
	        ldr	r1, =62		// initial y
	        ldr	r2, =94 	// final x
	        ldr	r3, =93 	// final y
	        ldr	r4, =CoinCount
                bl      CreateImage

                ldr	r0, =94 	// initial x
	        ldr	r1, =93		// initial y
	        ldr	r2, =125	// final x
	        ldr	r3, =124 	// final y

                ldr     r5,     =Coins
                ldr     r5,     [r5]

                mov     r6,     r0
                mov     r7,     r1
                mov     r8,     r2
                mov     r9,     r3

CoinLoop:       cmp     r5,     #0
                ble     endCoinLoop

                mov     r0,     r6
                mov     r1,     r7
                mov     r2,     r8
                mov     r3,     r9               

	        ldr	r4, =coin
                bl      CreateImage
                sub     r5,     r5,     #1

                add     r6,     r6,     #31
                add     r8,     r8,     #31
                
                b       CoinLoop

endCoinLoop:

                pop     {r4 - r10, pc}



//===================================================
//No Input no returns
//Initialize Score and Life and coins to generic values of three
//and zero
InitializeScore:        
                        push    {r2 - r4, lr}

                        ldr     r0,     =Life
                        mov     r1,     #3
                        str     r1,     [r0],    #4
                        mov     r1,     #0
                        str     r1,     [r0],    #4
                        str     r1,     [r0]

                pop     {r2 - r4, pc}
//===================================================
//Prints cells of 32 by 32 with either sky or ground
//loops through the cells and prints the sky image
PrintGameScreen:        
                        push    {r2 - r10, lr}
                        ldr     r5,     =1023
                        ldr     r10,    =703
                        mov     r6,      #0     //x1
                        mov     r7,      #0     //y1
                        mov     r8,      #31    //x2
                        mov     r9,     #31     //y2  
      
GSLoop1:                cmp     r8,     r5
                        bgt     GSLoop2
                        mov     r0,     r6
                        mov     r1,     r7
                        mov     r2,     r8
                        mov     r3,     r9
                        ldr     r4,     =sky
                        bl      CreateImage
                        add     r6,     #31
                        add     r8,     #31
                        b       GSLoop1


GSLoop2:                cmp     r9,     r10
                        bge     TempGS
                        add     r7,     #31
                        add     r9,     #31
                        mov     r6,     #0
                        mov     r8,     #31
                        b       GSLoop1

TempGS:
                        ldr     r10,    =767
GSLoop3:                cmp     r8,     r5
                        bgt     GSLoop4
                        mov     r0,     r6
                        mov     r1,     r7
                        mov     r2,     r8
                        mov     r3,     r9
                        ldr     r4,     =ground
                        bl      CreateImage
                        add     r6,     #31
                        add     r8,     #31
                        b       GSLoop3


GSLoop4:                cmp     r9,     r10
                        bge     ENDGS
                        add     r7,     #31
                        add     r9,     #31
                        mov     r6,     #0
                        mov     r8,     #31
                        b       GSLoop3

ENDGS:                  pop     {r2 - r10, pc}
                        

	.unreq	BUTTON
	.unreq	JUMP
	.unreq	JUMPX
	.unreq	JUMPBASE

//===================================================
objectCollision:

push	{r4-r12,lr}

	mov r1, #0b00000
	//load values of mario into respective registers
	xLeft1  	.req 	r5			//left x coordinate for first object
	xRight1 	.req	r6			//right x coordinate for first object
	yDown1  	.req	r7			//Down y coordinate for first object
	yUp1		.req    r8				//up y coordinate for first object
	bl Grab


	ldr     xLeft1,     [r0], #4
	ldr     yUp1,       [r0], #20
	ldr     xRight1,    [r0], #4
	ldr     yDown1,     [r0]
	
	mov r1,   #0b00010
        mov     r4,     r1

	//load values of object two into respective registers
grabObject:
        mov     r1,     r4
	bl Grab
	xLeft2 	        .req  r9				//left x coordinate for second object
	xRight2	        .req  r10			//right x coordinate for first object
	yDown2	        .req  r11			//Down y coordinate for first object
	yUp2		.req  r12			//up y coordinate for first object

	ldr xLeft2,     [r0], #4
	ldr yUp2,       [r0], #20
	ldr xRight2,    [r0], #4
	ldr yDown2,     [r0]

	mov r0, xLeft2
	mov r1, yUp2
	mov r2, xRight2
	mov r3, yDown2

bl displayCheck
	cmp r0, #0
	beq next

//algorithm from
//https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection

	cmp 	xLeft1, xRight2			//check if left side of object one overlaps with right side of
	bgt 	noCollDetected							//object two, if they don't, branch to exit
	
	cmp 	xRight1, xLeft2			//check if right side of object one overlaps with left side of
	blt	noCollDetected						//object two, if they don't, branch to exit
	
	cmp	yDown1, yUp2				//check if lower bound of object one overlaps with upper bound
	blt	noCollDetected							//of object two, if they don't, branch to exit
	
	cmp	yUp1, yDown2				//check if upper bound of object one overlaps with lower bound
	bgt	noCollDetected							//of object two, if they don't, branch to exit



collDetected:

	mov r0, r4			//move code of object to r0 if collision is detected
	b exit				//branch to exit when collision is detected
	
noCollDetected:
	mov r0, #0

next:
	add r4, r4, #0b00001		//add 1 to object code
	cmp r4, #13
	blt grabObject
exit:   pop {r4-r12, pc}

//===============================================
//Game controller input is from here on

	.equ	BASE_ADRS, 0x3f200000
	.equ	LATCH, 9
	.equ	DATA, 10
	.equ	CLOCK, 11
	.equ	UN_PRESS, 4095

	DONE_FLAG .req r10
	SAVED_BUTTONS .req r9	



//Needs to take in an argument about if fall is true and if jump is true
getInputGame:
	push	{r4-r11, lr}
        
//	mov	SAVED_BUTTONS, r5	// save the current state of the buttons
pressLoop:	
        mov     r10,    r1
        mov     r9,    r4
        bl      WinCond
        bl      GoombaLogic
        //bl      BillLogic
        cmp     r9,     #0
        beq     Falling
        mov     r1,     r9
        bl      MarioJump
        b       NewJump

Falling: 

                bl      MarioFall
                cmp     r0,     #1
                beq     NoJump
                cmp     r10,    #1
                beq     NewJump
                b       NoJump

NewJump:        cmp     r10,    #0
                beq     NoJump
                cmp     r9,     #0
                bne     NoJump
                mov     r9,     #8
        

NoJump:	bl	Read_SNES		// Begin reading controller input

	mov	r5, r0			// Store 'buttons' array
	bl	Check_Buttons		// Check for flags
	mov	r8, r1			// sets flag for whether any buttons have been pressed
//	cmp	SAVED_BUTTONS, r5	// checks whether buttons have changed
//	beq	pressLoop		// if not, keep looping
	
        cmp     r9,     #0
        beq     noSub
        sub     r9,     r9,     #1
noSub:  cmp     r8,     #0
//	moveq	SAVED_BUTTONS, r5	// if not, preserves unpressed state
	beq	pressLoop		// it also keeps looping

	lsr	r5, #5			// shift the unneeded four bits out (13-16)
	mov	r0, r5			// returns buttons pressed to main
        mov     r1, r9
	pop	{r4-r11, lr}
	bx 	lr


Check_Buttons:
	push	{r4-r10, lr}

	mov	r3, r0			// checks if no buttons have been pressed
	lsr	r3, #5			// remove unused right bits
	ldr	r2, =UN_PRESS		// loads 0b111111111111, 0b1^(12)
	cmp	r3, r2			// checks if any buttons have been pressed 
	moveq	r1, #0			// returns 0 if none have been pressed
	movne	r1, #1			// returns 1 otherwise

	pop	{r4-r10, lr}
	bx 	lr

Init_GPIO:
	push	{r4-r10, lr}
	
	PIN .req r4
	FUNC .req r1
	ADRS .req r3
	REG .req r5
	
	ldr	ADRS, =BASE_ADRS	// retrieve base address
	mov	PIN, r0
	mov	REG, #0			// the register number

setPin:
	cmp	PIN, #9			// check if pin number is isolated to one's column
	subgt	PIN, #10		// if not, subtract by 10
	addgt	REG, #1			// increase the register number
	bgt	setPin			// continue to loop until left with one's column

	add	ADRS, REG, lsl #2	// retrieve address (address + (register * 4))
	add	PIN, PIN, PIN, lsl #1	// PIN*3 = (PIN+(PINx2))
	lsl	FUNC, PIN		// align function to desired bits
	
	ldr	r6, [ADRS]		// retrieve value from address
	mov	r7, #7			// create the bit mask
	lsl	r7, PIN			// align the mask	
	bic	r6, r7			// clear the bits
	orr	r6, FUNC		// place the function
	str	r6, [ADRS]		// store changed value		
	
	.unreq PIN
	.unreq FUNC
	.unreq ADRS
	.unreq REG

	pop	{r4-r10, lr}
	bx	lr

// takes an integer parameter
// PARAM = 0, clear latch
// PARAM = 1, set latch
Write_Latch:
	PIN .req r0
	PARAM .req r1
	
	push	{r4-r10, lr}

	mov	PIN, #LATCH		// LATCH
	ldr	r2, =BASE_ADRS		// BASE GPIO REGISTER
	mov	r3, #1	
	lsl	r3, PIN			// ALIGN BIT FOR PIN 9
	teq	PARAM, #0
	streq	r3, [r2, #40]		// GPCLEAR0
	strne	r3, [r2, #28]		// GPSET0

	pop	{r4-r10, lr}
	bx	lr

Write_Clock:
	push	{r4-r10, lr}

	mov	PIN, #CLOCK		// CLOCK
	ldr	r2, =BASE_ADRS		// BASE GPIO REGISTER
	mov	r3, #1	
	lsl	r3, PIN			// ALIGN BIT FOR PIN 10
	teq	PARAM, #0
	streq	r3, [r2, #40]		// GPCLEAR0
	strne	r3, [r2, #28]		// GPSET0

	pop	{r4-r10, lr}
	bx	lr

// in this function, we are reading the line of data from SNES
// read in the form of a 16 bit binary number
// each bit gives information of whether or not a button is pressed
// last four bits are always 1
// the buttons are being read from left to right
	RETURN .req r2
Read_Data:
	push	{r4-r10, lr}

	mov	PIN, #DATA		// DATA
	ldr	r2, =BASE_ADRS		// BASE GPIO REGISTER
	ldr	r1, [r2, #52]		// GPLEV0

	// r3 in this case will hold the location of the bit we want to examine
	mov	r3, #1
	lsl	r3, PIN			// ALIGN PIN 10 BIT
	and	r1, r3			// MASK EVERYTHING ELSE
	teq	r1, #0
	moveq	RETURN, #0		// RETURN 0
	movne	RETURN, #1		// RETURN 1

	pop	{r4-r10, lr}
	bx	lr

	.unreq PIN
	.unreq PARAM

Wait:
	push	{r4-r10, lr}
	ldr 	r0, =0x3f003004 	// address of CLOCK
	ldr 	r2, [r0] 		// read CLOCK
	add	r1, r2 			// add desired wait time

waitLoop:
	ldr 	r2, [r0]
	cmp	r1, r2 			// stop when CLOCK = r1
	bhi 	waitLoop		// else keep waiting
	
	pop	{r4-r10, lr}
	bx	lr

Read_SNES:
	push	{r4-r10, lr}
	BUTTONS .req r4
	ARG	.req r1	
	COUNTER .req r5
	
	mov	BUTTONS, #0
	mov	ARG, #1
	bl	Write_Clock		// set clock
	mov	ARG, #1
	bl	Write_Latch		// set latch
	mov	ARG, #12
	bl	Wait			// wait for 12 microseconds
	mov	ARG, #0
	bl	Write_Latch		// clear latch
	mov	COUNTER, #0		// clear counter before pulseloop starts
	
pulseLoop:
	mov	ARG, #6
	bl	Wait			// wait for 6 microseconds
	mov	ARG, #0
	bl 	Write_Clock		// clear clock
	mov	ARG, #6
	bl	Wait			// wait for 6 microseconds
	bl	Read_Data		// read buttons[i] from SNES controller
	
	mov	r6, RETURN
	orr	BUTTONS, r6		// for each button that has been 'pressed'
	lsl	BUTTONS, #1		// we mark that it has been pressed (buttons[i] = b)
	
	mov	ARG, #1			// set clock
	bl	Write_Clock	
	add	COUNTER, #1		// increment counter
	cmp	COUNTER, #16		// if haven't read all buttons
	blt	pulseLoop		// keep going through the loop
	mov	r0, BUTTONS
	
	.unreq	ARG
	.unreq	COUNTER
	.unreq	RETURN

	pop	{r4-r10, lr}
	bx	lr
//============================================================================
//Initializes the value pack when it is called from the intterupt 
//takes in a random number and places it at that coordinate
InitializeValuePack:

                push {r5, r6, lr}
                bl      RandomNumber
                mov     r0,     r5
                mov     r6,     #31
                add     r6,     r6,     r5
                mov     r1,   #0b1100  
                bl      Grab
                
                mov     r1,     r5
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                mov     r1,     r6
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                mov     r1,     r5
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4
                mov     r1,     r6
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4

                pop {r5, r6,  pc}
//============================================================================
//Obtains a random number with which to place the value pack
RandomNumber:
        push {lr}        
        mov     r0,     #4
        ldr     r0,     =0x3F003004
        ldr     r0,     [r0]
        
        eor     r0,     r0,     lsr #12
        eor     r0,     r0,     lsl #25
        eor     r0,     r0,     lsr #27

        ldr     r1,     =0x7ff
        and     r0,     r1
        pop {pc}
//============================================================================
DrawChar:
	push	{r4-r9, lr}
        ldr     r0,     =Score
        cmp     r0,     #0
        bgt     Ch1
        mov     r9,     #'0'
Ch1:    cmp     r0,     #1
        bgt     Ch2
        mov     r9,     #'1'
Ch2:    cmp     r0,     #2
        bgt     Ch3
        mov     r9,     #'2'
Ch3:    cmp     r0,     #3
        bgt     Ch4
        mov     r9,     #'3'
Ch4:    cmp     r0,     #4
        bgt     Ch5
        mov     r9,     #'4'
Ch5:    cmp     r0,     #5
        bgt     Ch6
        mov     r9,     #'5'
Ch6:    cmp     r0,     #6
        bgt     Ch7
        mov     r9,     #'6'
Ch7:    cmp     r0,     #7
        bgt     Ch8
        mov     r9,     #'7'
Ch8:    cmp     r0,     #8
        bgt     Ch9
        mov     r9,     #'8'
Ch9:    mov     r9,     #'9'

	chAdr	.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask	.req	r8

	ldr		chAdr,	=font		// load the address of the font map
	mov		r0,		r9	// load the character into r0
	add		chAdr,	r0, lsl #4	// char address = font base + (char * 16)

	mov		py,		#31			// init the Y coordinate (pixel coordinate)

charLoop$:
	mov		px,		#158			// init the X coordinate

	mov		mask,	#0x01		// set the bitmask to 1 in the LSB
	
	ldrb	row,	[chAdr], #1	// load the row byte, post increment chAdr

rowLoop$:
	tst		row,	mask		// test row byte against the bitmask
	beq		noPixel$

	mov		r0,		px
	mov		r1,		py
	mov		r2,		#0xF800		// red
	bl		DrawPixel			// draw red pixel at (px, py)

noPixel$:
	add		px,		#1			// increment x coordinate by 1
	lsl		mask,	#1			// shift bitmask left by 1

	tst		mask,	#0x100		// test if the bitmask has shifted 8 times (test 9th bit)
	beq		rowLoop$

	add		py,		#1			// increment y coordinate by 1

	tst		chAdr,	#0xF
	bne		charLoop$			// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask

	pop		{r4-r9, pc}



DrawPixel:
	push	{r4}




	offset	.req	r4

	// offset = (y * 1024) + x = x + (y << 10)
	add		offset,	r0, r1, lsl #10
	// offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl		offset, #1

	// store the colour (half word) at framebuffer pointer + offset

	ldr	r0, =FrameBufferPointer
	ldr	r0, [r0]
	strh	r2, [r0, offset]

	pop		{r4}
	bx	lr

.section .data

Life:   .int            0
Score:  .int            0
Coins:  .int            0
Pause:  .int            0

.align 4
font:		.incbin	"font.bin"



