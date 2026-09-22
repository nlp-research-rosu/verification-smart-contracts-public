#!/usr/bin/env bash
set -euo pipefail

session_id="73d69834-e371-4ec8-b44b-23b8cd12edd6"

kprover validate \
  --project /app \
  --session "$session_id" \
  --semantics evm \
  --spec inputs/spec.k \
  --spec-module SPEC \
  --verification inputs/verification.k \
  --verification-module VERIFICATION \
  --source inputs/runtime.k

kprover prove \
  --project /app \
  --session "$session_id" \
  --semantics evm \
  --spec inputs/spec.k \
  --spec-module SPEC \
  --verification inputs/verification.k \
  --verification-module VERIFICATION \
  --source inputs/runtime.k
