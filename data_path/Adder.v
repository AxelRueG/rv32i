module Adder (
    input [31:0] op1,
    input [31:0] op2,
    output [31:0] sal
);

    assign sal = op1 + op2;
    
endmodule