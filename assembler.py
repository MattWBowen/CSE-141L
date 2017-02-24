# assembler
# rule:
# 1. label should be followed by an \n instead of instruction
import sys
from bitstring import Bits

opcode = {
    'take': 0,
    'put': 1,
    'load': 2,
    'store': 3,
    'xor': 4,
    'nand': 5,
    'shl': 6,
    'shr': 7,
    'lookup': 8,
    'lsn': 9,
    'eql': 10,
    'add': 11,
    'sub': 12,
    'of0': 13,
    'halt': 14,
    'tba': 15
}

registers = {
    'r0': 0,
    'r1': 1,
    'r2': 2,
    'r3': 3,
    'r4': 4,
    'r5': 5,
    'r6': 6,
    'r7': 7,
    'r8': 8,
    'r9': 9,
    'r10': 10,
    'r11': 11,
    'r12': 12,
    'r13': 13,
    'r14': 14,
    'r15': 15
}

LookUp = {
    '0': 0,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
    '10': 10,
    '11': 11,
    '12': 12,
    '13': 13,
    '14': 14,
    '15': 15
}


label_table = {}



if __name__ == "__main__":
    # extract file name from command line argument
    args = sys.argv
    if len(args) != 3:
        print("invalid input, correct format: \n\tpython assembler.py <assembly file> <machine_code file>")
        sys.exit(0);

    # s = "LLL:this is a comment \t #comment# comment\n"
    # l = s.split('#', 1)[0]
    # if ':' in l:
    #     label = l.split(':', 1)[0]
    # else:
    #     label = ''
    #
    # # print type(label)
    # if not label:
    #     print "label is empty string!!!"
    # else:
    #     print label

    print("Assembler Launching...")

    # first run: read through the input file for first time to record label position
    with open(args[1], 'r') as inFile:

        lineCount = 1
        effective_lineCount = 0
        label = ''
        instr = ''
        stored_label = ''

        for line in inFile:
            print("Assembling line %d" % lineCount)
            line = line.split('#', 1)[0]       # get the non-comment part

            # get label in the current line
            if ':' in line:
                label = line.split(':', 1)[0]
                instr = line.split(':', 1)[1]
            else:
                label = ''
                instr = line

            # save the label for next effective instruction position
            if label:
                stored_label = label

            words = instr.split()

            # syntax check start
            if len(words) == 0:
                pass
            elif len(words) == 1:       # halt, tba, of0
                if words[0] not in ['halt', 'tba', 'of0']:
                    print("invalid instruction format at line %d" % lineCount)
                    exit(0)
                else:
                    # valid instruction, save current/previous label position
                    effective_lineCount += 1
                    if label:
                        label_table[label] = effective_lineCount
                        stored_label = ''
                    else:
                        if stored_label:
                            label_table[stored_label] = effective_lineCount
                            stored_label = ''       # free store_label to prevent double assignment
            elif len(words) == 2:
                if words[0] not in ['b0', 'take', 'put', 'load', 'store', 'xor', 'nand', 'shl', 'shr', 'lookup', 'lsn', 'eql', 'add', 'sub']:
                    print("invalid instruction format at line %d" % lineCount)
                    exit(0)
                else:
                    # it does NOT matter of the second argument of b0 at this phrase
                    if words[0] == 'lookup':        # lookup => second argument is 0~15
                        if words[1] not in LookUp.keys():
                            print("invalid instruction format at line %d" % lineCount)
                            exit(0)
                        else:
                            effective_lineCount += 1
                            if label:
                                label_table[label] = effective_lineCount
                                stored_label = ''
                            else:
                                if stored_label:
                                    label_table[stored_label] = effective_lineCount
                                    stored_label = ''       # free store_label to prevent double assignment
                    else:                           # non lookup => second argument is r0~r15
                        if words[0] == 'b0':
                            # in the second run, check if label is legit
                            effective_lineCount += 1
                            if label:
                                label_table[label] = effective_lineCount
                                stored_label = ''
                            else:
                                if stored_label:
                                    label_table[stored_label] = effective_lineCount
                                    stored_label = ''       # free store_label to prevent double assignment
                        else:
                            if words[1] in registers.keys():
                                effective_lineCount += 1
                                if label:
                                    label_table[label] = effective_lineCount
                                    stored_label = ''
                                else:
                                    if stored_label:
                                        label_table[stored_label] = effective_lineCount
                                        stored_label = ''       # free store_label to prevent double assignment
                            else:   # second argument not in right format r0~r15
                                print("invalid instruction format at line %d" % lineCount)
                                exit(0)
            else:
                print("invalid instruction format at line %d" % lineCount)
                exit(0)

            lineCount += 1

            # print(words)
            # print(len(words))


            # print("Label is:\t" + label)
            # print("store_Label is:\t" + stored_label)
            # print("line content:\t" + instr)

        print label_table

    # second run: write to output file
    with open(args[1], 'r') as theInputFile, open(args[2], 'w') as theOutputFile:

        lineCount = 1
        effective_lineCount = 0
        instr = ''

        for line in theInputFile:
            print("Assembling line %d" % lineCount)
            line = line.split('#', 1)[0]       # get the non-comment part

            # get label in the current line
            if ':' in line:
                instr = line.split(':', 1)[1]
            else:
                instr = line

            words = instr.split()

            # syntax check start
            if len(words) == 0:
                pass
            elif len(words) == 1:       # halt, tba, of0
                effective_lineCount += 1

                op = opcode[words[0]]

                theOutputFile.write(format(0, 'b').zfill(1))
                theOutputFile.write('_')
                theOutputFile.write(format(op, 'b').zfill(4))
                theOutputFile.write('_')
                theOutputFile.write(format(0, 'b').zfill(4))
                theOutputFile.write('    // ')
                for word in words:
                    theOutputFile.write(word + ' ')
                theOutputFile.write('\n')

            elif len(words) == 2:
                if words[0] == 'lookup':        # lookup => second argument is 0~15
                    effective_lineCount += 1

                    op = opcode[words[0]]
                    reg = LookUp[words[1]]

                    theOutputFile.write(format(0, 'b').zfill(1))
                    theOutputFile.write('_')
                    theOutputFile.write(format(op, 'b').zfill(4))
                    theOutputFile.write('_')
                    theOutputFile.write(format(reg, 'b').zfill(4))
                    theOutputFile.write('    // ')
                    for word in words:
                        theOutputFile.write(word + ' ')
                    theOutputFile.write('\n')

                else:                           # non lookup => second argument is r0~r15
                    if words[0] == 'b0':        # if this is a branch instruction
                        effective_lineCount += 1
                        if words[1] not in label_table:         # check if label is legit
                            print("Label not exist at line %d" % lineCount)
                            exit(0)
                        else:                                   # if legit, translate into machine code
                            offset = label_table[words[1]] - effective_lineCount
                            op = 1
                            theOutputFile.write(format(op, 'b').zfill(1))
                            theOutputFile.write('_')

                            if offset > -1:
                                theOutputFile.write(format(offset, 'b').zfill(8))
                            else:
                                theOutputFile.write(str(Bits(int=offset, length=8).bin))

                            # theOutputFile.write(format(offset, 'b').zfill(8))
                            theOutputFile.write('    // ')
                            for word in words:
                                theOutputFile.write(word + ' ')
                            theOutputFile.write('\n')

                    else:                       # this is a normal instruction excluding lookup
                        effective_lineCount += 1

                        op = opcode[words[0]]
                        reg = registers[words[1]]
                        theOutputFile.write(format(0, 'b').zfill(1))
                        theOutputFile.write('_')
                        theOutputFile.write(format(op, 'b').zfill(4))
                        theOutputFile.write('_')
                        theOutputFile.write(format(reg, 'b').zfill(4))
                        theOutputFile.write('    // ')
                        for word in words:
                            theOutputFile.write(word + ' ')
                        theOutputFile.write('\n')
            else:
                print("invalid instruction format at line %d" % lineCount)
                exit(0)

            lineCount += 1

    print("\nAssembler successfully terminated")

