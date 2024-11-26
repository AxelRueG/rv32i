
/*
## RESUME

| SEL | F3  | OP, F7     | Instruction | ALU_OP     |
|-----|-----|------------|-------------|------------|
| 00  | x   | x          | lw,sw       | 000 (add)  |
| 01  | x   | x          | beq         | 001 (sub)  |
| 10  | 000 | 00, 01, 10 | add         | 000 (add)  |
| 10  | 000 | 11         | sub         | 001 (sub)  |
| 10  | 100 | x          | slt         | 101 (slt)  |
| 10  | 110 | x          | or          | 011 (or)   |
| 10  | 111 | x          | and         | 010 (and)  |

*/
module aluDeco(
    input [1:0] sel,
    input [2:0] f3,
    input wire op,
    input wire f7,
    output [2:0] alu_op
);

reg[2:0] alu_op_aux = 3'b000;

always @(*) begin
    case (sel)
        2'b00:
            alu_op_aux = 3'b000; // add
        2'b01:
            case(f3)
                3'b000:
                    alu_op_aux = 3'b100; // BEQ
                3'b100:
                    alu_op_aux = 3'b101; // BLT
                default:
                    alu_op_aux = 3'b001; // substract
            endcase
        2'b10:
            case(f3)
                3'b000:
                    if(f7 && op)
                    begin
                        alu_op_aux = 3'b001; // substract
                    end else begin
                        alu_op_aux = 3'b000; // add
                    end
                3'b010:
                    alu_op_aux = 3'b101;     // slt
                3'b110:
                    alu_op_aux = 3'b011;     // or
                3'b111:
                    alu_op_aux = 3'b010;     // and
            endcase
    endcase
end

assign alu_op = alu_op_aux;

endmodule
