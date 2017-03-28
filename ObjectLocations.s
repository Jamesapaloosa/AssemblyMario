//This details the locations of different objects in the game
.globl Grab
.globl Screen_loc
.globl init_Objects
.globl GrabImage
.globl Init_Boxes


//Initialize Mario and Goomba to gamestart locations
init_Objects:   push    {r0 - r10, lr}
                ldr     r0,     =Mario_loc
                mov     r1,     #0
                str     r1,     [r0], #4
                ldr     r1,     =681
                str     r1,     [r0], #4
                mov     r1,     #31
                str     r1,     [r0], #4
                ldr     r1,     =681
                str     r1,     [r0], #4
                mov     r1,     #0
                str     r1,     [r0], #4
                ldr     r1,     =713
                str     r1,     [r0], #4
                mov     r1,     #31
                str     r1,     [r0], #4
                ldr     r1,     =713
                str     r1,     [r0], #4

                //Initialize temp
                ldr     r0,     =Mario_Temp
                mov     r1,     #0
                str     r1,     [r0], #4
                ldr     r1,     =681
                str     r1,     [r0], #4
                mov     r1,     #31
                str     r1,     [r0], #4
                ldr     r1,     =681
                str     r1,     [r0], #4
                mov     r1,     #0
                str     r1,     [r0], #4
                ldr     r1,     =713
                str     r1,     [r0], #4
                mov     r1,     #31
                str     r1,     [r0], #4
                ldr     r1,     =713
                str     r1,     [r0], #4

                //Initialize goomba
                ldr     r0,     =Goomba_loc
                ldr     r1,     =900
                str     r1,     [r0], #4
                ldr     r1,     =681
                str     r1,     [r0], #4
                ldr     r1,     =931
                str     r1,     [r0], #4
                ldr     r1,     =681
                str     r1,     [r0], #4
                ldr     r1,     =900
                str     r1,     [r0], #4
                ldr     r1,     =713
                str     r1,     [r0], #4
                ldr     r1,     =931
                str     r1,     [r0], #4
                ldr     r1,     =713
                str     r1,     [r0], #4

                //Initialize Bill
                ldr     r0,     =Bill_loc
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

                //Initialize Screen
                ldr     r0,     =Screen_loc
                mov     r1,     #0
                str     r1,     [r0], #4
                ldr     r1,     =1024
                str     r1,     [r0]
                pop     {r0 - r10, pc}


Init_Boxes:
                push    {r0 - r10, lr}
                ldr     r0,     =Question1_loc
                ldr     r1,     =450
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =481
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =450
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4
                ldr     r1,     =481
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4

                ldr     r0,     =Question2_loc
                ldr     r1,     =2267
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =2298
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =2267
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4
                ldr     r1,     =2298
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4

                ldr     r0,     =Question3_loc
                ldr     r1,     =2236
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =2267
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =2236
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4
                ldr     r1,     =2267
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4

                ldr     r0,     =BrickBox1_loc
                ldr     r1,     =400
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =431
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =400
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4
                ldr     r1,     =431
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4

                ldr     r0,     =BrickBox2_loc
                ldr     r1,     =500
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =531
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =500
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4
                ldr     r1,     =531
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4

                ldr     r0,     =BrickBox3_loc
                ldr     r1,     =2298
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =2329
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =2297
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4
                ldr     r1,     =2330
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4

                ldr     r0,     =BrickBox4_loc
                ldr     r1,     =2248
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =2278
                str     r1,     [r0], #4
                ldr     r1,     =576
                str     r1,     [r0], #4
                ldr     r1,     =2248
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4
                ldr     r1,     =2278
                str     r1,     [r0], #4
                ldr     r1,     =608
                str     r1,     [r0], #4
                pop     {r0 - r10, pc}

//Object codes are as follows:
//MarioTemp 00000
//Mario 00001
//Goomba 00010
//Question Box 00011
//Unbreakable Box1 00100
//Unbreakable Box2 00101
//Unbreakable Box3 00110
//Unbreakable Box4 00111
//Pipe 01000
//Bill  01001
//Question Box 01010
//Question Box 01011
//ValuePack 01100
//Hole1 01101
//Hole2 01110
//Hole3 01111
//Hole4 10000




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
                ldr     r0,     =Bill_loc
                cmp     r1,     #0b01001
                beq     endGrab


                ldr     r0,     =Question2_loc
                cmp     r1,     #0b01010
                beq     endGrab

                ldr     r0,     =Question3_loc
                cmp     r1,     #0b01011
                beq     endGrab

                ldr     r0,     =ValuePack_loc
                cmp     r1,     #0b01100
                beq     endGrab

                ldr     r0,     =Hole_loc1
                cmp     r1,     #0b01101

                beq     endGrab
                ldr     r0,     =Hole_loc2
                cmp     r1,     #0b01110

                beq     endGrab
                ldr     r0,     =Hole_loc3
                cmp     r1,     #0b01111

                beq     endGrab
                ldr     r0,     =Hole_loc4
                cmp     r1,     #0b10000

                beq     endGrab
                mov     r0,     #-1

endGrab:        pop     {r2 - r10, pc}

//Image ID stored in r1
GrabImage:      push    {r2 - r10, lr}
                ldr     r0,     =goomba
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
                ldr     r0,     =pipe1
                cmp     r1,     #0b01000

                beq     endGrab

                ldr     r0,     =bullet
                cmp     r1,     #0b01001
                beq     endGrab

                ldr     r0,     =box
                cmp     r1,     #0b01010
                beq     endGrab

                ldr     r0,     =box
                cmp     r1,     #0b01011
                beq     endGrab

                ldr     r0,     =ValuePack_loc
                cmp     r1,     #0b01100
                beq     endGrab

                beq     endGrab
                ldr     r0,     =sky
                cmp     r1,     #0b01101

                beq     endGrab
                ldr     r0,     =sky
                cmp     r1,     #0b01110

                beq     endGrab
                ldr     r0,     =sky
                cmp     r1,     #0b01111

                beq     endGrab
                ldr     r0,     =sky
                cmp     r1,     #0b10000

                beq     endGrab
                mov     r0,     #-1

endGrabImage:   pop     {r2 - r10, pc}

.global Grab_Screen
Grab_Screen:    push    {r2 - r10, lr}
                ldr     r0,    =Screen_loc
                pop     {r2 - r10, lr}
                bx      lr



//Assumes that game starts at exactly one brick box above the screen size
//Floor will be at height 50



.data
Mario_Temp:     .int    0               //Point 1 - top left corner
                .int    0

                .int    0              //point 2 - Top right corner
                .int    0
                
                .int    0               //Point 3 - bottom left corner
                .int    0

                .int    0               //Point 4 - bottom right corner
                .int    0
Mario_loc:      .int    0               //Point 1 - top left corner
                .int    0

                .int    0               //point 2 - Top right corner
                .int    0
                
                .int    0               //Point 3 - bottom left corner
                .int    0

                .int    0               //Point 4 - bottom right corner
                .int    0

Goomba_loc:     .int    0
                .int    0

                .int    0
                .int    0
                
                .int    0
                .int    0
                
                .int    0
                .int    0

Question1_loc:  .int    450
                .int    576
                
                .int    481
                .int    576
        
                .int    450
                .int    608
        
                .int    481
                .int    608	

Question2_loc:  .int    2267
                .int    576
                
                .int    2298
                .int    576
        
                .int    2267
                .int    608
        
                .int    2298
                .int    608	

Question3_loc:  .int    2236
                .int    576
                
                .int    2267
                .int    576
        
                .int    2236
                .int    608
        
                .int    2267
                .int    608		


BrickBox1_loc:  .int    400
                .int    576		

                .int    431
                .int    576

                .int    400
                .int    608
                
                .int    431
                .int    608

BrickBox2_loc:  .int    500
                .int    576
                
                .int    531
                .int    576
        
                .int    500
                .int    608

                .int    531
                .int    608

BrickBox3_loc:  .int    2298
                .int    576
                
                .int    2329
                .int    576    	
        
                .int    2297
                .int    608

                .int    2330
                .int    608		

BrickBox4_loc:  .int    2248
                .int    576
                
                .int    2278
                .int    576
        
                .int    2248
                .int    608

                .int    2278
                .int    608

Pipe_loc:       .int    1274
                .int    681		
                
                .int    1305
                .int    681
        
                .int    1274
                .int    713

                .int    1305
                .int    713

ValuePack_loc:  .int    5000
                .int    5000		
                
                .int    5031
                .int    5000
        
                .int    5000
                .int    5031

                .int    5031
                .int    5031

Hole_loc1:      .int    1183
                .int    713
                
                .int    1214
                .int    713
        
                .int    1183
                .int    744

                .int    1214
                .int    744

Hole_loc2:      .int    1183
                .int    744
                
                .int    1214
                .int    744
        
                .int    1183
                .int    775

                .int    1214
                .int    775

Hole_loc3:      .int    1214
                .int    713
                
                .int    1245
                .int    713
        
                .int    1214
                .int    744

                .int    1245
                .int    744

Hole_loc4:      .int    1214
                .int    744
                
                .int    1245
                .int    744
        
                .int    1214
                .int    775

                .int    1245
                .int    775


Bill_loc:       .int    1624
                .int    736
                
                .int    1815
                .int    736
        
                .int    1624
                .int    768

                .int    1815
                .int    768


Screen_loc:     .int    0
                .int    0

Victory_line:   .int    2672
             	 .int    0
