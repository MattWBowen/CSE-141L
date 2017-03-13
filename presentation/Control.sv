
module Control(
    input               TypeBit,
    input        [3:0]  OP,
    output logic        RegWrite,
    output logic        AccWrite,
    output logic        Halt,
    output logic        Branch,
    output logic        ReadMem,
    output logic        WriteMem,
    output logic        LookUp,
    output logic        of0,
    output logic        isMem

    );
    always_comb	begin
        if(TypeBit==1'b1) begin
            RegWrite    = 0;
            AccWrite    = 0;
            Halt        = 0;
            Branch      = 1;
            ReadMem     = 0;
            WriteMem    = 0;
            LookUp      = 0;
            of0         = 0;
            isMem       = 0;
        end
        else begin
            case(OP)
                0 : begin       //take $reg: $accumulator = $reg
                    RegWrite    = 0;
                    AccWrite    = 1;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 0;

                end
                1 : begin       //put $reg: $reg = $accumulator
                    RegWrite    = 1;
                    AccWrite    = 0;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 0;
                end
                2 : begin       //load $reg: $accumulator = MEM[$reg]
                    RegWrite    = 0;
                    AccWrite    = 1;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 1;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 1;
                end
                3 : begin       //store $reg: MEM[$reg] = $accumulator
                    RegWrite    = 0;
                    AccWrite    = 0;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 1;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 0;
                end
                4 : begin       //xor $reg: $accumulator = $accumulator ^ $reg
                    RegWrite    = 0;
                    AccWrite    = 1;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 0;
                end
                5 : begin       //nand $reg: accumulator = $accumulator nand $reg
                    RegWrite    = 0;
                    AccWrite    = 1;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 0;
                end
                6 : begin       //shl $reg: accumulator = $accumulator << $reg
                    RegWrite    = 0;
                    AccWrite    = 1;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 0;
                end            
                7 : begin       //shr $reg: $accumulator = $accumulator >> $reg
                    RegWrite    = 0;
                    AccWrite    = 1;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 0;
                end
                8 : begin       //lookup key: $accumulator = table [key]
                    RegWrite    = 0;
                    AccWrite    = 1;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 1;
                    of0         = 0;
                    isMem       = 0;
                end
                9 : begin       //lsn $reg: if $accumulator < $reg, $accumulator = 1, else accumulator = 0
                    RegWrite    = 0;
                    AccWrite    = 1;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 0;
                end
                10 : begin      //eql $reg: if $accumulator == $reg, $accumulator = 1, else $accumulator = 0
                    RegWrite    = 0;
                    AccWrite    = 1;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 0;
                end
                11 : begin      //add $reg: $accumulator = $accumulator + $reg
                    RegWrite    = 0;
                    AccWrite    = 1;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 0;
                end
                12 : begin      //sub $reg: $accumulator = $accumulator - $reg
                    RegWrite    = 0;
                    AccWrite    = 1;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 0;
                end
                13 : begin      //of0: set overflow bit register to zero 
                    RegWrite    = 0;
                    AccWrite    = 0;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 1;
                    isMem       = 0;
                end
                14 : begin      //halt: PC <= PC
                    RegWrite    = 0;
                    AccWrite    = 0;
                    Halt        = 1;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 0;
                end
                default : begin //tba
                    RegWrite    = 0;
                    AccWrite    = 0;
                    Halt        = 0;
                    Branch      = 0;
                    ReadMem     = 0;
                    WriteMem    = 0;
                    LookUp      = 0;
                    of0         = 0;
                    isMem       = 0;
                end
            endcase
        end // end else
    end // end always_comb logic

endmodule
