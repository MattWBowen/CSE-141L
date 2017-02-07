module reg_file #(parameter W=8, D=4)(
    input         CLK,
	              RegWrite,
                  AccWrite,
    input  [ D-1:0] reg_index,
    input  [ W-1:0] writeValue,

    output [ W-1:0] Acc_out,
    output logic [W-1:0] Reg_out
    );

// 8 bits wide [7:0] and 16 registers deep [0:15] or just [16]	 
logic [W-1:0] registers[2**D];

// combinational reads
assign Acc_out = registers[0];              //accumulator is the first register in RF in our design by default
assign Reg_out = registers[reg_index];

// sequential (clocked) writes
always_ff@(posedge CLK)
begin
    if(AccWrite)
        registers[0] <= writeValue;
    else
    begin
        if(RegWrite)
            registers[reg_index] <= writeValue;
    end
end
endmodule
