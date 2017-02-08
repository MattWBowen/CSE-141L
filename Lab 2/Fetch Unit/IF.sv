module IF(
  input Branch,
  input [7:0] Target,
  input start,
  input Halt,
  input CLK,
  output logic[9:0] PC      //10 bit of pc, 2^10=1024 instructions
  );

    logic [9:0] offset;

    //sign extend the Target into an 10 bit offset for PC increment
    assign offset = Target[7:7]? {2{1}, Target } : {2{0}, Target};


    always_ff@(posedge CLK)
    begin
	    if(start)
	        PC <= 0;              //can change to start_address
	    else if(Halt)
	        PC <= PC;
	    else if(Branch)
	        PC <= PC + offset;    //relative addressing by offset from assembler
	    else
	        PC <= PC+8'b00_0000_0001;
    end

endmodule
