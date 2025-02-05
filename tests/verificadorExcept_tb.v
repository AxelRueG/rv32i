`include "./verificadorExcept.v"
`timescale 1ps/1ps

module verificadorExcept_tb;

    reg [31:0] csr_info;

    reg [15:0] addr_rom;
    reg [15:0] addr_ram;
    reg [31:0] instr;

    wire exception;
    wire interrup;
    wire [31:0] excep_info;
    
    integer i;

    verificadorExcept uut(
        .csr_info(csr_info),
        .addr_rom(addr_rom),
        .addr_ram(addr_ram),
        .instr(instr),
        .exception(exception),
        .interrup(interrup),
        .excep_info(excep_info)
    );

    initial begin
        $dumpfile("./waves/vexcept_tb.vcd");
        $dumpvars(0, uut);

        csr_info = 0;
        
        for (i=0; i<2; i=i+1) begin
            // primero una intruccion R con direcciones validas
            instr = 32'b00000000011100000000001010010011; // addi x5,x0,7
            addr_rom = 32'h00000008;
            addr_ram = 32'h00000000;
            #10

            // instruccion invalida
            instr = 32'b00000000011100000000001011111111; // op_code invalido 1111111
            addr_rom = 32'h00000008;
            addr_ram = 32'h00000000;
            #10

            // addr RAM invalid
            // addr_ram = 32'h00000000;
            instr = 32'b00000000011100000000001010000011; // addi x5,x0,7
            addr_rom = 32'h00000008;
            addr_ram = 32'h0000f000; // invalid addr
            #10

            // addr ROM invalid
            // addr_rom = 32'h00000008;
            instr = 32'b00000000011100000000001010010011; // addi x5,x0,7
            addr_rom = 32'h0000F008; // invalid addr
            addr_ram = 32'h00000000;
            #10

            csr_info = 1;
        end

        $finish;

    end

endmodule