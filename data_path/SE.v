/**
SIGNED EXTENSION
generate an inmediate value from the instruction op_code
*/
module SE(
    input [31:0] instr,
    output reg [31:0] inm
);

wire [4:0] aux_rd2;
wire [6:0] op;
always @(*)
begin
    case(instr[6:0])
        3:   inm = {{20{instr[31]}}, instr[31:20]};                                //lw
        19:  inm = {{20{instr[31]}}, instr[31:20]};                                //I-Type
        35:  inm = {{20{instr[31]}}, instr[31:25], instr[11:7]};                   //sw
        99:  inm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};   //B-Type
        111: inm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; //J-Type
        115: inm = {27'b0, instr[19:15]};                                          //csrinm
        default: inm = 32'bx;
    endcase
end
assign aux_rd2 = instr[24:20];
assign op = instr[6:0];

endmodule