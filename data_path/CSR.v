`timescale 1ps/1ps

module CSR (
    // para mantener actualizado y controlado los registros
    input [31:0] instr,
    input [15:0] ram_addr,
    input [15:0] rom_addr, // es lo mismo que pc
    output reg [1:0] op_m, // por ahora esto getionara como si fuera la atencion a excepciones original
    output reg [31:0] addr_o,

    // key for handle external interrup
    input wire key,

    // para las intrucciones CSR
    input wire clk,
    input wire csr_w,
    input [11:0] csr,
    input [31:0] wd,
    output reg [31:0] rd
);

    // def and initialization of registers
    reg [31:0] mstatus = 32'h00000000;
    reg [31:0] fflags = 32'h00000000;
    reg [31:0] frm = 32'h00000000;
    reg [31:0] fcsr = 32'h00000000;
    reg [31:0] mie = 32'h00000000; // creo que este es el que necesito para las interrupciones
    reg [31:0] mtvec = 32'h00000000;
    reg [31:0] mscratch = 32'h00000000;
    reg [31:0] mepc = 32'h00000000;
    reg [31:0] mcause = 32'h00000000;
    reg [31:0] s_rd = 32'h00000000;
    
    // direcciones de los registros
    parameter ADDR_mstatus = 12'h000;
    parameter ADDR_fflags = 12'h001;
    parameter ADDR_frm = 12'h002;
    parameter ADDR_fcsr = 12'h003;
    parameter ADDR_mie = 12'h004;
    parameter ADDR_mtvec = 12'h005;
    parameter ADDR_mscratch = 12'h040;
    parameter ADDR_mepc = 12'h041;
    parameter ADDR_mcause = 12'h042;
    
    parameter ROM_MAX_ADDR = 508;

    // auxiliares
    reg [6:0] ope_code;
    reg en_mepc_excep;


    always @(*) begin

        en_mepc_excep = 0;

        // --- HANDLE ERROR ------------------------------------------------------------------------
        op_m = 2'b00;
        addr_o = 32'bx;
        ope_code = instr[6:0];
        // Si MSTATUS esta enable entonces podemos menjar las excepciones
        if (mstatus) begin
            if (
                ope_code != 3   &&
                ope_code != 19  &&
                ope_code != 35  &&
                ope_code != 51  &&
                ope_code != 99  &&
                ope_code != 111 &&
                ope_code != 115
            ) begin // si opcode no esta entre los valores validos
                op_m = 2'b11;
                addr_o = mtvec;
                mcause = 2; // intruccion ilegal
                en_mepc_excep = 1;
            end 
            
            if ((ope_code == 3 || ope_code == 35) && 
                ($signed(ram_addr) < 0 || ram_addr > 16'h007c )) 
            begin
                op_m = 2'b11;
                addr_o = mtvec;
                mcause = 4; // Load address misaligned
                en_mepc_excep = 1;
            end 
            
            if (rom_addr > ROM_MAX_ADDR) begin
                op_m = 2'b11;
                addr_o = mtvec;
                mcause = 0; // instruction address misaligned
                en_mepc_excep = 1;
            end 
            
            // Instruction EBREAK
            if (instr[14:12] == 3'b000 && csr == ADDR_fflags && ope_code == 115) begin
                op_m = 2'b11;
                addr_o = mtvec;
                mcause = 0;
                en_mepc_excep = 1;
            end 
            // Instruction MRET
            if (instr[14:12] == 3'b000 && csr == ADDR_frm && ope_code == 115) begin
                op_m = 2'b11;
                addr_o = mepc;
                mcause = 0;
                // en_mepc_excep = 0;
            end

            if (mie != 32'b0 && key == 1) begin
                op_m = 2'b11;
                addr_o = mtvec;
                mcause = 32'h0000000b; // should be 32'h8000000b
                en_mepc_excep = 1;
                #10
                op_m = 2'b00;
            end
        end


        // ---- definimos la salida del rd ---------------------------------------------------------
        case (csr)
            ADDR_mstatus:  rd = mstatus; 
            ADDR_fflags:   rd = fflags; 
            ADDR_frm:      rd = frm; 
            ADDR_fcsr:     rd = fcsr; 
            ADDR_mie:      rd = mie; 
            ADDR_mtvec:    rd = mtvec; 
            ADDR_mscratch: rd = mscratch; 
            ADDR_mepc:     rd = mepc; 
            ADDR_mcause:   rd = mcause; 
            default: rd = 32'bx; 
        endcase
    end

    // guardamos el pc la la instruccion que genero la excepcion
    always @(negedge(clk))
    begin
        if (en_mepc_excep) begin
            mepc = rom_addr;
        end
    end

    // always @(posedge(key)) begin
    //     if (mie != 32'b0) begin
    //         op_m = 2'b11;
    //         addr_o = mtvec;
    //         // the most significative bit is 1 because is an interrupt, but for this implementation reduced is only 11
    //         mcause = 32'h0000000b; 
    //         mepc = rom_addr;
    //         // en_mepc_excep = 1;
    //         // #10;`
    //     end
    // end


    // en caso de flanco de subida actualizamos los registros con write_data
    always @(posedge clk)
    begin
        if (csr_w) begin
            case (csr)
                ADDR_mstatus:  mstatus = wd; 
                ADDR_fflags:   fflags = wd; 
                ADDR_frm:      frm = wd; 
                ADDR_fcsr:     fcsr = wd; 
                ADDR_mie:      mie = wd; 
                ADDR_mtvec:    mtvec = wd; 
                ADDR_mscratch: mscratch = wd; 
                ADDR_mepc:     mepc = wd; 
                ADDR_mcause:   mcause = wd; 
            endcase
        end
    end
    
endmodule