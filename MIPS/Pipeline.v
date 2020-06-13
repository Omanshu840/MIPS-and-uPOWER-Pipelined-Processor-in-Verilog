`include "mux21.v"
`include "Regmux.v"
`include "ALUmux.v"
`include "WBmux.v"
`include "ALUControlUnit.v"
`include "MainControlUnit.v"
`include "ALU32.v"

module pipeline(Instruction, clk);

    input [31:0] Instruction;
    input clk;

    wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, SignZero;

    wire [1:0] ALUOp;

    Control C1(RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, Jump, SignZero, Instruction[31:26]);

    // always @(posedge clk)
    // begin
    //     $display("Control Signals\n");
    //     $display("RegDst = %d\tALUSrc = %d\tMemtoReg = %d\t\n", RegDst, ALUSrc, MemtoReg);   
    // end
           

    
    //  Register File

    reg [31:0] regFile[0:31];

    integer i;
    
    initial
    begin
        for (i=0; i<31; i=i+1)
        begin
            regFile[i] = i;
        end
    end

    
    
    
    // Data Memory

    reg [31:0] Mem[0:31];

    initial
    begin
        for (i=0; i<31; i=i+1)
        begin
            Mem[i] = i;
        end
    end


    
    
    // Instruction Decode Stage

    wire [4:0] ReadReg1 = Instruction[25:21];
    wire [4:0] ReadReg2 = Instruction[20:16];

    wire [4:0] WriteReg;

    Regmux R1(WriteReg, Instruction[20:16], Instruction[15:11], RegDst);


    wire [31:0] ReadData1;
    wire [31:0] ReadData2;


    assign ReadData1 = regFile[ReadReg1];
    assign ReadData2 = regFile[ReadReg2];


    always @(posedge clk)
    begin
        $display("ReadData1 = %0d\tReadData2 = %0d\nWrite Reg = %0d", ReadData1, ReadData2, WriteReg);   
    end
    
    
    // ALU Stage

    
    wire [3:0] ALUControl;


    MIPS_ALUControlUnit AC(ALUControl, ALUOp, Instruction[5:0]);


    wire [31:0] SignExInstr;

    assign SignExInstr[15:0] = Instruction[15:0];
    assign SignExInstr[31:16] = {16{Instruction[15]}};


    wire [31:0] ALUoperand2;

    ALUmux AM1(ALUoperand2, ReadData2, SignExInstr, ALUSrc);

    wire [31:0] ALUResult;

    wire Zero,Overflow;

    ALU_32b A32(ReadData1, ALUoperand2, ALUControl, ALUResult, Overflow, Zero);


    always @(posedge clk)
    begin
        $display("ALU Result = %0d\n", ALUResult);   
    end

    
    
    
    // Memory Stage

    always @* begin
        if (MemWrite == 1)
        begin
            Mem[ALUResult] = ReadData2;
        end
    end

    wire [31:0] MemReadData;

    assign MemReadData = Mem[ALUResult];


    always @(posedge clk)
    begin
        $display("Written Data = %0d\tMemRead Data = %0d\n", ReadData2, MemReadData);   
    end


    
    
    // Write Back Stage 

    wire [31:0] WriteData;

    WBmux WB1(WriteData, MemReadData, ALUResult, MemtoReg);


    always @* begin
        if (RegWrite==1)
        begin
            regFile[WriteReg] = WriteData;
        end
    end

    always @(posedge clk)
            begin
                $display("Reg Written Data = %0d\n", WriteData);   
            end

endmodule






