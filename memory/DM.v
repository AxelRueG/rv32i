module DM(
    input clk, we,
    input [15:0] addres,
    input [31:0] wd,
    output [31:0] rd
);

    reg [31:0] RAM [31:0];

    // activacion por flanco ascendente
    always @(posedge clk) begin
        if (we) begin
            RAM[addres] <= wd;
        end
    end

    // retorna el estado anterior
    assign rd = RAM[addres];

endmodule