`include "./rv32i.v"
`timescale 1ps/1ps

module rv32i_tb1;
    

    reg clk;
    wire [15:0] instrAddr;
    wire [31:0] aluResult;
    wire [31:0] memoryOut;
    wire [31:0] memoryIn;
    wire [31:0] instruction;

    integer iter;

    rv32i uut (
        .clk(clk),
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

    // procesamos las intrucciones
    initial begin
        $dumpfile("./waves/rv32i_tb1.vcd");
        $dumpvars(0, rv32i_tb1);
        
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