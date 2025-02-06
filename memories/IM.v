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


        // ROM[] = 32'b00000297; <-- auipc
        // ROM[0] = 32'h01c28293;  // 000000011100 00101 000 00101 0010011 | 28  5 5 | 0 (addi)
        // ROM[1] = 32'h0000d073;  // 000000000000 00001 101 00000 1110011 | 0   1 0 | 4 (csrrwi)
        // ROM[2] = 32'h00529073;  // 000000000101 00101 001 00000 1110011 | 5   5 0 | 8 (csrrw)
        // ROM[3] = 32'h00100073;  // 000000000001 00000 000 00000 1110011 | 1   0 0 | 12 (ebrak)
        // ROM[3] = 32'h00000073;  // 000000000000 00000 000 00000 1110011 | 0   0 0 | 12 (ecall) 
        // ROM[3] = 32'h0660057f;  // 000001100110 00000 000 01010 0010011 | 102 0 5 | 12
        // ROM[4] = 32'h06600513;  // 000001100110 00000 000 01010 0010011 | 102 0 5 | 16 (addi)

        // ROM[7] = 32'h041012f3;  // 000001000001 00000 001 00101 1110011 | 65  0 5 | 28 (csrrw)
        // ROM[8] = 32'h00428293;  // 000000000100 00101 000 00101 0010011 | 4   5 5 | 32 (addi)
        // ROM[9] = 32'h04129073;  // 000001000001 00101 001 00000 1110011 | 65  5 0 | 36 (csrrw)
        // ROM[10] = 32'h00200073; // 000000000010 00000 000 00000 1110011 | 2   0 0 | 40 (uret)

        // ---------------- COUNTER WITH EXCEPTION HANDLER METHOD ----------------------------------
        // ROM[0]  = 32'h02800293; //    000000101000 00000 000 00101 0010011 | 40 0  5 | 0: I <--- MOD
        // ROM[1]  = 32'h00529073; //    000000000101 00101 001 00000 1110011 |  5 5  0 | 4: CSR
        // ROM[2]  = 32'h0000d073; //    000000000000 00001 101 00000 1110011 |  0 1  0 | 8: CSR
        // ROM[3]  = 32'h00b00313; //    000000001010 00000 000 00110 0010011 | 10 0  6 | 12: I
        // ROM[4]  = 32'h000003b3; //   0000000 00000 00000 000 00111 0110011 |  0 0  7 | 16: R
        // ROM[5]  = 32'h00638663; // 0 000000 00110 00111 000 0110 0 1100011 | 12 6  7 | 20: BEQ
        // ROM[6]  = 32'h00138393; //    000000000001 00111 000 00111 0010011 |  1 7  7 | 24: I
        // ROM[7]  = 32'hff9ff06f; //   1 1111111100 1 11111111 00000 1101111 | -8 -  0 | 28: J
        // ROM[8]  = 32'h00a00893; //    000000001010 00000 000 10001 0010011 | 10 0 17 | 32: I
        // ROM[10] = 32'h041012f3; //    000001000001 00000 001 00101 1110011 | 65 0  5 | 40: CSR
        // ROM[11] = 32'h00428293; //    000000000100 00101 000 00101 0010011 |  4 5  5 | 44: I
        // ROM[12] = 32'h04129073; //    000001000001 00101 001 00000 1110011 | 65 5  0 | 48: CSR
        // ROM[13] = 32'h00200073; //    000000000010 00000 000 00000 1110011 |  2 0  0 | 52: URET
    
        // ----- CHECK LW Y SW INSTR ---------------------------------------------------------------
        ROM[0] = 32'h00050513; //  000000000000 01010 000 01010 0010011 | ADDI   
        ROM[1] = 32'h00a00293; //  000000001010 00000 000 00101 0010011 | ADDI   
        ROM[2] = 32'h01400313; //  000000010100 00000 000 00110 0010011 | ADDI   
        ROM[3] = 32'h02800393; //  000000101000 00000 000 00111 0010011 | ADDI   
        ROM[4] = 32'h00552023; // 0000000 00101 01010 010 00000 0100011 | SW   
        ROM[5] = 32'h00652223; // 0000000 00110 01010 010 00100 0100011 | SW   
        ROM[6] = 32'h00752423; // 0000000 00111 01010 010 01000 0100011 | SW   
        ROM[7] = 32'h00052383; //  000000000000 01010 010 00111 0000011 | LW   
        ROM[8] = 32'h00452303; //  000000000100 01010 010 00110 0000011 | LW   
        ROM[9] = 32'h00852283; //  000000001000 01010 010 00101 0000011 | LW   

    end

    // The program counter is updated with a step of four
    assign rd = ROM[addr >> 2];

endmodule
