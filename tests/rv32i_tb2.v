`include "./rv32i.v"
`timescale 1ps/1ps

module rv32i_tb2;
    

    reg clk;
    reg key;
    wire [15:0] instrAddr;
    wire [31:0] aluResult;
    wire [31:0] memoryOut;
    wire [31:0] memoryIn;
    wire [31:0] instruction;

    integer iter;

    rv32i uut (
        .clk(clk),
        .key(key),
        .instrAddr(instrAddr),
        .aluResult(aluResult),
        .memoryOut(memoryOut),
        .memoryIn(memoryIn),
        .instruction(instruction)
    );

    // inicializamos reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        key = 0;
        #122
        $display("the key was pressed");
        key = 1;
        #1
        key = 0;
    end

    // procesamos las intrucciones
    initial begin
        $dumpfile("./waves/rv32i_tb2.vcd");
        $dumpvars(0, rv32i_tb2);

        for (iter = 0; iter<64; iter=iter+1) begin
            #2
            $display("[addr_%d: %h]-> %h", iter, instrAddr, instruction);
            #8
            // si no hay mas intrucciones corta la ejecucion
            if (instruction === 32'bx) begin
                $finish;
            end
        end

        $finish;
    end


endmodule