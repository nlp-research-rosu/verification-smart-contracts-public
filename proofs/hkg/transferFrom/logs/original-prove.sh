#!/usr/bin/env bash
set -euo pipefail

kprover prove \
  --project /app \
  --session b35c50df-236f-408a-864d-02f003f9759e \
  --semantics evm \
  --spec inputs/spec.k \
  --spec-module SPEC \
  --verification inputs/verification.k \
  --verification-module VERIFICATION \
  --source inputs/hkg-bin-runtime.k
