`include "./data_path/DataPath.v"
`timescale 1ps/1ps

module dp_csr_tb;
    
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
    reg csr_w;
    reg csr_inm;
    reg [1:0] mocsr;

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
        .readData(readData),
        .resultSrc(resultSrc),
        .inmSrc(inmSrc),
        .instr(instr),
        .regWrite(regWrite),
        .aluSrc(aluSrc),
        .aluControl(aluControl),
        .csr_w(csr_w),
        .csr_inm(csr_inm),
        .mocsr(mocsr),

        .aluRes(aluRes),
        .zero(zero),
        .op(op),
        .f3(f3),
        .f7(f7),
        .writeData(writeData),
        .pc(pc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        $dumpfile("./waves/dp_csr_tb.vcd");
        $dumpvars(0, dp_csr_tb);

        /*
        QUE DEBEMOS probar? en cada caso debemos ver cual es el pc
        1. hacer un guardado en memoria
        2. hacer un segundo guardado en memoria
        3. tirar un error tirar una excepcion (csr_w=1)
        4. debemos ver cual es el pc en el que actua a continuacion; hacemos un segundo guardado
        5. retornamos a la siguiente direccion (csr_w=0; op_m=1) consumimos un dato inmediato
        6. hacemos un ultimo guardado        
        */
        csr_w = 0;
        mocsr = 2'b00;
        csr_inm = 1'bx;

        // -- 1: instruction type-I save an inmediate in a op_m --
        jump = 2'b01; // normal way
        branch = 0; // don't jump
        regWrite = 1; // enable write in op_m  
        inmSrc = 2'b00; // signed extension of type-I
        aluControl = 3'b000; // add
        aluSrc = 1; // use the inmediate as srcB
        resultSrc = 2'b00; // save the ALU result
        instr = 32'h05600513; // ADDi x10, x0, 86
        #10

        // -- 2: thow and exception, this exception save in x1 -> 1
        csr_w = 1;            // enable writing in CSR
        csr_inm = 0;
        regWrite = 1;         // disable writing in REGISTERS  
        inmSrc = 2'bxx;       // in theory I dont need extend nothing
        aluControl = 3'b111;  // no ALU op
        aluSrc = 0;           // use the inmediate as srcB
        resultSrc = 2'b01;    // save the inm
        instr = 32'h00551073; // 32'h0000d2f3
        mocsr = 1;
        #10

        // -- 3: check values
        csr_w = 0;            // enable writing in CSR
        csr_inm = 0;
        regWrite = 0; // enable write in op_m  
        inmSrc = 2'b00; // signed extension of type-I
        aluControl = 3'b000; // add
        aluSrc = 1; // use the inmediate as srcB
        resultSrc = 2'b00; // save the ALU result
        instr = 32'h00000100; // ADDi x2, x0, 0
        mocsr = 0;
        #10

        // -- 4:  check csrrwi
        csr_inm = 1; // uso el inmediato
        csr_w = 1; // activo la escritura en csr
        regWrite = 1; // la salida del csr se guarda en un registro
        aluControl = 3'bx;
        aluSrc = 0;
        resultSrc = 2'b01;
        mocsr = 1;
        instr = 32'b00000000010100111000010111110011; // csrrwi x11,9,7
        #10

        // -- 3: check values
        csr_w = 0;            // enable writing in CSR
        csr_inm = 0;
        regWrite = 0; // enable write in op_m  
        inmSrc = 2'b00; // signed extension of type-I
        aluControl = 3'b000; // add
        aluSrc = 1; // use the inmediate as srcB
        resultSrc = 2'b00; // save the ALU result
        instr = 32'b00000000000001011000000110000000; // ADDi x3, x12, 0
        mocsr = 0;
        #10

        $display("finished...");
        $finish;
        
    end

endmodule