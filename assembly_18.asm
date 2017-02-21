# r0 = accumulator
# r1 ~ r5 = single_match ~ quintuple_match
# r6 = string / temporary
# r7 = temp_string
# r8 = key
# r9 = temp base
# r10= result
# r11= count
# r12= counter of LOAD_MEM
# r13= counter of FIVE
# r14= memory address
# r15= temporary shift amount

        #initialize count and match counter
        lookup 0            #$acc  = table[0] = 0

        put r1              #single_match=0
        put r2              #...
        put r3              #
        put r4              #
        put r5              #quintuple_match=0

        #start loading key and string from memory
        lookup 9            #acc = table[9] = 9
        put r14             #r14 = 9
        load r14            #load the byte of memory at address r14 (which is 9) into accumulator
        put r8              #put the content of accumulator into r8, key stored

        #key = key << 4;
        #key = key >> 4;
        lookup 2            #acc = table[2] = 2
        add r0              #acc = acc + acc = 2 + 2 = 4 TODO: both operands = acc might cause problem
        
        put r15             #r15 = shift amount = 4
        take r8             #take key into accumulator, acc = key
        shl r15             #shift the key to the left by 4 bit
        shr r15             #shift the key to the right by 4 bit
        put r8              #put key back

        #since we finish loading key from the mem, relase r14 for string loading
        lookup 3            #acc = 32
        put r14             #first string address = 32


        #set up r12, counter of the loop LOAD_MEM
        lookup 0            #acc = 0
        put r12             #put 0 into r12, r12 is the counter to loop through 64 bytes

LOAD_MEM:
        lookup 0
        put r11             #count=0, reset the count at begin of loop loading string

        load r14            #load the byte of memory at address r14 into accumulator, r14 = mem[?]
        put r6              #save the string you are comparing into r6
        
        #set up counter of loop FIVE r13, start key matching
        lookup 0
        put r13     #i = r13 = 0

FIVE:   
        #temp_string(r7) = string(r6)
        take r6             #acc = r6 = string
        shl r13             #temp_string << i
        shr r13             #temp_string >> i
        put r7              #save temp_string

        #acc = 4-i
        lookup 2
        add r0              #acc = 4
        sub r13             #acc = 4-i
        put r6              #r6 = 4-i
        
        #temp_string = temp_string << (4-i)
        take r7             #acc = temp_string
        shl r6              #shift right (4-i), acc = temp_string >> (4-i)
        put r7              #store the result back to temp_string

        #result = temp_string ^ key
        xor r8
        put r10

        #if result==0 count++
        lookup 0            #acc = 0
        eql r10             #if result == 0 (acc) acc=1 then count++
        b0 SKIP             #result != 0 means key unmatch => do NOT increment count

        lookup 1            #acc = 1
        add r11             #acc = 1 + r11
        put r11             #save r11, r11++
SKIP:
        #r13(i)++, if i<5 loop again
        lookup 5            #acc = 5
        put r15             #r15 = 5
        lookup 1
        add r13             #i++
        put r13
        lsn r15             #if (r13) i<5 (r15) acc = 1, else end Loop FIVE
        b0 OUT_FIVE         #end loop FIVE
        lookup 0
        b0 FIVE             #loop FIVE

OUT_FIVE:
        #check count(r11) and increment corresponding match
        lookup 1
        eql r11             #check if count == 1 (single match)
        put r15             #since if count == 1, we want to branch to SINGLE but we dont have b1
        lookup 0
        eql r15             #if count == 1, acc will become 0
        b0 SINGLE

        lookup 2
        eql r11
        put r15
        lookup 0
        eql r15
        b0 DOUBLE

        lookup 1
        put r15
        lookup 2
        add r15             #acc = 1+2 = 3 
        eql r11             #check if count == 3
        put r15
        lookup 0
        eql r15
        b0 TRIPLE

        lookup 2
        add r0              #acc = 2+2 = 4 TODO: acc+acc
        eql r11
        put r15
        takei #0
        eql r15
        b0 QUADRUPLE

        lookup 5
        eql r11
        put r15
        lookup 0
        eql r15
        b0 QUINTUPLE

        lookup 0
        b0 BREAK            #count == 0, dont NOT increment any match

SINGLE:
        lookup 1
        add r1
        put r1              #r1++
        lookup 0
        b0 BREAK
DOUBLE:
        lookup 1
        add r2
        put r2
        lookup 0
        b0 BREAK
TRIPLE:
        lookup 1
        add r3
        put r3
        lookup 0
        b0 BREAK
QUADRUPLE:
        lookup 1
        add r4
        put r4
        lookup 0
        b0 BREAK
QUINTUPLE:
        lookup 1
        add r5
        put r5
BREAK:

        #r14++, for loading next string from mem
        lookup 1
        add r14
        put r14                 #r14 loop from 32 ~ 95

        #r12++, if r12<64 loop LOAD_MEM
        lookup 4                #acc = 64
        put r15                 #r15 = 64
        lookup 1                #acc = 1
        add r12
        put r12                 #counter of loop LOAD_MEM r12++
        lsn r15                 #if acc(r12) < 64, acc = 1, else acc = 0
        b0 OUT_LOAD_MEM         #if acc(r12) < 64 is false(0), end loop

        lookup 0                #acc = 0
        b0 LOAD_MEM             #jump to LOAD_MEM

OUT_LOAD_MEM:
        #store match# into memory

        lookup 5
        add r0                  #acc = 5+5 = 10
        put r9                  #r9 = first mem location (10) to store

        take r1                 #acc = count of Single Match
        store r9                #mem[r9] = mem[10] = r1 = single_match
        
        lookup 1
        add r9
        put r9                  #r9++, now r9 = 11

        take r2
        store r9                #mem[r9] = mem[11] = r2 = double_match

        lookup 1
        add r9
        put r9                  #r9++, now r9 = 12

        take r3
        store r9                #mem[r9] = mem[12] = r3 = triple_match

        lookup 1
        add r9
        put r9                  #r9++, now r9 = 13

        take r4
        store r9                #mem[r9] = mem[13] = r4 = quadruple_match

        lookup 1
        add r9
        put r9                  #r9++, now r9 = 14

        take r5
        store r9                #mem[r9] = mem[14] = r5 = quintuple_match
END





