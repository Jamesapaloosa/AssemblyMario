.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
    	mov	sp, #0x8000	// Initializing the stack pointer
	bl	EnableJTAG

	bl	initi

mainmenu:
	bl	startMenu
	mov	r4, r0
	cmp	r4, #1

              ldr	r0, =337		// initial x
	        ldr	r1, =299		// initial y
	        ldr	r2, =689	// final x
	        ldr	r3, =379	// final y
	        ldr	r4, =lose_img
	bleq	CreateImage
	blne	clearScreen
    
haltLoop$:
	b		haltLoop$
