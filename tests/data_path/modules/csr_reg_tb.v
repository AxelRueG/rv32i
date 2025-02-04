`timescale 1ps/1ps
`include "./data_path/CSR_regs.v"


module moduleName;

    reg clk;
    reg csr_w;
    reg [11:0] csr_addr;
    reg [31:0] data_in;
    wire [31:0] data_out;


    CSR uut (
        .clk(clk),
        .csr_w(csr_w),
        .csr_addr(csr_addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // inicializamos el reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
    
        $dumpfile("./waves/csr_tb.vcd");
        $dumpvars(0, uut);

        data_in = 1;
        csr_w = 0; csr_addr = 12'h001;
        #10
        csr_w = 1;
        #10
        data_in = 32'h000000ac;
        csr_w = 0; csr_addr = 12'h000;
        #10
        csr_w = 1;
        #10
        csr_w = 0; csr_addr = 12'h041;
        #10
        csr_w = 1;
        #10
        csr_w = 0; csr_addr = 12'h042;
        #10
        csr_w = 1;
        #10
        csr_w = 0; csr_addr = 12'h005;
        #10
        csr_w = 1;
        #10
        csr_w = 0; csr_addr = 12'h044;
        #10
        csr_w = 1;
        #10

        $finish;
    end

endmodule