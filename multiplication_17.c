#include<stdio.h>
#include <stdbool.h>

#define REG_SIZE 8

char isOverFlow(unsigned char a, unsigned char b)
{
    /* why convert to unsigned:
     * consider the case 0111 1111 + 0000 0001
     * it is NOT an overflow case, if you use signed char,
     * it will render the result 1000 0000 as -128,
     * which is less than 01111 1111 (127) and 0000 0001 (1)
     * and return an overflow flag
     */
    unsigned char sum = a + b;
    if(sum < a || sum < b)
        return 1;   //overflow
    else
        return 0;
}

int main(int argc, char *argv[]){

    //a1 = 00000011 = 3, a2 = 11111111 = -1; a1a2 = 1023
    char a1=3, a2=-1;
    //b1 = 11111111 = -1, b2 = 11111011 = -5; b1b2 = -5
    char b1=-1, b2=-5;
    /*
    char a1=-1, a2=-95;
    char b1=0, b2=103;
    */

    /* -29417x-27 = 794259
    char a1=-115, a2=23;
    char b1=-1, b2=-27;
    */

    /*TODO: for test only, clean it later
    printf("a1 = %d\n", a1);
    printf("a2 = %d\n", a2);
    printf("b1 = %d\n", b1);
    printf("b2 = %d\n", b2);
    */

    //calculate the sign for final result
    bool isNeg = false;
    char sign_a, sign_b;
    sign_a = (unsigned char)a1 >> (REG_SIZE-1);
    sign_b = (unsigned char)b1 >> (REG_SIZE-1);

    if((sign_a==1 && sign_b==0) || (sign_a==0 && sign_b==1))
        isNeg = true;
    else
        isNeg = false;

    //printf("isNeg = %d\n", isNeg);

    //TODO: only edge case is that cannot take absolute value of -32768 
    //supposely -32768~32767 should work since short is 16 bit
    //all other cases seem to work, welcome more tests


    //absolute value of input a1a2 and b1b2
    //calculate product of the absolute value of them
    //then add sign at the end by isNeg
    if(a1 < 0) 
    {
        //flip a1, a2, add 1 to a2, see if the last carry bit is 1, if yes, add 1 to a1
        a1=~a1;
        a2=~a2;

        if(a2==-1)  //when a2 = 1111 1111, adding 1 will yield 0 and lost the carry bit
        {
            a2=0;  //same as a2=a2+1;
            a1=a1+1; //add the carry over bit from a2
        }
        else
            a2=a2+1;
    }
    //else do nothing

    if(b1 < 0)
    {
        b1=~b1;
        b2=~b2;

        if(b2==-1)
        {
            b2=0;
            b1=b1+1;
        }
        else
            b2=b2+1;
    }

    
    //debug print out
    /*
    printf("\nafter taking absolute value---------------\n");
    printf("a1 = %d\n", a1);
    printf("a2 = %d\n", a2);
    printf("b1 = %d\n", b1);
    printf("b2 = %d\n", b2);
    */

    char s1=0, s2=0, s3=0, s4=0;
    char overflow_bit=0;
    char mask;
    char b_bit;

    char sum_low, sum_high;
    char partial_low, partial_high;

    // after taking absolute value, a1 = 3 = 0000 0011, a2 = -1 = 1111 1111
    //                              b1 = 0 = 0000 0000, b2 = 5 =  0000 0101
    // a2xb2 -------------------------------------------------------------------------------------------------------------

    sum_low=0;
    sum_high=0;     //reset the overflow flag and sum and partial product 

    for(int i=0;i<REG_SIZE;i++)
    {
        //mask b2 to see if a certain bit is 1 or 0
        mask = 1;
        mask = mask << i;
        b_bit = b2 & mask;

        //if the current bit is 1, add a2 (shift accordingly)
        if(b_bit)
        {
            partial_low = a2 << i;
            partial_high = (unsigned char)a2 >> (REG_SIZE-i); //right shift in c fill with 1 unless unsigned

            //check if the lower portion of sum is overflow by adding partial_low
            overflow_bit = isOverFlow(sum_low, partial_low);

            //accumulate shifted a2 into sum, add overflow bit if necessary
            sum_low = sum_low + partial_low;
            sum_high = sum_high + partial_high + overflow_bit;
        }
    }
    //accumulate the product into sum register
    //first time modify result register, no need to worry about overflow
    s3 = s3 + sum_high;
    s4 = s4 + sum_low;
    
    // a1xb2    a1 = 3 = 0000 0011, b2 = 5 =  0000 0101 -----------------------------------------------------------------
    sum_low=0;
    sum_high=0;     //reset the overflow flag and sum and partial product 

    for(int i=0;i<REG_SIZE;i++)
    {
        //mask b2 to see if a certain bit is 1 or 0
        mask = 1;
        mask = mask << i;
        b_bit = b2 & mask;

        //if the current bit is 1, add a1 (shift accordingly)
        if(b_bit)
        {
            partial_low = a1 << i;
            partial_high = (unsigned char)a1>> (REG_SIZE-i); //right shift in c fill with 1 unless unsigned

            //check if the lower portion of sum is overflow by adding partial_low
            overflow_bit = isOverFlow(sum_low, partial_low);

            //accumulate shifted a1 into sum, add overflow bit if necessary
            sum_low = sum_low + partial_low;
            sum_high = sum_high + partial_high + overflow_bit;
        }
    }
    //accumulate the product into sum register
    //s3 has been modified before, check overflow on it
    char s3_overflow, s2_overflow;
    s3_overflow = isOverFlow(s3, sum_low);
    if(s3_overflow)         //if s3 will overflow by s3 = s3 + sum_slow, push the overflow bit to s2
    {   
        //Careful!!! adding overflow bit into s2 could also cause s2 oveflow
        s2_overflow = isOverFlow(s2, 1);
        s2 = s2 + 1;        //overflow bit from s3
        if(s2_overflow)     //case when adding overflow bit from s3_overflow DOES cause s2 overflow
        {
            s1 = s1 + 1;    

            s2_overflow = isOverFlow(s2, sum_high);
            if(s2_overflow)
                s1 = s1 + 1;
        }
        else                //case when adding overflow bit from s3_overflow does NOT cause s2 overflow
        {
            s2_overflow = isOverFlow(s2, sum_high);
            if(s2_overflow)
                s1 = s1 + 1;
            
        }
        s2 = s2 + sum_high;
        s3 = s3 + sum_low;
    }
    else    //s3 not overflow
    {
        s2_overflow = isOverFlow(s2, sum_high);
        if(s2_overflow)
            s1 = s1 + 1;

        s2 = s2 + sum_high;
        s3 = s3 + sum_low;
    }
/*
 char s3_overflow, s2_overflow;
    s3_overflow = isOverFlow(s3, sum_low);
    if(s3_overflow)        
    {   
        s2_overflow = isOverFlow(s2, 1);
        s2 = s2 + 1;        
        if(s2_overflow)    
            s1 = s1 + 1;    
    }

    s2_overflow = isOverFlow(s2, sum_high);
    if(s2_overflow)
        s1 = s1 + 1;

    s2 = s2 + sum_high;
    s3 = s3 + sum_low;
*
    // a2xb1    a2 = -1 = 1111 1111, b1 = 0 = 0000 0000 -----------------------------------------------------------------
    sum_low=0;
    sum_high=0;     //reset the overflow flag and sum and partial product 

    for(int i=0;i<REG_SIZE;i++)
    {
        //mask b1 to see if a certain bit is 1 or 0
        mask = 1;
        mask = mask << i;
        b_bit = b1 & mask;

        //if the current bit is 1, add a2 (shift accordingly)
        if(b_bit)
        {
            partial_low = a2 << i;
            partial_high = (unsigned char)a2 >> (REG_SIZE-i);
            
            //check if the lower portion of sum is overflow by adding partial_low
            overflow_bit = isOverFlow(sum_low, partial_low);

            //accumulate shifted a2 into sum, add overflow bit if necessary
            sum_low = sum_low + partial_low;
            sum_high = sum_high + partial_high + overflow_bit;
        }
    }

    //accumulate the product into sum register, check overflow first
    s3_overflow = isOverFlow(s3, sum_low);
    if(s3_overflow)         //if s3 will overflow by s3 = s3 + sum_slow, push the overflow bit to s2
    {   
        //Careful!!! adding overflow bit into s2 could also cause s2 oveflow
        s2_overflow = isOverFlow(s2, 1);
        s2 = s2 + 1;        //overflow bit from s3
        if(s2_overflow)     //case when adding overflow bit from s3_overflow DOES cause s2 overflow
        {
            s1 = s1 + 1;    

            s2_overflow = isOverFlow(s2, sum_high);
            if(s2_overflow)
                s1 = s1 + 1;
        }
        else                //case when adding overflow bit from s3_overflow does NOT cause s2 overflow
        {
            s2_overflow = isOverFlow(s2, sum_high);
            if(s2_overflow)
                s1 = s1 + 1;
            
        }
        s2 = s2 + sum_high;
        s3 = s3 + sum_low;
    }
    else    //s3 not overflow
    {
        s2_overflow = isOverFlow(s2, sum_high);
        if(s2_overflow)
            s1 = s1 + 1;

        s2 = s2 + sum_high;
        s3 = s3 + sum_low;
    }

    // a1xb1    a1 = 3 = 0000 0011, b1 = 0 = 0000 0000 -----------------------------------------------------------------
    sum_low=0;
    sum_high=0;     //reset the overflow flag and sum and partial product 

    for(int i=0;i<REG_SIZE;i++)
    {
        //mask b1 to see if a certain bit is 1 or 0
        mask = 1;
        mask = mask << i;
        b_bit = b1 & mask;

        //if the current bit is 1, add a1 (shift accordingly)
        if(b_bit)
        {
            partial_low = a1 << i;
            partial_high = (unsigned char)a1 >> (REG_SIZE-i);

            //check if the lower portion of sum is overflow by adding partial_low
            overflow_bit = isOverFlow(sum_low, partial_low);

            //accumulate shifted a1 into sum, add overflow bit if necessary
            sum_low = sum_low + partial_low;
            sum_high = sum_high + partial_high + overflow_bit;
        }
    }
    //accumulate the product into sum register
    //s1 will never overflow as s4
    s2_overflow = isOverFlow(s2, sum_high);
    if(s2_overflow)
        s1 = s1 + 1;

    s1 = s1 + sum_high;
    s2 = s2 + sum_low;

    //if sign is validate as negative before, do 2's compliment
    if(isNeg)
    {
        s1 = ~s1;
        s2 = ~s2;
        s3 = ~s3;
        s4 = ~s4;

        if(s4 == -1)    //if s4 = 1111, adding 1 to it will propagate an overflow bit to s3
        {
            s4 = 0;     // s4 = 1111 + 0001 = 0000, pass overflow bit to s3
            if(s3 == -1)
            {
                s3 = 0;
                if(s2 == -1)
                {
                    s2 = 0;
                    s1 = s1 + 1;
                }
                else
                    s2 = s2 + 1;
            }
            else
                s3 = s3 + 1;
        }
        else
            s4 = s4 + 1;
    }

    //result should be 1023x-5=-5115
    //sum is 11111111 11111111 11101100 00000101
    //       -1       -1       -20      5
    printf("my result is: \n");
    printf("s1 = %d\n", s1);
    printf("s2 = %d\n", s2);
    printf("s3 = %d\n", s3);
    printf("s4 = %d\n", s4);
    printf("correct result below---------------\n");
    printf("s1 = %d\n", -1);
    printf("s2 = %d\n", -1);
    printf("s3 = %d\n", -20);
    printf("s4 = %d\n", 5);

    return 0;
}
