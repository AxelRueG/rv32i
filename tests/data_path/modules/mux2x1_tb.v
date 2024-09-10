`include "./data_path/Mux2x1.v"
`timescale 1ps/1ps

module mux2x1_tb;
    
    reg [31:0] e1;
    reg [31:0] e2;
    reg sel;
    wire [31:0] sal;

    Mux2x1 uut (
        .e1(e1),
        .e2(e2),
        .sel(sel),
        .sal(sal)
    );

    initial begin

        e1 = 32'h1000000a;
        e2 = 32'h0100000b;

        // sel 0
        sel = 0;
        #10 $display("mux[%b]: %h", sel, sal);
        // sel 1
        sel = 1;
        #10 $display("mux[%b]: %h", sel, sal);

        $finish;
    end

endmodule