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

    wire f7, flag, branch, reg_w, alu_s, mem_w;
    wire csr_w, csr_inm;
    wire [1:0] dato_s, jump, inmSrc, mocsr;
    wire [2:0] alu_op, f3;
    wire [6:0] op_code;
    wire [15:0] pc;
    wire [31:0] instr;
    wire [31:0] alu_res;
    wire [31:0] write_data;
    wire [31:0] read_data;

    ControlUnit control_unit (
        .op_code(op_code),
        .f3(f3),
        .f7(f7),
        .flag(flag),

        .alu_op(alu_op),
        .dato_s(dato_s),
        .jump(jump),
        .branch(branch),
        .mem_w(mem_w),
        .alu_s(alu_s),
        .reg_w(reg_w),
        .mocsr(mocsr),
        .csr_w(csr_w),
        .csr_inm(csr_inm)
    );

    DataPath data_path (
        .branch(branch),
        .jump(jump),
        .clk(clk),
        .read_data(read_data),
        .dato_s(dato_s),
        .instr(instr),
        .reg_w(reg_w),
        .alu_s(alu_s),
        .alu_op(alu_op),
        .csr_w(csr_w),
        .csr_inm(csr_inm),
        .mocsr(mocsr),

        .key(key), // tecla dell teclado presionado

        .alu_res(alu_res),
        .flag(flag),
        .op_code(op_code),
        .f3(f3),
        .f7(f7),
        .write_data(write_data),
        .pc(pc)
    );

    Memory memory (
        .clk(clk),
        .en(mem_w),
        .addr_ram(alu_res[15:0]),
        .data(write_data),
        .addr_rom(pc),

        .out_rom(instr),
        .out_ram(read_data)
    );

    assign instrAddr = pc;
    assign aluResult = alu_res;
    assign memoryOut = read_data;
    assign memoryIn = write_data;
    assign instruction = instr;
    
endmodule