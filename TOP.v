`include "./rv32i.v"
`include "./Memory.v"

module Top (
    input wire clk,
    input wire key,
    output [31:0] data
);

    // output of processor
    wire mem_w;
    wire [15:0] pc;
    wire [31:0] alu_res, write_data;
    // output of memory
    wire [31:0] instr, read_data;

    rv32i processor (
        .clk(clk),
        .key(key),
        .instr(instr),
        .read_data(read_data),

        .mem_w(mem_w),
        .alu_res(alu_res),
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
    
    assign data = read_data;
    
endmodule