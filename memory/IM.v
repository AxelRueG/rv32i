module IM(
    input [15:0] pc,
    output [31:0] instr
);

    parameter ROM_WIDTH = 32;
    parameter ROM_ADDR_BITS = 64;
    reg [ROM_WIDTH-1:0] ROM [ROM_ADDR_BITS-1:0];

    initial begin

        // TEST instructions type-I and tipy-R
        // ROM[0]  = 32'h00300413; // x8  = 3            | (0)
        // ROM[1]  = 32'h00100493; // x9  = 1            | (4)
        // ROM[2]  = 32'h01000913; // x18 = 16           | (8)
        // ROM[3]  = 32'h009462b3; // x5 = x8 || x9 = 3  | (12)
        // ROM[4]  = 32'h00947333; // x6 = x8 && x9 = 1  | (16)
        // ROM[5]  = 32'h009403b3; // x7 = x8 + x9 = 4   | (20)
        // ROM[6]  = 32'h40940e33; // x28 = x8 - x9 = 2  | (24)
        // ROM[7]  = 32'h40848eb3; // x29 = x9 - x8 = -2 | (28)
        // ROM[8]  = 32'h00942f33; // x30 = x8 < x9 = 0  | (32)
        // ROM[9]  = 32'h0084afb3; // x31 = x9 < x8 = 1  | (36)
        // ROM[10] = 32'h01d4afb3; // x31 = x8 < x29 = 1 | (40)

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
        // ROM[0] = 32'h00300413; // x8  = 3   | (0)
        // ROM[1] = 32'h00100493; // x9  = 1   | (4)
        // ROM[2] = 32'h01000913; // x18 = 16  | (8)
        // ROM[3] = 32'h00802023; // sw 0      | (12)
        // ROM[4] = 32'h00902223; // sw 4      | (16)
        // ROM[5] = 32'h01202423; // sw 8      | (20)
        // ROM[6] = 32'h00002283; // lw 0      | (24)
        // ROM[7] = 32'h00402303; // lw 4      | (28)
        // ROM[8] = 32'h00802383; // lw 8      | (32)


        // ~~ EJEMPLO DE INSTUCCION NO CONODICA (05-09 11:17) ~~
        // ROM[0] = 32'h00300413; // x8 - 3         | (0)
        // ROM[1] = 32'h00b00493; // x9 - 11        | (4)
        // ROM[2] = 32'h000002b3; // x5 = 0         | (8)
        // ROM[3] = 32'h00000333; // x6 = 0         | (12)
        // ROM[4] = 32'h00828a63; // while x5 != x8 | (16)
        // ROM[5] = 32'h00128293; // x5 += 1        | (20)
        // // ROM[6] = 32'h00100073; // ebreak         | (24)
        // // ROM[7] = 32'h00930333; // x6 += x9       | (28)
        // // ROM[8] = 32'hff1ff06f; // endWhile       | (32)
        // // ROM[9] = 32'h00a00893; // x17 = 10 (end) | (36) 
        // ROM[6] = 32'h00930333; // x6 += x9       | (24)
        // ROM[7] = 32'hff5ff06f; // endWhile       | (28)
        // ROM[8] = 32'h00a00893; // x17 = 10 (end) | (32) 

        ROM[0] = 32'h05600513;
        ROM[1] = 32'h005512f3;
        ROM[2] = 32'h005022f3;
        ROM[3] = 32'h005b5573;
        

        ROM[63] = 32'hfff00893; // aca esta lo que deberia pasar para gestar la cosa de las cosas
    end

    // divido por cuato debido a que pc va aumentando de a 4 jeje
    assign instr = ROM[pc >> 2];

endmodule
