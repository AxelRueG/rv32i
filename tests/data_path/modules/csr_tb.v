`include "./data_path/CSR.v"
`timescale 1ps/1ps

module csr_tb;
    
    reg clk;
    reg csr_w;
    reg [11:0] csr;
    reg [31:0] wd;
    wire [31:0] rd;

    CSR uut (
        .clk(clk),
        .csr_w(csr_w),
        .csr(csr),
        .wd(wd),
        .rd(rd)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("./waves/csr_tb.vcd");
        $dumpvars(0, csr_tb);

        wd = 100;

        // show importans register
        csr_w = 0;
        csr = 0;
        #10 $display("[0]: %h", rd);
        csr = 5;
        #10 $display("[5]: %h", rd);
        csr = 64;
        #10 $display("[64]: %h", rd);
        csr = 65;
        #10 $display("[65]: %h", rd);
        csr = 66;
        #10 $display("[66]: %h", rd);
        $display("-----------------------------------");

        // modificamos mtvec
        csr_w = 0;
        csr = 0;
        #10 $display("[0]: %h", rd);
        csr = 5;
        csr_w = 1; // enable write
        #10 $display("[5]: %h", rd);
        csr = 64;
        csr_w = 0; // disable write
        #10 $display("[64]: %h", rd);
        csr = 65;
        #10 $display("[65]: %h", rd);
        csr = 66;
        #10 $display("[66]: %h", rd);
        $display("-----------------------------------");


        // vemos los datos actuales 
        csr_w = 0;
        csr = 0;
        #10 $display("[0]: %h", rd);
        csr = 5;
        #10 $display("[5]: %h", rd);
        csr = 64;
        #10 $display("[64]: %h", rd);
        csr = 65;
        #10 $display("[65]: %h", rd);
        csr = 66;
        #10 $display("[66]: %h", rd);

        $finish;
    end

endmodule