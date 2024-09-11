`include "./control_unit/aluDeco.v"
`include "./control_unit/mainDeco.v"
`include "./control_unit/csrDeco.v"

module ControlUnit (
    input wire [6:0] op,
    input wire [2:0] f3,
    input wire f7,
    input wire zero,

    output wire [2:0] aluControl,
    output wire [1:0] resSrc,
    output wire [1:0] jump,
    output wire [1:0] inmSrc,
    output wire branch,
    output wire memWrite,
    output wire aluSrc,
    output wire regWrite,
    //csr output
    output wire [1:0] mocsr,
    output wire csr_w,
    output wire csr_inm
);

    wire [2:0] s_aluControl;
    wire [1:0] s_aluOpe;
    wire [1:0] s_resSrc;
    wire [1:0] s_jump;
    wire [1:0] s_inmSrc;
    wire s_branch;
    wire s_memWrite;
    wire s_aluSrc;
    wire s_regWrite;

    wire [1:0] s_mocsr;
    wire s_csr_w;
    wire s_csr_imn;
    wire s_csr_rd;

    reg r_branch; // salida, incluye la comparacion con el resultado de la ALU

    mainDeco main_decode (
        .op(op),
        .branch(s_branch),
        .jump(s_jump),
        .resSrc(s_resSrc),
        .memWrite(s_memWrite),
        .aluSrc(s_aluSrc),
        .inmSrc(s_inmSrc),
        .regWrite(s_regWrite),
        .aluOp(s_aluOpe),
        .mocsr(s_mocsr)
    );

    aluDeco alu_decode(
        .op(op[5]),
        .f7(f7),
        .f3(f3),
        .aluOp(s_aluOpe),
        .aluControl(aluControl)
    );

    csrDeco csr_decode (
        .op(op),
        .f3(f3),
        .csr_w(s_csr_w),
        .csr_inm(s_csr_inm),
        .reg_write(s_csr_rd)
    );

    always @(*) begin
        r_branch = s_branch && zero;
    end

    assign aluControl = s_aluControl;
    assign resSrc = s_resSrc;
    assign jump = s_jump;
    assign inmSrc = s_inmSrc;
    assign branch = r_branch;
    assign memWrite = s_memWrite | s_csr_rd;
    assign aluSrc = s_aluSrc;
    assign regWrite = s_regWrite;
    assign mocsr = s_mocsr;
    assign csr_w = s_csr_w;
    assign csr_inm = s_csr_inm;
    
endmodule