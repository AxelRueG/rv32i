module SE(
    input [31:0] instr,
    output reg [31:0] inmExt
);

always @(*)
begin
    case(instr[6:0])
        3:   inmExt = {{20{instr[31]}}, instr[31:20]};                                //lw
        19:  inmExt = {{20{instr[31]}}, instr[31:20]};                                //I-Type
        35:  inmExt = {{20{instr[31]}}, instr[31:25], instr[11:7]};                   //sw
        99:  inmExt = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};   //B-Type
        111: inmExt = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; //J-Type
        default: inmExt = 32'bx;
    endcase
end

endmodule