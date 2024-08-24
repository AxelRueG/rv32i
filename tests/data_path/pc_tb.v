`include "./data_path/PC.v"
`timescale 1 ns / 1 ps

module pc_tb;
    
    reg clk;
    reg [15:0] in;
    wire [15:0] out;

    PC uut (
        .clk(clk),
        .pcNext(in),
        .pc(out)
    );

    // configuramos reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("./waves/pc_test.vcd");
        $dumpvars(0, pc_tb);
        $display("in: %b\tout:%b", in, out);

        #10
        in = 16'h0004;
        $display("in: %b\tout:%b", in, out);

        #10
        in = 16'h0008;
        $display("in: %b\tout:%b", in, out);

        #10
        in = 16'h000c;
        $display("in: %b\tout:%b", in, out);

        #10
        in = 16'h0010;
        $display("in: %b\tout:%b", in, out);

        #20
        $display("in: %b\tout:%b", in, out);

        $finish;
    end


endmodule