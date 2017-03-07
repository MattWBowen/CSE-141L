
module TopLevel(
    input     start,
    input     CLK,
    output    Halt
    );

    wire[8:0] Instruction;  // our 9-bit opcode

    wire RegWrite;
    wire AccWrite;
    //wire start;
    //wire Halt;
    wire Branch;
    wire ReadMem;
    wire WriteMem;
    wire LookUp;
    wire of0;
    wire isMem;

    wire [3:0] reg_index;
    wire [7:0] writeValue;
    wire [7:0] Acc_out;
    wire [7:0] Reg_out;

    wire [7:0] ALU_out;
    wire [7:0] lookup_value;
    wire [7:0] MemOut;

    logic       overflow, overflow_n;    //1 bit overflow register
    logic[31:0] cycle_ct;

    fetch_unit IF(
        .start,
        .CLK,
        .Halt,
        .Branch,
        .Target(Instruction[7:0]),
        //below is output
        .instruction(Instruction)
    );

    Control ctrl(
        .TypeBit(Instruction[8:8]),
        .OP(Instruction[7:4]),
        //below is output
        .RegWrite,
        .AccWrite,
        .Halt,
        .Branch,
        .ReadMem,
        .WriteMem,
        .LookUp,
        .of0,
        .isMem
        
    );
    
    reg_file rf(
        .CLK,
        .RegWrite,
        .AccWrite,
        .reg_index(Instruction[3:0]),
        .writeValue((isMem? MemOut: ALU_out)),
        //below is output
        .Acc_out,
        .Reg_out
    );

    ALU alu(
        .OP(Instruction[7:4]),
        .Acc_in(Acc_out),
        .Reg_in((LookUp? lookup_value: Reg_out)),   //check if the second input of ALU is from table or RF
        .overflow_in(overflow),
        //bellow is output
        .OUT(ALU_out),
        .overflow_out(overflow_n)       //overflow_n is the next overflow value in next clock cycle
    );

    lookup lk(
        .key(Instruction[3:0]),
        //below is output
        .value(lookup_value)
    );

    data_mem mem(
        .CLK,
        .DataAddress(ALU_out),
        .ReadMem,
        .WriteMem,
        .DataIn(Acc_out),
        //below is output
        .DataOut(MemOut)
    );

    //set up 1 bit overflow register
    always@(posedge CLK)
        if(start == 1 || of0 ==1)
            overflow <= 1'b0;
        else
            overflow <= overflow_n;


    // count number of instructions executed
    always@(posedge CLK) 
        if (start == 1)
            cycle_ct <= 0;
        else if(Halt == 0)
            cycle_ct <= cycle_ct+1;
    

endmodule
