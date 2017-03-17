

.globl	objectCollision
objectCollision:

push	(r4-r10,lr)

//load values of object one into respective registers
xLeft1  	.req 	r1			//left x coordinate for first object
xRight1 	.req	r2			//right x coordinate for first object
yDown1  	.req	r3			//Down y coordinate for first object
yUp1		.req  r4				//up y coordinate for first object

//load values of object two into respective registers 
xLeft2 	.req 	r5			//left x coordinate for second object
xRight2	.req  r6			//right x coordinate for first object
yDown2	.req  r7			//Down y coordinate for first object
yUp2		.req  r8				//up y coordinate for first object


//algorithm from
//https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection

	cmp 	xLeft1, xRight2			//check if left side of object one overlaps with right side of
	bgt 	exit							//object two, if they don't, branch to exit
	
	cmp 	xRight1, xLeft2			//check if right side of object one overlaps with left side of
	blt	exit							//object two, if they don't, branch to exit
	
	cmp	yDown1, yUp2				//check if lower bound of object one overlaps with upper bound
	bgt	exit							//of object two, if they don't, branch to exit
	
	cmp	yUp1, yDown2				//check if upper bound of object one overlaps with lower bound
	blt	exit							//of object two, if they don't, branch to exit



collDetected:

	mov r0, #1			//move 1 to r0 if collision is detected


exit:

	pop (r4-r10,lr)
	bx		lr
