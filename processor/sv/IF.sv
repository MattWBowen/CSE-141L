module IF(
  input Branch,
  input [7:0] Target,
  input start,
  input Halt,
  input CLK,
  output logic[7:0] PC
  );

  always @(posedge CLK)
	if(start)
	  PC <= 0;
	else if(Halt)
	  PC <= PC;
	else if(Branch)
	  PC <= PC + Target;    //relative addressing by offset from assembler
	else
	  PC <= PC+1;

endmodule
