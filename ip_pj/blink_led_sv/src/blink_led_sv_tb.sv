// LED 1Hz点滅回路 テストベンチ
// Lang: System Verilog
// Ver: 0.1 (2025/7/10)
// Copyright (c) 2025 Chimipupu(https://github.com/Chimipupu) All Rights Reserved.

`timescale 1ns/1ps

module testbench_tb;

    // パラメータ
    parameter CLOCK_XTAL = 27000000;
    parameter LED_NUM = 6;

    // 信号
    logic clk;
    logic [LED_NUM-1:0] leds;

    // DUTインスタンス
    top #(
        .CLOCK_XTAL(CLOCK_XTAL),
        .LED_NUM(LED_NUM)
    ) dut (
        .clk(clk),
        .leds(leds)
    );

    // クロック生成 (10ns周期: 100MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // シミュレーション制御
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, testbench_tb);
      #10000000; // シミュレーション時間

        $finish;
    end

endmodule
