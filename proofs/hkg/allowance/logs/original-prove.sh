#!/bin/sh
set -eu

exec /usr/local/bin/kprover prove \
  --project /app \
  --session 547121a7-36d3-4228-9b32-a494d0d3ed15 \
  --semantics evm \
  --spec inputs/spec.k \
  --spec-module SPEC \
  --verification inputs/verification.k \
  --verification-module VERIFICATION
