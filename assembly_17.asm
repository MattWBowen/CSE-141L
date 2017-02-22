# r0 = accumulator
# r1 = a1
# r2 = a2
# r3 = b1
# r4 = b2
# r5 = s1
# r6 = s2
# r7 = s3
# r8 = s4
# r9 = upper bound 8  /sign_a  /temp
# r10= loop counter i /sign_b
# r11= isNeg          /
# r12= sum_high           
# r13= sum_low
# r14= partial_high
# r15= partial_low    
# *r16 = overlow_bit (1 bit register)

    #load operand a1,a2,b1,b2
    lookup 1    
    load r0     #acc = mem[1]
    put r1      #r1=a1

    lookup 2
    load r0
    put r2      #r2=a2

    lookup 2
    put r9
    lookup 1
    add r9      #acc = 1+r9 = 1+2 = 3
    load r0     #acc = mem[3]
    put r3      #r3=b1

    lookup 2
    add r0      #acc = r0 = 2+2 = 4
    load r0     #acc = mem[4]
    put r4      #r4=b2

    #declare sign_a, sign_b
    lookup 5
    put r12     #use r12(sum_high) to temp record shift amount
    lookup 2
    add r12
    put r12     #r12 = 2+5 = 7
    take r1
    shr r12
    put r9      #sign_a = r9

    take r3
    shr r12
    put r10     #sign_b = r10


    /* complex condition unrolling
    if((r9==1 && r10==0) || (r9==0 && r10==1))

    isNeg=0
    if(r9==1)
    {
        if(r10==0)
            isNeg=1;
    }
    if(all==0)
    {
        if(r9==0)
        {
            if(r10==1)
                isNeg=1;
        }
    }
    */

    lookup 0
    put r11         #initialize: isNeg=0

    lookup 1
    eql r9          #check if r9==1, if yes, acc=1
    b0 S_1
    
    # case: r9==1
    lookup 0
    eql r10
    b0 S_1
    lookup 1        #r9==1 and r10==0
    put r11         #isNeg=1

    lookup 0
    b0 S_2          #jump over case r9==0 since it's examined before

S_1:                
    # case: r9==0
    lookup 1
    eql r10         #check if r10==1, if yes, acc=1
    eql r9
    b0 S_2
    # r9==0 and r10==1
    lookup 1
    put r11         #isNeg=1
    
    //-----------------------------------
S_2:

    #do 2's complement on A and B
    #r1=a1, r2=a2, r3=b1, r4=b2
    #check if r9(sign_a)==1, if yes, a1<0, acc=1
    lookup 1
    eql r9
    b0 S_3          #if acc=0, means a1>=0, no need for 2's compliment

    take r1         #a1 = ~a1
    nand r0         #acc = a1 nand a1 = not a1
    put r1          #store flipped a1

    take r2         #a2 = ~a2
    nand r0
    put r2

    lookup 15       #acc = -1
    eql r2          #if(a2 == -1) if yes, acc=1, else acc=0 and jump out scope
    b0 S_4
    lookup 0
    put r2          #a2=0;
    lookup 1
    add r1          #a1=a1+1
    put r1
    lookup 0        #jump over the else case
    b0 S_3
S_4:
    lookup 1
    add r2          #a2=a2+1
    put r2          #store a2
S_3:

    #r1=a1, r2=a2, r3=b1, r4=b2
    #check if r10(sign_b)==1, if yes, b1<0
    lookup 1
    eql r10         
    b0 S_5          #if acc==0, means b1(r3)>0, no need for 2's compliment

    take r3         #b1 = ~b1
    nand r0         #acc = b1 nand b1 = ~b1
    put r3          #store b1(r3)

    take r4         #negate b2 and store it
    nand r0
    put r4

    lookup 15       #acc = -1
    eql r4          #if(b2 == -1) if yes, acc=1, else acc=0 and jump out of scope
    b0 S_6
    lookup 0
    put r4          #b2=0
    lookup 1
    add r3          #b1=b1+1
    put r3

    lookup 0        #jump over the else case
    b0 S_5
S_6:
    lookup 1        #b2=b2+1
    add r4
    put r4
S_5:

    #set s1~s4=0
    lookup 0
    put r5
    put r6
    put r7
    put r8


    #a2xb2 (r2xr4)--------------------------------
    #reset partial sum to zero
    put r12
    put r13
    put r14
    put r15

    put r10         #i=0
A2B2:
    
    #mask=1 << i
    lookup 1    #acc=0000_0001
    shl r10     #acc = acc << i
                #acc(mask) and b2(r4)
    nand r4
    nand r0     #create an and gate: acc = b_bit = b2 & mask
                #acc = b2 & mask

    b0 A2B2_S   #if acc==0, means the digit i of b2 is zero, no partial product yield

    take r2     #acc = a2
    shl r10     #acc = a2 << i
    put r15     #save partial_low

    lookup 8    #acc = 8
    sub r10     #acc = 8-i
    put r9      #r9 = 8-i
    take r2     #acc = a2
    shr r9      #acc = a2 >> 8-i
    put r14     #save partial_high

    of0         #TODO: new instruction - set overlow_bit to zero
    take r13    #acc = sum_low
    add r15     
    put r13     #sum_low = sum_low + partial_low

    take r12    #acc = sum_high
    add r14
    put r12     #sum_high = sum_high + partial_hight
    of0

A2B2_S:

    #check counter at the end of loop
    lookup 1
    add r10
    put r10         #i++

    lookup 8
    put r9          #r9 is the upper limit of loop, r9=8
    take r10        #acc = i
    lsn r9          #check if i<8, if yes keep looping, acc=1
    b0 A2B2_OUT

    lookup 0
    b0 A2B2

A2B2_OUT:

    #s3 = s3 + sum_high = r7 + r12
    #s4 = s4 + sum_low = r8 + r13
    of0
    take r8
    add r13
    put r8          #s4 += sum_low

    take r7
    add r12
    put r7          #s3 += sum_hight
    of0
    
    #a1xb2 (r1xr4)--------------------------------
    #reset partial sum to zero
    lookup 0
    put r12
    put r13
    put r14
    put r15

    put r10         #i=0
A1B2:
    
    #r1 x r4
    #mask=1 << i
    lookup 1
    shl r10
                #acc and b2(r4)
    nand r4
    nand r0     #create an and gate: acc = b_bit = b2 & mask

    b0 A1B2_S
    take r1
    shl r10
    put r15     #save partial_low

    lookup 8
    sub r10     #8-i
    put r9
    take r1
    shr r9      #a1>>8-i
    put r14     #save partial_high

    of0         #set overlow_bit to zero
    take r13
    add r15
    put r13     #sum_low = sum_low + partial_low

    take r12
    add r14
    put r12     #sum_high = sum_high + partial_high
    of0

A1B2_S:
    #check counter at the end of loop
    lookup 1
    add r10
    put r10

    lookup 8
    put r9          #r9 is the upper limit of loop
    take r10
    lsn r9
    b0 A1B2_OUT

    lookup 0
    b0 A1B2

A1B2_OUT:

    #s1(r5) = s1 + 0 + (of)
    #s2(r6) = s2 + sum_high = r6 + r12 (of)
    #s3(r7) = s3 + sum_low = r7 + r13 (of)

    of0
    take r7         #s3 = s3 + sum_low
    add r13
    put r7
    
    take r6         #s2 = s2 + sum_hight
    add r12
    put r6

    lookup 0
    add r5         #s1 = s1 + 0 + of
    put r5
    of0
    
    #a2xb1 (r2xr3)--------------------------------
    #reset partial sum to zero
    lookup 0
    put r12
    put r13
    put r14
    put r15

    put r10         #i=0
A2B1:
    
    #mask=1 << i
    lookup 1
    shl r10
                #acc and b1(r3)
    nand r3
    nand r0     #create an and gate: acc = b_bit = b1 & mask

    b0 A2B1_S
    take r2
    shl r10
    put r15     #save partial_low

    lookup 8
    sub r10     #8-i
    put r9
    take r2
    shr r9      #a2>>8-i
    put r14     #save partial_high

    of0         #set overlow_bit to zero
    take r13
    add r15
    put r13     #sum_low = sum_low + partial_low

    take r12
    add r14
    put r12
    of0

A2B1_S:
    #check counter at the end of loop
    lookup 1
    add r10
    put r10

    lookup 8
    put r9          #r9 is the upper limit of loop
    take r10
    lsn r9
    b0 A2B1_OUT

    lookup 0
    b0 A2B1

A2B1_OUT:

    #s1(r5) = s1 + 0 + (of)
    #s2(r6) = s2 + sum_high = r6 + r12 (of)
    #s3(r7) = s3 + sum_low = r7 + r13 (of)

    of0
    take r7         #s3 = s3 + sum_low
    add r13
    put r7
    
    take r6         #s2 = s2 + sum_hight
    add r12
    put r6

    lookup 0
    add r5         #s1 = s1 + 0 + of
    put r5
    of0

#a1xb1 (r1xr3)--------------------------------
    #reset partial sum to zero
    lookup 0
    put r12
    put r13
    put r14
    put r15

    put r10         #i=0
A1B1:
    
    #mask=1 << i
    lookup 1
    shl r10
                #acc and b1(r3)
    nand r3
    nand r0     #create an and gate: acc = b_bit = b1 & mask

    b0 A1B1_S
    take r1
    shl r10
    put r15     #save partial_low

    lookup 8
    sub r10     #8-i
    put r9
    take r1
    shr r9      #a1>>8-i
    put r14     #save partial_high

    of0         #set overlow_bit to zero
    take r13
    add r15
    put r13     #sum_low = sum_low + partial_low

    take r12
    add r14
    put r12
    of0

A1B1_S:
    #check counter at the end of loop
    lookup 1
    add r10
    put r10

    lookup 8
    put r9          #r9 is the upper limit of loop
    take r10
    lsn r9
    b0 A1B1_OUT

    lookup 0
    b0 A1B1

A1B1_OUT:

    #s1(r5) = s1 + sum_high = r5 + r12
    #s2(r6) = s2 + sum_low= r6 + r13 (of)
    of0
    take r6
    add r13
    put r6

    take r5
    add r12
    put r5
    of0

    #if isNeg is true, 2's complement result

    take r11    #acc = isNeg
    b0 SKIP     #if acc(isNeg) == 0, skip 2's complement
    
    take r5
    nand r0     #nand with acc will create not gate
    put r5      #s1 = ~s1
    take r6
    nand r0
    put r6      
    take r7
    nand r0
    put r7
    take r8
    nand r0
    put r8      #flip s1~s4

    of0
    lookup 1    #acc = 1
    add r8      #s4 = s4 + 1, pass down overflow
    put r8

    lookup 0
    add r7
    put r7

    lookup 0
    add r6
    put r6

    lookup 0
    add r5
    put r5

SKIP:
    #write the result s1~s4 into memory location 5~8
    #make r1 the destination address
    lookup 5    #acc = 5
    put r1      #r1 = 5
    take r5     #acc = r5 = s1
    store r1    #mem[5] = s1 (r5)

    lookup 10   #acc = 6
    put r1      #r1 = 6
    take r6     #acc = r6 = s2
    store r1    #mem[6] = s2 (r6)

    lookup 11   #acc = 7
    put r1      #r1 = 7
    take r7     #acc = r7 = s3
    store r1    #mem[7] = s3 (r7)

    lookup 8    #acc = 8
    put r1      #r1 = 8
    take r8     #acc = r8 = s4
    store r1    #mem[8] = s4 (r8)

END
