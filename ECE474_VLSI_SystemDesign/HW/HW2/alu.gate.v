/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : L-2016.03-SP2
// Date      : Fri Apr 19 14:43:20 2019
/////////////////////////////////////////////////////////////


module alu_DW01_addsub_0 ( A, B, CI, ADD_SUB, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI, ADD_SUB;
  output CO;

  wire   [9:0] carry;
  wire   [8:0] B_AS;
  assign carry[0] = ADD_SUB;

  FADDX1 U1_7 ( .A(A[7]), .B(B_AS[7]), .CI(carry[7]), .CO(carry[8]), .S(SUM[7]) );
  FADDX1 U1_6 ( .A(A[6]), .B(B_AS[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  FADDX1 U1_5 ( .A(A[5]), .B(B_AS[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  FADDX1 U1_4 ( .A(A[4]), .B(B_AS[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  FADDX1 U1_3 ( .A(A[3]), .B(B_AS[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  FADDX1 U1_2 ( .A(A[2]), .B(B_AS[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  FADDX1 U1_1 ( .A(A[1]), .B(B_AS[1]), .CI(carry[1]), .CO(carry[2]), .S(SUM[1]) );
  FADDX1 U1_0 ( .A(A[0]), .B(B_AS[0]), .CI(carry[0]), .CO(carry[1]), .S(SUM[0]) );
  XOR3X1 U1_8 ( .IN1(A[8]), .IN2(carry[0]), .IN3(carry[8]), .Q(SUM[8]) );
  XOR2X1 U1 ( .IN1(B[7]), .IN2(carry[0]), .Q(B_AS[7]) );
  XOR2X1 U2 ( .IN1(B[6]), .IN2(carry[0]), .Q(B_AS[6]) );
  XOR2X1 U3 ( .IN1(B[5]), .IN2(carry[0]), .Q(B_AS[5]) );
  XOR2X1 U4 ( .IN1(B[4]), .IN2(carry[0]), .Q(B_AS[4]) );
  XOR2X1 U5 ( .IN1(B[3]), .IN2(carry[0]), .Q(B_AS[3]) );
  XOR2X1 U6 ( .IN1(B[2]), .IN2(carry[0]), .Q(B_AS[2]) );
  XOR2X1 U7 ( .IN1(B[1]), .IN2(carry[0]), .Q(B_AS[1]) );
  XOR2X1 U8 ( .IN1(B[0]), .IN2(carry[0]), .Q(B_AS[0]) );
endmodule


module alu ( in_a, in_b, opcode, alu_out, alu_zero, alu_carry );
  input [7:0] in_a;
  input [7:0] in_b;
  input [3:0] opcode;
  output [7:0] alu_out;
  output alu_zero, alu_carry;
  wire   N45, N46, N47, N48, N49, N50, N51, N52, N53, N54, N55, N56, N57, N58,
         N59, N60, N61, N62, N63, N64, N65, N66, N67, N68, N69, N70, N71, N72,
         N73, N74, N75, N76, N77, \U3/U1/Z_0 , \U3/U1/Z_1 , \U3/U1/Z_2 ,
         \U3/U1/Z_3 , \U3/U1/Z_4 , \U3/U1/Z_5 , \U3/U1/Z_6 , \U3/U1/Z_7 ,
         \U3/U2/Z_0 , \U3/U2/Z_1 , \U3/U2/Z_2 , \U3/U2/Z_3 , \U3/U2/Z_4 ,
         \U3/U2/Z_5 , \U3/U2/Z_6 , \U3/U2/Z_7 , \U3/U3/Z_0 , n143, n144, n145,
         n146, n147, n148, n149, n150, n151, n152, n153, n154, n155, n156,
         n157, n158, n159, n160, n161, n162, n163, n164, n165, n166, n167,
         n168, n169, n170, n171, n172, n173, n174, n175, n176, n177, n178,
         n179, n180, n181, n182, n183, n184, n185, n186, n187, n188, n189,
         n190, n191, n192, n193, n194, n195, n196, n197, n198, n199, n200,
         n201, n202, n203, n204, n205, n206, n207;

  alu_DW01_addsub_0 r29 ( .A({n207, \U3/U1/Z_7 , \U3/U1/Z_6 , \U3/U1/Z_5 , 
        \U3/U1/Z_4 , \U3/U1/Z_3 , \U3/U1/Z_2 , \U3/U1/Z_1 , \U3/U1/Z_0 }), .B(
        {1'b0, \U3/U2/Z_7 , \U3/U2/Z_6 , \U3/U2/Z_5 , \U3/U2/Z_4 , \U3/U2/Z_3 , 
        \U3/U2/Z_2 , \U3/U2/Z_1 , \U3/U2/Z_0 }), .CI(1'b0), .ADD_SUB(
        \U3/U3/Z_0 ), .SUM({N53, N52, N51, N50, N49, N48, N47, N46, N45}) );
  INVX0 U162 ( .IN(opcode[0]), .QN(n178) );
  INVX0 U163 ( .IN(opcode[3]), .QN(n180) );
  INVX0 U164 ( .IN(opcode[1]), .QN(n179) );
  NAND2X0 U165 ( .IN1(opcode[3]), .IN2(opcode[1]), .QN(n173) );
  NAND2X0 U166 ( .IN1(n178), .IN2(n179), .QN(n143) );
  AO21X1 U167 ( .IN1(opcode[2]), .IN2(n143), .IN3(opcode[3]), .Q(n174) );
  OAI21X1 U168 ( .IN1(n178), .IN2(n173), .IN3(n174), .QN(n168) );
  NOR2X0 U169 ( .IN1(n173), .IN2(opcode[0]), .QN(n175) );
  AND4X1 U170 ( .IN1(opcode[2]), .IN2(opcode[0]), .IN3(n179), .IN4(n180), .Q(
        n167) );
  AOI222X1 U171 ( .IN1(N45), .IN2(n168), .IN3(n206), .IN4(n175), .IN5(N61), 
        .IN6(n167), .QN(n146) );
  AND3X1 U172 ( .IN1(opcode[1]), .IN2(n180), .IN3(opcode[2]), .Q(n144) );
  AND2X1 U173 ( .IN1(n144), .IN2(opcode[0]), .Q(n170) );
  NOR2X0 U174 ( .IN1(n180), .IN2(opcode[1]), .QN(n147) );
  AND2X1 U175 ( .IN1(n147), .IN2(n178), .Q(n163) );
  AND2X1 U176 ( .IN1(n144), .IN2(n178), .Q(n169) );
  AOI222X1 U177 ( .IN1(N77), .IN2(n170), .IN3(n163), .IN4(in_a[1]), .IN5(N69), 
        .IN6(n169), .QN(n145) );
  NAND2X0 U178 ( .IN1(n146), .IN2(n145), .QN(alu_out[0]) );
  AND2X1 U179 ( .IN1(opcode[0]), .IN2(n147), .Q(n176) );
  AO22X1 U180 ( .IN1(N68), .IN2(n169), .IN3(n163), .IN4(in_a[2]), .Q(n148) );
  AO221X1 U181 ( .IN1(n176), .IN2(in_a[0]), .IN3(N76), .IN4(n170), .IN5(n148), 
        .Q(n150) );
  AO222X1 U182 ( .IN1(N60), .IN2(n167), .IN3(n205), .IN4(n175), .IN5(N46), 
        .IN6(n168), .Q(n149) );
  OR2X1 U183 ( .IN1(n150), .IN2(n149), .Q(alu_out[1]) );
  AO22X1 U184 ( .IN1(N67), .IN2(n169), .IN3(n163), .IN4(in_a[3]), .Q(n151) );
  AO221X1 U185 ( .IN1(n176), .IN2(in_a[1]), .IN3(N75), .IN4(n170), .IN5(n151), 
        .Q(n153) );
  AO222X1 U186 ( .IN1(N59), .IN2(n167), .IN3(n204), .IN4(n175), .IN5(N47), 
        .IN6(n168), .Q(n152) );
  OR2X1 U187 ( .IN1(n153), .IN2(n152), .Q(alu_out[2]) );
  AO22X1 U188 ( .IN1(N66), .IN2(n169), .IN3(n163), .IN4(in_a[4]), .Q(n154) );
  AO221X1 U189 ( .IN1(n176), .IN2(in_a[2]), .IN3(N74), .IN4(n170), .IN5(n154), 
        .Q(n156) );
  AO222X1 U190 ( .IN1(N58), .IN2(n167), .IN3(n203), .IN4(n175), .IN5(N48), 
        .IN6(n168), .Q(n155) );
  OR2X1 U191 ( .IN1(n156), .IN2(n155), .Q(alu_out[3]) );
  AO22X1 U192 ( .IN1(N65), .IN2(n169), .IN3(n163), .IN4(in_a[5]), .Q(n157) );
  AO221X1 U193 ( .IN1(n176), .IN2(in_a[3]), .IN3(N73), .IN4(n170), .IN5(n157), 
        .Q(n159) );
  AO222X1 U194 ( .IN1(N57), .IN2(n167), .IN3(n202), .IN4(n175), .IN5(N49), 
        .IN6(n168), .Q(n158) );
  OR2X1 U195 ( .IN1(n159), .IN2(n158), .Q(alu_out[4]) );
  AO22X1 U196 ( .IN1(N64), .IN2(n169), .IN3(n163), .IN4(in_a[6]), .Q(n160) );
  AO221X1 U197 ( .IN1(n176), .IN2(in_a[4]), .IN3(N72), .IN4(n170), .IN5(n160), 
        .Q(n162) );
  AO222X1 U198 ( .IN1(N56), .IN2(n167), .IN3(n201), .IN4(n175), .IN5(N50), 
        .IN6(n168), .Q(n161) );
  OR2X1 U199 ( .IN1(n162), .IN2(n161), .Q(alu_out[5]) );
  AO22X1 U200 ( .IN1(N63), .IN2(n169), .IN3(n163), .IN4(in_a[7]), .Q(n164) );
  AO221X1 U201 ( .IN1(n176), .IN2(in_a[5]), .IN3(N71), .IN4(n170), .IN5(n164), 
        .Q(n166) );
  AO222X1 U202 ( .IN1(N55), .IN2(n167), .IN3(n200), .IN4(n175), .IN5(N51), 
        .IN6(n168), .Q(n165) );
  OR2X1 U203 ( .IN1(n166), .IN2(n165), .Q(alu_out[6]) );
  AOI222X1 U204 ( .IN1(N52), .IN2(n168), .IN3(n199), .IN4(n175), .IN5(N54), 
        .IN6(n167), .QN(n172) );
  AOI222X1 U205 ( .IN1(N70), .IN2(n170), .IN3(N62), .IN4(n169), .IN5(n176), 
        .IN6(in_a[6]), .QN(n171) );
  NAND2X0 U206 ( .IN1(n172), .IN2(n171), .QN(alu_out[7]) );
  NAND2X0 U207 ( .IN1(n174), .IN2(n173), .QN(n177) );
  AO221X1 U208 ( .IN1(N53), .IN2(n177), .IN3(n176), .IN4(in_a[7]), .IN5(n175), 
        .Q(alu_carry) );
  NOR2X0 U209 ( .IN1(n181), .IN2(n182), .QN(alu_zero) );
  OR4X1 U210 ( .IN1(alu_out[1]), .IN2(alu_out[0]), .IN3(alu_out[3]), .IN4(
        alu_out[2]), .Q(n182) );
  OR4X1 U211 ( .IN1(alu_out[5]), .IN2(alu_out[4]), .IN3(alu_out[7]), .IN4(
        alu_out[6]), .Q(n181) );
  OAI21X1 U212 ( .IN1(n183), .IN2(opcode[1]), .IN3(n184), .QN(\U3/U3/Z_0 ) );
  NOR2X0 U213 ( .IN1(n185), .IN2(n186), .QN(\U3/U2/Z_7 ) );
  NOR2X0 U214 ( .IN1(n185), .IN2(n187), .QN(\U3/U2/Z_6 ) );
  NOR2X0 U215 ( .IN1(n185), .IN2(n188), .QN(\U3/U2/Z_5 ) );
  NOR2X0 U216 ( .IN1(n185), .IN2(n189), .QN(\U3/U2/Z_4 ) );
  NOR2X0 U217 ( .IN1(n185), .IN2(n190), .QN(\U3/U2/Z_3 ) );
  NOR2X0 U218 ( .IN1(n185), .IN2(n191), .QN(\U3/U2/Z_2 ) );
  NOR2X0 U219 ( .IN1(n185), .IN2(n192), .QN(\U3/U2/Z_1 ) );
  NAND3X0 U220 ( .IN1(n193), .IN2(n194), .IN3(n195), .QN(\U3/U2/Z_0 ) );
  MUX21X1 U221 ( .IN1(n183), .IN2(n178), .S(opcode[1]), .Q(n195) );
  OR2X1 U222 ( .IN1(n196), .IN2(n185), .Q(n193) );
  OA21X1 U223 ( .IN1(opcode[1]), .IN2(opcode[2]), .IN3(n184), .Q(n185) );
  MUX21X1 U224 ( .IN1(n207), .IN2(n197), .S(in_a[7]), .Q(\U3/U1/Z_7 ) );
  MUX21X1 U225 ( .IN1(n207), .IN2(n197), .S(in_a[6]), .Q(\U3/U1/Z_6 ) );
  MUX21X1 U226 ( .IN1(n207), .IN2(n197), .S(in_a[5]), .Q(\U3/U1/Z_5 ) );
  MUX21X1 U227 ( .IN1(n207), .IN2(n197), .S(in_a[4]), .Q(\U3/U1/Z_4 ) );
  MUX21X1 U228 ( .IN1(n207), .IN2(n197), .S(in_a[3]), .Q(\U3/U1/Z_3 ) );
  MUX21X1 U229 ( .IN1(n207), .IN2(n197), .S(in_a[2]), .Q(\U3/U1/Z_2 ) );
  MUX21X1 U230 ( .IN1(n207), .IN2(n197), .S(in_a[1]), .Q(\U3/U1/Z_1 ) );
  MUX21X1 U231 ( .IN1(n207), .IN2(n197), .S(in_a[0]), .Q(\U3/U1/Z_0 ) );
  NAND3X0 U232 ( .IN1(n198), .IN2(n184), .IN3(opcode[1]), .QN(n197) );
  NAND2X0 U233 ( .IN1(n178), .IN2(n183), .QN(n184) );
  INVX0 U234 ( .IN(opcode[2]), .QN(n183) );
  OR2X1 U235 ( .IN1(n178), .IN2(opcode[3]), .Q(n198) );
  INVX0 U236 ( .IN(n194), .QN(n207) );
  NAND2X0 U237 ( .IN1(opcode[3]), .IN2(opcode[1]), .QN(n194) );
  XOR2X1 U238 ( .IN1(in_b[0]), .IN2(in_a[0]), .Q(N77) );
  XOR2X1 U239 ( .IN1(in_b[1]), .IN2(in_a[1]), .Q(N76) );
  XOR2X1 U240 ( .IN1(in_b[2]), .IN2(in_a[2]), .Q(N75) );
  XOR2X1 U241 ( .IN1(in_b[3]), .IN2(in_a[3]), .Q(N74) );
  XOR2X1 U242 ( .IN1(in_b[4]), .IN2(in_a[4]), .Q(N73) );
  XOR2X1 U243 ( .IN1(in_b[5]), .IN2(in_a[5]), .Q(N72) );
  XOR2X1 U244 ( .IN1(in_b[6]), .IN2(in_a[6]), .Q(N71) );
  XOR2X1 U245 ( .IN1(in_b[7]), .IN2(in_a[7]), .Q(N70) );
  NOR2X0 U246 ( .IN1(n206), .IN2(n196), .QN(N69) );
  NOR2X0 U247 ( .IN1(n205), .IN2(n192), .QN(N68) );
  NOR2X0 U248 ( .IN1(n204), .IN2(n191), .QN(N67) );
  NOR2X0 U249 ( .IN1(n203), .IN2(n190), .QN(N66) );
  NOR2X0 U250 ( .IN1(n202), .IN2(n189), .QN(N65) );
  NOR2X0 U251 ( .IN1(n201), .IN2(n188), .QN(N64) );
  NOR2X0 U252 ( .IN1(n200), .IN2(n187), .QN(N63) );
  NOR2X0 U253 ( .IN1(n199), .IN2(n186), .QN(N62) );
  NAND2X0 U254 ( .IN1(n196), .IN2(n206), .QN(N61) );
  INVX0 U255 ( .IN(in_a[0]), .QN(n206) );
  INVX0 U256 ( .IN(in_b[0]), .QN(n196) );
  NAND2X0 U257 ( .IN1(n192), .IN2(n205), .QN(N60) );
  INVX0 U258 ( .IN(in_a[1]), .QN(n205) );
  INVX0 U259 ( .IN(in_b[1]), .QN(n192) );
  NAND2X0 U260 ( .IN1(n191), .IN2(n204), .QN(N59) );
  INVX0 U261 ( .IN(in_a[2]), .QN(n204) );
  INVX0 U262 ( .IN(in_b[2]), .QN(n191) );
  NAND2X0 U263 ( .IN1(n190), .IN2(n203), .QN(N58) );
  INVX0 U264 ( .IN(in_a[3]), .QN(n203) );
  INVX0 U265 ( .IN(in_b[3]), .QN(n190) );
  NAND2X0 U266 ( .IN1(n189), .IN2(n202), .QN(N57) );
  INVX0 U267 ( .IN(in_a[4]), .QN(n202) );
  INVX0 U268 ( .IN(in_b[4]), .QN(n189) );
  NAND2X0 U269 ( .IN1(n188), .IN2(n201), .QN(N56) );
  INVX0 U270 ( .IN(in_a[5]), .QN(n201) );
  INVX0 U271 ( .IN(in_b[5]), .QN(n188) );
  NAND2X0 U272 ( .IN1(n187), .IN2(n200), .QN(N55) );
  INVX0 U273 ( .IN(in_a[6]), .QN(n200) );
  INVX0 U274 ( .IN(in_b[6]), .QN(n187) );
  NAND2X0 U275 ( .IN1(n186), .IN2(n199), .QN(N54) );
  INVX0 U276 ( .IN(in_a[7]), .QN(n199) );
  INVX0 U277 ( .IN(in_b[7]), .QN(n186) );
endmodule

