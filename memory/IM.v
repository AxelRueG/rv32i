module IM(
    input [15:0] pc,
    output [31:0] instr
);

    parameter ROM_WIDTH = 32;
    parameter ROM_ADDR_BITS = 64;
    reg [ROM_WIDTH-1:0] ROM [ROM_ADDR_BITS-1:0];

    initial begin

        ROM[0]  = 32'h00300413;
        ROM[1]  = 32'h00100493;
        ROM[2]  = 32'h01000913;
        ROM[3]  = 32'h009462b3;
        ROM[4]  = 32'h00947333;
        ROM[5]  = 32'h009403b3;
        ROM[6]  = 32'h40940e33;
        ROM[7]  = 32'h40848eb3;
        ROM[8]  = 32'h00942f33;
        ROM[9]  = 32'h0084afb3;
        ROM[10] = 32'h01d4afb3;

    end

    // divido por cuato debido a que pc va aumentando de a 4 jeje
    assign instr = ROM[pc >> 2];

endmodule