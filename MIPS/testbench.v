`include "Pipeline.v"

module datapath_tb;
    
    reg [31:0] Instruction;

    reg clk;

    pipeline P1(Instruction, clk);

    initial
        begin
            clk = 1'b0;
            repeat(8)
            #2 clk = ~clk;
        end

    initial
        begin
            $dumpfile("datapath.vcd");
            $dumpvars(0, datapath_tb);

            Instruction = 32'b00000000111010010001000000100000;
            $display("\nAdd R2, R7, R9\n");

            #4 Instruction = 32'b10001100111001010000000000000110;
            $display("\nLW R5, 6(R7)\n");

            #4 Instruction = 32'b10101100101000100000000000000100;
            $display("\nSW R2, 4(R5)\n");

            #4 Instruction = 32'b00010000010010100001100000100010;
            $display("\nBEQ\n");
        end

endmodule 