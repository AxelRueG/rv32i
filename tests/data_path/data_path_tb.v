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

        jump = 1; // enable pc

        // dentro del reg 21 tenemos 32'b1 lo sumaremos con sigo mismo y guardaremos el resultado en el reg 22
        regWrite = 1;
        aluControl = 3'b000;
        instr = 32'b00000001010110101000101100000000; // add -> rd22 (deberia ser 2)
        #10
        aluControl = 3'b001;
        instr = 32'b00000001011010101000101110000000; // sub -> rd23 (deberia ser -1)
        #10
        aluControl = 3'b010;
        instr = 32'b00000001011010101000110000000000; // and -> rd23 (deberia ser 0)
        #10
        aluControl = 3'b011;
        instr = 32'b00000001011010101000110010000000; // or -> rd23 (deberia ser 3)
        #10
        aluControl = 3'b101;
        instr = 32'b00000001010110101000110100000000; // slt -> rd23 (deberia ser 0)
        #10


        $display("finished...");
        $finish;
        
    end

endmodule