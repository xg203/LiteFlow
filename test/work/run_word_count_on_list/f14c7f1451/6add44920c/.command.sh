#!/bin/bash

# --- Execution Environment ---
# Host CWD: /Users/xg203/workspace/liteflow2/test/work/run_word_count_on_list/f14c7f1451/6add44920c
# User: $(id -u):$(id -g)

# --- Command ---
docker run --rm --user=$(id -u):$(id -g) -v /Users/xg203/workspace/liteflow2/test/work/split_file/7168e8bf47:/inputs:ro -v /Users/xg203/workspace/liteflow2/test/work/run_word_count_on_list/f14c7f1451/6add44920c:/outputs -v /Users/xg203/workspace/liteflow2/script:/scripts:ro -w /outputs ubuntu:latest bash /scripts/word_counter.sh /inputs/split_04.txt > /Users/xg203/workspace/liteflow2/test/work/run_word_count_on_list/f14c7f1451/6add44920c/count_04.txt
