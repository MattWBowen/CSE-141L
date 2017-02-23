module lookup (
  input  [3:0]  key,
  output logic [7:0] value);
//TODO: add logic to value so it can run in simulation?
//change the value later for program usage
always_comb
  case(key)
    4'b0000: value = 8'b0000_0000;      // table[0] = 0
    4'b0001: value = 8'b0000_0001;      // table[1] = 1
    4'b0010: value = 8'b0000_0010;      // table[2] = 2
    4'b0011: value = 8'b0010_0000;      // table[3] = 32
    4'b0100: value = 8'b0100_0000;      // table[4] = 64
    4'b0101: value = 8'b0000_0101;      // table[5] = 5
    4'b0110: value = 8'b0111_1111;      // table[6] = 127
    4'b0111: value = 8'b0001_0100;      // table[7] = 20
    4'b1000: value = 8'b0000_1000;      // table[8] = 8
    4'b1001: value = 8'b0000_1001;      // table[9] = 9
    4'b1010: value = 8'b0000_0110;      // table[10] = 6
    4'b1011: value = 8'b0000_0111;      // table[11] = 7
    4'b1100: value = 8'b1111_1111;      // table[12] = -1
    4'b1101: value = 8'b1111_1111;      // table[13] = -1
    4'b1110: value = 8'b1111_1111;      // table[14] = -1
    4'b1111: value = 8'b1111_1111;      // table[15] = -1
    default: value = 8'b0000_0000;
  endcase
endmodule
