# Verification scope

The target is the unchanged 2,874-byte DSValue runtime in program/contract.bin,
entered at PC 0 with an empty word stack and memory. Pinned EVM revision:
4f4c3843076c. Each claim executes the bytecode under ISTANBUL with gas
accounting enabled and the semantics' infinite #gas(VGAS) supply. This tracks
cost without proving that any finite gas budget suffices.

## Input domain

Canonical peek() or read() selector followed by arbitrary suffix CD of at most
1,250,000,000 bytes, matching the RV reference. The complete account storage
map, current account, caller, static flag and call value are symbolic;
addresses and call value have EVM ranges. The account must exist.
The has byte is bits 160–167 of slot 1; val is slot 2. Missing slots read zero.

## Observable results

- peek with zero call value returns (val, has != 0) as two ABI words.
- read with zero call value and nonzero has returns val as one ABI word,
  with gas metadata decreasing by exactly 2043, as in the reference.
- read with zero call value and zero has reverts with Error("haz-not").
- Nonzero call value reverts with empty output for either selector.
- All claims preserve account storage. Final internal stack, memory and PC
  are unobserved. Gas for claims other than successful read is unobserved.

Short inputs, other selectors and finite-gas exhaustion are excluded. Broader
symbolic storage includes the reference's packed owner/Boolean representation.
No custom rules replace bytecode execution: the helpers name the exact runtime,
packed-byte projection and concrete error payload.
