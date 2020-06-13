`include "Pipeline.v"

module datapath_tb;
    
    reg [31:0] Instruction;

    reg clk, reset;

    pipeline P1(clk, reset);

    initial
        begin
            clk = 1'b0;
            repeat(8) // was 8 initially
            #5 clk = ~clk; // was 2 initially
        end

    initial
        begin
            $dumpfile("datapath.vcd");
            $dumpvars(0, datapath_tb);

            reset = 1'b1;
            // Delay here for global reset to finish
            #1;
            reset = 1'b0;

            // Instruction = 32'b00000000111010010001000000100000;
            // $display("\nAdd R2, R7, R9\n");

            // #4 Instruction = 32'b10001100111001010000000000000110;
            // $display("\nLW R5, 6(R7)\n");

            // #4 Instruction = 32'b10101100101000100000000000000100;
            // $display("\nSW R2, 4(R5)\n");

            // #4 Instruction = 32'b00010000010010100001100000100010;
            // $display("\nBEQ\n");
        end

endmodule 