`timescale 1 ps / 100 fs

module Control(RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, Jump, SignZero, Opcode);

    output RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,Jump,SignZero;
    output [1:0] ALUOp;
    input [5:0] Opcode;
    reg RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,Jump,SignZero;
    reg [1:0] ALUOp;

    always @(*)
    casex (Opcode)
        6'b011111 : begin // X and XO type
                        RegDst = 1'b1;
                        ALUSrc = 1'b0;
                        MemtoReg= 1'b0;
                        RegWrite= 1'b1;
                        MemRead = 1'b0;
                        MemWrite= 1'b0;
                        Branch = 1'b0;
                        ALUOp = 2'b10;
                        Jump = 1'b0;
                        SignZero= 1'b0;
                    end
        // 6'b111010 : begin // Immediate
        //                 RegDst = 1'b0;
        //                 ALUSrc = 1'b1;
        //                 MemtoReg= 1'b0;
        //                 RegWrite= 1'b1;
        //                 MemRead = 1'b0;
        //                 MemWrite= 1'b0;
        //                 Branch = 1'b0;
        //                 ALUOp = 2'b10;
        //                 Jump = 1'b0;
        //                 SignZero= 1'b0; // sign extend
        //             end
        6'b111010 : begin // DS - load Double Word
                        RegDst = 1'b0;
                        ALUSrc = 1'b1;
                        MemtoReg= 1'b1;
                        RegWrite= 1'b1;
                        MemRead = 1'b1;
                        MemWrite= 1'b0;
                        Branch = 1'b0;
                        ALUOp = 2'b00;
                        Jump = 1'b0;
                        SignZero= 1'b0; // sign extend
                    end
        6'b111110 : begin // DS - Store Double Word
                        RegDst = 1'bx;
                        ALUSrc = 1'b1;
                        MemtoReg= 1'bx;
                        RegWrite= 1'b0;
                        MemRead = 1'b0;
                        MemWrite= 1'b1;
                        Branch = 1'b0;
                        ALUOp = 2'b00;
                        Jump = 1'b0;
                        SignZero= 1'b0;
                    end
        6'b010011 : begin // B - Branch Conditional Relative
                        RegDst = 1'bx;
                        ALUSrc = 1'b0;
                        MemtoReg= 1'bx;
                        RegWrite= 1'b0;
                        MemRead = 1'b0;
                        MemWrite= 1'b0;
                        Branch = 1'b1;
                        ALUOp = 2'b01;
                        Jump = 1'b0;
                        SignZero= 1'b0; // sign extend
                    end
        
        default :   begin 
                        RegDst = 1'b0;
                        ALUSrc = 1'b0;
                        MemtoReg= 1'b0;
                        RegWrite= 1'b0;
                        MemRead = 1'b0;
                        MemWrite= 1'b0;
                        Branch = 1'b0;
                        ALUOp = 2'b10;
                        Jump = 1'b0;
                        SignZero= 1'b0;
                    end
    
    endcase

endmodule