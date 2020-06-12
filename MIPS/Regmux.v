module Regmux(Y, D0, D1, S);

    output [4:0] Y;
    input [4:0] D0, D1;
    input S;

    mux21 mr1(Y[0], D0[0], D1[0], S);
    mux21 mr2(Y[1], D0[1], D1[1], S);
    mux21 mr3(Y[2], D0[2], D1[2], S);
    mux21 mr4(Y[3], D0[3], D1[3], S);
    mux21 mr5(Y[4], D0[4], D1[4], S);

endmodule