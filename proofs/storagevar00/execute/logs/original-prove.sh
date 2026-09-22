#!/usr/bin/env sh
set -eu

kprover prove \
  --session 00599ca4-f253-4bff-8222-619c376a46e8 \
  --spec inputs/spec.k \
  --spec-module SPEC \
  --verification inputs/verification.k \
  --verification-module VERIFICATION
