`include "./data_path/ALU.v"
`timescale 1ps/1ps

module alu_tb;
    
    reg [31:0] srcA;
    reg [31:0] srcB;
    reg [2:0] ALUControl;
    wire [31:0] res;
    wire flag;

    ALU uut (
        .srcA(srcA),
        .srcB(srcB),
        .ALUControl(ALUControl),
        .res(res),
        .flag(flag)
    );

    initial begin
        
        // A == B
        srcA = 1025;
        srcB = 1025;
        ALUControl = 3'b000;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b001;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b010;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b011;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b100;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b101;
        #5
        $display("op[%d] -> %h (%d) %b\n", ALUControl, res, res, flag);

        // A > B
        srcA = 1025;
        srcB = 1000;
        ALUControl = 3'b000;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b001;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b010;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b011;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b100;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b101;
        #5
        $display("op[%d] -> %h (%d) %b\n", ALUControl, res, res, flag);

        // A < B
        srcA = 513;
        srcB = 1000;
        ALUControl = 3'b000;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b001;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b010;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b011;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b100;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);
        ALUControl = 3'b101;
        #5
        $display("op[%d] -> %h (%d) %b", ALUControl, res, res, flag);

        $finish;
    end

endmodule