/** ------------------------------------------------------------------------------------------------
    Registros de control y estado
------------------------------------------------------------------------------------------------- */
module CSR_regs (
    // gestión excepciones
    input except,
    input interrupt,
    input [31:0] except_info,
    output [31:0] csr_info,

    // solo relacionados al registro
    input clk,
    input csr_w,
    input [11:0] csr_addr,
    input [31:0] data_in,
    output reg [31:0] data_out
);
    
    // -- REGISTROS CSR ---
    reg [31:0] mstatus = 0; // para habilitar las excepciones
    reg [31:0] mepc = 0;    // guarda la direccion en la que se genero la excepcion
    reg [31:0] mcause = 0;  // causa de la excepcion
    reg [31:0] mtvec = 0;   // direccion de la rutina manejadora de excepciones (vector de excepts)
    reg [31:0] mip = 0;     // indica el estado de las excepciones

    // -- DIRECCIONES ---
    parameter ADDR_MSTATUS = 12'h000;
    parameter ADDR_FRM     = 12'h002;
    parameter ADDR_MEPC    = 12'h041; 
    parameter ADDR_MCAUSE  = 12'h042;
    parameter ADDR_MTVEC   = 12'h005;
    parameter ADDR_MIP     = 12'h044;

    // -- lectura del registro csr ---
    always @(*) 
    begin
        case (csr_addr)
            ADDR_MSTATUS: data_out = mstatus;
            ADDR_FRM:     data_out = mepc; // MRET: retorna el valor de MEPC
            ADDR_MEPC:    data_out = mepc;
            ADDR_MCAUSE:  data_out = mcause;
            ADDR_MTVEC:   data_out = mtvec;
            ADDR_MIP:     data_out = mip;
            default:      data_out = 32'b0; // Valor por defecto
        endcase

        if (except) begin
            data_out = mtvec;
        end
    end

    // -- escritura del registro csr y manejo de excepciones ---
    always @(posedge(clk)) 
    begin
        if (except) begin
            // Manejo de excepciones
            mepc <= {16'b0, except_info[15:0]};
            mstatus <= {24'b0, except_info[23:16]};
            mcause <= {except_info[31], 24'b0, except_info[30:24]};
        end
        else if (csr_w) begin
            // Escritura en registros CSR
            case (csr_addr)
                ADDR_MSTATUS: mstatus <= data_in;
                ADDR_MEPC:    mepc    <= data_in;
                ADDR_MCAUSE:  mcause  <= data_in;
                ADDR_MTVEC:   mtvec   <= data_in;
                ADDR_MIP:     mip     <= data_in;
            endcase    
        end
    end

    assign csr_info = { mip[15:0], mstatus[15:0] };

endmodule