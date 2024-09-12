`include "./data_path/CSR.v"
`timescale 1ps/1ps

module csr_tb;
    
    
    reg [31:0] instr;
    reg [15:0] ram_addr;
    reg [15:0] rom_addr;
    wire op_m;
    wire [31:0] addr_o;

    reg clk;
    reg csr_w;
    reg [11:0] csr;
    reg [31:0] wd;
    wire [31:0] rd;

    CSR uut (
        .instr(instr),
        .ram_addr(ram_addr),
        .rom_addr(rom_addr), // es lo mismo que pc
        .op_m(op_m), // por ahora esto getionara como si fuera la atencion a excepciones original
        .addr_o(addr_o),


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



        instr = 32'h00502073;
        ram_addr = 12;
        rom_addr = 24;

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