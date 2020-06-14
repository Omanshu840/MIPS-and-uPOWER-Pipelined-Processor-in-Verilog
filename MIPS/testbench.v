`include "Pipeline.v"

module datapath_tb;

    reg clk, reset;

    pipeline P1(clk, reset);

    initial
        begin
            clk = 1'b0;
            repeat(22) // was 8 initially
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

            // Instruction = 32'b000000 00111 01001 00010 00000100000;
            // $display("\nAdd R2, R7, R9\n");

            // #4 Instruction = 32'b100011 00111 00101 0000000000000110;
            // $display("\nLW R5, 6(R7)\n");

            // #4 Instruction = 32'b101011 00101 00010 0000000000000100;
            // $display("\nSW R2, 4(R5)\n");

            // #4 Instruction = 32'b000100 00010 00010 0000000000000010;
            // $display("\nBEQ R2, R2, 2\n");

            //For demo2,
            // add R4, R0, R0 // This makes contents of R4 zero

            // lw R3, 0(R2) // Here R3 has value 2.
            // add R4, R4, R3 // R4 becomes 2.

            // lw R3 , 1(R2) // Here R3 has value 3.
            // add R4, R4, R3 // R4 becomes 2 + 3 = 5

            // lw R3 , 2(R2) // Here R3 has value 4.
            // add R4, R4, R3 // R4 becomes 5 + 4 = 9.

            // lw R3 , 3(R2) // Here R3 has value 5.
            // add R4, R4, R3 // R4 becomes 9 + 5 = 14

            // lw R3 , 4(R2) // Here R3 has value 6.
            // add R4, R4, R3 // R4 becomes 14 + 6 = 20


            // 000000 00000 00000 00100 00000100000

            // 100011 00010 00011 0000000000000000
            // 000000 00100 00011 00100 00000100000

            // 100011 00010 00011 0000000000000001
            // 000000 00100 00011 00100 00000100000

            // 100011 00010 00011 0000000000000010
            // 000000 00100 00011 00100 00000100000

            // 100011 00010 00011 0000000000000011
            // 000000 00100 00011 00100 00000100000

            // 100011 00010 00011 0000000000000100
            // 000000 00100 00011 00100 00000100000

        end

endmodule 