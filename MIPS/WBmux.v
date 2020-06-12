module WBmux(Y, D0, D1, S);

    output [31:0] Y;
    input [31:0] D0, D1;
    input S;

    mux21 mu1(Y[0], D0[0], D1[0], S);
    mux21 mu2(Y[1], D0[1], D1[1], S);
    mux21 mu3(Y[2], D0[2], D1[2], S);
    mux21 mu4(Y[3], D0[3], D1[3], S);
    mux21 mu5(Y[4], D0[4], D1[4], S);
    mux21 mu6(Y[5], D0[5], D1[5], S);
    mux21 mu7(Y[6], D0[6], D1[6], S);
    mux21 mu8(Y[7], D0[7], D1[7], S);
    mux21 mu9(Y[8], D0[8], D1[8], S);
    mux21 mu10(Y[9], D0[9], D1[9], S);
    mux21 mu11(Y[10], D0[10], D1[10], S);
    mux21 mu12(Y[11], D0[11], D1[11], S);
    mux21 mu13(Y[12], D0[12], D1[12], S);
    mux21 mu14(Y[13], D0[13], D1[13], S);
    mux21 mu15(Y[14], D0[14], D1[14], S);
    mux21 mu16(Y[15], D0[15], D1[15], S);
    mux21 mu17(Y[16], D0[16], D1[16], S);
    mux21 mu18(Y[17], D0[17], D1[17], S);
    mux21 mu19(Y[18], D0[18], D1[18], S);
    mux21 mu20(Y[19], D0[19], D1[19], S);
    mux21 mu21(Y[20], D0[20], D1[20], S);
    mux21 mu22(Y[21], D0[21], D1[21], S);
    mux21 mu23(Y[22], D0[22], D1[22], S);
    mux21 mu24(Y[23], D0[23], D1[23], S);
    mux21 mu25(Y[24], D0[24], D1[24], S);
    mux21 mu26(Y[25], D0[25], D1[25], S);
    mux21 mu27(Y[26], D0[26], D1[26], S);
    mux21 mu28(Y[27], D0[27], D1[27], S);
    mux21 mu29(Y[28], D0[28], D1[28], S);
    mux21 mu30(Y[29], D0[29], D1[29], S);
    mux21 mu31(Y[30], D0[30], D1[30], S);
    mux21 mu32(Y[31], D0[31], D1[31], S);

endmodule