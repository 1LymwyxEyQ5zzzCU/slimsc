#!/bin/bash

# Usage: ./run_tx.sh <tx_hash>

tx_hash=$1
CWD=$(pwd) # Current working directory

# Paths
tx_json_path="$CWD/data/transactions/$tx_hash/tx.json"
prestate_json_path="$CWD/data/transactions/$tx_hash/prestate.json"
contract_addr=$(jq -r '.to | ascii_downcase' "$tx_json_path")
runtime_bin_path="$CWD/data/contracts/$contract_addr/bin-runtime"

# Environment settings
ENABLE_SGX=1
LEVEL=1
SUBCALL_VM="$CWD/bin/libevmone.so.0.9.1"
ENCLAVE_PATH="$CWD/bin/debloated_enclave.signed"
DATA_PATH="$CWD/data"
TAINT_CONFIG="$CWD/data/transactions/$tx_hash/taint.json"

# SlimSC Arguments
EVAL_PATH="$CWD/bin/eval"
SLIMSC_PATH="$CWD/bin/libslimsc.so.0.9.1"
slimsc_args=("$EVAL_PATH" "$SLIMSC_PATH" "$tx_json_path" "$prestate_json_path" "$runtime_bin_path")

env -i ENABLE_SGX=$ENABLE_SGX LEVEL=$LEVEL SUBCALL_VM=$SUBCALL_VM ENCLAVE_PATH=$ENCLAVE_PATH DATA_PATH=$DATA_PATH TAINT_CONFIG=$TAINT_CONFIG "${slimsc_args[@]}" 2>&1

