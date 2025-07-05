// IP: LED点滅回路
// Ver: 0.1 (2025/7/5)
// Copyright (c) 2025 Chimipupu(https://github.com/Chimipupu) All Rights Reserved.

module top#(
        // 定数
        parameter CLOCK_XTAL = 27000000 // 水晶 27MHz
        parameter LED_NUM = 6           // 基板のLED数
    )
    (
        // 入出力
        input clk,
        output [ LED_NUM-1 :0] leds
    );

    // レジスタ
    reg reg_cnt_1s_flg; // 1秒カウントフラグレジスタ()
    reg [23:0] reg_1s_cnt = 'd0;

    // 
    always @(posedge clk ) begin
        if( reg_1s_cnt < CLOCK_XTAL / 2 ) begin
            reg_1s_cnt <= reg_1s_cnt + 'd1;
            reg_cnt_1s_flg <= 'd0;
        end else begin
            reg_1s_cnt <= 'd0;
            reg_cnt_1s_flg <= 'd1;
        end
    end


    reg [5:0] leds_value = 'd0;

    always @(posedge clk ) begin
        if( reg_cnt_1s_flg ) begin
            leds_value[ LED_NUM-1 :0] <= ~ leds_value[ LED_NUM-1 :0];
        end
    end

    assign leds = ~leds_value;
endmodule