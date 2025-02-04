/**
Registros de control y estado

intrucciones a implementar
csr[11:0]
csrrw  rd, csr, r1 -> 00529073 => 000000000101 00101 001 00000 1110011
csrrwi rd, csr, r1 -> 0000d073 => 000000000000 00001 101 00000 1110011
ebreak             -> 00100073 => 000000000001 00000 000 00000 1110011
ecall              -> 00000073 => 000000000000 00000 000 00000 1110011
mret               -> 00200073 => 000000000010 00000 000 00000 1110011
*/
module CSR_regs (
    input clk,
    input csr_w,
    input [11:0] csr_addr,
    input [31:0] data_in,
    output [31:0] data_out
);
    
    // -- REGISTROS CSR ---
    reg [31:0] mstatus = 0; // para habilitar las excepciones
    reg [31:0] mepc = 0;    // guarda la direccion en la que se genero la excepcion
    reg [31:0] mcause = 0;  // causa de la excepcion
    reg [31:0] mtvec = 0;   // direccion de la rutina manejadora de excepciones (vector de excepts)
    reg [31:0] mip = 0;     // indica el estado de las excepciones

    // -- DIRECCIONES ---
    parameter ADDR_MSTATUS = 12'h000;
    parameter ADDR_MRM     = 12'h002;
    parameter ADDR_MEPC    = 12'h041; 
    parameter ADDR_MCAUSE  = 12'h042;
    parameter ADDR_MTVEC   = 12'h005;
    parameter ADDR_MIP     = 12'h044;

    reg [31:0] s_data_out;

    // -- lectura del registro csr ---
    always @(*) 
    begin
        case (csr_addr)
            ADDR_MSTATUS: s_data_out <= mstatus;
            ADDR_MRM: begin
                if (mstatus == 12'h001)
                    s_data_out <= mtvec;
                else
                    s_data_out <= mepc;
            end
            ADDR_MEPC:    s_data_out <= mepc;
            ADDR_MCAUSE:  s_data_out <= mcause;
            ADDR_MTVEC:   s_data_out <= mtvec;
            ADDR_MIP:     s_data_out <= mip;
            default:      s_data_out <= 32'bx;
        endcase
    end

    // -- escritura del registro csr ---
    always @(posedge(clk)) 
    begin
        if (csr_w) begin
            case (csr_addr)
                ADDR_MSTATUS: mstatus = data_in;
                ADDR_MEPC:    mepc    = data_in;
                ADDR_MCAUSE:  mcause  = data_in;
                ADDR_MTVEC:   mtvec   = data_in;
                ADDR_MIP:     mip     = data_in;
            endcase    
        end
    end

    assign data_out = s_data_out;

endmodule