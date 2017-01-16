#include<stdio.h>

int main(int argc, char *argv[]){
    //get A and B from terminal
    int A = -4096;
    int B = -4096;
    //bool isNeg = false;

    /*if((A < 0 && B > 0 ) || (A > 0 && B < 0)){
        isNeg = true;

    }
    */

    //bool to keep track of sign of A and B
    //look at A: if + keep going, if - -> 2' op
    //same for B
    //mult:
    int partialProduct = A;
    int sum=0;
    for(int i=0; i<32; i++){
        int mask = 1;
        int b_bit;

        mask = mask << i;   //mult the binary by 2
        b_bit = B & mask;   //
        
        //mult by 2 if the bit from a is 1
        if(b_bit){

            partialProduct = A << i;
            sum = sum + partialProduct;
        }
    }

    printf("result is: %d", sum);
    return 0;
}
