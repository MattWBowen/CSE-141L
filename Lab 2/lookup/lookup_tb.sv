module lookup_tb;

    bit [3:0] key;
    wire [7:0] value;
    
	lookup uut (
            .key,
            .value
	);

	initial begin
		// Initialize Inputs
        // the lookup memory has some build-in value:
        // key=0 --> value=0000_0001
        // key=1 --> value=0000_0011
        // key=2 --> value=0000_0101
        // key=3 --> value=0000_0111
        // all other keys are map to value 1111 1111


		// Wait 100 ns for global reset to finish
		#100ns;
		// Add stimulus here

        key = 0;    //expect output value = 0000_0001
        #10ns
        key = 1;    //expect output value = 0000_0011
        #10ns
        key = 2;    //expect output value = 0000_0101
        #10ns
        key = 3;    //expect output value = 0000_0111
        #10ns
        key = 4;    //expect output value = 1111_1111
        #10ns
        key = 15;    //expect output value = 1111_1111
        #10ns ;
	end


endmodule
