#!/usr/bin/env bash
set -euo pipefail

# Replays the final unfiltered construction proof. The session is intentionally
# fixed: creating a replacement session here would bypass KIT's attempt ledger.
kprover prove \
  --session 4061601c-c8bc-4ea7-bc43-5e24891ed434 \
  --project /app \
  --semantics evm \
  --spec inputs/spec.k \
  --spec-module SPEC \
  --verification inputs/verification.k \
  --verification-module VERIFICATION \
  --source inputs/helpers/hkg-bytecode.k
