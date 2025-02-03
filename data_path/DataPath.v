`include "./data_path/Adder.v"
`include "./data_path/PC.v"
`include "./data_path/Mux2x1.v"
`include "./data_path/Mux4x1.v"
`include "./data_path/BR.v"
`include "./data_path/ALU.v"
`include "./data_path/SE.v"

module DataPath (
    // ---------------------------------------------------------------------------------------------
    // INPUTS
    // ---------------------------------------------------------------------------------------------
    input wire branch,
    input wire [1:0] jump,
    input wire clk,
    input wire [31:0] read_data,
    input wire [1:0] dato_s,
    input wire [31:0] instr,
    input wire reg_w,
    input wire alu_s,
    input wire [2:0] alu_op,

    // ---------------------------------------------------------------------------------------------
    // OUTPUTS
    // ---------------------------------------------------------------------------------------------
    output wire [31:0] alu_res, // esto deberia ir a la memoria
    output wire flag, // por lo pronto no se como funcionara esto
    output wire [6:0] op_code,
    output wire [2:0] f3,
    output wire f7,
    output wire [31:0] write_data,
    output wire [15:0] pc
);

    // --- intern signals --------------------------------------------------------------------------
    wire [15:0] s_pck;
    wire [31:0] s_pck1;
    wire [31:0] s_pc_offset;
    wire [31:0] s_pc_next;
    wire [31:0] s_pc_jump;

    wire [31:0] s_alu_res;
    wire [31:0] s_srcA;
    wire [31:0] s_srcB;

    wire [31:0] s_inm;
    wire [31:0] s_src2;
    wire [31:0] s_wd3;

    // constantes
    reg [31:0] cuatro = 4;
    reg [31:0] addr_reset = 0;

    // --- conections ------------------------------------------------------------------------------
    // FETCH    
    Mux2x1 m4 (
        .e1(cuatro),
        .e2(s_inm),
        .sel(branch),
        .sal(s_pc_offset)
    );

    Adder add1 (
        .op1(s_pc_offset),
        .op2({16'b0, s_pck}),
        .res(s_pc_next)
    );

    Adder add2 (
        .op1(s_inm),
        .op2({16'b0, s_pck}),
        .res(s_pc_jump)
    );

    Mux4x1 m1 (
        .e1(addr_reset),
        .e2(s_pc_next),
        .e3(s_pc_jump),
        .e4(addr_reset), // <-- here add a addr for except (mtvec)
        .sel(jump),
        .sal(s_pck1)
    );

    PC program_counter (
        .clk(clk),
        .pcNext(s_pck1[15:0]),
        .pc(s_pck)
    );

    // TYPE-R
    BR register_bank (
        .clk(clk),
        .we(reg_w),
        .a1(instr[19:15]),
        .a2(instr[24:20]),
        .a3(instr[11:7]),
        .wd3(s_wd3),
        .rd1(s_srcA),
        .rd2(s_srcB)
    );

    ALU alu (
        .srcA(s_srcA),
        .srcB(s_src2),
        .operation(alu_op),
        .res(s_alu_res),
        .flag(flag)
    );

    // TYPE-I
    SE sign_extension (
        .instr(instr),
        .inm(s_inm)
    );

    Mux2x1 m2 (
        .e1(s_srcB),
        .e2(s_inm),
        .sel(alu_s),
        .sal(s_src2)
    );

    Mux4x1 m3 (
        .e1(s_alu_res),
        .e2(read_data),
        .e3(s_inm),
        .e4(s_pc_next),
        .sel(dato_s),
        .sal(s_wd3)
    );

    // --- outputs ---------------------------------------------------------------------------------
    assign pc = s_pck;
    assign alu_res = s_alu_res;
    assign f3 = instr[14:12];
    assign f7 = instr[30];
    assign op_code = instr[6:0];
    assign write_data = s_srcB;


endmodule