module ALU_tb;

// Inputs
  bit [ 3:0] OP;
  bit [7:0] Acc_in;
  bit [7:0] Reg_in;
  bit overflow_in;

// Outputs
  wire [7:0] OUT;
  wire overflow_out;

	// Instantiate the Unit Under Test (UUT)
  ALU uut (
		.OP, 
		.Acc_in, 
		.Reg_in, 
		.overflow_in, 
		.OUT, 
		.overflow_out
	);

initial begin
// Wait 100 ns for global reset to finish
  #100ns;
        
// Add stimulus here
  Acc_in = 20;  //8'b0001_0100
  Reg_in = 12;  //8'b0000_1100

//1. verify xor
//expected output: 8'b0001_1000
  #20ns  OP = 4'b0100;

//2. verify nand
//expected output: 8'b1111_1011
  #20ns  OP = 4'b0101;

//3. verify shl
//expected output: 8'b0010_0000
  #20ns  OP = 4'b0110;

//4. verify shr
//expected output: 8'b0000_0000
  #20ns  OP = 4'b0111;

//5. verify lsn
//expected output: 8'b0000_0000
  #20ns  OP = 4'b1001;

//6. verify eql
//expected output: 8'b0000_0000
  #20ns  OP = 4'b1010;

//7. verify add
//expected output: 8'b0010_0000
  #20ns  OP = 4'b1011;

//8. verify sub
//expected output: 8'b0000_1000
  #20ns  OP = 4'b1100;

//--------- some more test --------------

//9. verify shift with new value
//expected output: 0000_1000 => 0000_0010 => 0000_1000 => 0010_0000
  #20ns  OP = 4'b0110;  //shl
  Acc_in = 8;
  Reg_in = 2;
  #20ns  OP = 4'b0111;  //shr

//10. verify sub
//expected output: -10 = 8'b1111_0110
  #20ns  OP = 4'b1100;  //sub
  Acc_in = 90; 
  Reg_in = 100;

//11. verify comparision
//expected output: 78==78 yield 1 as output, 10 < 100 yield 1 as output
  #20ns  OP = 4'b1010;  //eql
  Acc_in = 78; 
  Reg_in = 78;
  #20ns  OP = 4'b1001;  //lsn
  Acc_in = 10; 
  Reg_in = 100;

//13. verify overflow
//expected output: 1 => 0 => 1 =>
  #20ns  OP = 4'b1011;  //add
  Acc_in = 8'b1111_1111;
  Reg_in = 8'b0000_0001;
  #20ns
  Acc_in = 8'b0111_1111;
  Reg_in = 8'b0000_0001;
  #20ns
  Acc_in = 8'b0100_0000;
  Reg_in = 8'b1100_0000;
  #20ns
  Acc_in = 8'b0111_1111;
  Reg_in = 8'b1000_0000;

  #20ns ;
end

endmodule

