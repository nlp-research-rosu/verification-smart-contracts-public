#!/bin/sh
set -eu
exec kprover prove --session ffc42fa9-049a-4ada-9213-9f10f524f41f --semantics evm --spec inputs/spec.k --spec-module SPEC --source inputs/verification.k
