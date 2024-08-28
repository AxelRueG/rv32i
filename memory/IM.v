module IM(
    input [15:0] pc,
    output [31:0] instr
);

    parameter ROM_WIDTH = 32;
    parameter ROM_ADDR_BITS = 64;
    reg [ROM_WIDTH-1:0] ROM [ROM_ADDR_BITS-1:0];

    initial begin

        // TEST instructions type-I and tipy-R
        // ROM[0]  = 32'h00300413;
        // ROM[1]  = 32'h00100493;
        // ROM[2]  = 32'h01000913;
        // ROM[3]  = 32'h009462b3;
        // ROM[4]  = 32'h00947333;
        // ROM[5]  = 32'h009403b3;
        // ROM[6]  = 32'h40940e33;
        // ROM[7]  = 32'h40848eb3;
        // ROM[8]  = 32'h00942f33;
        // ROM[9]  = 32'h0084afb3;
        // ROM[10] = 32'h01d4afb3;

        // TEST: instruction BEQ and J
        // ROM[0] = 32'h00300413; // x8  = 3   | (0)
        // ROM[1] = 32'h00100493; // x9  = 1   | (4)
        // ROM[2] = 32'h01000913; // x18 = 16  | (8)
        // ROM[3] = 32'h00100293; // x5  = 1   | (12)
        // ROM[4] = 32'h00000313; // x6  = 0   | (16)
        // ROM[5] = 32'h01228863; // beq       | (20)
        // ROM[6] = 32'h005282b3; // x5 += x5  | (24)
        // ROM[7] = 32'h00130313; // x6 += 1   | (28)
        // ROM[8] = 32'hff5ff06f; // jal beq   | (32)

        // TEST: save and load value
        ROM[0] = 32'h00300413; // x8  = 3   | (0)
        ROM[1] = 32'h00100493; // x9  = 1   | (4)
        ROM[2] = 32'h01000913; // x18 = 16  | (8)
        ROM[3] = 32'h00802023; // sw 0      | (12)
        ROM[4] = 32'h00902223; // sw 4      | (16)
        ROM[5] = 32'h01202423; // sw 8      | (20)
        ROM[6] = 32'h00002283; // lw 0      | (24)
        ROM[7] = 32'h00402303; // lw 4      | (28)
        ROM[8] = 32'h00802383; // lw 8      | (32)

    end

    // divido por cuato debido a que pc va aumentando de a 4 jeje
    assign instr = ROM[pc >> 2];

endmodule

/*
00802023
imm = 000000000000  | 0
rs2 = 01000         | 8
rs1 = 00000         | 0
f3  = 010           | 
op  = 0100011       | 35

00902223
imm = 000000000100  | 4
rs2 = 01001         | 9
rs1 = 00000         | 0
f3  = 010           | 
op  = 0100011       | 35

01202423
imm = 000000001000  | 8
rs2 = 10010         | 18
rs1 = 00000         | 0
f3  = 010           | 
op  = 0100011       | 35

*/