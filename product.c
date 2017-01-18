#include<stdio.h>
#include <stdbool.h>

int main(int argc, char *argv[]){
    //get A and B from terminal
    short input_a = 4096;
    short input_b = -5;
    //TODO: only edge case is that cannot take absolute value of -32768 
    //supposely -32768~32767 should work since short is 16 bit
    //all other cases seem to work, welcome more tests

    short A;        //absolute valiue of 2 byte input_a
    short B;        //absolute valiue of input_b

    printf("input_a = %d\n", input_a);
    printf("input_b = %d\n", input_b);

    //absolute value of input a and b
    //calculate product of the absolute value A and B
    //then add sign at the end by isNeg
    if(input_a < 0)
    {
        A = ~input_a +1;
    }
    else
        A = input_a;

    if(input_b < 0)
    {
        B = ~input_b +1;
    }
    else
        B = input_b;

    printf("absolute value of input_a --> A = %d\n", A);
    printf("absolute value of input_b --> B = %d\n", B);

    bool isNeg = false;

    if((input_a < 0 && input_b > 0 ) || (input_a > 0 && input_b < 0))
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

    if(isNeg)
    {
        sum = ~sum +1;      //if sign is validate as negative before, do 2's compliment
    }


    printf("result is: %d\n", sum);
    return 0;
}
