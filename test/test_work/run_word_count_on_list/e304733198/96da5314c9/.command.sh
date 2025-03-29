#!/bin/bash

# --- Execution Environment ---
# Host CWD: /Users/xg203/workspace/liteflow2/test/test_work/run_word_count_on_list/e304733198/96da5314c9
# User: $(id -u):$(id -g)

# --- Command ---
docker run --rm --user=$(id -u):$(id -g) -v /Users/xg203/workspace/liteflow2/test/test_work/split_file/1d2ab6d5a0:/inputs:ro -v /Users/xg203/workspace/liteflow2/test/test_work/run_word_count_on_list/e304733198/96da5314c9:/outputs -v /Users/xg203/workspace/liteflow2/script:/scripts:ro -w /outputs ubuntu:latest bash /scripts/word_counter.sh /inputs/split_03.txt > /Users/xg203/workspace/liteflow2/test/test_work/run_word_count_on_list/e304733198/96da5314c9/count_03.txt
