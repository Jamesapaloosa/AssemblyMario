

.globl	objectCollision
objectCollision:

push	{r4-r10,lr}

mov r1, #0b00001
//load values of mario into respective registers
xLeft1  	.req 	r5			//left x coordinate for first object
xRight1 	.req	r6			//right x coordinate for first object
yDown1  	.req	r7			//Down y coordinate for first object
yUp1		.req  r8				//up y coordinate for first object
bl Grab


ldr xLeft1, [r0], #4
ldr yUp1, [r0], #20
ldr xRight1, [r0], #4
ldr yDown1, [r0]

mov r4, #0b00010

loadObject:

cmp r4, #0b00010
moveq r1, #0b00010

cmp r4, #0b00011
moveq r1, #0b00011

cmp r4, #0b00100
moveq r1, #0b00100

cmp r4, #0b00101
moveq r1, #0b00101

cmp r4, #0b00110
moveq r1, #0b00110

cmp r4, #0b00111
moveq r1, #0b00111

cmp r4, #0b01000
moveq r1, #0b01001

cmp r4, #0b00111
moveq r1, #0b00111
//load values of object two into respective registers
bl Grab
 
xLeft2 	.req 	r9				//left x coordinate for second object
xRight2	.req  r10			//right x coordinate for first object
yDown2	.req  r11			//Down y coordinate for first object
yUp2		.req  r12			//up y coordinate for first object

ldr xLeft2, [r0], #4
ldr yUp2, [r0], #20
ldr xRight2, [r0], #4
ldr yDown2, [r0]

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
	bgt	noCollDetected							//of object two, if they don't, branch to exit
	
	cmp	yUp1, yDown2				//check if upper bound of object one overlaps with lower bound
	blt	noCollDetected							//of object two, if they don't, branch to exit



collDetected:

	mov r0, r4			//move code of object to r0 if collision is detected
	
	b exit				//branch to exit when collision is detected
	
noCollDetected:
	mov r0, #0

next:
	add r4, r4, #0b00001		//add 1 to object code
	cmp r4, #0b01010
	blt loadObject
	
exit:

	pop {r4-r10,lr}
	bx		lr