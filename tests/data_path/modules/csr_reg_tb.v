`timescale 1ps/1ps
`include "./data_path/CSR_regs.v"


module moduleName;

    reg except;
    reg interrupt;
    reg [31:0] except_info;
    wire [31:0] csr_info;

    reg clk;
    reg csr_w;
    reg [11:0] csr_addr;
    reg [31:0] data_in;
    wire [31:0] data_out;


    CSR_regs uut (
        .except(except),
        .interrupt(interrupt),
        .except_info(except_info),
        .csr_info(csr_info),

        .clk(clk),
        .csr_w(csr_w),
        .csr_addr(csr_addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // inicializamos el reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
    
        $dumpfile("./waves/csr_tb.vcd");
        $dumpvars(0, uut);

        /** ----------------------------------------------------------------------------------------
        FLUJO NORMAL DE CSR
        ----------------------------------------------------------------------------------------- */
        except = 0;
        interrupt = 0;
        except_info = 0;

        csr_w = 1; csr_addr = 12'h001; data_in = 101;
        #10
        csr_w = 0; data_in = 10;
        #10
        data_in = 32'h000000ac;
        csr_w = 1; csr_addr = 12'h000; data_in = 102;
        #10
        csr_w = 0; data_in = 10;
        #10
        csr_w = 1; csr_addr = 12'h041; data_in = 103;
        #10
        csr_w = 0; data_in = 10;
        #10
        csr_w = 1; csr_addr = 12'h042; data_in = 104;
        #10
        csr_w = 0; data_in = 10;
        #10
        csr_w = 1; csr_addr = 12'h005; data_in = 105;
        #10
        csr_w = 0; data_in = 10;
        #10
        csr_w = 1; csr_addr = 12'h044; data_in = 106;
        #10
        csr_w = 0; data_in = 10;
        #10

        /** ----------------------------------------------------------------------------------------
        FLUJO NORMAL DE CSR
        ----------------------------------------------------------------------------------------- */
        except = 1;
        interrupt = 0;

        // --- EXCEPCION: INSTRUCCION DESCONOCIDA ---
        //  cause:  00000010 
        //  status: 00010000 
        //  pc:     0000000000010100;
        except_info = 32'b00000010000100000000000000010100;
        // csr_w = 1; csr_addr = 12'h001; data_in = 101;
        // #10
        // csr_w = 0; data_in = 10;
        // #10

    
        data_in = 32'h000000ac;
        csr_w = 1; csr_addr = 12'h000; data_in = 102;
        #10

        // --- EXCEPCION: ADDR INVALIDA ---
        //  cause:  00000100 
        //  status: 00010000 
        //  pc:     0000000000010100;
        except_info = 32'b00000100000100000000000000010100;
        csr_w = 0; data_in = 10;
        #10

        // --- URET ---
        except = 0;

        //  cause:  00000000 
        //  status: 00000010 
        //  pc:     0000000000000000;
        except_info = 32'b00000000000000100000000000000000;
        csr_w = 0; data_in = 10; csr_addr = 12'h002;
        #10

        $finish;
    end

endmodule