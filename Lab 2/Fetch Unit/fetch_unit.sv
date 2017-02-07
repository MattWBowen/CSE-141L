module fetch_unit(
    input start,
    input CLK,
    input Halt,
    input Branch,
    input [7:0] Target,
	output [8:0] instruction 
);

    //pc counter between IF module and InstROM
    wire [7:0] PC;

    //Instruction Fetch module
    IF if_module(
            .Branch(Branch),
            .Target(Target),
            .start(start),
            .Halt(Halt),
            .CLK(CLK),
            .PC(PC)
            );
    
    //Instruction Memory Module
    InstROM(
            .InstAddress(PC),
            .InstOut(instruction)
            );

endmodule
