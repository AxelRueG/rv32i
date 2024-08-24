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
        .addres(addr),
        .wd(wd),
        .rd(rd)
    );

    // configuramos reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // test
    initial begin

        // estado inicial
        for (iterator = 0; iterator < 32; iterator = iterator + 1) begin
            addr = iterator;
            #10
            $display("[%d]: [%h]", addr, rd);
        end

        // escribimos algunos valores alazares
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
        // post changes
        for (iterator = 0; iterator < 32; iterator = iterator + 1) begin
            addr = iterator;
            #10
            $display("[%d]: [%h]", addr, rd);
        end

        $finish;
        
    end


endmodule