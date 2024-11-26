`include "./memory/DM.v"
`include "./memory/IM.v"

module Memory (
    input wire clk,
    input wire en,
    input wire [15:0] addr_ram,
    input wire [31:0] data,
    input wire [15:0] addr_rom,

    output wire [31:0] out_rom,
    output wire [31:0] out_ram
);

    DM data_memory (
        .clk(clk), 
        .we(en),
        .addr(addr_ram),
        .wd(data),
        .rd(out_ram)
    );

    IM instruction_memory (
        .addr(addr_rom),
        .rd(out_rom)
    );
    
endmodule