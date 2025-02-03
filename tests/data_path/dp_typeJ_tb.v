`include "./data_path/DataPath.v"
`timescale 1ps/1ps

module dp_typeJ_tb;
    
    // inputs
    reg branch;
    reg [1:0] jump;
    reg clk;
    reg [31:0] readData;
    reg [1:0] resultSrc;
    reg [1:0] inmSrc;
    reg [31:0] instr;
    reg regWrite;
    reg aluSrc;
    reg [2:0] aluControl;

    // outputs
    wire [31:0] aluRes;
    wire zero;
    wire [6:0] op;
    wire [2:0] f3;
    wire f7;
    wire [31:0] writeData;
    wire [15:0] pc;

    DataPath uut (
        .branch(branch),
        .jump(jump),
        .clk(clk),
        .read_data(readData),
        .dato_s(resultSrc),
        .instr(instr),
        .reg_w(regWrite),
        .alu_s(aluSrc),
        .alu_op(aluControl),
        .alu_res(aluRes),
        .flag(zero),
        .op_code(op),
        .f3(f3),
        .f7(f7),
        .write_data(writeData),
        .pc(pc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        $dumpfile("./waves/dp_typeJ_tb.vcd");
        $dumpvars(0, dp_typeJ_tb);

        // --- COMPROBAMOS QUE EJECUTE EL SALTO ------------------------------------
        jump = 2'b10; // operacion tipo jal
        branch = 0; // no ejecuta saltos
        regWrite = 1; // debe guardar el pcNext en un registro  
        inmSrc = 2'b11; // type-J
        aluControl = 3'b111; // operacion por default
        aluSrc = 0; // (en este caso no nos importa la ALU)
        resultSrc = 2'b11; // debemos tomar el valor de pcNext para guardar en registro

        // 0 0000011010 1 00000000 00100 0000000 -> divicion de datos 
        // rd = 00100 -> x4
        // inm = 0 00000000 1 0000011010 0 -> 2100
        instr = 32'b00000011010100000000001001101111; // BEQ rd21,rd21,36
        #10

        // --- comprovamos el valor guardado en el reg------------------------------
        regWrite = 0; // vamos a guardar un dato en registros 
        inmSrc = 2'bxx; // type R
        aluControl = 3'b000; // sumaremos zero al valor del registro 
        aluSrc = 0; // optamos por la salida del SE
        resultSrc = 2'b00; // guardamos el resultado de la ALU
        instr = 32'b00000000000000100000001011101111; // ADDI rd2,rd0,21
        #10

        $display("finished...");
        $finish;
        
    end

endmodule