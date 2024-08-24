
/*
## RESUME

| ALUOp | f3  | op, f5     | instruction | ALUControl |
|-------|-----|------------|-------------|------------|
| 00    | x   | x          | lw,sw       | 000 (add)  |
| 01    | x   | x          | beq         | 001 (sub)  |
| 10    | 000 | 00, 01, 10 | add         | 000 (add)  |
| 10    | 000 | 11         | sub         | 001 (sub)  |
| 10    | 100 | x          | slt         | 101 (slt)  |
| 10    | 110 | x          | or          | 011 (or)   |
| 10    | 111 | x          | and         | 010 (and)  |

*/
module aluDeco(
    input wire op,
    input wire f7,
    input [2:0] f3,
    input [1:0] aluOp,
    output [2:0] aluControl
);

reg[2:0] aluControlAux = 3'b000;
wire andAux;
assign andAux = f7 && op;

always @(*) begin
    case (aluOp)
        2'b00:
            aluControlAux = 3'b000; // add
        2'b01:
            case(f3)
                3'b000:
                    aluControlAux = 3'b100; // BEQ
                3'b100:
                    aluControlAux = 3'b101; // BLT
                default:
                    aluControlAux = 3'b001; // substract
            endcase
        2'b10:
            case(f3)
                3'b000:
                    if(f7 && op)
                    begin
                        aluControlAux = 3'b001; // substract
                    end else begin
                        aluControlAux = 3'b000; // add
                    end
                3'b010:
                    aluControlAux = 3'b101;     // slt
                3'b110:
                    aluControlAux = 3'b011;     // or
                3'b111:
                    aluControlAux = 3'b010;     // and
            endcase
    endcase
end

assign aluControl = aluControlAux;

endmodule
