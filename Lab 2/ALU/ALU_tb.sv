module ALU_tb;

// Inputs
  bit [ 1:0] OP;
  bit [15:0] INPUTA;
  bit [15:0] INPUTB;

// Outputs
  wire [15:0] OUT;
  wire        ZERO;
  wire        EQUAL;

	// Instantiate the Unit Under Test (UUT)
  ALU uut (
		.OP, 
		.INPUTA, 
		.INPUTB, 
		.OUT, 
		.ZERO, 
		.EQUAL
	);

initial begin
// Wait 100 ns for global reset to finish
  #100ns;
        
// Add stimulus here
  INPUTA = 16'h0004;
  INPUTB = 16'h0004;
  #20ns  OP = kSUB;
  #20ns	 OP = kAND;
  #20ns	 INPUTB = 16'h0003;
  OP = kXOR;
end

endmodule

