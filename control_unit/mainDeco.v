/**
## RESUME

| branch | jump | resSrc | memWrite | aluSrc | immSrc | regWrite |aluOp  |
|--------|------|--------|----------|--------|--------|----------|-------|
| 0      | 0    | 2'b01  | 0        | 1      | 2'b00  | 1        | 2'b00 |  LW
| 0      | 0    |        | 1        | 1      | 2'b01  | 0        | 2'b00 |  SW
| 0      | 0    | 2'b00  | 0        | 0      |        | 1        | 2'b10 |  R-type
| 1      | 0    |        | 0        | 0      | 2'b10  | 0        | 2'b01 |  B-type
| 0      | 0    | 2'b00  | 0        | 1      | 2'b00  | 1        | 2'b10 |  I-Type
| 0      | 1    | 2'b10  | 0        |        | 2'b11  | 1        |       |  jal


- a la tabla de la guia a resSrc se le agrego un bit estra
- mbien se agrego una senial jump
**/

module mainDeco(
    input [6:0] op,
    output wire branch,
    output wire [1:0] jump,
    output [1:0] resSrc,
    output wire memWrite,
    output wire aluSrc,
    output [1:0] immSrc,
    output wire regWrite,
    output [1:0] aluOp
);

    reg branchAux;
    reg [2:0] jumpAux;
    reg [1:0] resSrcAux;
    reg memWriteAux;
    reg aluSrcAux;
    reg [1:0] immSrcAux;
    reg regWriteAux;
    reg [1:0] aluOpAux;

    always @(*)
    begin
        case (op)
            // -- lw -------------------------------------------------------------------------------   
            3:
            begin
                branchAux = 0;
                jumpAux = 2'b00;
                resSrcAux = 2'b01;
                memWriteAux = 0;
                aluSrcAux = 1;
                immSrcAux = 2'b00;
                regWriteAux = 1;
                aluOpAux = 2'b00;
            end
            // -- sw -------------------------------------------------------------------------------       
            35:
            begin
                branchAux = 0;
                jumpAux = 2'b01;
                resSrcAux = 2'bx;
                memWriteAux = 1;
                aluSrcAux = 1;
                immSrcAux = 2'b01;
                regWriteAux = 0;
                aluOpAux = 2'b00;
            end
            // -- R-Type ---------------------------------------------------------------------------
            51:
            begin
                branchAux = 0;
                jumpAux = 2'b01;
                resSrcAux = 2'b00;
                memWriteAux = 0;
                aluSrcAux = 0;
                immSrcAux = 2'bx;
                regWriteAux = 1;
                aluOpAux = 2'b10;
            end
            // -- B-Type ---------------------------------------------------------------------------
            99:
            begin
                branchAux = 1;
                jumpAux = 2'b01;
                resSrcAux = 2'bx;
                memWriteAux = 0;
                aluSrcAux = 0;
                immSrcAux = 2'b10;
                regWriteAux = 0;
                aluOpAux = 2'b01;
            end
            // -- I-Type ---------------------------------------------------------------------------
            19:
            begin
                branchAux = 0;
                jumpAux = 2'b01;
                resSrcAux = 2'b00;
                memWriteAux = 0;
                aluSrcAux = 1;
                immSrcAux = 2'b00;
                regWriteAux = 1;
                aluOpAux = 2'b10;
            end
            // -- jal ------------------------------------------------------------------------------     
            111:
            begin
                branchAux = 0;
                jumpAux = 2'b10;
                resSrcAux = 2'b10;
                memWriteAux = 0;
                aluSrcAux = 1'bx;
                immSrcAux = 2'b11;
                regWriteAux = 1;
                aluOpAux = 2'bx;
            end
            default:
            begin
                branchAux = 1'bx;
                jumpAux = 2'b11;
                resSrcAux = 2'bx;
                memWriteAux = 1'bx;
                aluSrcAux = 1'bx;
                immSrcAux = 2'bx;
                regWriteAux = 1'bx;
                aluOpAux = 2'bx;
            end
        endcase
    end

    assign branch = branchAux;
    assign jump = jumpAux;
    assign resSrc = resSrcAux;
    assign memWrite = memWriteAux;
    assign aluSrc = aluSrcAux;
    assign immSrc = immSrcAux;
    assign regWrite = regWriteAux;
    assign aluOp = aluOpAux;

endmodule