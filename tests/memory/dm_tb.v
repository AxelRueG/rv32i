`include "./memory/DM.v"
`timescale 1ps/1ps

module dm_tb;
    
    reg clk;
    reg we;
    reg [15:0] addr;
    reg [31:0] wd;
    wire [31:0] rd;

    integer iterator;

    DM uut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .wd(wd),
        .rd(rd)
    );

    // starting clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // test
    initial begin

        // inital state
        for (iterator = 0; iterator < 32; iterator = iterator + 1) begin
            addr = iterator;
            #10
            $display("[%d]: [%h]", addr, rd);
        end

        // write randoms values
        we = 1;
        // changes in registers
        addr = 10;
        wd = 32'h00000012;
        #10
        addr = 5;
        wd = 32'h0000f00f;
        #10
        addr = 21;
        wd = 32'h00000abc;
        #10

        $display("\nupdating...\n");
        we = 0;
        // show updates values
        for (iterator = 0; iterator < 32; iterator = iterator + 1) begin
            addr = iterator;
            #10
            $display("[%d]: [%h]", addr, rd);
        end

        $finish;
        
    end


endmodule