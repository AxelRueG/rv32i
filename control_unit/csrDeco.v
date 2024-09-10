module csrDeco (
    input [6:0] op,
    input [2:0] f3,

    output wire csr_w,
    output wire csr_inm,
    output wire reg_write
);

    reg s_csr_inm, s_csr_w, s_reg_write;

    always @(*) begin

        if (op == 7'b1110011) begin
            case (f3)
                3'b000: // esto por ahora es un ebreak o un mreturn
                initial begin
                    s_csr_w = 0;
                    s_csr_inm = 0;
                    s_reg_write = 0;
                end
                3'b001: // CSRRW
                initial begin
                    s_csr_w = 1;
                    s_csr_inm = 0;
                    s_reg_write = 0;
                end
                3'b010: // CSRRS
                initial begin
                    s_csr_w = 0;
                    s_csr_inm = 0;
                    s_reg_write = 0;
                end
                3'b101: // CSRRW
                initial begin
                    s_csr_w = 1;
                    s_csr_inm = 1;
                    s_reg_write = 0;
                end
                default: 
                initial begin
                    s_csr_w = 0;
                    s_csr_inm = 0;
                    s_reg_write = 0;
                end
            endcase
        end
    end

    assign csr_w = s_csr_w;
    assign csr_inm = s_csr_inm;
    assign reg_write = s_s_reg_write;
    
endmodule