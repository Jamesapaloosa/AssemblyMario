
.globl displayCheck

displayCheck:

push {r4-r9, lr}


x1 .req r0		//x of top left
y1 .req r1		//y of top left

x4 .req r2		//x of bottom right
y4 .req r3		//y of bottom right

screenXLeft .req r8	
screenXRight .req r9	


ldr r5, =Screen_loc
bl Grab

ldr screenXLeft,	[r5], #4
ldr screenXRight, [r5]

cmp x4, screenXLeft
blt	notAllowed			//check if right x value of object is on left side of the left edge

cmp x1, screenXRight
bgt	notAllowed			//check if left x value of object is on the right side of the right edge

Allowed:
mov r0, #1			//return #1 if drawing is allowed 

b exit
notAllowed:			
mov r0, #0			//return #0 if drawing is not allowed

exit:

pop {r4-r9, lr}
bx lr
