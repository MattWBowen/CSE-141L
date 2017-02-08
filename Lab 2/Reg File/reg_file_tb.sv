module reg_file_tb;
	parameter DT = 4,
	          WT = 8;
// DUT Input Drivers
	bit          CLK;	      // bit can be only 0, 1 (no x or z)
    bit          RegWrite;   // bit self-initializes to 0, not x (handy)
    bit          AccWrite;   
	bit [ DT-1:0] reg_index;
	bit [ WT-1:0] writeValue;

// DUT Outputs
	wire [WT-1:0] Acc_out,
                  Reg_out;

// Instantiate the Unit Under Test (UUT)
	reg_file #(.W(WT),.D(DT)) uut(
	  .CLK        ,     
	  .RegWrite   , 
      .AccWrite   ,
	  .reg_index  , 
	  .writeValue , 
	  .Acc_out    , 
	  .Reg_out
	);

	initial begin
// Initialize the register file with all zero
      for(int i=0;i<16;i++)
        uut.registers[i] = 0;

// Wait 100 ns for global reset to finish
	  #100ns;
        
// Add stimulus here
// 1. check if writing to accumulator works
//    expectation output: r[0] = 1
      reg_index  =  4'b0000;        //Dont care value since not writing to register
	  writeValue =  8'b0000_0001;
	  RegWrite   =  0;
	  AccWrite   =  1;
		
	  #20ns;
// 2. verify if writing to reg 15 works: r15 should be 
//    expectation output: r[15] = 2
      reg_index  =  4'b1111;        
	  writeValue =  8'b0000_0010;
	  RegWrite   =  1;
	  AccWrite   =  0;
		
	  #20ns;
// 3. verify writing without RegWrite/AccWrite has no impact
//    expectation output: no register value change
      reg_index  =  4'b1111;        
	  writeValue =  8'b0000_0011;
	  RegWrite   =  0;
	  AccWrite   =  0;

	  #20ns;	
// 4. verify overwrite an previous modified register
//    expectation output: r[15] = 4
      reg_index  =  4'b1111;        
	  writeValue =  8'b0000_0100;
	  RegWrite   =  1;
	  AccWrite   =  0;

	  #20ns 
// 5. verify overwrite the accumulator
//    expectation output: r[0] = 5
      reg_index  =  4'b1101;        
	  writeValue =  8'b0000_0101;
	  RegWrite   =  0;
	  AccWrite   =  1;

	  #20ns 
// above is for testing writing to RF, below is testing reading without writing
	  RegWrite   =  0;
	  AccWrite   =  0;
      for(int i=0;i<15;i++)
        uut.registers[i] = i;

	  #20ns 
// 6. verify reading register file: reading r8 should return 8
//    expectation output: r[8] = 8 as soon as reg_index change to 8
      reg_index  =  4'b1000;        
	  writeValue =  8'b0000_0101;
	  RegWrite   =  0;
	  AccWrite   =  0;
	  #20ns 

      $stop;	
	end
always begin
  #10ns CLK = 1;
  #10ns CLK = 0;
end      
endmodule

