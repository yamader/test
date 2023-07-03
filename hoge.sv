
// 加算器
//
// 4bit整数2つを受け取り，4bit整数とキャリー信号を出力する
// クロック信号が立ち上がった瞬間に，入力を読み取り，出力を確定する
//   出力は次のクロックの立ち上がりまで保持される
// リセット信号が1の間は，(クロックを含む)いかなる入力にも係らず，sとcが0になる
module adder(
    input   rst,      // リセット     : 1の間はsとcが0
    input   clk,      // クロック     : 立ち上がり時に入力から出力を確定
    input   [3:0] a,  // 入力整数a    : 加算器の入力
    input   [3:0] b,  // 入力整数b    : 加算器の入力
    output  [3:0] s,  // 出力整数     : 加算器の出力
    output  c);       // 出力キャリー : 加算器の出力(キャリー)

  // 実際の計算で利用する値
  reg [3:0] _a, _b;


  // 加算器の各bitのキャリー用
  wire c0, c1, c2;

  // 加算器
  full_adder
    dig0(_a[0], _b[0], 1'b0, s[0], c0),
    dig1(_a[1], _b[1], c0, s[1], c1),
    dig2(_a[2], _b[2], c1, s[2], c2),
    dig3(_a[3], _b[3], c2, s[3], c);

  // 制御信号の立ち上がり毎に実行される
  always @(posedge clk, posedge rst) begin
    // リセット信号の判別
    if(rst) begin
      // リセット動作
      _a <= 4'b0000;
      _b <= 4'b0000;
    end else begin
      // 入力を読み取り，計算結果を出力する
      _a <= a;
      _b <= b;
    end
  end
endmodule

// 非同期式の全加算器
module full_adder(input a, b, ci, output y, co);
  assign y = a ^ b ^ ci;
  assign co = a & b | ci & (a ^ b);
endmodule

// 加算器のテストベンチ
module adder_tb;
  reg a, b, ci;
  wire y, co;

  adder adder_inst(a, b, ci, y, co);

  initial begin
    $dumpfile("adder_test.vcd");
    $dumpvars(1, adder_tb);

    a = 0; b = 0;
    #10 a = 1;
    #10 a = 0; b = 1;
    #10 a = 1;
    #10 a = 0; b = 0;
    #10 $finish;
  end
endmodule
