`include "./rv32i.v"
`include "./Memory.v"

module Top (
    input wire clk,
    input wire key,
    output [15:0] pc,
    output [31:0] instr,
    output [31:0] mem_out,
    output [31:0] led_1,
    output [31:0] led_2
);

    // output of processor
    wire mem_w;
    wire [15:0] s_pc;
    wire [31:0] alu_res, write_data;
    // output of memory
    wire [31:0] s_instr, read_data;

    rv32i processor (
        .clk(clk),
        .key(key),
        .instr(s_instr),
        .read_data(read_data),

        .mem_w(mem_w),
        .alu_res(alu_res),
        .write_data(write_data),
        .pc(s_pc)
    );

    Memory memory (
        .clk(clk),
        .en(mem_w),
        .addr_ram(alu_res[15:0]),
        .data(write_data),
        .addr_rom(s_pc),
        .key(key),

        .out_rom(s_instr),
        .out_ram(read_data),
        .led_1(led_1),
        .led_2(led_2)
    );
    
    assign pc = s_pc;
    assign mem_out = read_data;
    assign instr = s_instr;
    
endmodule