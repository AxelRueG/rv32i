`include "./data_path/CSR.v"
`timescale 1ps/1ps

module csr_exception_tb;
    
    
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
        $dumpfile("./waves/csr_exception_tb.vcd");
        $dumpvars(0, csr_exception_tb);

        // Excepcion de invalid op
        // instr CSR
        // op  = 7'b1111111
        // csr = 12'h005
        // rd = 00000
        // f3 = 010
        // ra = 00000
        instr = 32'b00000000010100000010000001111111;
        ram_addr = 12;
        rom_addr = 24;
        csr_w = 1;
        wd = 100;
        csr = 12'h005;
        #10

        // Instruccion CSR normal 
        // op = 7'b1110011
        instr = 32'b00000000010100000010000001110011;
        ram_addr = 12;
        rom_addr = 28;
        csr_w = 1;
        wd = 100;
        csr = 12'h005;
        #10

        // Instruccion RAM addr invalid 
        // op = 7'b1110011
        instr = 32'b00000000010100000010000001110011;
        ram_addr = 76;
        rom_addr = 32;
        csr_w = 1;
        wd = 100;
        csr = 12'h005;
        #10

        // Instruccion ROM addr invalid 
        // op = 7'b1110011
        instr = 32'b00000000010100000010000001110011;
        ram_addr = 12;
        rom_addr = 112;
        csr_w = 1;
        wd = 100;
        csr = 12'h005;
        #10

        $finish;
    end

endmodule