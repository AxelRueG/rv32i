module IM(
    input [15:0] pc,
    output [31:0] instr
);

    parameter ROM_WIDTH = 32;
    parameter ROM_ADDR_BITS = 64;
    reg [ROM_WIDTH-1:0] ROM [ROM_ADDR_BITS-1:0];

    initial begin

        ROM[0] = 32'h00300413;      // addi a0,zero,3
        ROM[1] = 32'h00100493;      // addi a1,zero,1
        ROM[2] = 32'h01000913;      // addi a2,zero,16

    end

    // divido por cuato debido a que pc va aumentando de a 4 jeje
    assign instr = ROM[pc >> 2];

endmodule