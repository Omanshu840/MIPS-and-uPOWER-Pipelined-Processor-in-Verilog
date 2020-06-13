/*

This file contains the uPOWER_ALUControlUnit module, which is the ALU Control Unit associated with the ALU used for the uPOWER datapath.

ALUOp, OpCode and XO are the inputs to this module, and ALUControl is the output which is to be sent to the ALU.

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

module uPOWER_ALUControlUnit(ALUControl, ALUOp, OpCode, XO);
    
    output [3:0] ALUControl;
    input [1:0] ALUOp;
    input [5:0] OpCode;
    input [8:0] XO;
    wire [16:0] ALUControlIn;
    reg [3:0] ALUCtrl;

    assign ALUControlIn = {ALUOp,OpCode,XO};
    
    always @(ALUControlIn)
        casex (ALUControlIn)
            17'b00xxxxxxxxxxxxxxx: ALUCtrl<=4'b0010;  // ALU Operation: Add ; Instruction: LW-SW
            17'b01xxxxxxxxxxxxxxx: ALUCtrl<=4'b0110;  // ALU Operation: Sub ; Instruction: BNE
            17'b10001110xxxxxxxxx: ALUCtrl<=4'b0010;  // ALU Operation: Add ; Instruction: Add Imm
            17'b10011000xxxxxxxxx: ALUCtrl<=4'b0001;  // ALU Operation: Or  ; Instruction: Or Imm
            17'b10011100xxxxxxxxx: ALUCtrl<=4'b0000;  // ALU Operation: AND ; Instruction: And Imm
            17'b10011111000011100: ALUCtrl<=4'b0000;  // ALU Operation: AND ; Instruction: And
            17'b10011111000101000: ALUCtrl<=4'b0110;  // ALU Operation: SUB ; Instruction: Sub
            17'b10011111100001010: ALUCtrl<=4'b0010;  // ALU Operation: ADD ; Instruction: Add
            17'b10011111110111100: ALUCtrl<=4'b0001;  // ALU Operation: OR  ; Instruction: Or
            17'b10011111111011100: ALUCtrl<=4'b1101;  // ALU Operation: NAND ; Instruction: Nand
            default: ALUCtrl<=4'b0000;
        endcase
    


    or o1 (ALUControl[0], ALUCtrl[0], 0);
    or o2 (ALUControl[1], ALUCtrl[1], 0);
    or o3 (ALUControl[2], ALUCtrl[2], 0);
    or o4 (ALUControl[3], ALUCtrl[3], 0);


endmodule