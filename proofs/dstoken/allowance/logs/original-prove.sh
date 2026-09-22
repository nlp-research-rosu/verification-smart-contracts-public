#!/usr/bin/env bash
set -euo pipefail

cd /app
exec /usr/local/bin/kprover prove \
  --project /app \
  --session f0df5f9e-5a29-4f02-b383-b202d5972853 \
  --semantics evm \
  --spec inputs/spec.k \
  --spec-module SPEC \
  --verification inputs/verification.k \
  --verification-module VERIFICATION \
  --source inputs/runtime.k

