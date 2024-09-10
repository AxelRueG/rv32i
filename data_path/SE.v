module SE(
    input [31:0] instr,
    input [1:0] src,
    output [31:0] inmExt
);

reg[31:0] inmaux;

always @(*)
begin
    case(src)
        2'b00:  //I-Type
        begin
            inmaux = {{20{instr[31]}}, instr[31:20]};
        end
        2'b01:  //S-Type
        begin
            inmaux = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        end
        2'b10:  //B-Type
        begin
            inmaux = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
        end
        2'b11:  //J-Type
        begin
            inmaux = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
        end
        default: inmaux = 32'bx;
    endcase
end

assign inmExt = inmaux;

endmodule