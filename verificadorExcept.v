/**
CONTROLADOR ENCARGADO DE VERIFICAR EXCEPCIONES
*/

module verificadorExcept (
    input [31:0] mstatus, // reg csr para saber si estan activas las excepciones
    input [31:0] mip,     // reg csr para saber si se atienden interrupciones

    // entradas que debemos comprovar
    input [15:0] addr_rom, // instruccion desalineada
    input [15:0] addr_ram, // addr_instruc desalineada
    input [31:0] instr,   // instruccion invalida

    // TODO: debemos agregar aca el valor de la direccion de memoria es modificada por el pulsador

    // salidas
    output exception, // 1 => ocurrio una excepcion
    output interrup,  // 1 => ocurrio una interrupcion
    output [31:0] excep_info // aca va a estar codificado la causa y la direccion generadora
);
    // parametros del procesador
    parameter MAX_RAM_SIZE = 16'h007c;
    parameter MAX_ROM_SIZE = 16'h007c;


    // seniales que generar una salida conpuesta codificada con la informacion de la excep
    reg [6:0] s_mcause = 0;
    reg s_cause_type = 0;
    reg [15:0] s_mret = 0;
    reg [7:0] s_mstatus = 0; 

    reg s_exception = 0;

    always @(*) begin
        // si estan activas las excepciones
        if (mstatus == 1) begin
            
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

        end
    end

    assign excepcion = s_exception;
    assign excep_info = { s_cause_type, s_mcause, s_mstatus, s_mret };
    
endmodule