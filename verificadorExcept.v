/** ------------------------------------------------------------------------------------------------
CONTROLADOR ENCARGADO DE VERIFICAR EXCEPCIONES

implementado:
[*] csrrw
[*] csrrwi
[*] uret
[*] ecall
[*] ebreak
[*] deteccion de excepcion mcause 2
[*] deteccion de excepcion mcause 4
[*] deteccion de excepcion mcause 0
[*] ir a manejador
------------------------------------------------------------------------------------------------- */

module verificadorExcept (
    input [31:0] csr_info, // senial compuesta por mstatus y mip
    input irq,

    // entradas que debemos comprovar
    input [15:0] addr_rom, // instruccion desalineada
    input [15:0] addr_ram, // addr_instruc desalineada
    input [31:0] instr,   // instruccion invalida

    // TODO: debemos agregar aca el valor de la direccion de memoria es modificada por el pulsador

    // salidas
    output reg exception, // 1 => ocurrio una excepcion
    output interrup,  // 1 => ocurrio una interrupcion
    output reg [31:0] excep_info // aca va a estar codificado la causa y la direccion generadora
);
    // parametros del procesador
    parameter MAX_RAM_SIZE = 16'h007c; //  32 addr RAM alineadas cada 4 partiendo de 0 -> 124
    parameter MAX_ROM_SIZE = 16'h01fc; // 128 addr ROM alineadas cada 4 partiendo de 0 -> 508


    // seniales que generar una salida conpuesta codificada con la informacion de la excep
    reg [6:0] s_mcause;
    reg s_cause_type;
    reg [15:0] s_mret;
    reg [7:0] s_mstatus;

    reg s_exception;

    always @(*) begin
        // reseteamos todas las seniales a zero
        s_exception = 0;
        s_mcause = 0;
        s_cause_type = 0;
        s_mret = 0;
        // estado inicial de mstatus
        s_mstatus = 8'h01;
        if (csr_info[15:0] == 0)
            s_mstatus = 8'h00;

        // si estan activas las excepciones
        if (csr_info[15:0] == 1) begin
            
            // Instruccion invalida
            if (
                instr[6:0] != 3   && // no es lw
                instr[6:0] != 19  && // no es I-type
                instr[6:0] != 35  && // no es sw
                instr[6:0] != 51  && // no es R-type
                instr[6:0] != 99  && // no es B-type
                instr[6:0] != 111 && // no es J-type
                instr[6:0] != 115    // no es CSR instruction
            ) begin
                s_mcause = 2; // intruccion ilegal
                s_mret = addr_rom;
                s_cause_type = 0;
                s_mstatus = 8'h10;
                s_exception = 1;
            end 

            // Direccion RAM invalida (Load address misaligned)
            if ((instr[6:0] == 3 || instr[6:0] == 35) && // si trata de acceder a memoria 
                ($signed(addr_ram) < 0 || addr_ram > MAX_RAM_SIZE )) 
            begin
                s_mcause = 4;
                s_mret = addr_rom;
                s_cause_type = 0;
                s_mstatus = 8'h10;
                s_exception = 1;
            end 

            // Direccion invalida de pc (instruction address misaligned)
            if (addr_rom > MAX_ROM_SIZE) begin
                s_mcause = 0;
                s_mret = addr_rom;
                s_cause_type = 0;
                s_mstatus = 8'h10;
                s_exception = 1;
            end 

            // ECALL
            if (instr == 32'h00000073) begin
                s_mcause = 11;
                s_mret = addr_rom;
                s_cause_type = 0;
                s_mstatus = 8'h10;
                s_exception = 1;
            end 

            // EBREAK
            if (instr == 32'h00100073) begin
                s_mcause = 3;
                s_mret = addr_rom;
                s_cause_type = 0;
                s_mstatus = 8'h10;
                s_exception = 1;
            end 

            // Interrupcion
            if (csr_info[31:16] == 16'b0001 && irq == 1) begin
                s_mcause = 16;
                s_mret = addr_rom;
                s_cause_type = 1;
                s_mstatus = 8'h10;
                s_exception = 1;
            end

        end
        
        exception = s_exception;
        excep_info = { s_cause_type, s_mcause, s_mstatus, s_mret };
    end

endmodule