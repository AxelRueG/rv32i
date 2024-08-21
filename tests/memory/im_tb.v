`include "./memory/IM.v"
`timescale 1 ns / 1 ps

module im_tb;
    
    reg [15:0] instr_addr;
    integer iterator;
    wire [31:0] instr;

    IM uut(
        .pc(instr_addr),
        .instr(instr)
    );


    initial begin
        for (iterator = 0; iterator < 256; iterator = iterator + 4) begin
            instr_addr = iterator;
            #10;
            $display("inst [%d] %h", iterator, instr);
        end

        #10
        $finish;
        
    end

endmodule