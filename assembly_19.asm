#r2 = biggestHamDist
#r3 = currHamDist
#r4 = byte	//counter of byte loop
#r5 = i		//the counter from 128-147
#r6 = j		//the counter of inner loop
#r7 = num[i]
#r8 = num[j]
#r9 = dist
#
#r11 = 127 	//address to write result
#r12 = mask
#r13 = temp
#r14 = buffer to put 1
#r15 = 147 = upper bound of loop

  lookup 6	#acc = 127 mem&. TODO: change syntax of key
  put r11		#returnReg = 127 mem&
  lookup 1
  put r12   #r12 = mask = 1
  add r11		#acc = 128 mem&
  put r5		#set up loop counter for Binomial, i=128

  lookup 0
  put r2			#r2 = acc = biggestHamDist

  #set up upper bound of loop
  lookup 6    #acc=127
  put r14     #r14=127
  lookup 7    #acc=20
  add r14     #acc=127+20=147
  put r15     #r15=147

I_LOOP:		#for loop from j=i+1 to 19
	load r5		#acc = mem[i]
	put r7		#r7 = acc = mem[i]

  lookup 1
  add r5    #j=i+1, set up for j loop
  put r6

J_LOOP:
  lookup 0
  put r3    #currHamDist=0, reset

  load r6   #acc = mem[j] = num[j]
  put  r8   #r8 = num[j]

  xor r7    #num[i] ^ num[j]
  put r9    #store dist

  lookup 0
  put r4    #set up counter for byte loop

BYTE:
  take r12  #mask
  nand r9   #mask nand dist
  nand r0   #acc = dist & mask
  put r13   #r13 = temp = dist & mask

  lookup 1
  eql r13   #if(temp==1)? yes acc=1: no acc=0
  b0 IF_END

  lookup 1
  add r3    #currHamDist++
  put r3

  take r2
  lsn r3    #if(biggestHamDist < currHamDist)? yes acc=1: no acc=0
  b0 IF_END

  take r3
  put r2    #biggestHamDist = currHamDist

  lookup 8
  eql r2    #if(biggestHamDist==8)? yes acc=1: no acc=0
  b0 IF_END

  lookup 0
  b0 OUT_I

IF_END:
  lookup 1
  put r14
  take r9
  shr r14
  put r9    #dist = dist >> 1

  #BYTE counter increment
  lookup 8
  put r14   #r14=8
  lookup 1
  add r4
  put r4    #byte++
  lsn r14   #if(byte<8)? yes acc=1 : no acc=0
  b0 OUT_BYTE
  lookup 0
  b0 BYTE

OUT_BYTE:

  #J_LOOP counter increment
  lookup 1
  add r6      #acc=j++
  put r6
  eql r15     #if(j==147)? yes acc=1 : no acc=0
  b0 J_LOOP

  #out of J_LOOP
  #I_LOOP counter increment
  lookup 1
  add r5
  put r5    #r5 = i++
  lsn r15   #if(i<147)? yes acc=1 : no acc=0
  b0 OUT_I

  lookup 0
  b0 I_LOOP

OUT_I:
  take r2   #acc=biggestHamDist
  store r11 #mem[127]=biggestHamDist
  halt
