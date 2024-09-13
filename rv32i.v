`include "./control_unit/ControlUnit.v"
`include "./data_path/DataPath.v"
`include "./memory/Memory.v"

module rv32i (
    input wire clk,
    input wire key,
    output wire [15:0] instrAddr,
    output wire [31:0] aluResult,
    output wire [31:0] memoryOut,
    output wire [31:0] memoryIn,
    output wire [31:0] instruction
);

    wire f7, zero, branch, regWrite, aluSrc, memWrite;
    wire csr_w, csr_inm;
    wire [1:0] resSrc, jump, inmSrc, mocsr;
    wire [2:0] aluControl, f3;
    wire [6:0] op;
    wire [15:0] pc;
    wire [31:0] instr;
    wire [31:0] aluRes;
    wire [31:0] dataWrite;
    wire [31:0] dataRead;

    ControlUnit control_unit (
        .op(op),
        .f3(f3),
        .f7(f7),
        .zero(zero),

        .aluControl(aluControl),
        .resSrc(resSrc),
        .jump(jump),
        .branch(branch),
        .memWrite(memWrite),
        .aluSrc(aluSrc),
        .regWrite(regWrite),
        .mocsr(mocsr),
        .csr_w(csr_w),
        .csr_inm(csr_inm)
    );

    DataPath data_path (
        .branch(branch),
        .jump(jump),
        .clk(clk),
        .readData(dataRead),
        .resultSrc(resSrc),
        .instr(instr),
        .regWrite(regWrite),
        .aluSrc(aluSrc),
        .aluControl(aluControl),
        .csr_w(csr_w),
        .csr_inm(csr_inm),
        .mocsr(mocsr),

        .key(key),

        .aluRes(aluRes),
        .zero(zero),
        .op(op),
        .f3(f3),
        .f7(f7),
        .writeData(dataWrite),
        .pc(pc)
    );

    Memory memory (
        .clk(clk),
        .en(memWrite),
        .addr(aluRes[15:0]),
        .inputData(dataWrite),
        .pcAddr(pc),

        .instr(instr),
        .outputData(dataRead)
    );

    assign instrAddr = pc;
    assign aluResult = aluRes;
    assign memoryOut = dataRead;
    assign memoryIn = dataWrite;
    assign instruction = instr;
    
endmodule