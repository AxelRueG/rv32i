`include "./memory/DM.v"
`include "./memory/IM.v"

module Memory (
    input wire clk,
    input wire en,
    input wire [15:0] addr,
    input wire [31:0] inputData,
    input wire [15:0] pcAddr,

    output wire [31:0] instr,
    output wire [31:0] outputData
);

    DM data_memory (
        .clk(clk), 
        .we(en),
        .addres(addr),
        .wd(inputData),
        .rd(outputData)
    );

    IM instruction_memory (
        .pc(pcAddr),
        .instr(instr)
    );
    
endmodule