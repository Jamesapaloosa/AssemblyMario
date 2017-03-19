
.globl	displayConvert

displayConvert:
push {r4 - r10, lr}
mov r4, r0		
mov r5, r1
mov r6, r2
mov r7, r3			//move coordinates 

bl displayCheck		
cmp r0, #1			//check if object can be drawn
bne notOnScreen	// if not, branch to notOnScreen

ldr r4, =Screen_loc
ldr r8, [r4], #4	//load left x of screen
ldr r9, [r4]		//laod right x of screen

sub r0, r4, r8		//subtract left x of screen from left x of object
mov r1, r5			//top y stays the same
sub r2, r6, r8		//subtract left x of screen from right x of object
mov r3, r7			//bottom y stays the same
b exit

notOnScreen:
	mov r0, #-1			//return (-1) if object is not on screen
	
exit:
pop {r4 - r10, lr}
bx lr





