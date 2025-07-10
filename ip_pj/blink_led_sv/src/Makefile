# Makefile(Verilator用)
# LED 1Hz点滅回路
# Ver: 0.1 (2025/7/10)
# Copyright (c) 2025 Chimipupu(https://github.com/Chimipupu) All Rights Reserved.

# 設定
TOP_MODULE = tb_top
RTL_FILES = top.sv tb_top.sv
VERILATOR_FLAGS = --cc --exe --build --trace --top-module $(TOP_MODULE)
VERILATOR_FLAGS += --assert --coverage --timing
VERILATOR_FLAGS += -Wall -Wno-fatal -Wno-DECLFILENAME

# C++ドライバが必要な場合
CPP_FILES = 

# 出力ディレクトリ
OBJ_DIR = obj_dir

# デフォルトターゲット
all: compile run

# コンパイル
compile:
	@echo "=== Verilatorでコンパイル中 ==="
	verilator $(VERILATOR_FLAGS) $(RTL_FILES) $(CPP_FILES)

# シミュレーション実行
run:
	@echo "=== シミュレーション実行中 ==="
	./$(OBJ_DIR)/V$(TOP_MODULE)

# VCD波形ファイルをGTKWaveで表示
wave:
	@echo "=== GTKWaveで波形表示 ==="
	@if [ -f led_blink.vcd ]; then \
		gtkwave led_blink.vcd; \
	else \
		echo "VCDファイルが見つかりません。先にシミュレーションを実行してください。"; \
	fi

# カバレッジレポート生成
coverage:
	@echo "=== カバレッジレポート生成 ==="
	@if [ -d $(OBJ_DIR) ]; then \
		verilator_coverage --annotate coverage_report $(OBJ_DIR)/coverage.dat; \
		echo "カバレッジレポートを coverage_report/ に生成しました"; \
	else \
		echo "カバレッジデータが見つかりません。--coverage オプションでコンパイルしてください。"; \
	fi

# クリーンアップ
clean:
	@echo "=== クリーンアップ中 ==="
	rm -rf $(OBJ_DIR)
	rm -f *.vcd
	rm -rf coverage_report
	rm -f *.log

# リント（構文チェック）のみ
lint:
	@echo "=== リント実行中 ==="
	verilator --lint-only $(RTL_FILES)

# 詳細情報表示
info:
	@echo "=== Verilator設定情報 ==="
	@echo "TOP_MODULE: $(TOP_MODULE)"
	@echo "RTL_FILES: $(RTL_FILES)"
	@echo "VERILATOR_FLAGS: $(VERILATOR_FLAGS)"
	@echo "OBJ_DIR: $(OBJ_DIR)"
	@verilator --version

# ヘルプ
help:
	@echo "=== 使用可能なターゲット ==="
	@echo "all      : コンパイル + 実行"
	@echo "compile  : Verilatorでコンパイル"
	@echo "run      : シミュレーション実行"
	@echo "wave     : GTKWaveで波形表示"
	@echo "coverage : カバレッジレポート生成"
	@echo "lint     : リント（構文チェック）のみ"
	@echo "clean    : 生成ファイルを削除"
	@echo "info     : 設定情報表示"
	@echo "help     : このヘルプを表示"

.PHONY: all compile run wave coverage clean lint info help