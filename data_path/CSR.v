module CSR (
    input wire clk, // <------ CHECK IF THIS IS REQUIRED
    input wire csr_w,
    input [11:0] csr,
    input [31:0] wd,
    output [31:0] rd
);

    // def and initialization of registers
    reg [31:0] registers [99:0];

    integer i;
    initial begin
        for(i = 0;i<100;i=i+1) begin
            registers[i] <= 32'h00000000;
        end
    end


    always @(posedge clk)
    begin
        if (csr_w) begin
            registers[csr] = wd;
        end
    end

    assign rd = registers[csr];

endmodule