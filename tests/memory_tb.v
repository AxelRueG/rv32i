`include "./Memory.v"
`timescale 1ps/1ps

module moduleName;

    reg clk;
    reg en;
    reg [15:0] addr_ram;
    reg [31:0] data;
    reg [15:0] addr_rom;
    wire [31:0] out_rom;
    wire [31:0] out_ram;

    integer iter;

    Memory mem (
        .clk(clk),
        .en(en),
        .addr_ram(addr_ram),
        .data(data),
        .addr_rom(addr_rom),
        .out_rom(out_rom),
        .out_ram(out_ram)
    );

    // starting clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        en = 0;
        for (iter = 0 ; iter <32; iter = iter + 1) begin
            addr_ram = iter;
            data = iter + 100;
            #10
            $display("[%d] RAM:<%h: %h>", iter, addr_ram, out_ram);
        end

        $display("------------------------------------------------------------");
        en = 1;
        for (iter = 0 ; iter <32; iter = iter + 1) begin
            addr_ram = iter;
            data = iter + 100;
            #10
            $display("[%d] RAM:<%h: %h>", iter, addr_ram, out_ram);
        end

        $display("------------------------------------------------------------");
        en = 0;
        for (iter = 0 ; iter <32; iter = iter + 1) begin
            addr_ram = iter;
            data = iter + 100;
            #10
            $display("[%d] RAM:<%h: %h>", iter, addr_ram, out_ram);
        end

        $display(" ---- ROM ----");

        for (iter = 0 ; iter < 256; iter = iter + 4) begin
            addr_rom = iter;
            #10
            $display("[%d] ROM:<%h: %h>", iter, addr_rom, out_rom);
        end

        $finish;
    end


endmodule