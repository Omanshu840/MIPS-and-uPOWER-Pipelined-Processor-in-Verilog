`include "mux21.v"
`include "Regmux.v"
`include "ALUmux.v"
`include "WBmux.v"
`include "ALUControlUnit.v"
`include "MainControlUnit.v"
`include "ALU64.v"
`include "PCmux.v"

module pipeline(clk, reset);

    reg [31:0] Instruction;
    input clk, reset;

    wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, SignZero;

    wire [1:0] ALUOp;

    Control C1(RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, Jump, SignZero, Instruction[31:26]);

    // always @(posedge clk)
    // begin
    //     $display("Control Signals\n");
    //     $display("RegDst = %d\tALUSrc = %d\tMemtoReg = %d\t\n", RegDst, ALUSrc, MemtoReg);   
    // end
           

    
    //  Register File

    reg [63:0] regFile[0:31];

    integer i;
    
    initial
    begin
        for (i=0; i<31; i=i+1)
        begin
            regFile[i] = i;
        end
    end

    
    
    
    // Data Memory

    reg [63:0] Mem[0:31];

    initial
    begin
        for (i=0; i<31; i=i+1)
        begin
            Mem[i] = i;
        end
    end


    // Instruction Fetch Stage

    reg [63:0] pc_current;
    wire [63:0] pc_next;
    // wire [31:0] pc_out;
    reg [31:0]instructionMemory[1023:0];

    initial
    begin
        $readmemb("demo.txt", instructionMemory);
    end

    always @(posedge clk or posedge reset)
    begin
        if(reset)
            pc_current <= 64'b0;
        else
            pc_current <= pc_next;
    end

    

    always @(pc_current)
    begin
        Instruction = instructionMemory[pc_current/4];
    end

    // assign pc_out = pc_current;


    
    // Instruction Decode Stage


    wire [4:0] ReadReg1 = Instruction[25:21];
    wire [4:0] ReadReg2 = Instruction[20:16];

    wire [4:0] WriteReg;

    Regmux R1(WriteReg, Instruction[20:16], Instruction[15:11], RegDst);


    wire [63:0] ReadData1;
    wire [63:0] ReadData2;


    assign ReadData1 = regFile[ReadReg1];
    assign ReadData2 = regFile[ReadReg2];


    // always @(posedge clk)
    // begin
    //     $display("ReadData1 = %0d\tReadData2 = %0d\nWrite Reg = %0d", ReadData1, ReadData2, WriteReg);   
    // end
    
    
    // ALU Stage

    
    wire [3:0] ALUControl;


    uPOWER_ALUControlUnit AC(ALUControl, ALUOp, Instruction[31:26], Instruction[9:1]);


    wire [63:0] SignExInstr;

    assign SignExInstr[15:0] = Instruction[15:0];
    assign SignExInstr[63:16] = {48{Instruction[15]}};


    wire [63:0] ALUoperand2;

    ALUmux AM1(ALUoperand2, ReadData2, SignExInstr, ALUSrc);

    wire [63:0] ALUResult;

    wire Zero,Overflow;

    ALU_64b ALU64(ReadData1, ALUoperand2, ALUControl, ALUResult, Overflow, Zero);


    // always @(posedge clk)
    // begin
    //     $display("ALU Result = %0d\n", ALUResult);
    // end

    
    
    
    // Memory Stage

    always @(posedge clk) begin
        if (MemWrite == 1)
        begin
            Mem[ALUResult] = ReadData2;
        end
    end

    wire [63:0] MemReadData;

    assign MemReadData = Mem[ALUResult];


    // always @(posedge clk)
    // begin
    //     $display("Written Data = %0d\tMemRead Data = %0d\n", ReadData2, MemReadData);   
    // end


    
    
    // Write Back Stage 

    wire [63:0] WriteData;

    WBmux WB1(WriteData, MemReadData, ALUResult, MemtoReg);


    always @(posedge clk) begin
        if (RegWrite==1)
        begin
            regFile[WriteReg] = WriteData;
        end
    end

    // always @(posedge clk)
    //         begin
    //             $display("Reg Written Data = %0d\n", WriteData);   
    //         end
    

    // Update the PC

    wire [63:0] shiftLeft2Output;
    wire [63:0] pc_plus_4;
    wire [63:0] branchAddResult;

    assign shiftLeft2Output = {SignExInstr[61:0], 1'b0, 1'b0};
    assign pc_plus_4 = pc_current + 64'b0100;
    assign branchAddResult = shiftLeft2Output + pc_plus_4;

    wire PCSrc;

    and andForPC(PCSrc, Zero, Branch);
    PCmux PCmux1(pc_next, pc_plus_4, branchAddResult, PCSrc);   // (Y, D0, D1, S)

    always @(posedge clk)
    begin
        $display("Time is ", $time);
        $display("IF Stage\n\nInstruction = %b\n\n", Instruction);
        $display("ID Stage\n\nReadData1 = %0d\tReadData2 = %0d\nWrite Reg = %0d\n\n", ReadData1, ReadData2, WriteReg);
        $display("ALU Stage\n\nALU Result = %0d, Zero flag = %b\n\n", ALUResult, Zero);
        $display("Memory Stage\n\nMemRead Data = %0d\n\n", MemReadData);
        $display("Write Back stage\n\nWBmuxOutput = %0d, RegWriteSignal = %b\n\n", WriteData, RegWrite);
        $display("Update PC stage\n\npc_next = %0d\n\n\n\n", pc_next);
        #1;
        $display("Register file:\n");
        $display("Reg 0: %0d Reg 1: %0d Reg 2: %0d Reg 3: %0d Reg 4: %0d Reg 5: %0d Reg 6: %0d Reg 7: %0d Reg 8: %0d Reg 9: %0d\n\n", regFile[0], regFile[1], regFile[2], regFile[3], regFile[4], regFile[5], regFile[6], regFile[7], regFile[8], regFile[9]);
        $display("Mem 0: %0d Mem 1: %0d Mem 2: %0d Mem 3: %0d Mem 4: %0d Mem 5: %0d Mem 6: %0d Mem 7: %0d Mem 8: %0d Mem 9: %0d\n", Mem[0], Mem[1], Mem[2], Mem[3], Mem[4], Mem[5], Mem[6], Mem[7], Mem[8], Mem[9]);
        $display("Mem 10: %0d Mem 11: %0d Mem 12: %0d Mem 13: %0d Mem 14: %0d Mem 15: %0d Mem 16: %0d Mem 17: %0d Mem 18: %0d Mem 19: %0d\n", Mem[10], Mem[11], Mem[12], Mem[13], Mem[14], Mem[15], Mem[16], Mem[17], Mem[18], Mem[19]);
        //$display("Reg 10: %0d Reg 11: %0d Reg 12: %0d Reg 13: %0d Reg 14: %0d Reg 15: %0d Reg 16: %0d Reg 17: %0d Reg 18: %0d Reg 19: %0d\n", );
        //$display("Reg 20: %0d Reg 21: %0d Reg 22: %0d Reg 23: %0d Reg 24: %0d Reg 25: %0d Reg 26: %0d Reg 27: %0d Reg 28: %0d Reg 29: %0d\n", );
        
    end

endmodule






