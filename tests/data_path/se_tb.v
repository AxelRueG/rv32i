`include "./data_path/SE.v"
`timescale 1ps/1ps

module moduleName;
    
    reg [31:0] instr;
    reg [1:0] src;
    wire [31:0] immExt;

    SE uut (
        .instr(instr),
        .src(src),
        .immExt(immExt)
    );

    initial begin
        
        instr = 32'h44208380; // 0100010 00010 00001 000 00111 0000000
                              // 0100 0100 0010 0000 1000 0011 1000 0000

        // R-type: nada
        // I-type: 0000 0000 0000 0000 0000 0100 0100 0010 -> 32'h00000442
        // S-type: 0000 0000 0000 0000 0000 0100 0100 0111 -> 32'h00000447
        // B-type: 0000 0000 0000 0000 0000 1100 0100 0110 -> 32'h00000C46
        // J-type: 0000 0000 0000 0000 1000 0100 0100 0010 -> 32'h00088442
        #10
        $display("R-type: %h", immExt);
        src = 2'b00;
        #10
        $display("I-type: %h", immExt);
        src = 2'b01;
        #10
        $display("S-type: %h", immExt);
        src = 2'b10;
        #10
        $display("B-type: %h", immExt);
        src = 2'b11;
        #10
        $display("J-type: %h", immExt);
        
        $finish;

    end

endmodule