`include "./control_unit/ControlUnit.v"
`include "./data_path/DataPath.v"

module rv32i (
    input wire clk,
    input wire key,
    input [31:0] instr,
    input [31:0] read_data,

    output wire mem_w,
    output [31:0] alu_res,
    output [31:0] write_data,
    output [15:0] pc
);

    wire f7, flag, branch, reg_w, alu_s;
    wire [1:0] dato_s, jump;
    wire [2:0] alu_op, f3;
    wire [6:0] op_code;
    wire [31:0] s_alu_res;    

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
        .reg_w(reg_w)
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

        .alu_res(alu_res),
        .flag(flag),
        .op_code(op_code),
        .f3(f3),
        .f7(f7),
        .write_data(write_data),
        .pc(pc)
    );

endmodule