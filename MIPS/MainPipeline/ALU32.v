/*

This file contains, along with other supporting modules, the ALU_32b module, which is a 32-bit ALU used for the MIPS datapath.

The supporting modules are:
1. mux2to1
2. mux4to1
3. fullAdder
4. ALU_1b_Ordinary
5. ALU_1b_Most_Significant

The 2-to-1 MUX, the 4-to-1 MUX, and the Full Adder are used to build the 1-bit ALUs.

31 ordinary 1-bit ALUs, along with the 1-bit most significant ALU, is used for building the 32-bit ALU in a ripple-carry fashion.

The members of the team who have built this file:
--------------------------------
Name					Roll no.
--------------------------------
Bhaskar Kataria 		181CO213
Ketan Kiran Bhujange 	181CO227
Manas Trivedi 			181CO231
Omanshu Mahawar 		181CO237
--------------------------------

This file was written over a period of 11 days from 21-05-2020 to 31-05-2020.

*/

module mux2to1(outputLine, inputLines, selectLine);
	
	input [1:0] inputLines;
	input selectLine;
	output outputLine;

	wire w1, w2, w3;

	not G1(w1, selectLine);
	and G2(w2, inputLines[0], w1);
	and G3(w3, inputLines[1], selectLine);
	or G4(outputLine, w2, w3);

endmodule



module fullAdder(sum, cout, a, b, cin);

	input a, b, cin;
	output sum, cout;

	wire w1, w2, w3;

	xor H1(w1, a, b), G2(sum, w1, cin), G3(cout, w3, w2);
	and H2(w2, a, b), G5(w3, w1, cin);

endmodule



module mux4to1(outputLine, inputLines, selectLines);

	input [3:0] inputLines;
	input [1:0] selectLines;
	output outputLine;

	wire [1:0] w;

	mux2to1 M0(w[0], inputLines[1:0], selectLines[0]);
	mux2to1 M1(w[1], inputLines[3:2], selectLines[0]);
	mux2to1 M2(outputLine, w, selectLines[1]);

endmodule



module ALU_1b_Ordinary(a, b, Less, Ainvert, Binvert, CarryIn, Operation, Result, CarryOut);

	input a, b, Less, Ainvert, Binvert, CarryIn;
	input [1:0] Operation;
	output Result, CarryOut;

	wire w1, w2;
	wire [1:0] mux0inputs;
	wire [1:0] mux1inputs;
	wire [3:0] mux2inputs;

	assign mux0inputs[0] = a;
	assign mux0inputs[1] = ~a;

	assign mux1inputs[0] = b;
	assign mux1inputs[1] = ~b;

	assign mux2inputs[3] = Less;		// The fourth input for big mux is Less.

	mux2to1 P0(w1, mux0inputs, Ainvert);
	mux2to1 P1(w2, mux1inputs, Binvert);

	and P2(mux2inputs[0], w1, w2);
	or P3(mux2inputs[1], w1, w2);
	fullAdder P4(mux2inputs[2], CarryOut, w1, w2, CarryIn);

	mux4to1 P5(Result, mux2inputs, Operation);

endmodule


module ALU_1b_Most_Significant(a, b, Less, Ainvert, Binvert, CarryIn, Operation, Result, Set, Overflow, CarryOut);

	input a, b, Less, Ainvert, Binvert, CarryIn;
	input [1:0] Operation;
	output Result, Set, Overflow, CarryOut;

	wire w1, w2;
	wire [1:0] mux0inputs;
	wire [1:0] mux1inputs;
	wire [3:0] mux2inputs;

	assign mux0inputs[0] = a;
	assign mux0inputs[1] = ~a;

	assign mux1inputs[0] = b;
	assign mux1inputs[1] = ~b;

	assign mux2inputs[3] = Less;		// The fourth input for big mux is Less.

	mux2to1 J0(w1, mux0inputs, Ainvert);
	mux2to1 J1(w2, mux1inputs, Binvert);

	and J2(mux2inputs[0], w1, w2);
	or J3(mux2inputs[1], w1, w2);
	fullAdder fa0(mux2inputs[2], CarryOut, w1, w2, CarryIn);
	xor J4(Overflow, CarryIn, CarryOut);
	xor J4(Set, Overflow, mux2inputs[2]);

	mux4to1 J5(Result, mux2inputs, Operation);

endmodule



module ALU_32b(a, b, ALUOperatn, Result, Overflow, Zero);

	input [31:0] a, b;
	input [3:0] ALUOperatn;
	output [31:0] Result;
	output Zero, Overflow;

	wire [31:0] CarryOut;
	wire Set;

	ALU_1b_Ordinary A0(a[0], b[0], Set, ALUOperatn[3], ALUOperatn[2], ALUOperatn[2], ALUOperatn[1:0], Result[0], CarryOut[0]);
	ALU_1b_Ordinary A1(a[1], b[1], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[0], ALUOperatn[1:0], Result[1], CarryOut[1]);
	ALU_1b_Ordinary A2(a[2], b[2], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[1], ALUOperatn[1:0], Result[2], CarryOut[2]);
	ALU_1b_Ordinary A3(a[3], b[3], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[2], ALUOperatn[1:0], Result[3], CarryOut[3]);
	ALU_1b_Ordinary A4(a[4], b[4], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[3], ALUOperatn[1:0], Result[4], CarryOut[4]);
	ALU_1b_Ordinary A5(a[5], b[5], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[4], ALUOperatn[1:0], Result[5], CarryOut[5]);
	ALU_1b_Ordinary A6(a[6], b[6], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[5], ALUOperatn[1:0], Result[6], CarryOut[6]);
	ALU_1b_Ordinary A7(a[7], b[7], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[6], ALUOperatn[1:0], Result[7], CarryOut[7]);
	ALU_1b_Ordinary A8(a[8], b[8], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[7], ALUOperatn[1:0], Result[8], CarryOut[8]);
	ALU_1b_Ordinary A9(a[9], b[9], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[8], ALUOperatn[1:0], Result[9], CarryOut[9]);
	ALU_1b_Ordinary A10(a[10], b[10], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[9], ALUOperatn[1:0], Result[10], CarryOut[10]);
	ALU_1b_Ordinary A11(a[11], b[11], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[10], ALUOperatn[1:0], Result[11], CarryOut[11]);
	ALU_1b_Ordinary A12(a[12], b[12], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[11], ALUOperatn[1:0], Result[12], CarryOut[12]);
	ALU_1b_Ordinary A13(a[13], b[13], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[12], ALUOperatn[1:0], Result[13], CarryOut[13]);
	ALU_1b_Ordinary A14(a[14], b[14], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[13], ALUOperatn[1:0], Result[14], CarryOut[14]);
	ALU_1b_Ordinary A15(a[15], b[15], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[14], ALUOperatn[1:0], Result[15], CarryOut[15]);
	ALU_1b_Ordinary A16(a[16], b[16], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[15], ALUOperatn[1:0], Result[16], CarryOut[16]);
	ALU_1b_Ordinary A17(a[17], b[17], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[16], ALUOperatn[1:0], Result[17], CarryOut[17]);
	ALU_1b_Ordinary A18(a[18], b[18], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[17], ALUOperatn[1:0], Result[18], CarryOut[18]);
	ALU_1b_Ordinary A19(a[19], b[19], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[18], ALUOperatn[1:0], Result[19], CarryOut[19]);
	ALU_1b_Ordinary A20(a[20], b[20], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[19], ALUOperatn[1:0], Result[20], CarryOut[20]);
	ALU_1b_Ordinary A21(a[21], b[21], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[20], ALUOperatn[1:0], Result[21], CarryOut[21]);
	ALU_1b_Ordinary A22(a[22], b[22], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[21], ALUOperatn[1:0], Result[22], CarryOut[22]);
	ALU_1b_Ordinary A23(a[23], b[23], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[22], ALUOperatn[1:0], Result[23], CarryOut[23]);
	ALU_1b_Ordinary A24(a[24], b[24], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[23], ALUOperatn[1:0], Result[24], CarryOut[24]);
	ALU_1b_Ordinary A25(a[25], b[25], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[24], ALUOperatn[1:0], Result[25], CarryOut[25]);
	ALU_1b_Ordinary A26(a[26], b[26], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[25], ALUOperatn[1:0], Result[26], CarryOut[26]);
	ALU_1b_Ordinary A27(a[27], b[27], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[26], ALUOperatn[1:0], Result[27], CarryOut[27]);
	ALU_1b_Ordinary A28(a[28], b[28], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[27], ALUOperatn[1:0], Result[28], CarryOut[28]);
	ALU_1b_Ordinary A29(a[29], b[29], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[28], ALUOperatn[1:0], Result[29], CarryOut[29]);
	ALU_1b_Ordinary A30(a[30], b[30], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[29], ALUOperatn[1:0], Result[30], CarryOut[30]);
	ALU_1b_Most_Significant A31(a[31], b[31], 1'b0, ALUOperatn[3], ALUOperatn[2], CarryOut[30], ALUOperatn[1:0], Result[31], Set, Overflow, CarryOut[31]);

	nor K1(Zero, Result[0], Result[1], Result[2], Result[3], Result[4], Result[5], Result[6], Result[7], Result[8], Result[9], Result[10], Result[11], Result[12], Result[13], Result[14], Result[15], Result[16], Result[17], Result[18], Result[19], Result[20], Result[21], Result[22], Result[23], Result[24], Result[25], Result[26], Result[27], Result[28], Result[29], Result[30], Result[31]);

endmodule