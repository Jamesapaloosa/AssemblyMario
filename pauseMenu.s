.section .text
.globl pauseMenu
		
	.equ	SEL, 0b110111111111
	.equ	START, 0b111011111111
	.equ	UP, 0b111101111111
	.equ	DOWN, 0b111110111111
	.equ	LEFT, 0b111111011111
	.equ	RIGHT, 0b111111101111
	.equ	A, 0b111111110111
	
	
pauseMenu:
			BUTTON 	.req r6		// contains the button pressed
			FLAG 	.req r5		// if flag is set, then start game. Else, quit game
			
			push	{r4 - r10}
			
			mov		FLAG, #1	// initialize main menu so that user is selecting resume
			mov		r0, #0		// initial x
			mov		r1, #0		// initial y
			
			ldr		r0, =351		// initial x
	        ldr		r1, =315		// initial y
	        ldr		r2, =670	// final x
	        ldr		r3, =443	// final y
	        ldr		r4, =pause_img
			bl		CreateImage
			
			ldr		r0, =453	// initial x
			ldr		r1, =380	// initial y
			ldr		r2, =484	// final x
			ldr		r3, =412	// final y
			ldreq	r4, =mushroom
			bleq	CreateImage
				
			b		pauseLoop
			
pauseLoop:

			
			bl		getInput
			mov		BUTTON, r0
			
			mov		r0, BUTTON	// arg 1: the user input
			ldr		r1, =START		// arg 2: desired button
			bl		checkButton	// check if user pressed A
			cmp		r0, #1		
			beq     Resume
			
			
			mov		r0, BUTTON	// arg 1: the user input
			ldr		r1, =A		// arg 2: desired button
			bl		checkButton	// check if user pressed A
			cmp		r0, #1		
			beq     Selection

			mov		r0, BUTTON	// arg 1: the user input
			ldr		r1, =UP		// arg 2: desired button
			bl		checkButton	// check if user pressed UP
			cmp		r0, #1		// check if the button matches		
			cmpeq	FLAG, #0	// checks if user is currently selecting 'exit'
			moveq	FLAG, #1	// if so, selection is moved to 'restart'
			
			ldr		r0, =453	// initial x
			ldr		r1, =400	// initial y
			ldr		r2, =484	// final x
			ldr		r3, =432	// final y
			ldreq	r4, =sky
			bleq	CreateImage
			
			ldr		r0, =453	// initial x
			ldr		r1, =380	// initial y
			ldr		r2, =484	// final x
			ldr		r3, =412	// final y
			ldreq	r4, =mushroom
			bleq	CreateImage
			
			mov		r0, BUTTON	// arg 1: the user input
			ldr		r1, =DOWN	// arg 2: desired button
			bl		checkButton	// check if user pressed DOWN
			cmp		r0, #1		// if the button matches
			cmpeq	FLAG, #1	// checks if user is currenty selecting 'restart'
			moveq	FLAG, #0	// if so, selection is moved to 'exit'
			
			ldr		r0, =453	// initial x
			ldr		r1, =380	// initial y
			ldr		r2, =484	// final x
			ldr		r3, =412	// final y
			ldreq	r4, =sky
			bleq	CreateImage
			
			ldr		r0, =453	// initial x
			ldr		r1, =400	// initial y
			ldr		r2, =484	// final x
			ldr		r3, =432	// final y
			ldreq	r4, =mushroom
			bleq	CreateImage
            
			
			b		pauseLoop
	
	
Resume:
			bl      PrintGameScreen
                        ldr     r1,     =MarioStandRImg
                        bl      MarioPrint
                        bl      PrintObjects
                        bl      ScorePrinter
                        b       Resume
                        
	
	
	
	
Selection:   
	   		cmp     FLAG,   #1
			bl		initi
                        bl      BeginGame
	
					
exit:
			mov		r0, FLAG
			pop		{r4-r10}
			bl		startMenu
			
.unreq	BUTTON
.unreq	FLAG

 	   

			
			
