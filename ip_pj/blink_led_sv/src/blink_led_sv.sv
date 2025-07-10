// IP: LED点滅回路
// Lang: System Verilog
// Ver: 0.1 (2025/7/10)
// Copyright (c) 2025 Chimipupu(https://github.com/Chimipupu) All Rights Reserved.

module top #(
        // [定数]
        parameter CLOCK_XTAL = 27000000, // 水晶 27MHz
        parameter LED_NUM = 6            // 基板のLED数
    ) (
        // [入出力]
        input clk,                  // 水晶 27MHz
        output [ LED_NUM-1 :0] leds // 基板のLED
    );

    // [レジスタ]
    reg reg_cnt_1s_flg;             // 1bit 1秒カウントフラグレジスタ
    reg [31:0] reg_1s_cnt = 'd0;    // 32bit 1秒カウントフラグレジスタ
    reg [5:0] reg_led_val = 'd0;    // 6bit LEDデータレジスタ

    always @(posedge clk ) begin
        if( reg_1s_cnt < CLOCK_XTAL / 2 ) begin
            reg_1s_cnt <= reg_1s_cnt + 'd1;
            reg_cnt_1s_flg <= 'd0;
        end else begin
            reg_1s_cnt <= 'd0;
            reg_cnt_1s_flg <= 'd1;
        end
    end

    always @(posedge clk ) begin
        if( reg_cnt_1s_flg ) begin
            reg_led_val[ LED_NUM-1 :0] <= ~reg_led_val[ LED_NUM-1 :0];
        end
    end

    assign leds = ~reg_led_val;
endmodule