`include "./Top.v"
`timescale 1ps/1ps

module top_tb;

    reg clk;
    reg key;

    wire [15:0] pc;
    wire [31:0] instr;
    wire [31:0] data;

    integer iter;

    Top uut (
        .clk(clk),
        .key(key),
        .pc(pc),
        .instr(instr),
        .mem_out(data)
    );

    // start clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // execute instructions
    initial begin
        $dumpfile("./waves/top.vcd");
        $dumpvars(0, uut);
        
        key = 0;

        for (iter = 0; iter<64; iter=iter+1) begin
            // #2
            // $display("[%d : %d] -> <rom: %h, ram: %h>", iter, pc, instr, data);
            // #8
            // si no hay mas intrucciones corta la ejecucion
            #10
            if (instr === 32'bx) begin
                $finish;
            end
        end

        $finish;
    end


endmodule