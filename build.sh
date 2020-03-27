#!/bin/bash

cat Dockerfile | time docker build -t shattered/janus:x86 -f- .

# cat Dockerfile.arm64 | time docker build -t shattered/janus:arm64 -f- .
