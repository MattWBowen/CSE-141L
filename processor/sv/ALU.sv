module ALU(
  input [ 3:0] OP,
  input [7:0] Acc_in,
  input [7:0] Reg_in,
  input type_bit,
  output logic [7:0] OUT,
  //output logic ZERO,
  //output wire EQUAL
    );
	 
  assign EQUAL = (INPUTA == INPUTB) ? 1 : 0;
  op_mne op_mnemonic;
	
always_comb 
begin
	
//if type_bit=0, do normal-type instruction
if(type_bit==1'b0)
begin
    unique case(OP)
        //take
        4'b00_00:
            OUT = Reg_in;
        //put
        4'b00_01:
        //load
        4'b00_10:
        //store
        4'b00_11:
        //xor
        4'b01_00:
        //nand
        4'b01_01:
        //shl
        4'b01_10:
        //shr
        4'b01_11:
        //lookup
        4'b10_00:
        //lsn
        4'b10_01:
        //eql
        4'b10_10:
        //add
        4'b10_11:
        //sub
        4'b11_00:
        //of0
        4'b11_01:
        //halt
        4'b11_10:
        //tba
        4'b11_11:
        default:
            OUT = 0;
    endcase
end
	 
	case(OUT)
	  16'b0 :   ZERO = 1'b1;
	  default : ZERO = 1'b0;
	endcase
	//$display("ALU Out %d \n",OUT);
    op_mnemonic = op_mne'(OP);

end

endmodule
