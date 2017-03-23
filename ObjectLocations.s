//This details the locations of different objects in the game
.globl Grab
.globl Screen_loc
.globl init_Objects
.globl GrabImage


//Initialize Mario and Goomba to gamestart locations
init_Objects:   push    {r0 - r10}
                ldr     r0,     =Mario_loc
                mov     r1,     #0
                str     r1,     [r0], #4
                movw     r1,     #668
                str     r1,     [r0], #4
                mov     r1,     #49
                str     r1,     [r0], #4
                movw     r1,     #668
                str     r1,     [r0], #4
                mov     r1,     #0
                str     r1,     [r0], #4
                ldr     r1,     =718
                str     r1,     [r0], #4
                mov     r1,     #49
                str     r1,     [r0], #4
                ldr     r1,     =718
                str     r1,     [r0], #4

                //Initialize temp
                ldr     r0,     =Mario_Temp
                mov     r1,     #0
                str     r1,     [r0], #4
                movw     r1,     #668
                str     r1,     [r0], #4
                mov     r1,     #49
                str     r1,     [r0], #4
                movw     r1,     #668
                str     r1,     [r0], #4
                mov     r1,     #0
                str     r1,     [r0], #4
                ldr     r1,     =718
                str     r1,     [r0], #4
                mov     r1,     #49
                str     r1,     [r0], #4
                ldr     r1,     =718
                str     r1,     [r0], #4

                //Initialize goomba
                ldr     r0,     =Goomba_loc
                movw     r1,     #2622
                str     r1,     [r0], #4
                mov     r1,     #668
                str     r1,     [r0], #4
                mov     r1,     #2671
                str     r1,     [r0], #4
                mov     r1,     #668
                str     r1,     [r0], #4
                movw     r1,     #2622
                str     r1,     [r0], #4
                movw     r1,     #718
                str     r1,     [r0], #4
                mov     r1,     #2671
                str     r1,     [r0], #4
                movw     r1,     #718
            
                str     r1,     [r0], #4

                //Initialize Screen
                ldr     r0,     =Screen_loc
                mov     r1,     #0
                str     r1,     [r0], #4
                ldr     r1,     =1024
                str     r1,     [r0]


                pop     {r0 - r10}
                bx      lr


//Object codes are as follows:
//MarioTemp 00000
//Mario 00001
//Goomba 00010
//Question Box 00011
//Unbreakable Box1 00100
//Unbreakable Box2 00101
//Unbreakable Box3 00110
//Unbreakable Box4 00111
//BulletBill 01000
//Pipe 01000
//Hole 01001




//r1 = the nubmer code of the object you want
//r0 = address of object
Grab:           push    {r2 - r10, lr}
                ldr     r0,     =Mario_Temp
                cmp     r1,     #0b00000
                beq     endGrab
                ldr     r0,     =Mario_loc
                cmp     r1,     #0b00001
                beq     endGrab
                ldr     r0,     =Goomba_loc
                cmp     r1,     #0b00010
                beq     endGrab
                ldr     r0,     =Question1_loc
                cmp     r1,     #0b00011
                beq     endGrab
                ldr     r0,     =BrickBox1_loc
                cmp     r1,     #0b00100
                beq     endGrab
                ldr     r0,     =BrickBox2_loc
                cmp     r1,     #0b00101
                beq     endGrab
                ldr     r0,     =BrickBox3_loc
                cmp     r1,     #0b00110

                beq     endGrab
                ldr     r0,     =BrickBox4_loc
                cmp     r1,     #0b00111

                beq     endGrab
                ldr     r0,     =Pipe_loc
                cmp     r1,     #0b01000

                beq     endGrab
                ldr     r0,     =Hole_loc
                cmp     r1,     #0b01001

                beq     endGrab
                mov     r0,     #-1

endGrab:        pop     {r2 - r10, pc}

//Image ID stored in r1
GrabImage:      push    {r2 - r10}
                ldr     r0,     =GoombaImage
                cmp     r1,     #0b00010

                beq     endGrab
                ldr     r0,     =box
                cmp     r1,     #0b00011

                beq     endGrab
                ldr     r0,     =brick
                cmp     r1,     #0b00100

                beq     endGrab
                ldr     r0,     =brick
                cmp     r1,     #0b00101

                beq     endGrab
                ldr     r0,     =brick
                cmp     r1,     #0b00110

                beq     endGrab
                ldr     r0,     =brick
                cmp     r1,     #0b00111

                beq     endGrab
                ldr     r0,     =pipe2
                cmp     r1,     #0b01000

                beq     endGrab
                ldr     r0,     =HoleImage
                cmp     r1,     #0b01001

                beq     endGrab
                mov     r0,     #-1

endGrabImage:   pop     {r2 - r10, lr}
                bx      lr

.global Grab_Screen
Grab_Screen:    push    {r2 - r10, lr}
                ldr     r0,    =Screen_loc
                pop     {r2 - r10, lr}
                bx      lr



//Assumes that game starts at exactly one brick box above the screen size
//Floor will be at height 50



.data
Mario_Temp:     .int    0               //Point 1 - top left corner
                .int    150

                .int    50               //point 2 - Top right corner
                .int    150
                
                .int    0               //Point 3 - bottom left corner
                .int    50

                .int    50               //Point 4 - bottom right corner
                .int    50
Mario_loc:      .int    0               //Point 1 - top left corner
                .int    150

                .int    50               //point 2 - Top right corner
                .int    150
                
                .int    0               //Point 3 - bottom left corner
                .int    50

                .int    50               //Point 4 - bottom right corner
                .int    50

Goomba_loc:     .int    0
                .int    0

                .int    0
                .int    0
                
                .int    0
                .int    0
                
                .int    0
                .int    0

Question1_loc:  .int    450
                .int    468
                
                .int    499
                .int    468
        
                .int    450
                .int    518
        
                .int    499
                .int    518


BrickBox1_loc:  .int    400
                .int    468

                .int    449
                .int    468

                .int    400
                .int    518
                
                .int    449
                .int    518

BrickBox2_loc:  .int    500
                .int    468
                
                .int    549
                .int    468
        
                .int    500
                .int    518

                .int    549
                .int    518

BrickBox3_loc:  .int    2298
                .int    468
                
                .int    2347
                .int    468
        
                .int    2298
                .int    518

                .int    2347
                .int    518

BrickBox4_loc:  .int    2248
                .int    468
                
                .int    2297
                .int    468
        
                .int    2248
                .int    518

                .int    2297
                .int    518

Pipe_loc:       .int    1224
                .int    618
                
                .int    1323
                .int    618
        
                .int    1224
                .int    718

                .int    1323
                .int    718

Hole_loc:       .int    1624
                .int    718
                
                .int    1923
                .int    718
        
                .int    1624
                .int    768

                .int    1923
                .int    768

Bill_loc:       .int    1624
                .int    718
                
                .int    1924
                .int    718
        
                .int    1624
                .int    768

                .int    1924
                .int    768


Screen_loc:     .int    0
                .int    0

Victory_line:   .int    2672
             	 .int    0















