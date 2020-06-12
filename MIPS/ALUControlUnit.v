/*

This file contains the MIPS_ALUControlUnit module, which is the ALU Control Unit associated with the ALU used for the MIPS datapath.

ALUOp and Funct are the inputs to this module, and ALUControl is the output which is to be sent to the ALU.

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

module MIPS_ALUControlUnit(ALUControl, ALUOp, Funct);
    
    output [3:0] ALUControl;
    input [1:0] ALUOp;
    input [5:0] Funct;
    wire [7:0] ALUControlIn;
    reg [3:0] ALUCtrl;

    assign ALUControlIn = {ALUOp,Funct};
    
    always @(ALUControlIn)
        casex (ALUControlIn)
            8'b00xxxxxx: ALUCtrl<=4'b0010;  // ALU Operation: Add ; Instruction: LW-SW
            8'b01xxxxxx: ALUCtrl<=4'b0110;  // ALU Operation: Sub ; Instruction: BNE
            8'b10100000: ALUCtrl<=4'b0010;  // ALU Operation: Add ; Instruction: Add
            8'b10100010: ALUCtrl<=4'b0110;  // ALU Operation: Sub ; Instruction: Sub
            8'b10100100: ALUCtrl<=4'b0000;  // ALU Operation: AND ; Instruction: AND
            8'b10100101: ALUCtrl<=4'b0001;  // ALU Operation: OR ; Instruction: OR
            8'b10101010: ALUCtrl<=4'b0111;  // ALU Operaton: SLT ; Instruction: SLT
            default: ALUCtrl<=4'b0000;
        endcase
    


    or o1 (ALUControl[0], ALUCtrl[0], 0);
    or o2 (ALUControl[1], ALUCtrl[1], 0);
    or o3 (ALUControl[2], ALUCtrl[2], 0);
    or o4 (ALUControl[3], ALUCtrl[3], 0);


endmodule