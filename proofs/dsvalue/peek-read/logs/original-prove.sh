#!/bin/sh
set -eu
exec kprover prove --session 70c7b8c6-5023-41b0-b803-fb2317fcfa33 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION
