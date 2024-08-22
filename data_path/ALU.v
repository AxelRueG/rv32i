module ALU(
    input [31:0] srcA,
    input [31:0] srcB,
    input [2:0] ALUControl,
    output [31:0] res,
    output wire zero
);

reg [31:0] aux = 0;
reg aux_zero = 0;

always @(*)
begin
    case (ALUControl)
        3'b000:
            begin
                aux = srcA+srcB;
                aux_zero <= 0;
            end
        3'b001: 
            begin
                aux = srcA-srcB;
                aux_zero <= 0;
            end
        3'b010:
            begin
                aux = srcA & srcB;
                aux_zero <= 0;
            end
        3'b011:
            begin
                aux = srcA | srcB;
                aux_zero <= 0;
            end
        // este no esta incluuido en la guia, puede ser util
        3'b100:
            begin
                aux = (srcA == srcB);
                aux_zero <= srcA == srcB;
            end
        3'b101: // SLT
            begin
                aux = srcB > srcA;
                aux_zero <=  srcB > srcA;
            end
        default:
            begin
                aux = srcA;
                aux_zero <= 0;
            end
    endcase
end

assign zero = aux_zero;
assign res = aux;

endmodule