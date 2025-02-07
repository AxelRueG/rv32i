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
        ROM[0]  = 32'h00000513; // [0] la a0, mem
        ROM[1]  = 32'h04400293; // [4] la t0,handler        # cargo direccion de la rutina manejadora
        ROM[2]  = 32'h0000d073; // [8] csrrwi zero,0,1      # activo las excepciones
        ROM[3]  = 32'h00529073; // [12] csrrw zero,5,t0  	# cargo mtvec
        ROM[4]  = 32'h0440d073; // [16] csrrwi zero,68,1 	# activar la interrupciones
        ROM[5]  = 32'h00100293; // [20] addi t0,zero,1      # encendemos el LED
        ROM[6]  = 32'h06552a23; // [24] sw t0, 116(a0)
        ROM[7]  = 32'h00a00593; // [28] addi a1,zero,10     # punto de control para lanzar except
        ROM[8]  = 32'h00000333; // [32] add t1,zero,zero 	# iniciamos el contador
        // loop
        ROM[9]  = 32'h00130313; // [36] addi t1,t1,1
        ROM[10] = 32'h00b30463; // [40] beq t1,a1,then
        ROM[11] = 32'hff9ff06f; // [44] j loop 			    # es como un continue
        // then
        ROM[12] = 32'h00000333; // [48] add t1,zero,zero 	# reiniciamos el valor de t1
        ROM[13] = 32'h00000073; // [52] ecall               # EBREAK 
        ROM[14] = 32'hfedff06f; // [56] j loop
        ROM[15] = 32'h00a00893; // [60] addi a7,zero,10     # return 0
        ROM[16] = 32'h00000073; // [64] ecall
        // -----------------------------------------------------------------------------------------
        // --- HANDLER -----------------------------------------------------------------------------
        ROM[17] = 32'h00652023; // [68] sw t1, (a0)      	# guardamos en memoria el valor del contador actual
        ROM[18] = 32'h00b52223; // [72] sw a1, 4(a0)        # guardo el valor del punto de control
        ROM[19] = 32'h06052a23; // [76] sw zero, 116(a0) 	# apagamos el LED_1
        ROM[20] = 32'h00100313; // [80] addi t1,zero,1
        ROM[21] = 32'h06652c23; // [84] sw t1, 120(a0)      # activamos el LED_2
        ROM[22] = 32'h00c00393; // [88] addi t2,zero,12  	# el MCAUSE de excepcion mas grande que tenemos es 11
        ROM[23] = 32'h04201e73; // [92] csrrw t3,66,zero 	# cargo el mcause
        ROM[24] = 32'h000e2eb3; // [96] slt t4,t3,zero     	# guardamos si MCAUSE < 12 
        ROM[25] = 32'h006e8c63; // [100] beq t4,t1,inter 	# t4 = 1
        // exception
        ROM[26] = 32'h00600593; // [104] addi a1,zero,6     # se repetira un loop 20 veces
        ROM[27] = 32'h00000eb3; // [108] add t4,zero,zero 	# iniciamos contador
        // loop1
        ROM[28] = 32'h03d58063; // [112] beq a1,t4,endexcept
        ROM[29] = 32'h001e8e93; // [116] addi t4,t4,1
        ROM[30] = 32'hff9ff06f; // [120] j loop1
        // interruption
        ROM[31] = 32'h00300593; // [124] addi a1,zero,3
        ROM[32] = 32'h00000eb3; // [128] add t4,zero,zero
        // loop2
        ROM[33] = 32'h01d58663; // [132] beq a1,t4,endexcept
        ROM[34] = 32'h001e8e93; // [136] addi t4,t4,1
        ROM[35] = 32'hff9ff06f; // [140] j loop2
        // endexcept
        ROM[36] = 32'h06052c23; // [144] sw zero, 120(a0) 	# apagamos   LED_2
        ROM[37] = 32'h06652a23; // [148] sw t1, 116(a0)   	# encendemos LED_1
        ROM[38] = 32'h00052303; // [152] lw t1, (a0)      	# recuperamos el valor del contador
        ROM[39] = 32'h00452583; // [156] lw a1, 4(a0)     	# recupero el valor del punto de control
        ROM[40] = 32'h041012f3; // [160] csrrw t0,65,zero
        ROM[41] = 32'h00428293; // [164] addi t0,t0,4
        ROM[42] = 32'h04129073; // [168] csrrw zero,65,t0
        ROM[43] = 32'h00200073; // [172] uret

    end

    // The program counter is updated with a step of four
    assign rd = ROM[addr >> 2];

endmodule
