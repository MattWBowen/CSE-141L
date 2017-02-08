module fetch_unit_tb;

	// Inputs
	bit Branch;
	bit [7:0] Target;
	bit Init;
	bit Halt;
	bit CLK;

	// Outputs
	wire [7:0] PC;      //PC is wire here because its register locate in the IF module

	// Instantiate the Unit Under Test (UUT)
	fetch_unit uut (
  	  .Branch, 
	  .Target, 
	  .start, 
	  .Halt  , 
	  .CLK   , 
      .instruction
	);

  initial begin
// Wait 100 ns for global reset to finish
	 #100ns;
// Add stimulus here
	 start = 1;
	 #20ns  start   = 0;
	 #20ns  Target = 20;
	 #10ns  Branch = 1;
	 #20ns  Branch = 0;
	 #20ns  Halt   = 1;
  end
      
  always begin
     #5ns  CLK = 1;
     #5ns  CLK = 0; // Toggle clock every 5 ticks
  end
		
endmodule

