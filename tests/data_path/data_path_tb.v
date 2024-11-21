`include "data_path/DataPath.v"
`timescale 1ps/1ps

module data_path_tb;
    
    // inputs
    reg branch;
    reg [1:0] jump;
    reg clk;
    reg [31:0] read_data;
    reg [1:0] dato_s;
    reg [31:0] instr;
    reg reg_w;
    reg alu_s;
    reg [2:0] alu_op;

    reg csr_w;
    reg csr_inm;
    reg [1:0] mocsr;
    reg key;

    // outputs
    wire [31:0] alu_r;
    wire flag;
    wire [6:0] op_code;
    wire [2:0] f3;
    wire f7;
    wire [31:0] write_data;
    wire [15:0] pc;

    DataPath uut (  
        // inputs
        .branch(branch),
        .jump(jump),
        .clk(clk),
        .read_data(read_data),
        .dato_s(dato_s),
        .instr(instr),
        .reg_w(reg_w),
        .alu_s(alu_s),
        .alu_op(alu_op),

        .csr_w(csr_w),
        .csr_inm(csr_inm),
        .mocsr(mocsr),
        .key(key),

        // outputs
        .alu_r(alu_r),
        .flag(flag),
        .op_code(op_code),
        .f3(f3),
        .f7(f7),
        .write_data(write_data),
        .pc(pc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        $dumpfile("./waves/data_path_tb.vcd");
        $dumpvars(0, data_path_tb);

        jump = 2'b01; // enable pc

        // constantes
        reg_w = 1;
        alu_op = 3'b000;
        alu_s = 1;

        // test
        dato_s = 2'b00;
        instr = 32'b00000001010110101000101100010011; // add -> rd22 (deberia ser 22)
        //      32'b000000010101 10101 000 10110 0010011
        #10
        dato_s = 2'b01;
        instr = 32'b00000001011010101000101110010011; // add -> rd23 (deberia ser 23)
        //      32'b000000010110 10101 000 10111 0010011
        read_data = 32'h0000000c;
        #10

        $display("finished...");
        $finish;
        
    end

endmodule