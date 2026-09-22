#!/usr/bin/env bash
set -eu

exec /usr/local/bin/kprover prove \
  --project /app \
  --session 34aef060-d0b8-47bc-8577-d4fdb4c1f87e \
  --semantics evm \
  --spec inputs/spec.k \
  --spec-module SPEC \
  --verification inputs/verification.k \
  --verification-module VERIFICATION
