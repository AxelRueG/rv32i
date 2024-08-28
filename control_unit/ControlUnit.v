`include "./control_unit/aluDeco.v"
`include "./control_unit/mainDeco.v"

module ControlUnit (
    input wire [6:0] op,
    input wire [2:0] f3,
    input wire f7,
    input wire zero,

    output wire [2:0] aluControl,
    output wire [1:0] resSrc,
    output wire [1:0] jump,
    output wire [1:0] immSrc,
    output wire branch,
    output wire memWrite,
    output wire aluSrc,
    output wire regWrite
);

    wire [2:0] s_aluControl;
    wire [1:0] s_aluOpe;
    wire [1:0] s_resSrc;
    wire [1:0] s_jump;
    wire [1:0] s_immSrc;
    wire s_branch;
    wire s_memWrite;
    wire s_aluSrc;
    wire s_regWrite;

    reg r_branch; // salida, incluye la comparacion con el resultado de la ALU

    mainDeco main_decode (
        .op(op),
        .branch(s_branch),
        .jump(s_jump),
        .resSrc(s_resSrc),
        .memWrite(s_memWrite),
        .aluSrc(s_aluSrc),
        .immSrc(s_immSrc),
        .regWrite(s_regWrite),
        .aluOp(s_aluOpe)
    );

    aluDeco alu_decode(
        .op(op[5]),
        .f7(f7),
        .f3(f3),
        .aluOp(s_aluOpe),
        .aluControl(aluControl)
    );

    always @(*) begin
        r_branch = s_branch && zero;
    end

    assign aluControl = s_aluControl;
    assign resSrc = s_resSrc;
    assign jump = s_jump;
    assign immSrc = s_immSrc;
    assign branch = r_branch;
    assign memWrite = s_memWrite;
    assign aluSrc = s_aluSrc;
    assign regWrite = s_regWrite;
    
endmodule