//`timescale 1ns / 1ps

module InstROM(
    input [9:0] InstAddress,
    output logic[8:0] InstOut
    );
	 
    // Instructions have [1bit type bit][4bit op code][4bit register] 
    // no need for clock since the professor said he will use $readmemb instead of clock read
    logic [8:0] instruction_memory [0:1023];     //1024 slots(2^10) of instr mem, can change later
    assign InstOut = instruction_memory[InstAddress];

endmodule
