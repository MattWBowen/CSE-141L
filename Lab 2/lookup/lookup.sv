module lookup (
  input  [3:0]  key,
  output logic [7:0] value);
//TODO: add logic to value so it can run in simulation?
//change the value later for program usage
always_comb
  case(key)
    4'b0000: value = 8'b0000_0001;
    4'b0001: value = 8'b0000_0011;
    4'b0010: value = 8'b0000_0101;
    4'b0011: value = 8'b0000_0111;
    4'b0100: value = 8'b1111_1111;
    4'b0101: value = 8'b1111_1111;
    4'b0110: value = 8'b1111_1111;
    4'b0111: value = 8'b1111_1111;
    4'b1000: value = 8'b1111_1111;
    4'b1001: value = 8'b1111_1111;
    4'b1010: value = 8'b1111_1111;
    4'b1011: value = 8'b1111_1111;
    4'b1100: value = 8'b1111_1111;
    4'b1101: value = 8'b1111_1111;
    4'b1110: value = 8'b1111_1111;
    4'b1111: value = 8'b1111_1111;
	default: value = 8'b0000_0000;
  endcase
endmodule
