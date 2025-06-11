#!/bin/bash

PROTO_ROOT="/Users/wxyawang/work/SDK/Example/QAPM/QAPMGRPC/Protos"
OUTPUT_DIR="/Users/wxyawang/work/SDK/Example/QAPM/QAPMGRPC/Sources/Generated"

protoc \
  --proto_path="${PROTO_ROOT}" \
  --swift_out="${OUTPUT_DIR}" \
  --grpc-swift_out="${OUTPUT_DIR}" \
  "${PROTO_ROOT}/hello.proto" \
  "${PROTO_ROOT}/order/orderSystem.proto"

# 修复 Xcode 索引问题（可选）
# touch "${OUTPUT_DIR}"/.generated
