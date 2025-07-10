// LED 1Hz点滅回路 テストベンチ
// Lang: System Verilog
// Ver: 0.1 (2025/7/10)
// Copyright (c) 2025 Chimipupu(https://github.com/Chimipupu) All Rights Reserved.

`timescale 1ns / 1ps

module tb_top();
    // テストベンチ用パラメータ
    parameter int CLOCK_XTAL = 1000;          // シミュレーション用（1kHz相当）
    parameter int LED_NUM = 6;
    parameter real CLOCK_PERIOD = 37.037;    // 27MHz想定の周期

    // タイミング計算表示用
    real actual_toggle_period_ns;
    real actual_toggle_period_ms;

    // 信号定義
    logic clk;
    logic [LED_NUM-1:0] leds;

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
        clk = 1'b0;
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
    function automatic string led_display(input logic [LED_NUM-1:0] led_state);
        string result = "";
        for (int i = LED_NUM-1; i >= 0; i--) begin
            if (led_state[i])
                result = {result, "[*]"};
            else
                result = {result, "[ ]"};
        end
        return result;
    endfunction

    // 内部信号の監視（デバッグ用）
    always @(posedge dut.reg_cnt_1s_flg) begin
        $display("[%0t] 1秒フラグ発生 - LEDトグル -> %s", $time, led_display(leds));
    end

    // アサーション（検証用）
    // クロック周期の確認
    property clk_period_check;
        @(posedge clk) 1'b1 |-> ##[CLOCK_PERIOD-1:CLOCK_PERIOD+1] $rose(clk);
    endproperty

    // LED値の初期化確認
    property led_init_check;
        @(posedge clk) ($time == 0) |-> (leds == '1); // アクティブLowなので初期値は全1
    endproperty

    // 1秒フラグの周期性確認
    property one_second_flag_period;
        @(posedge clk) $rose(dut.reg_cnt_1s_flg) |-> ##[CLOCK_XTAL/2-1:CLOCK_XTAL/2+1] $rose(dut.reg_cnt_1s_flg);
    endproperty

    // アサーション有効化（シミュレーション開始後）
    initial begin
        #200; // 初期化完了を待つ
        assert property (one_second_flag_period)
            else $error("1秒フラグの周期が正しくありません");
    end

    // カバレッジ収集
    covergroup led_coverage @(posedge clk);
        led_state: coverpoint leds {
            bins all_on = {'0};      // 全LED ON (アクティブLow)
            bins all_off = {'1};     // 全LED OFF
            bins others = default;
        }

        counter_state: coverpoint dut.reg_1s_cnt {
            bins low_count = {[0:CLOCK_XTAL/4-1]};
            bins mid_count = {[CLOCK_XTAL/4:CLOCK_XTAL/2-1]};
            bins overflow = {[CLOCK_XTAL/2:$]};
        }
    endgroup

    led_coverage cov_inst = new();

    // 統計情報収集
    int toggle_count = 0;
    logic [LED_NUM-1:0] prev_leds;

    always @(leds) begin
        if (leds != prev_leds) begin
            toggle_count++;
            prev_leds = leds;
        end
    end

    // 最終統計表示
    final begin
        $display("=== 統計情報 ===");
        $display("LED状態変化回数: %d", toggle_count);
        $display("カバレッジ: %.2f%%", cov_inst.get_coverage());
    end

endmodule