`include "./data_path/CSR.v"
`timescale 1ps/1ps

module csr_exception_tb;
    
    
    reg [31:0] instr;
    reg [15:0] ram_addr;
    reg [15:0] rom_addr;
    wire [1:0] op_m;
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


        // 32'h10000293;
        // 32'h00529073;
        // 32'h0000e073;
        // 32'hfff02003;
        // 32'h00a00893;
        instr = 32'h10000293;
        ram_addr = 32;
        rom_addr = 0;
        csr_w = 0;
        wd = 0;
        csr = 12'h100;
        #10

        instr = 32'h00529073;
        ram_addr = 32;
        rom_addr = 4;
        csr_w = 1;
        wd = 32'h00000100;
        csr = 12'h005;
        #10

        instr = 32'h0000e073;
        ram_addr = 32;
        rom_addr = 8;
        csr_w = 1;
        wd = 1;
        csr = 12'h000;
        #10

        instr = 32'hfff02003;
        ram_addr = -1;
        rom_addr = 12;
        csr_w = 0;
        wd = 0;
        csr = 12'hfff;
        #10

        instr = 32'h00a00893;
        ram_addr = 32;
        rom_addr = 16;
        csr_w = 0;
        wd = 0;
        csr = 12'h00a;
        #10

        $finish;
    end

endmodule