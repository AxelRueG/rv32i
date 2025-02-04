module csrDeco (
    input [6:0] op,
    input [2:0] f3,

    output wire csr_w,
    output wire csr_data_s,
    output wire data_read_sel
);

    // reg s_csr_inm, s_csr_w, csr_data_s;
    reg s_csr_w;
    reg s_csr_data_s;
    reg s_data_read_sel;

    always @(*) begin
        if (op == 115) begin
            case (f3)
                3'b000: // [ebreak, mret, ecall]
                begin
                    s_csr_w = 0;
                    s_csr_data_s = 1'bx;
                    s_data_read_sel = 0;
                end
                3'b001: // CSRRW
                begin
                    s_csr_w = 1;
                    s_csr_data_s = 0;
                    s_data_read_sel = 1;
                end
                // 3'b010: // CSRRS
                // begin
                //     s_csr_w = 0;
                //     s_csr_data_s = 0;
                //     s_data_read_sel = 0;
                // end
                3'b101: // CSRRWI
                begin
                    s_csr_w = 1;
                    s_csr_data_s = 1;
                    s_data_read_sel = 1;
                end
                // 3'b110: // CSRRSI
                // begin
                //     s_csr_w = 1;
                //     s_csr_data_s = 1;
                //     s_data_read_sel = 1;
                // end
                default: 
                begin
                    s_csr_w = 0;
                    s_csr_data_s = 0;
                    s_data_read_sel = 0;
                end
            endcase
        end else begin
            s_csr_w = 0;
            s_csr_data_s = 0;
            s_data_read_sel = 0;
        end
    end

    assign csr_w = s_csr_w;
    assign csr_data_s = s_csr_data_s;
    assign data_read_sel = s_data_read_sel;
    
endmodule