`include "./data_path/DataPath.v"
`timescale 1ps/1ps

module dp_tpyeB_tb;
    
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

        $dumpfile("./waves/dp_tpyeB_tb.vcd");
        $dumpvars(0, dp_tpyeB_tb);


        /*
        RESUMEN:
        en este test, vamos a probar la funcionalidad de las operaciones de tipo B (beq)
        para ello vamos a usar
        - aluOP -> comparacion
        - jump -> 01
        - branch -> 1, para producir el salto (de 9 lineas -> 36 bytes) 
        - 
        */
        jump = 2'b01; // enable pc

        // --- COMPROBAMOS QUE EJECUTE EL SALTO ------------------------------------
        branch = 1;
        regWrite = 0;
        inmSrc = 2'b10; // b-type
        aluControl = 3'b100;
        aluSrc = 0; // optamos por la salida del BR
        resultSrc = 2'b10;
        // 0 0 000001 0010 0 -> offset = 36  
        instr = 32'b00000011010110101000001001100011; // BEQ rd21,rd21,36
        //      32'h035a8200
        #10

        // --- CARGAMOS UN DATO EN LOS REGISTROS -----------------------------------
        branch = 0; // esta no es del tipo B
        regWrite = 1; // vamos a guardar un dato en registros 
        inmSrc = 2'b00; // type I 
        aluControl = 3'b000; // sumaremos 21 a res 
        aluSrc = 1; // optamos por la salida del SE
        resultSrc = 2'b00; // guardamos el resultado de la ALU
        // 0 0 000001 0010 0 -> offset = 36  
        instr = 32'b00000001010100000000000100010011; // ADDI rd2,rd0,21
        //      32'h01500100
        #10

        // --- COMPROBAMOS QUE NO EJECUTE EL SALTO ---------------------------------
        branch = 1;
        regWrite = 0;
        inmSrc = 2'b10; // b-type
        aluControl = 3'b100;
        aluSrc = 0; // optamos por la salida del BR
        resultSrc = 2'b10;
        // 0 0 000001 0010 0 -> 36  
        // 1 1 111110 1101 1 -> complemento a1 -> 36  
        // 1 1 111110 1110 0 -> complemento a2 -> -36 (offset)  
        instr = 32'b11111100001000000000111011100011; // BEQ rd0, rd2, -36 
        //      32'hfc200e80
        #10
        $display("finished...");
        $finish;
        
    end

endmodule