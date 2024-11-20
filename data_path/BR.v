/**
REGISTER BANK 
32 general purpose 32-bit registers

NOTE: [x0] is inmutable 
*/
module BR(
    input wire clk,
    input wire we,
    input [4:0] a1,
    input [4:0] a2,
    input [4:0] a3,
    input [31:0] wd3,
    output [31:0] rd1,
    output [31:0] rd2
);

    reg [31:0] regBank[31:0];

    // iniciamos todos los registros en cero  
    integer i;
    initial begin
        for(i = 0;i<32;i=i+1) begin
            regBank[i] <= 32'h00000000;
        end
    end

    // activacion por cambio de flanco
    always @(posedge clk)
    begin
        if(we && a3 != 0)
        begin
            regBank[a3] <= wd3;
        end
    end

    assign rd1 = regBank[a1];
    assign rd2 = regBank[a2];

endmodule
