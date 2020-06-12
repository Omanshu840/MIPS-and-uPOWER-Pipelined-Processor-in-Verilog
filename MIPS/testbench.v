`include "Pipeline.v"

module datapath_tb;
    
    reg [31:0] Instruction;

    reg clk;

    pipeline P1(Instruction);

    initial
        begin
            clk = 1'b0;
            repeat(100)
            #2 clk = ~clk;
        end

    initial
        begin
            $dumpfile("datapath.vcd");
            $dumpvars(0, datapath_tb);

            Instruction = 32'b00000000111010010001000000100000;
            #4 $display("\nAdd R2, R7, R9\n");

            Instruction = 32'b00000000010010100001100000100010;
            #4 $display("\nSub R3, R2, R10\n");
        end

endmodule 