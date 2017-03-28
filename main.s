.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
    	mov	sp, #0x8000	// Initializing the stack pointer
	bl	EnableJTAG
/*
                //Deal with interupts here
                bl      InstallIntTable           
                
                ldr     r0,     0x3F00b214
                ldr     r1,     #10
                str     r1,     [r0]

                ldr     r0,     0x3f00b210
                mov     r1,     #0
                str     r1,     [r0]

                mrs     r0,     cpscr
                bic     r0,     #0x80
                msr     cpsr_c, r0
*/
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
/*
//Installs the interupt table
//Taken from tutorial exercises
InstallIntTable:
	ldr		r0, =IntTable
	mov		r1, #0x00000000

	// load the first 8 words and store at the 0 address
	ldmia	r0!, {r2-r9}
	stmia	r1!, {r2-r9}

	// load the second 8 words and store at the next address
	ldmia	r0!, {r2-r9}
	stmia	r1!, {r2-r9}

	// switch to IRQ mode and set stack pointer
	mov		r0, #0xD2
	msr		cpsr_c, r0
	mov		sp, #0x8000

	// switch back to Supervisor mode, set the stack pointer
	mov		r0, #0xD3
	msr		cpsr_c, r0
	mov		sp, #0x8000000

	bx		lr	

IRQ:
        ldr     r1,     =0x3F00B204
        tst     r1,     #2
        beq     e
        ldr     r1,     =Pause
        ldr     r2,     [r1]
        cmp     r2,     #1
        beq     e
        bl      InitializeValuePack
        ldr     r1,     =0x3F003000
        mov     r1,     #1
        subs    pc,     lr,     #4
*/
