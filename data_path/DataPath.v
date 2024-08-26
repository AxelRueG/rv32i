`include "./data_path/Adder.v"
`include "./data_path/PC.v"
`include "./data_path/Mux2x1.v"
`include "./data_path/BR.v"
`include "./data_path/ALU.v"

module DataPath (
    // ---------------------------------------------------------------------------------------------
    // INPUTS
    // ---------------------------------------------------------------------------------------------
    input wire branch,
    input wire jump,
    input wire clk,
    input wire [31:0] readData,
    input wire [1:0] resultSrc,
    input wire [1:0] inmSrc,
    input wire [31:0] instr,
    input wire regWrite,
    input wire aluSrc,
    input wire [2:0] aluControl,

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
    wire [31:0] s_pc_0;

    wire [31:0] s_alu_res;
    wire [31:0] s_srcA;
    wire [31:0] s_srcB;

    // constantes
    reg [31:0] cuatro = 4;
    reg [31:0] addr_reset = 0;

    // --- conections ------------------------------------------------------------------------------
    // FETCH    
    Adder add1 (
        .op1(cuatro),
        .op2({16'b0, s_pck}),
        .sal(s_pck1)
    );

    Mux2x1 m1 (
        .e1(addr_reset),
        .e2(s_pck1),
        .sel(jump),
        .sal(s_pc_0)
    );

    PC program_counter (
        .clk(clk),
        .pcNext(s_pc_0[15:0]),
        .pc(s_pck)
    );

    // TYPE-R
    BR register_bank (
        .clk(clk),
        .a1(instr[19:15]),
        .a2(instr[24:20]),
        .a3(instr[11:7]),
        .wd3(s_alu_res),
        .we(regWrite),
        .rd1(s_srcA),
        .rd2(s_srcB)
    );

    ALU alu (
        .srcA(s_srcA),
        .srcB(s_srcB),
        .ALUControl(aluControl),
        .res(s_alu_res),
        .zero(zero)
    );

    // --- outputs ---------------------------------------------------------------------------------
    assign pc = s_pck;
    assign aluRes = s_alu_res;
    assign f3 = instr[14:12];
    assign f7 = instr[30];
    assign op = instr[6:0];



endmodule