`include "./memory/IM.v"
`timescale 1 ns / 1 ps

module im_tb;

    integer iterator;
    
    reg [15:0] instr_addr;
    wire [31:0] instr;

    IM uut(
        .addr(instr_addr),
        .rd(instr)
    );


    initial begin

        for (iterator = 0; iterator < 256; iterator = iterator + 4) begin
            instr_addr = iterator;
            #10;
            $display("inst [%d | %d] %h", iterator, iterator >> 2, instr);
        end

        #10
        $finish;
        
    end

endmodule