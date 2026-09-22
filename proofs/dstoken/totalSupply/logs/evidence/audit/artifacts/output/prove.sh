#!/usr/bin/env bash
set -eu
kprover prove --project /app \
  --session 446149a2-f38c-4c76-9ec9-b7953d48233c \
  --semantics evm \
  --spec inputs/spec.k \
  --spec-module SPEC \
  --verification inputs/verification.k \
  --verification-module VERIFICATION \
  --source inputs/dstoken-bin.k
