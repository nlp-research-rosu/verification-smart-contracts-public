#!/bin/sh
set -eu

exec kprover prove \
  --session 0965306b-374d-4868-a291-37d3096894d4 \
  --spec inputs/spec.k \
  --spec-module TRANSFER-FROM-SPEC \
  --verification inputs/verification.k \
  --verification-module VERIFICATION
