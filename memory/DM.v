/**
Data Memory (RAN)
*/
module DM(
    input clk, we,
    input [15:0] addr,
    input [31:0] wd,
    output [31:0] rd
);

    reg [31:0] RAM [31:0];

    // postedge activation
    always @(posedge clk) begin
        if (we) begin
            RAM[addr] <= wd;
        end
    end

    // return prev value
    assign rd = RAM[addr];

endmodule