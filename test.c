#include<stdio.h>
#include <stdbool.h>
int main(int argc, char *argv[]){
    //when A
    bool overflowA = false;
    bool overflowB = false;

    //a1 = 00000011 = 3, a2 = 11111111 = -1; a1a2 = 1023
    
    char a1=3, a2=7;
    /* some test on bit negation
    a2=~a2+1;
    printf("test: %d\n", a2);
    return 0;

    //conclusion: if ~a=1111 adding 1 will yield 0 without knowing overflow
    */

    //b1 = 11111111 = -1, b2 = 11111011; b1b2 = -5
    char b1=-1, b2=-5;

    //TODO: only edge case is that cannot take absolute value of -32768 
    //supposely -32768~32767 should work since short is 16 bit
    //all other cases seem to work, welcome more tests


    //absolute value of input a1a2 and b1b2
    //calculate product of the absolute value of them
    //then add sign at the end by isNeg
    if(a1 < 0) 
    {
        //TODO: 2's compliment on a1a2
        //flip a1, a2, add 1 to a2, see if the last carry bit is 1, if yes, add 1 to a1
        a1=~a1;
        a2=~a2;

        if(a2==-1)  //when a2 = 1111, adding 1 will yield 0000 and lost the carry bit
        {
            if(a1 == 127){
                overflowA = true;
            } // later we need to add b
            else {
                a2=0;  //same as a2=a2+1;

                a1=a1+1; //add the carry over bit from a2
            }
        }
        else
            a2=a2+1;
    }
    //else do nothing

    if(b1 < 0)
    {
        //TODO: 2's compliment on b1b2 
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


    bool isNeg = false;

    if((a1 < 0 && b1 > 0 ) || (a1 > 0 && b1 < 0))
        isNeg = true;
    else
        isNeg = false;

    printf("isNeg = %d\n", isNeg);

    //bool to keep track of sign of A and B
    //look at A: if + keep going, if - -> 2' op
    //same for B
    //mult:
    int partialProduct = (int)A;
    int sum=0;
    for(int i=0; i<16; i++){
        short mask = 1;
        short b_bit;

        mask = mask << i;   //mult the binary by 2
        b_bit = B & mask;   //
        
        //mult by 2 if the bit from a is 1
        if(b_bit){

            partialProduct = A << i;
            sum = sum + partialProduct;
        }
    }
    
    //32767*B+B
    if (overflowA && !overflowB){
    }
    //A*32767+A
    else if (!overflowA && overflowB){
    }
    //(32767+1)(32767+1)
    else if(overflowA && overflowB)
    {
    }

    if(isNeg)
    {
        sum = ~sum +1;      //if sign is validate as negative before, do 2's compliment
    }

    //result should be 1023x-5=-5115
    //sum is 32 bit binary: 1x16 1110110000000101
    printf("result is: %d\n", sum);
    return 0;
}
