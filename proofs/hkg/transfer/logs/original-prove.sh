#!/usr/bin/env bash
set -euo pipefail

kprover prove \
  --session be08e0e3-e40e-4601-8a5d-f2c542d32676 \
  --spec inputs/spec.k \
  --spec-module SPEC \
  --verification inputs/verification.k \
  --verification-module VERIFICATION
