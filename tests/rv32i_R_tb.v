`include "./rv32i.v"
`timescale 1ps/1ps

module moduleName;
    
    reg clk;
    reg key;
    reg [31:0] instr;
    reg [31:0] read_data;
    wire mem_w;
    wire [31:0] alu_res;
    wire [31:0] write_data;
    wire [15:0] pc;

    rv32i uut (
        .clk(clk),
        .key(key),
        .instr(instr),
        .read_data(read_data),
        .mem_w(mem_w),
        .alu_res(alu_res),
        .write_data(write_data),
        .pc(pc)
    );

    // start clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // test R-INSTRUCTION
    initial begin
        
        $dumpfile("./waves/rv32i_r_tn.vcd");
        $dumpvars(0, uut);

        // the key isn't press
        key = 0;

        // the read data in this case dont is required
        read_data = 32'bx;

        // INSTRUCTIONS
        instr = 32'h00300413; // x8  = 3            | (0)
        #10
        instr = 32'h00100493; // x9  = 1            | (4)
        #10
        instr = 32'h01000913; // x18 = 16           | (8)
        #10
        instr = 32'h009462b3; // x5 = x8 || x9 = 3  | (12)
        #10
        instr = 32'h00947333; // x6 = x8 && x9 = 1  | (16)
        #10
        instr = 32'h009403b3; // x7 = x8 + x9 = 4   | (20)
        #10
        instr = 32'h40940e33; // x28 = x8 - x9 = 2  | (24)
        #10
        instr = 32'h40848eb3; // x29 = x9 - x8 = -2 | (28)
        #10
        instr = 32'h00942f33; // x30 = x8 < x9 = 0  | (32)
        #10

        $finish;

    end

endmodule