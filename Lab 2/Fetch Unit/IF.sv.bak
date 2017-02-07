module IF(
  input Branch,
  input [7:0] Target,
  input start,
  input Halt,
  input CLK,
  output logic[7:0] PC
  );

    always_ff@(posedge CLK)
    begin
	    if(start)
	        PC <= 0;              //can change to start_address
	    else if(Halt)
	        PC <= PC;
	    else if(Branch)
	        PC <= PC + Target;    //relative addressing by offset from assembler
	    else
	        PC <= PC+1;
    end

endmodule
