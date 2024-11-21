`include "./data_path/SE.v"
`timescale 1ps/1ps

module moduleName;
    
    reg [31:0] instr;
    wire [31:0] inm;

    SE uut (
        .instr(instr),
        .inm(inm)
    );

    initial begin
        
        // 32'h44208380 => 0100 0100 0010 0000 1000 0011 1000 0000

        // R-type: nada
        // I-type: 0000 0000 0000 0000 0000 0100 0100 0010 -> 32'h00000442
        // lw:     0000 0000 0000 0000 0000 0100 0100 0010 -> 32'h00000442
        // sw:     0000 0000 0000 0000 0000 0100 0100 0111 -> 32'h00000447
        // B-type: 0000 0000 0000 0000 0000 1100 0100 0110 -> 32'h00000C46
        // J-type: 0000 0000 0000 0000 1000 0100 0100 0010 -> 32'h00008442
        instr = 32'h442083b3;
        #10
        $display("R-type: %h", inm);
        instr = 32'h44208393;
        #10
        $display("I-type: %h", inm);
        instr = 32'h44208383;
        #10
        $display("lw: %h", inm);
        instr = 32'h442083a3;
        #10
        $display("sw: %h", inm);
        instr = 32'h442083e3;
        #10
        $display("B-type: %h", inm);
        instr = 32'h442083ef;
        #10
        $display("J-type: %h", inm);
        
        $finish;

    end

endmodule