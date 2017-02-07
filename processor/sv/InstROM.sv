//`timescale 1ns / 1ps
//last modified: zhi 2/7

module InstROM(
    input [7:0] InstAddress,
    output logic[8:0] InstOut);
	 
    // Instructions have [1bit type bit][4bit op code][4bit register] 
    // no need for clock since the professor said he will use $readmemb instead of clock read

    
    logic [8:0] instruction_memory [0:255];     //256 slots of instr mem, can change later

    assign InstOut = instruction_memory[InstAddress];


/*
	 always_comb 
		case (InstAddress)
// opcode = 0 lhw, rs = 0, rt = 1
		0 : InstOut = 10'b0000000001;  // load from address at reg 0 to reg 1  
// opcode = 1 addi, rs/rt = 1, immediate = 1
     
		1 : InstOut = 10'b0001001001;  // addi reg 1 and 1
// replace instruction 1 with the following to produce an infinite loop (shows branch working)
//1 : InstOut = 10'b0001001000;  // addi reg 1 and 0
		
// opcode = 2 shw, rs = 0, rt = 1
		2 : InstOut = 10'b0010000001;  // sw reg 1 to address in reg 0
		
// opcode = 3 beqz, rs = 1, target = 1
        3 : InstOut = 10'b0011001001;  // beqz reg1 to absolute address 1
		
// opcode = 15 halt
		4 : InstOut = 10'b1111111111;  // halt
		default : InstOut = 10'b0000000000;
    endcase
*/

endmodule
