/**
## RESUME

| branch | jump | dato_s | mem_w    | alu_s  | reg_w    | sel   | mocsr |
|--------|------|--------|----------|--------|----------|-------|-------|
| 0      | 0    | 2'b01  | 0        | 1      | 1        | 2'b00 | 2'b00 |  LW     (3)
| 0      | 0    | 2'bxx  | 1        | 1      | 0        | 2'b00 | 2'b00 |  SW     (35)
| 0      | 0    | 2'b00  | 0        | 0      | 1        | 2'b10 | 2'b00 |  R-type (51)
| 1      | 0    | 2'bxx  | 0        | 0      | 0        | 2'b01 | 2'b00 |  B-type (99)
| 0      | 0    | 2'b00  | 0        | 1      | 1        | 2'b10 | 2'b00 |  I-Type (19)
| 0      | 1    | 2'b10  | 0        | x      | 1        | 2'bxx | 2'b00 |  jal    (111)
| 0      | 1    | 2'b10  | 0        | x      | 1        | 2'bxx | 2'b01 |  csr    (115)


- a la tabla de la guia a dato_s se le agrego un bit estra
- mbien se agrego una senial jump
**/

module mainDeco(
    input [6:0] op_code,
    output wire branch,
    output wire [1:0] jump,
    output [1:0] dato_s,
    output wire mem_w,
    output wire alu_s,
    output wire reg_w,
    output [1:0] sel
);

    reg s_branch;
    reg [2:0] s_jump;
    reg [1:0] s_dato_s;
    reg s_mem_w;
    reg s_alu_s;
    reg s_reg_w;
    reg [1:0] s_sel;

    always @(*)
    begin
        case (op_code)
            // -- lw -------------------------------------------------------------------------------   
            3:
            begin
                s_branch = 0;
                s_jump = 2'b01;
                s_dato_s = 2'b01;
                s_mem_w = 0;
                s_alu_s = 1;
                s_reg_w = 1;
                s_sel = 2'b00;
            end
            // -- sw -------------------------------------------------------------------------------       
            35:
            begin
                s_branch = 0;
                s_jump = 2'b01;
                s_dato_s = 2'bx;
                s_mem_w = 1;
                s_alu_s = 1;
                s_reg_w = 0;
                s_sel = 2'b00;
            end
            // -- R-Type ---------------------------------------------------------------------------
            51:
            begin
                s_branch = 0;
                s_jump = 2'b01;
                s_dato_s = 2'b00;
                s_mem_w = 0;
                s_alu_s = 0;
                s_reg_w = 1;
                s_sel = 2'b10;
            end
            // -- B-Type ---------------------------------------------------------------------------
            99:
            begin
                s_branch = 1;
                s_jump = 2'b01;
                s_dato_s = 2'bx;
                s_mem_w = 0;
                s_alu_s = 0;
                s_reg_w = 0;
                s_sel = 2'b01;
            end
            // -- I-Type ---------------------------------------------------------------------------
            19:
            begin
                s_branch = 0;
                s_jump = 2'b01;
                s_dato_s = 2'b00;
                s_mem_w = 0;
                s_alu_s = 1;
                s_reg_w = 1;
                s_sel = 2'b10;
            end
            // -- jal ------------------------------------------------------------------------------     
            111:
            begin
                s_branch = 0;
                s_jump = 2'b10;
                s_dato_s = 2'b10;
                s_mem_w = 0;
                s_alu_s = 1'bx;
                s_reg_w = 1;
                s_sel = 2'bx;
            end
            // // -- CSR ------------------------------------------------------------------------------     
            // 7'b1110011:
            // begin
            //     s_branch = 0;
            //     s_jump = 2'b01;
            //     s_dato_s = 2'b01;
            //     s_mem_w = 0;
            //     s_alu_s = 1'bx;
            //     s_reg_w = 1;
            //     s_sel = 2'bx;
            // end
            default:
            begin
                s_branch = 1'bx;
                s_jump = 2'b11;
                s_dato_s = 2'bx;
                s_mem_w = 1'bx;
                s_alu_s = 1'bx;
                s_reg_w = 1'bx;
                s_sel = 2'bx;
            end
        endcase
    end

    assign branch = s_branch;
    assign jump = s_jump;
    assign dato_s = s_dato_s;
    assign mem_w = s_mem_w;
    assign alu_s = s_alu_s;
    assign reg_w = s_reg_w;
    assign sel = s_sel;
    // assign mocsr = s_mocsr;

endmodule