module ALU(
    input [31:0] srcA,
    input [31:0] srcB,
    input [2:0] ALUControl,
    output reg [31:0] res,
    output wire zero
);

assign zero = (res == 32'b0) ? 1'b1: 1'b0;

always @(*) begin
    case (ALUControl)
        3'b000: res = srcA+srcB;
        3'b001: res = srcA-srcB;
        3'b010: res = srcA & srcB;
        3'b011: res = srcA | srcB;
        3'b100: res = (srcA == srcB);
        3'b101: res = $signed(srcB) > $signed(srcA);
        default: res = srcA;
    endcase
end

endmodule