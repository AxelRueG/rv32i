`include "./data_path/Adder.v"
`include "./data_path/PC.v"
`include "./data_path/Mux2x1.v"
`include "./data_path/Mux4x1.v"
`include "./data_path/BR.v"
`include "./data_path/ALU.v"
`include "./data_path/SE.v"
`include "./data_path/CSR.v"

module DataPath (
    // ---------------------------------------------------------------------------------------------
    // INPUTS
    // ---------------------------------------------------------------------------------------------
    input wire branch,
    input wire [1:0] jump,
    input wire clk,
    input wire [31:0] readData,
    input wire [1:0] resultSrc,
    // input wire [1:0] inmSrc,
    input wire [31:0] instr,
    input wire regWrite,
    input wire aluSrc,
    input wire [2:0] aluControl,
    input wire csr_w,
    input wire csr_inm,
    input wire [1:0] mocsr,

    // ---------------------------------------------------------------------------------------------
    // OUTPUTS
    // ---------------------------------------------------------------------------------------------
    output wire [31:0] aluRes, // esto deberia ir a la memoria
    output wire zero, // por lo pronto no se como funcionara esto
    output wire [6:0] op,
    output wire [2:0] f3,
    output wire f7,
    output wire [31:0] writeData,
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

    wire [31:0] s_inmExt;
    wire [31:0] s_src2;
    wire [31:0] s_wd3;

    wire [31:0] s_csr_wd;
    wire [31:0] s_csr_rd;
    wire [31:0] s_read_data;

    // constantes
    reg [31:0] cuatro = 4;
    reg [31:0] addr_reset = 0;
    reg [31:0] addr_excep = 100;

    // --- conections ------------------------------------------------------------------------------
    // FETCH    
    Mux2x1 m4 (
        .e1(cuatro),
        .e2(s_inmExt),
        .sel(branch),
        .sal(s_pc_offset)
    );

    Adder add1 (
        .op1(s_pc_offset),
        .op2({16'b0, s_pck}),
        .sal(s_pc_next)
    );

    Adder add2 (
        .op1(s_inmExt),
        .op2({16'b0, s_pck}),
        .sal(s_pc_jump)
    );

    Mux4x1 m1 (
        .e1(addr_reset),
        .e2(s_pc_next),
        .e3(s_pc_jump),
        .e4(addr_excep),
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
        .a1(instr[19:15]),
        .a2(instr[24:20]),
        .a3(instr[11:7]),
        .wd3(s_wd3),
        .we(regWrite),
        .rd1(s_srcA),
        .rd2(s_srcB)
    );

    ALU alu (
        .srcA(s_srcA),
        .srcB(s_src2),
        .ALUControl(aluControl),
        .res(s_alu_res),
        .zero(zero)
    );

    // TYPE-I
    SE sign_extension (
        .instr(instr),
        // .src(inmSrc),
        .inmExt(s_inmExt)
    );

    Mux2x1 m2 (
        .e1(s_srcB),
        .e2(s_inmExt),
        .sel(aluSrc),
        .sal(s_src2)
    );

    Mux4x1 m3 (
        .e1(s_alu_res),
        .e2(s_read_data),
        .e3(s_inmExt),
        .e4(s_pc_next),
        .sel(resultSrc),
        .sal(s_wd3)
    );

    // CSR
    Mux2x1 m5 (
        .e1(s_srcA),
        .e2({27'b0, instr[19:15]}),
        .sel(csr_inm),
        .sal(s_csr_wd)
    );

    CSR csr (
        .clk(clk),
        .csr_w(csr_w),
        .csr(instr[31:20]),
        .wd(s_csr_wd),
        .rd(s_csr_rd)
    );

    // necesitamos un mux para seleccionar la data de csr o la data leida de memoria

    Mux4x1 m6 (
        .e1(readData),
        .e2(s_csr_rd),
        .e3({16'b0, s_pck}),
        .e4(32'bx),
        .sel(mocsr),
        .sal(s_read_data)
    );

    // --- outputs ---------------------------------------------------------------------------------
    assign pc = s_pck;
    assign aluRes = s_alu_res;
    assign f3 = instr[14:12];
    assign f7 = instr[30];
    assign op = instr[6:0];
    assign writeData = s_srcB;


endmodule