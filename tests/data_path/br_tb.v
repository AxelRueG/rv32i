`include "./data_path/BR.v"
`timescale 1ps/1ps

module br_tb;
    
    reg clk;
    reg [4:0] a1;
    reg [4:0] a2;
    reg [4:0] a3;
    reg [31:0] wd3;
    reg we;
    wire [31:0] rd1;
    wire [31:0] rd2;

    integer iterator;

    BR uut (
        .clk(clk),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .wd3(wd3),
        .we(we),
        .rd1(rd1),
        .rd2(rd2)
    );

    // configuramos reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // test
    initial begin

        // estado inicial
        for (iterator = 0; iterator < 32; iterator = iterator + 2) begin
            a1 = iterator;
            a2 = iterator+1;
            #10
            $display("[%d]: [%h]\t[%d]: [%h]", a1, rd1, a2, rd2);
        end

        // escribimos algunos valores alazares
        we = 1;
        // changes in registers
        a3 = 10;
        wd3 = 32'h00000012;
        #10
        a3 = 5;
        wd3 = 32'h0000f00f;
        #10
        a3 = 21;
        wd3 = 32'h00000abc;
        #10

        $display("\nupdating...\n");
        we = 0;
        // post changes
        for (iterator = 0; iterator < 32; iterator = iterator + 2) begin
            a1 = iterator;
            a2 = iterator+1;
            #10
            $display("[%d]: [%h]\t[%d]: [%h]", a1, rd1, a2, rd2);
        end

        $finish;
        
    end


endmodule