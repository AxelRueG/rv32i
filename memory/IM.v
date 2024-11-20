/**
Instruction Memory (ROM)
*/
module IM(
    input [15:0] addr,
    output [31:0] rd
);

    parameter ROM_WIDTH = 32;
    parameter ROM_ADDR_BITS = 128;
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
        // ROM[10] = 32'h01d4afb3; // x31 = x8 < x29 = 0 | (40)

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


        // ~~ EXAMPLE OF A INSTRUCTION UNKNOWN (05-09 11:17) ~~
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

        // ROM[0] = 32'h10000293; // addi x5,x0,100
        // ROM[1] = 32'h00529073; // csrrw x0,5,x5
        // ROM[2] = 32'h0000e073; // csrrsi x0,0,1
        // ROM[3] = 32'hfff02003; // lw x0,0,1
        // ROM[4] = 32'h00a00893; // addi x17,xx0,10

        // // ROM[64] = 32'h00000013; // nop 
        // ROM[64] = 32'h041012f3; // csrrw x5,65,x0 
        // ROM[65] = 32'h00428293; // addi x5,x5,4
        // ROM[66] = 32'h04129073; // csrrw x0,65,x5
        // ROM[67] = 32'h00200073; // uret

        ROM[0] = 32'h10000293; // addi x5,x0,256
        ROM[1] = 32'h00529073; // csrrw x0,5,x5
        ROM[2] = 32'h0000e073; // csrrsi x0,0,1
        ROM[3] = 32'h0040e073; // csrrsi x0,4,1
        ROM[4] = 32'h00000333; // add x6,x0,x0
        ROM[5] = 32'h00a00393; // addi x7,x0,10
        ROM[6] = 32'h00730663; // beq x7,x0,12
        ROM[7] = 32'h00130313; // addi x6,x6,1
        ROM[8] = 32'hff9ff0ef; // jal x1,-8
        ROM[9] = 32'h00a00893; // addi x17,x0,10
 
        ROM[64] = 32'h04202573; // csrrs x10,66,x0
        ROM[65] = 32'h00b00593; // addi x11,x0,11
        ROM[66] = 32'h00b50463; // beq x10,x11,8
        ROM[67] = 32'h00200073; // uret
        ROM[68] = 32'h00000e33; // add x28,x0,x0 
        ROM[69] = 32'h00500e93; // addi x29,x0,5
        ROM[70] = 32'h01de0663; // beq x28,x29,12
        ROM[71] = 32'h001e0e13; // addi x28,x28,1
        ROM[72] = 32'hff9ff06f; // jal x0,-8
        ROM[73] = 32'h00200073; // uret

    end

    // The program counter is updated with a step of four
    assign rd = ROM[addr >> 2];

endmodule
