// LED点滅回路 テストベンチ
// Lang: System Verilog
// Ver: 0.1 (2025/7/10)
// Copyright (c) 2025 Chimipupu(https://github.com/Chimipupu) All Rights Reserved.

`timescale 1ns / 1ps

module tb_top();
    // テストベンチ用パラメータ
    parameter CLOCK_XTAL = 1000;     // シミュレーション用（1kHz相当）
    parameter LED_NUM = 6;
    parameter CLOCK_PERIOD = 37.037;  // 27MHz想定の周期

    // タイミング計算表示用
    real actual_toggle_period_ns;
    real actual_toggle_period_ms;

    // 信号定義
    reg clk;
    wire [LED_NUM-1:0] leds;

    // DUT (Device Under Test) インスタンス
    top #(
        .CLOCK_XTAL(CLOCK_XTAL),
        .LED_NUM(LED_NUM)
    ) dut (
        .clk(clk),
        .leds(leds)
    );

    // クロック生成
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end

    // テストシーケンス
    initial begin
        // VCD ファイル生成設定（必要な信号のみ）
        $dumpfile("led_blink.vcd");
        $dumpvars(0, clk);                    // クロック信号
        $dumpvars(0, dut.reg_cnt_1s_flg);     // 1秒フラグ
        $dumpvars(0, dut.reg_1s_cnt);         // 1秒カウンタ
        $dumpvars(0, dut.reg_led_val);        // LED値レジスタ

        // 初期化
        $display("=== LED点滅シミュレーション開始 ===");
        $display("CLOCK_XTAL = %d", CLOCK_XTAL);
        $display("LED_NUM = %d", LED_NUM);

        // タイミング計算
        actual_toggle_period_ns = (CLOCK_XTAL / 2) * CLOCK_PERIOD;
        actual_toggle_period_ms = actual_toggle_period_ns / 1000000;
        $display("シミュレーション用LEDトグル周期: %.0f ns (%.3f ms)", actual_toggle_period_ns, actual_toggle_period_ms);
        $display("実際の27MHzでは: 500ms間隔");
        $display("シミュレーションでは %d倍高速", 27000000/CLOCK_XTAL);
        $display("---");

        // リセット待機
        #100;

        // LEDの変化を監視
        $monitor("Time: %0t ns, LED状態: %b (0x%h)", $time, leds, leds);

        // 複数サイクルの動作を確認（6回のトグル）
        repeat(CLOCK_XTAL * 3) @(posedge clk);  // 3周期分（6回のトグル）

        $display("=== シミュレーション完了 ===");
        $finish;
    end

    // LED状態変化の検出（視覚的表示）
    always @(leds) begin
        $display("[%0t] LED状態変化: %s", $time, led_display(leds));
    end

    // LED状態の視覚的表示関数
    function [48*8-1:0] led_display;
        input [LED_NUM-1:0] led_state;
        integer i;
        reg [8*8-1:0] led_str;
        begin
            led_display = "";
            for (i = LED_NUM-1; i >= 0; i = i - 1) begin
                if (led_state[i])
                    led_str = "[*]";
                else
                    led_str = "[]";
                led_display = {led_display, led_str};
            end
        end
    endfunction

    // 内部信号の監視（デバッグ用）
    always @(posedge dut.reg_cnt_1s_flg) begin
        $display("[%0t] 1秒フラグ発生 - LEDトグル -> %s", $time, led_display(leds));
    end
endmodule