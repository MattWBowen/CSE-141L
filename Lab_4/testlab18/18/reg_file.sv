module reg_file #(parameter W=8, D=4)(
    input           CLK,
	            RegWrite,
                    AccWrite,
    input  [ D-1:0] reg_index,
    input  [ W-1:0] writeValue,

    output [ W-1:0] Acc_out,
    output logic [W-1:0] Reg_out,
    output [W-1:0] reg_debug [2**D]
    );


// 8 bits wide [7:0] and 16 registers deep [0:15] or just [16]
logic [W-1:0] registers[2**D];

//TODO: below is for debug use
assign reg_debug = registers;

// combinational reads
assign Acc_out = registers[0];              //accumulator is the first register in RF in our design by default
assign Reg_out = registers[reg_index];

// sequential (clocked) writes
always_ff@(posedge CLK)
begin
    //you dont need to set default behavios since this is not output
    //TODO: relook at this logic if there is bug: case 1 1
    if(AccWrite==1'b1)
        registers[0] <= writeValue;
    else
    begin
        if(RegWrite==1'b1)
            registers[reg_index] <= writeValue;
    end
end
endmodule
