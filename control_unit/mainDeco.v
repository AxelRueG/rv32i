/**
## RESUME

| branch | jump | resSrc | memWrite | aluSrc | inmSrc | regWrite |aluOp  | mocsr |
|--------|------|--------|----------|--------|--------|----------|-------|-------|
| 0      | 0    | 2'b01  | 0        | 1      | 2'b00  | 1        | 2'b00 | 2'b00 |  LW     (3)
| 0      | 0    |        | 1        | 1      | 2'b01  | 0        | 2'b00 | 2'b00 |  SW     (35)
| 0      | 0    | 2'b00  | 0        | 0      |        | 1        | 2'b10 | 2'b00 |  R-type (51)
| 1      | 0    |        | 0        | 0      | 2'b10  | 0        | 2'b01 | 2'b00 |  B-type (99)
| 0      | 0    | 2'b00  | 0        | 1      | 2'b00  | 1        | 2'b10 | 2'b00 |  I-Type (19)
| 0      | 1    | 2'b10  | 0        |        | 2'b11  | 1        |       | 2'b00 |  jal    (111)
| 0      | 1    | 2'b10  | 0        |        | 2'b11  | 1        |       | 2'b01 |  csr    (115)


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
    output [1:0] inmSrc,
    output wire regWrite,
    output [1:0] aluOp,
    output [1:0] mocsr
);

    reg s_branch;
    reg [2:0] s_jump;
    reg [1:0] s_resSrc;
    reg s_memWrite;
    reg s_aluSrc;
    reg [1:0] s_inmSrc;
    reg s_regWrite;
    reg [1:0] s_aluOp;
    reg [1:0] s_mocsr;

    always @(*)
    begin
        case (op)
            // -- lw -------------------------------------------------------------------------------   
            3:
            begin
                s_branch = 0;
                s_jump = 2'b01;
                s_resSrc = 2'b01;
                s_memWrite = 0;
                s_aluSrc = 1;
                s_inmSrc = 2'b00;
                s_regWrite = 1;
                s_aluOp = 2'b00;
                s_mocsr = 2'b00;
            end
            // -- sw -------------------------------------------------------------------------------       
            35:
            begin
                s_branch = 0;
                s_jump = 2'b01;
                s_resSrc = 2'bx;
                s_memWrite = 1;
                s_aluSrc = 1;
                s_inmSrc = 2'b01;
                s_regWrite = 0;
                s_aluOp = 2'b00;
                s_mocsr = 2'b00;
            end
            // -- R-Type ---------------------------------------------------------------------------
            51:
            begin
                s_branch = 0;
                s_jump = 2'b01;
                s_resSrc = 2'b00;
                s_memWrite = 0;
                s_aluSrc = 0;
                s_inmSrc = 2'bx;
                s_regWrite = 1;
                s_aluOp = 2'b10;
                s_mocsr = 2'b00;
            end
            // -- B-Type ---------------------------------------------------------------------------
            99:
            begin
                s_branch = 1;
                s_jump = 2'b01;
                s_resSrc = 2'bx;
                s_memWrite = 0;
                s_aluSrc = 0;
                s_inmSrc = 2'b10;
                s_regWrite = 0;
                s_aluOp = 2'b01;
                s_mocsr = 2'b00;
            end
            // -- I-Type ---------------------------------------------------------------------------
            19:
            begin
                s_branch = 0;
                s_jump = 2'b01;
                s_resSrc = 2'b00;
                s_memWrite = 0;
                s_aluSrc = 1;
                s_inmSrc = 2'b00;
                s_regWrite = 1;
                s_aluOp = 2'b10;
                s_mocsr = 2'b00;
            end
            // -- jal ------------------------------------------------------------------------------     
            111:
            begin
                s_branch = 0;
                s_jump = 2'b10;
                s_resSrc = 2'b10;
                s_memWrite = 0;
                s_aluSrc = 1'bx;
                s_inmSrc = 2'b11;
                s_regWrite = 1;
                s_aluOp = 2'bx;
                s_mocsr = 2'b00;
            end
            end
            // -- CSR ------------------------------------------------------------------------------     
            111:
            begin
                s_branch = 0;
                s_jump = 2'b10;
                s_resSrc = 2'b01;
                s_memWrite = 0;
                s_aluSrc = 1'bx;
                s_inmSrc = 2'b11;
                s_regWrite = 1;
                s_aluOp = 2'bx;
                s_mocsr = 2'b00; // por ahora, la salida sera csr_rd, despues vere lo de 2'b10->pc
            end
            default:
            begin
                s_branch = 1'bx;
                s_jump = 2'b11;
                s_resSrc = 2'bx;
                s_memWrite = 1'bx;
                s_aluSrc = 1'bx;
                s_inmSrc = 2'bx;
                s_regWrite = 1'bx;
                s_aluOp = 2'bx;
                s_mocsr = 2'b00;
            end
        endcase
    end

    assign branch = s_branch;
    assign jump = s_jump;
    assign resSrc = s_resSrc;
    assign memWrite = s_memWrite;
    assign aluSrc = s_aluSrc;
    assign inmSrc = s_inmSrc;
    assign regWrite = s_regWrite;
    assign aluOp = s_aluOp;
    assign mocsr = s_mocsr;

endmodule