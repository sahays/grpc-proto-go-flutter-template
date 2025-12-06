#!/bin/bash

# Script to generate Dart code from proto files

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Generating Dart proto files...${NC}"

# Create output directory
mkdir -p lib/generated

# Proto source directory
PROTO_DIR="../proto"
OUT_DIR="lib/generated"

# Generate Dart code from proto files
protoc \
  --dart_out=grpc:${OUT_DIR} \
  --proto_path=${PROTO_DIR} \
  ${PROTO_DIR}/*.proto

echo -e "${GREEN}Proto generation complete!${NC}"
echo -e "${GREEN}Generated files are in ${OUT_DIR}${NC}"
