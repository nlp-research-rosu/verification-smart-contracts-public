#!/usr/bin/env bash
set -euo pipefail

cd /app
exec /usr/local/bin/kprover prove \
  --session 504ef65f-e09d-448d-ad55-5e374d7ecf1c \
  --spec inputs/spec.k \
  --spec-module SPEC \
  --verification inputs/verification.k \
  --verification-module VERIFICATION \
  --source inputs/bytecode.k
