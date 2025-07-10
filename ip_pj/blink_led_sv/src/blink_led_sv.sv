// IP: LED 1Hz点滅回路
// Lang: System Verilog
// Ver: 0.1 (2025/7/10)
// Copyright (c) 2025 Chimipupu(https://github.com/Chimipupu) All Rights Reserved.

module top #(
        // [定数]
        parameter int CLOCK_XTAL = 27000000, // 水晶 27MHz
        parameter int LED_NUM = 6            // 基板のLED数
    ) (
        // [入出力]
        input logic clk,                    // 水晶 27MHz
        output logic [LED_NUM-1:0] leds     // 基板のLED
    );

    // [ローカルパラメータ]
    localparam int HALF_SECOND_COUNT = CLOCK_XTAL / 2;

    // [レジスタ]
    logic reg_cnt_1s_flg;                   // 1bit 1秒カウントフラグレジスタ
    logic [31:0] reg_1s_cnt;                // 32bit 1秒カウントフラグレジスタ
    logic [LED_NUM-1:0] reg_led_val;        // 6bit LEDデータレジスタ

    // 1秒カウンタとフラグ生成
    always_ff @(posedge clk) begin
        if (reg_1s_cnt < HALF_SECOND_COUNT - 1) begin
            reg_1s_cnt <= reg_1s_cnt + 1'b1;
            reg_cnt_1s_flg <= 1'b0;
        end else begin
            reg_1s_cnt <= '0;
            reg_cnt_1s_flg <= 1'b1;
        end
    end

    // LEDトグル制御
    always_ff @(posedge clk) begin
        if (reg_cnt_1s_flg) begin
            reg_led_val <= ~reg_led_val;
        end
    end

    // LED出力 (アクティブLow)
    assign leds = ~reg_led_val;

endmodule