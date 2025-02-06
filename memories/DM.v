/**
Data Memory (RAN)

- vamos a tener dos direcciones de salidas (30 y 31) 
- vamos a tener una direccion de entrada para le boton (29)
*/
module DM(
    input clk, we,
    input [15:0] addr,
    input [31:0] wd,
    output [31:0] rd

    // conexiones directas
    input [31:0] key,
    output [31:0] led_1,
    output [31:0] led_2
);

    reg [31:0] RAM [31:0];

    // postedge activation
    always @(posedge clk) begin
        if (we) begin
            RAM[addr] <= wd;
        end

        RAM[29] = key;
    end

    // return prev value
    assign rd = RAM[addr];
    assign led_1 = RAM[30];
    assign led_2 = RAM[31];

endmodule