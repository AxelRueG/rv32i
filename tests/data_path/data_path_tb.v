`include "./data_path/DataPath.v"
`timescale 1ps/1ps

module data_path_tb;
    
    // inputs
    reg branch;
    reg jump;
    reg clk;
    reg [31:0] readData;
    reg [1:0] resultSrc;
    reg [1:0] inmSrc;
    reg [31:0] instr;
    reg regWrite;
    reg aluSrc;
    reg [2:0] aluControl;

    // outputs
    wire [31:0] aluRes;
    wire zero;
    wire [6:0] op;
    wire [2:0] f3;
    wire f7;
    wire [31:0] writeData;
    wire [15:0] pc;

    DataPath uut (
        .branch(branch),
        .jump(jump),
        .clk(clk),
        .readData(readData),
        .resultSrc(resultSrc),
        .inmSrc(inmSrc),
        .instr(instr),
        .regWrite(regWrite),
        .aluSrc(aluSrc),
        .aluControl(aluControl),
        .aluRes(aluRes),
        .zero(zero),
        .op(op),
        .f3(f3),
        .f7(f7),
        .writeData(writeData),
        .pc(pc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        $dumpfile("./waves/data_path_tb.vcd");
        $dumpvars(0, data_path_tb);

        jump = 2'b01; // enable pc

        // constantes
        regWrite = 1;
        inmSrc = 2'b00;
        aluControl = 3'b000;
        aluSrc = 1;

        // test
        resultSrc = 2'b00;
        instr = 32'b00000001010110101000101100000000; // add -> rd22 (deberia ser 22)
        #10
        resultSrc = 2'b01;
        instr = 32'b00000001011010101000101110000000; // add -> rd23 (deberia ser 23)
        readData = 32'h0000000c;
        #10

        $display("finished...");
        $finish;
        
    end

endmodule