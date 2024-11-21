module ALU(
    input [31:0] srcA,
    input [31:0] srcB,
    input [2:0] operation,
    output [31:0] res,
    output wire flag
);

reg [31:0] aux = 0;
reg aux_flag = 0;

always @(*)
begin
    case (operation)
        3'b000:
            begin
                aux = srcA+srcB;
                aux_flag <= 0;
            end
        3'b001: 
            begin
                aux = srcA-srcB;
                aux_flag <= 0;
            end
        3'b010:
            begin
                aux = srcA & srcB;
                aux_flag <= 0;
            end
        3'b011:
            begin
                aux = srcA | srcB;
                aux_flag <= 0;
            end
        // este no esta incluuido en la guia, puede ser util
        3'b100:
            begin
                aux = (srcA == srcB);
                aux_flag <= srcA == srcB;
            end
        3'b101: // SLT
            begin
                aux = $signed(srcB) > $signed(srcA);
                aux_flag <=  $signed(srcB) > $signed(srcA);
            end
        default:
            begin
                aux = srcA;
                aux_flag <= 0;
            end
    endcase
end

assign flag = aux_flag;
assign res = aux;

endmodule