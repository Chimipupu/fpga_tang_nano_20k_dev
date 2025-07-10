# fpga_tn20k_dev

FPGA基板のTang Nano 20KでIPを個人開発

## 開発環境

### S/W

- EDA
  - [Gowin EDA V1.9.11.03 (Windows x64)](https://cdn.gowinsemi.com.cn/Gowin_V1.9.11.03_x64_win.zip)🔗
- シミュレータ
  - Verilog HDL
    - [Icarus Verilog](https://bleyer.org/icarus/)🔗
  - System Verilog
    - [Verilator](https://www.veripool.org/verilator/)🔗
- シミュレーション波形形確認ツール
  - [GTKWave](https://gtkwave.sourceforge.net/)🔗

『Verilog HDL』
Icarus Verilog + GTKWaveでのシミュレーション

```shell
> iverilog uart.v uart_tb.v
> vvp a.out
> gtkwave uart_tb.vcd
```

### H/W

- 基板
  - [Tang Primer 20K](https://wiki.sipeed.com/hardware/en/tang/tang-primer-20k/primer-20k.html)🔗
  - FPGA
    - [GW2AR-LV18QN88C8/I7](https://www.gowinsemi.com.cn/prod_view.aspx?TypeId=10&FId=t3:10:3&Id=167#GW2AR)
      - LUT:20736
      - Flip Flop:15552
      - SSRAM:41472bit
      - BSRAM:828Kbits
      - SDRAM(32bit): 64Mbit
      - PLL:x2
      - I/O Bank:x8
  - その他(基板実装部品)
    - フラッシュ:64Mbit
    - オンボード(JTAG & UART to USB):BL616
    - LED:オレンジ x6
    - RGB LED:WS2812(NeoPixel互換) x1
    - スイッチ:x2
    - SD/TFスロット:x1

