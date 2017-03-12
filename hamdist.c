#include<stdio.h>
#include<stdlib.h>
#include<time.h>

int main(){
    //array of 20 items
    char nums[20];
    //char nums[20] = {36,129,9,99,13,141,101,18,1,13,118,61,237,140,249,198,197,170,229,119};
    //printf("%u\n", (unsigned char)nums[12] );

    //this is the number we will save in location 127
    int biggestHamDist = 0;

    //this is a counter for ham dist btwn every 2 elements
    int currHamDist = 0;

    //will use this mask later - i put it here so we
    //don't create a new one every time we for loop
    char mask = 1;

    //this loop is only to initialize array - too lazy
    for (int lazy = 0; lazy < 20; ++lazy){
        nums[lazy] = (char)lazy;
        //printf("nums[%d]: %d\n", lazy, nums[lazy]);
    }


    //loop through only 19 of 20 elements
    //why? because the 20th element is checked against all
    //other elements before we reach its index. I will explain =)
    for (int i = 0; i < 19; ++i){
        //printf("i is: %d\n", i);
        //check all the elements for hamming dist.
        for (int j = i+1; j < 20; ++j){
            //printf("j is: %d\n", j);
            //the bits of "dist" containing 1 will indicate that
            //the hamming distance needs to be incrimented
            char dist = nums[i] ^ nums[j];
            //printf("dist is: %d\n", dist);

            //we loop through the byte to check each bit
            for (int byte = 0; byte < 8; ++byte){
                //this will either be 0000 0000 (false),
                //or 0000 0001 (true)
                int temp = dist & mask;
                //printf("dist & mask is: %d\n", temp);
                if (dist & mask){
                    //one more ham dist
                    ++currHamDist;
                    //printf("currHamDist is: %d\n", currHamDist);

                    //we change the ham dist only when biggest
                    //ham dist is smaller than curr ham dist
                    if (biggestHamDist < currHamDist){
                        biggestHamDist = currHamDist;
                        if (biggestHamDist == 8){
                            printf("Final Hamming Dist is: %d\n", biggestHamDist);
                            return 0;
                        }
                        //printf("biggestHamDist is: %d\n", biggestHamDist);
                    }
                }

                //put the bit of interest in the LSB
                dist = dist >> 1;
                //printf("byte is: %d\n", byte);
            }

            //reset for next byte
            currHamDist = 0;
        }
    }

    printf("Final Hamming Dist is: %d\n", biggestHamDist);
    return 0;
}
