`include "./control_unit/mainDeco.v"
`timescale 1ps/1ps

module main_deco_tb;
    
reg [6:0] op;
wire branch;
wire jump;
wire [1:0] resSrc;
wire memWrite;
wire aluSrc;
wire [1:0] immSrc;
wire regWrite;
wire [1:0] aluOp;

mainDeco uut (
    .op(op),
    .branch(branch),
    .jump(jump),
    .resSrc(resSrc),
    .memWrite(memWrite),
    .aluSrc(aluSrc),
    .immSrc(immSrc),
    .regWrite(regWrite),
    .aluOp(aluOp)
);

initial begin
    
    $display("| branch | jump | resSrc | memWrite | aluSrc | immSrc | regWrite | aluOp |");
    op = 3;
    #10 
    $display("lw | %b | %b | %b | %b | %b | %b | %b | %b |", branch, jump, resSrc, memWrite, aluSrc, immSrc, regWrite, aluOp);
    
    op = 35;
    #10 
    $display("sw | %b | %b | %b | %b | %b | %b | %b | %b |", branch, jump, resSrc, memWrite, aluSrc, immSrc, regWrite, aluOp);
    
    op = 51;
    #10 
    $display("R  | %b | %b | %b | %b | %b | %b | %b | %b |", branch, jump, resSrc, memWrite, aluSrc, immSrc, regWrite, aluOp);
    
    op = 99;
    #10 
    $display("B  | %b | %b | %b | %b | %b | %b | %b | %b |", branch, jump, resSrc, memWrite, aluSrc, immSrc, regWrite, aluOp);
    
    op = 19;
    #10 
    $display("I  | %b | %b | %b | %b | %b | %b | %b | %b |", branch, jump, resSrc, memWrite, aluSrc, immSrc, regWrite, aluOp);
    
    op = 111;
    #10 
    $display("J  | %b | %b | %b | %b | %b | %b | %b | %b |", branch, jump, resSrc, memWrite, aluSrc, immSrc, regWrite, aluOp);
    op = 103;
    #10 
    $display("Ex | %b | %b | %b | %b | %b | %b | %b | %b |", branch, jump, resSrc, memWrite, aluSrc, immSrc, regWrite, aluOp);


end

endmodule