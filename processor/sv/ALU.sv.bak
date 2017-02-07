module ALU(
  input [ 3:0] OP,
  input [7:0] Acc_in,
  input [7:0] Reg_in,
  input type_bit,
  input overflow_in,
  output logic [7:0] OUT,
  output logic overflow_out
    );
	 
wire [7:0] sub;
assign sub = Acc_in - Reg_in;

always_comb 
begin
	
//if type_bit=0, do normal-type instruction
if(type_bit==1'b0)
begin
    OUT = 8'b0000_0000;
    overflow_out = overflow_in;
    case(OP)
        //take
        4'b00_00:
            OUT = Reg_in;
        //put
        4'b00_01:
            OUT = Acc_in;
        //load
        4'b00_10:
            OUT = Reg_in;
        //store
        4'b00_11:
            OUT = Reg_in;
        //xor
        4'b01_00:
            OUT = Acc_in ^ Reg_in;
        //nand
        4'b01_01:
            OUT = !(Acc_in && Reg_in);
        //shl
        4'b01_10:
            OUT = Acc_in << Reg_in;
        //shr
        4'b01_11:
            OUT = Acc_in >> Reg_in;
        //lookup
        4'b10_00:
            OUT = Reg_in;
        //lsn
        4'b10_01:
        begin
            if(sub[7:7]==1'b1)  //negative
                OUT = 8'b0000_0001;
            else
                OUT = 8'b0000_0000;
        end
        //eql
        4'b10_10:
        begin
            if(sub==8'b0000_0000)
                OUT = 8'b0000_0001;
            else
                OUT = 8'b0000_0000;
        end
        //add
        4'b10_11:
            {overflow_out ,OUT} = Acc_in + Reg_in + overflow_in;

        //sub
        4'b11_00:
            OUT = Acc_in - Reg_in;
        //of0
        4'b11_01:
            overflow_out = 1'b0;
        //halt
        4'b11_10:
        //tba
        4'b11_11:
        default:
            OUT = 8'b0000_0000;
            overflow_out = overflow_in;
    endcase
end //end of if
	 
end //end of always_comb

endmodule
