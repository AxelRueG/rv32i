`include "./Top.v"
`timescale 1ps/1ps

module top_tb;

    reg clk;
    reg key;

    wire [15:0] pc;
    wire [31:0] instr;
    wire [31:0] data;
    wire [31:0] led_1;
    wire [31:0] led_2;

    integer iter;

    Top uut (
        .clk(clk),
        .key(key),
        .pc(pc),
        .instr(instr),
        .mem_out(data),
        .led_1(led_1),
        .led_2(led_2)
    );

    // start clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
      key = 0;
      #40
      key = 1;
      #8
      key = 0;
    end

    // execute instructions
    initial begin
        $dumpfile("./waves/top.vcd");
        $dumpvars(0, uut);

        for (iter = 0; iter<256; iter=iter+1) begin
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