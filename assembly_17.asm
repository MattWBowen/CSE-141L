r0 = accumulator
r1 = a1
r2 = a2
r3 = b1
r4 = b2
r5 = s1
r6 = s2
r7 = s3
r8 = s4
r9 = upper bound 8  /sign_a  /temp
r10= loop counter i /sign_b
r11= isNeg          /
r12= sum_high           
r13= sum_low
r14= partial_high
r15= partial_low    
*r16 = overlow_bit (1 bit register)

    //load operand a1,a2,b1,b2
    takei #1
    load r0
    put r1      //r1=a1

    takei #2
    load r0
    put r2      //r2=a2

    takei #3
    load r0
    put r3      //r3=b1

    takei #4
    load r0
    put r4      //r4=b2

    //declare sign_a, sign_b
    takei #7
    put r12     //use r12(sum_high) to temp record shift amount
    take r1
    shr r12
    put r9      //sign_a = r9

    take r3
    shr r12
    put r10     //sign_b = r10


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

    takei #0
    put r11         //isNeg=0
    takei #1        //acc=1
    eql r9          //check if r9==1, if yes, acc=1
    b0 S_1
    takei #0
    eql r10
    b0 S_1
    takei #1
    put r11         //isNeg=1
S_1:
    takei #0
    eql r11
    b0 S_2
    takei #0
    eql r9
    b0 S_2
    takei #1
    b0 S_2
    put r11         //implicitly have r11(isNeg)=1
S_2:

    //do 2's complement on A and B
    //r1=a1, r2=a2, r3=b1, r4=b2
    //check if r9(sign_a)==1, if yes, a1<0
    takei #1
    eql r9
    b0 S_3
    take r1
    nand r0
    put r1
    take r2
    nand r0
    put r2
    take #-1
    b0 S_4
    takei #0        //a2=0;
    put r2          //a1=a1+1;
    takei #1
    add r1
    put r1
    takei #0        //jump over the else case
    b0 S_3
S_4:
    takei #1        //a2=a2+1
    add r2
    put r2
S_3:

    //r1=a1, r2=a2, r3=b1, r4=b2
    //check if r10(sign_b)==1, if yes, b1<0
    takei #1
    eql r10
    b0 S_3
    take r3
    nand r0
    put r3
    take r4
    nand r0
    put r4
    takei #-1
    b0 S_6
    takei #0        //b2=0; (r4)
    put r4          //b1=b1+1;
    takei #1
    add r3
    put r3
    takei #0        //jump over the else case
    b0 S_5
S_6:
    takei #1        //b2=b2+1
    add r4
    put r4
S_5:

    //set s1~s4=0
    takei #0
    put r5
    put r6
    put r7
    put r8


    //a2xb2 (r2xr4)--------------------------------
    //reset partial sum to zero
    put r12
    put r13
    put r14
    put r15

    put r10         //i=0
A2B2:
    
    //mask=1 << i
    takei #1
    shl r10     //acc = mask
                //acc and b2(r4)
    nand r4
    nand r0     //create an and gate: acc = b_bit = b2 & mask

    b0 A2B2_S
    take r2
    shl r10
    put r15     //save partial_low

    takei #8
    sub r10     //8-i
    put r9
    take r2
    shr r9      //a2>>8-i
    put r14     //save partial_high

    of0         //TODO: new instruction - set overlow_bit to zero
    take r13
    add r15
    put r13     //sum_low = sum_low + partial_low

    take r12
    add r14
    add r16     //add overflow bit register
    put r12
A2B2_S:
    //check counter at the end of loop
    takei #1
    add r10
    put r10
    takei #8
    put r9          //r9 is the upper limit of loop
    take r10
    lsn r9          //check if i<8
    b0 A2B2

    //s3 = s3 + sum_high = r7 + r12
    //s4 = s4 + sum_low = r8 + r13
    take r7
    add r12
    put r12
    take r8
    add r13
    put r13
    
    //a1xb2 (r1xr4)--------------------------------
    //reset partial sum to zero
    take #0
    put r12
    put r13
    put r14
    put r15

    put r10         //i=0
A1B2:
    
    //mask=1 << i
    takei #1
    shl r10
                //acc and b2(r4)
    nand r4
    nand r0     //create an and gate: acc = b_bit = b2 & mask

    b0 A1B2_S
    take r1
    shl r10
    put r15     //save partial_low

    takei #8
    sub r10     //8-i
    put r9
    take r1
    shr r9      //a1>>8-i
    put r14     //save partial_high

    of0         //set overlow_bit to zero
    take r13
    add r15
    put r13     //sum_low = sum_low + partial_low

    take r12
    add r14
    add r16     //add overflow bit register
    put r12
A1B2_S:
    //check counter at the end of loop
    takei #1
    add r10
    put r10
    takei #8
    put r9          //r9 is the upper limit of loop
    take r10
    lsn r9
    b0 A1B2

    //s2(r6) = s2 + sum_high = r6 + r12 (of)
    //s3(r7) = s3 + sum_low = r7 + r13 (of)
    of0
    take r7
    add r13
    put r13
    take r16
    b0 A1B2_OF_1    //if(s3_overflow)?
    of0
    takei #1
    add r6
    put r6          //if of, s2+=1
    take r16
    b0 A1B2_OF_2    //if adding one to s2 cause of?
    of0
    takei #1
    add r5
    put r5          //s1 = s1 + 1

A1B2_OF_2:
A1B2_OF_1:

    of0
    take r6
    add r12
    put r12
    take r16
    b0 A1B2_OF_3
    takei #1
    add r5
    put r5          //s1 += 1

A1B2_OF_3:

    //a2xb1 (r2xr3)--------------------------------
    //reset partial sum to zero
    take #0
    put r12
    put r13
    put r14
    put r15

    put r10         //i=0
A2B1:
    
    //mask=1 << i
    takei #1
    shl r10
                //acc and b1(r3)
    nand r3
    nand r0     //create an and gate: acc = b_bit = b1 & mask

    b0 A2B1_S
    take r2
    shl r10
    put r15     //save partial_low

    takei #8
    sub r10     //8-i
    put r9
    take r2
    shr r9      //a2>>8-i
    put r14     //save partial_high

    of0         //set overlow_bit to zero
    take r13
    add r15
    put r13     //sum_low = sum_low + partial_low

    take r12
    add r14
    add r16     //add overflow bit register
    put r12
A2B1_S:
    //check counter at the end of loop
    takei #1
    add r10
    put r10
    takei #8
    put r9          //r9 is the upper limit of loop
    take r10
    lsn r9
    b0 A2B1

    //s2(r6) = s2 + sum_high = r6 + r12 (of)
    //s3(r7) = s3 + sum_low = r7 + r13 (of)
    of0
    take r7
    add r13
    put r13
    take r16
    b0 A2B1_OF_1    //if(s3_overflow)?
    of0
    takei #1
    add r6
    put r6          //if of, s2+=1
    take r16
    b0 A2B1_OF_2    //if adding one to s2 cause of?
    of0
    takei #1
    add r5
    put r5          //s1 = s1 + 1

A2B1_OF_2:
A2B1_OF_1:

    of0
    take r6
    add r12
    put r12
    take r16
    b0 A2B1_OF_3
    takei #1
    add r5
    put r5          //s1 += 1

A2B1_OF_3:

//a1xb1 (r1xr3)--------------------------------
    //reset partial sum to zero
    take #0
    put r12
    put r13
    put r14
    put r15

    put r10         //i=0
A1B1:
    
    //mask=1 << i
    takei #1
    shl r10
                //acc and b1(r3)
    nand r3
    nand r0     //create an and gate: acc = b_bit = b1 & mask

    b0 A1B1_S
    take r1
    shl r10
    put r15     //save partial_low

    takei #8
    sub r10     //8-i
    put r9
    take r1
    shr r9      //a1>>8-i
    put r14     //save partial_high

    of0         //set overlow_bit to zero
    take r13
    add r15
    put r13     //sum_low = sum_low + partial_low

    take r12
    add r14
    add r16     //add overflow bit register
    put r12
A1B1_S:
    //check counter at the end of loop
    takei #1
    add r10
    put r10
    takei #8
    put r9          //r9 is the upper limit of loop
    take r10
    lsn r9
    b0 A1B1

    //s1(r5) = s1 + sum_high = r5 + r12
    //s2(r6) = s2 + sum_low= r6 + r13 (of)
    of0
    take r6
    add r13
    put r6
    take r16
    b0 A1B1_OF_1
    take #1
    add r5
    put r5
A1B1_OF_1:
    take r5
    add r12
    put r5


    //if isNeg is true, 2's complement result

    take r11
    b0 SKIP
    take r5
    nand r0     //nand with acc will create not gate
    put r5      //s1 = ~s1
    take r6
    nand r0
    put r6      
    take r7
    nand r0
    put r7
    take r8
    nand r0
    put r8

    of0
    takei #1
    add r8
    put r8 
    take r16
    b0 SKIP       //check if s4+1 is overflow
    of0
    takei #1
    add r7
    put r7
    take r16
    b0 SKIP
    of0
    takei #1
    add r6
    put r6
    take r16
    b0 SKIP
    takei #1
    add r5
    put r5
SKIP:
    //write the result s1~s4 into memory location 5~8
    takei #5
    store r5
    takei #6
    store r6
    takei #7
    store r7
    takei #8
    store r8

END
