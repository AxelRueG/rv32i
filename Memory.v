`include "./memories/DM.v"
`include "./memories/IM.v"

module Memory (
    input wire clk,
    input wire en,
    input wire [15:0] addr_ram,
    input wire [31:0] data,
    input wire [15:0] addr_rom,
    input wire [31:0] key,

    output wire [31:0] out_rom,
    output wire [31:0] out_ram,
    output wire [31:0] led_1,
    output wire [31:0] led_2,
    output wire irq
);

    DM data_memory (
        .clk(clk), 
        .we(en),
        .addr(addr_ram),
        .wd(data),
        .rd(out_ram),

        .key(key),
        .led_1(led_1),
        .led_2(led_2),
        .IRQ(irq)
    );

    IM instruction_memory (
        .addr(addr_rom),
        .rd(out_rom)
    );
    
endmodule