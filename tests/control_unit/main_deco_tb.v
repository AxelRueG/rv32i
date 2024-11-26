`include "./control_unit/mainDeco.v"
`timescale 1ps/1ps

module main_deco_tb;
    
reg [6:0] op_code;
wire branch;
wire [1:0] jump;
wire [1:0] dato_s;
wire mem_w;
wire alu_s;
wire reg_w;
wire [1:0] sel;
wire [1:0] mocsr;

mainDeco uut (
    .op_code(op_code),
    .branch(branch),
    .jump(jump),
    .dato_s(dato_s),
    .mem_w(mem_w),
    .alu_s(alu_s),
    .reg_w(reg_w),
    .sel(sel),
    .mocsr(mocsr)
);

initial begin
    
    $display("   | branch | jump | dato_s | mem_w | alu_s | reg_w | sel | mocsr |");
    $display("   |--------|------|--------|-------|-------|-------|-----|-------|");
    op_code = 3;
    #10 
    $display("lw | %b      | %b   | %b     | %b     | %b     | %b     | %b  | %b    |", branch, jump, dato_s, mem_w, alu_s, reg_w, sel, mocsr);
    
    op_code = 35;
    #10 
    $display("sw | %b      | %b   | %b     | %b     | %b     | %b     | %b  | %b    |", branch, jump, dato_s, mem_w, alu_s, reg_w, sel, mocsr);
    
    op_code = 51;
    #10 
    $display("R  | %b      | %b   | %b     | %b     | %b     | %b     | %b  | %b    |", branch, jump, dato_s, mem_w, alu_s, reg_w, sel, mocsr);
    
    op_code = 99;
    #10 
    $display("B  | %b      | %b   | %b     | %b     | %b     | %b     | %b  | %b    |", branch, jump, dato_s, mem_w, alu_s, reg_w, sel, mocsr);
    
    op_code = 19;
    #10 
    $display("I  | %b      | %b   | %b     | %b     | %b     | %b     | %b  | %b    |", branch, jump, dato_s, mem_w, alu_s, reg_w, sel, mocsr);
    
    op_code = 111;
    #10 
    $display("J  | %b      | %b   | %b     | %b     | %b     | %b     | %b  | %b    |", branch, jump, dato_s, mem_w, alu_s, reg_w, sel, mocsr);
    op_code = 7'b1110011;
    #10 
    $display("csr| %b      | %b   | %b     | %b     | %b     | %b     | %b  | %b    |", branch, jump, dato_s, mem_w, alu_s, reg_w, sel, mocsr);
    op_code = 103;
    #10 
    $display("Ex | %b      | %b   | %b     | %b     | %b     | %b     | %b  | %b    |", branch, jump, dato_s, mem_w, alu_s, reg_w, sel, mocsr);


end

endmodule