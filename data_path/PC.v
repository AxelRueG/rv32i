/**
PROGRAM COUNTER
16-bit register with the address of the next instruction
*/
module PC (
    input wire clk,
    input wire [15:0] pcNext,
    output wire [15:0] pc
);

    reg [15:0] s_pc;

    // inicializacion en cero
    initial begin
        s_pc = 0;
    end

    // activacion por cambio de flanco
    always @(posedge clk) begin
        s_pc <= pcNext;
    end

    assign pc = s_pc;

endmodule