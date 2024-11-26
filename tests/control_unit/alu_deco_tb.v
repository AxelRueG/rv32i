`include "./control_unit/aluDeco.v"
`timescale 1ps/1ps

module alu_deco_tb;
    
reg [1:0] sel;
reg [2:0] f3;
reg op;
reg f7;
wire [2:0] alu_op;

aluDeco uut (
    .sel(sel),
    .f3(f3),
    .op(op),
    .f7(f7),
    .alu_op(alu_op)
);

initial begin
    
    $display("| SEL | F3  | OP, F7     | Instruction | ALU_OP    |");
    $display("|-----|-----|------------|-------------|-----------|");
    
    // lw | sw
    sel = 2'b00;
    f3 = 3'bx;
    op = 1'bx;
    f7 = 1'bx;
    #10
    $display("| %b  | %b | %b, %b       | lw,sw       | %b (add) |", sel, f3, op, f7, alu_op);

    // beq
    sel = 2'b01;
    f3 = 3'bx;
    op = 1'bx;
    f7 = 1'bx;
    #10
    $display("| %b  | %b | %b, %b       | beq         | %b (sub) |", sel, f3, op, f7, alu_op);

    // add
    sel = 2'b10;
    f3 = 3'b000;
    op = 1'bx;
    f7 = 1'bx;
    #10
    $display("| %b  | %b | %b, %b       | add         | %b (add) |", sel, f3, op, f7, alu_op);

    // sub
    sel = 2'b10;
    f3 = 3'b000;
    op = 1;
    f7 = 1;
    #10
    $display("| %b  | %b | %b, %b       | sub         | %b (sub) |", sel, f3, op, f7, alu_op);
    
    // slt
    sel = 2'b10;
    f3 = 3'b010;
    op = 1'bx;
    f7 = 1'bx;
    #10
    $display("| %b  | %b | %b, %b       | slt         | %b (slt) |", sel, f3, op, f7, alu_op);

    // or
    sel = 2'b10;
    f3 = 3'b110;
    op = 1'bx;
    f7 = 1'bx;
    #10
    $display("| %b  | %b | %b, %b       | or          | %b (or)  |", sel, f3, op, f7, alu_op);

    // and
    sel = 2'b10;
    f3 = 3'b111;
    op = 1'bx;
    f7 = 1'bx;
    #10

    $display("| %b  | %b | %b, %b       | and         | %b (and) |", sel, f3, op, f7, alu_op);
    $finish;

end


endmodule