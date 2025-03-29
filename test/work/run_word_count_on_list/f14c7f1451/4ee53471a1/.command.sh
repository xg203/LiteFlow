#!/bin/bash

# --- Execution Environment ---
# Host CWD: /Users/xg203/workspace/liteflow2/test/work/run_word_count_on_list/f14c7f1451/4ee53471a1
# User: $(id -u):$(id -g)

# --- Command ---
docker run --rm --user=$(id -u):$(id -g) -v /Users/xg203/workspace/liteflow2/test/work/split_file/7168e8bf47:/inputs:ro -v /Users/xg203/workspace/liteflow2/test/work/run_word_count_on_list/f14c7f1451/4ee53471a1:/outputs -v /Users/xg203/workspace/liteflow2/script:/scripts:ro -w /outputs ubuntu:latest bash /scripts/word_counter.sh /inputs/split_03.txt > /Users/xg203/workspace/liteflow2/test/work/run_word_count_on_list/f14c7f1451/4ee53471a1/count_03.txt
