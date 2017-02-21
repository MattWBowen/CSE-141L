#include<stdio.h>
#define SIZE 8
//print an unsinged byte into binary form
void printByte(unsigned char a)
{
    int arr[SIZE]={0};
    int i;
    unsigned char mask;
    unsigned char isOne;

    for(i=0;i<SIZE;i++)
    {
        mask=1;
        mask=mask<<i;

        isOne = a & mask;
        if(isOne)
            arr[SIZE-i-1]=1;
    }

    printf("binary form of (unsigned) %d is ", a);
    for(i=0;i<SIZE;i++)
    {
        if(i%4==0 && i!=0)
            printf(" ");

        printf("%d", arr[i]);
    }
    printf("\n");
}

void printArr(unsigned char arr[], int size)
{
    int i;
    
    printf("arr = ");
    for(i=0;i<size;i++)
        printf("%d ",arr[i]);
    printf("\n");
}

int main()
{
    unsigned char single_match=0;
    unsigned char double_match=0;
    unsigned char triple_match=0;
    unsigned char quadruple_match=0;
    unsigned char quintuple_match=0;

    printf("string paring program -----------------------\n");

    unsigned char string, temp_string;
    unsigned char key;          //4 bit search string

    unsigned char key_arr[4]={0};   //record key in 4 position
    int i,j;
    unsigned char mask;
    unsigned char isOne;
    unsigned char result;
    unsigned char count=0;

    //initialize key with specified value
    //key = 13;  //0000 1101, ==> want to search "1101", lower half
    //key = -46;   //11010010  ==> want to search "0010"
    key = 255;   //1101 1010   ==> want to search "1010"

    //set the string you want to search in
    //string = 219;   //1101 1011 => double match when key is 13
    //string = 19;     //0001 0010  => double match when key is -46
    string = 255;       //1010 1010 => triple match when key is -38

    printf("string: ");
    printByte(string);
    printf("key: ");
    printByte(key);


    //preprocess the key to make sure the higher part of it is 0 for later usage
    key = key << 4;
    key = key >> 4;

    for(i=0;i<5;i++)
    {
        //shift out the part higher than the desinated four bit in the string, replaced with zero
        //so that it matches the higher part of key (all zero), which provide
        //convenience when xor them
        temp_string = string;
        temp_string = temp_string << i;
        temp_string = temp_string >> i;

        temp_string = temp_string >> (4-i);
        result = temp_string ^ key;

        //in xor, same bit yield zero, higher part of string and key are already synchronized with zero
        //if the lower part are identical, the whole result will be 0000 0000
        if(!result)
            count++;
    }

    switch(count)
    {
        case 1:
            single_match++;
            break;
        case 2:
            double_match++;
            break;
        case 3:
            triple_match++;
            break;
        case 4:
            quadruple_match++;
            break;
        case 5:
            quintuple_match++;
            break;
        default:
            break;
    }

    printf("single match = \t\t%d\n", single_match);
    printf("double match = \t\t%d\n", double_match);
    printf("triple match = \t\t%d\n", triple_match);
    printf("quadruple match = \t%d\n", quadruple_match);
    printf("quintuple match = \t%d\n", quintuple_match);
    return 0;
}
