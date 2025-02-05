`include "./control_unit/ControlUnit.v"
`include "./data_path/DataPath.v"
`include "./verificadorExcept.v"

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
    reg [1:0] s_jump;
    wire [2:0] alu_op, f3;
    wire [6:0] op_code;
    wire [31:0] s_alu_res;    
    wire s_csr_w;
    wire s_csr_data_s;
    wire s_data_read_sel;

    wire s_except;
    wire s_interrupt;
    wire [31:0] s_except_info;
    wire [31:0] s_csr_info;

    // senial para ver si tengo que hacer un jump
    always @(*) begin
        if (s_except) 
            s_jump = 2'b11;
        else
            s_jump = jump;
    end

    ControlUnit control_unit (
        // --- INPUTS ---
        .op_code(op_code),
        .f3(f3),
        .f7(f7),
        .flag(flag),
        // --- OUTPUTS ---
        .alu_op(alu_op),
        .dato_s(dato_s),
        .jump(jump),
        .branch(branch),
        .mem_w(mem_w),
        .alu_s(alu_s),
        .reg_w(reg_w),
        // csr control signals
        .csr_w(s_csr_w),
        .csr_data_s(s_csr_data_s),
        .data_read_sel(s_data_read_sel)
    );

    DataPath data_path (
        // --- INPUTS ---
        .branch(branch),
        .jump(s_jump),
        .clk(clk),
        .read_data(read_data),
        .dato_s(dato_s),
        .instr(instr),
        .reg_w(reg_w),
        .alu_s(alu_s),
        .alu_op(alu_op),
        // csr control
        .csr_w(s_csr_w),
        .csr_data_s(s_csr_data_s),
        .data_read_sel(s_data_read_sel),
        // except
        .except(s_except),
        .interrupt(s_interrupt),
        .except_info(s_except_info),
        // --- OUTPUTS ---
        .alu_res(alu_res),
        .flag(flag),
        .op_code(op_code),
        .f3(f3),
        .f7(f7),
        .write_data(write_data),
        .pc(pc),
        // csr
        .csr_info(s_csr_info)
    );

    verificadorExcept excep_validator(
        .csr_info(s_csr_info),
        .addr_rom(pc),
        .addr_ram(alu_res[15:0]),
        .instr(instr),
        .exception(s_except),
        .interrup(s_interrupt),
        .excep_info(s_except_info)
    );

endmodule