`include "./control_unit/aluDeco.v"
`include "./control_unit/mainDeco.v"
`include "./control_unit/csrDeco.v"

module ControlUnit (
    input wire [6:0] op_code,
    input wire [2:0] f3,
    input wire f7,
    input wire flag,

    output wire [2:0] alu_op,
    output wire [1:0] dato_s,
    output wire [1:0] jump,
    output wire branch,
    output wire mem_w,
    output wire alu_s,
    output wire reg_w,

    output wire csr_w,
    output wire csr_data_s,
    output wire data_read_sel
);

    wire [2:0] s_alu_op;
    wire [1:0] s_sel;
    wire [1:0] s_resSrc;
    wire [1:0] s_jump;
    wire [1:0] s_inmSrc;
    wire s_branch;
    wire s_memWrite;
    wire s_aluSrc;
    wire s_regWrite;

    reg r_branch; // salida, incluye la comparacion con el resultado de la ALU

    mainDeco main_decode (
        .op_code(op_code),
        .branch(s_branch),
        .jump(s_jump),
        .dato_s(s_resSrc),
        .mem_w(s_memWrite),
        .alu_s(s_aluSrc),
        .reg_w(s_regWrite),
        .sel(s_sel)
    );

    aluDeco alu_decode(
        .op(op_code[5]),
        .f7(f7),
        .f3(f3),
        .sel(s_sel),
        .alu_op(s_alu_op)
    );

    csrDeco csr_decode(
        .op(op_code),
        .f3(f3),
        .csr_w(csr_w),
        .csr_data_s(csr_data_s),
        .data_read_sel(data_read_sel)
    );

    always @(*) begin
        r_branch = s_branch && flag;
    end

    assign alu_op = s_alu_op;
    assign dato_s = s_resSrc;
    assign jump = s_jump;
    assign branch = r_branch;
    assign mem_w = s_memWrite;
    assign alu_s = s_aluSrc;
    assign reg_w = s_regWrite;
    
endmodule