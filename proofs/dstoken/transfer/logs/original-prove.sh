#!/bin/sh
set -eu
: "${XDG_CONFIG_HOME:?Set XDG_CONFIG_HOME to the retained isolated configuration}"
exec kprover prove --session 9de91c94-5dde-4768-8d0d-ed007c7d6069 \
  --spec inputs/spec.k --spec-module SPEC \
  --verification inputs/verification.k --verification-module VERIFICATION \
  --source inputs/dstoken-bin.k
