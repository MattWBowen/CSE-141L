module lookup (
  input  [3:0]  key,
  output[7:0] value);
//change the value later for program usage
always_comb
  case(key)
    4'b0000: value = 16'hffff;
    4'b0001: value = 16'hffff;
    4'b0010: value = 16'hffff;
    4'b0011: value = 16'hffff;
    4'b0100: value = 16'hffff;
    4'b0101: value = 16'hffff;
    4'b0110: value = 16'hffff;
    4'b0111: value = 16'hffff;
    4'b1000: value = 16'hffff;
    4'b1001: value = 16'hffff;
    4'b1010: value = 16'hffff;
    4'b1011: value = 16'hffff;
    4'b1100: value = 16'hffff;
    4'b1101: value = 16'hffff;
    4'b1110: value = 16'hffff;
    4'b1111: value = 16'hffff;
  endcase
endmodule
