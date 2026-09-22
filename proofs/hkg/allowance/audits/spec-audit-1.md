# Specification audit 1

## Artifacts and inputs examined

- `/app/output/spec.k`
- `/app/output/verification.k`, including its empty
  `VERIFICATION-SUMMARIES` definitional layer
- `/app/output/SCOPE.md`
- `/app/contract.sol`
- `/app/contract.bin`
- Construction session `547121a7-36d3-4228-9b32-a494d0d3ed15`,
  semantics `evm` at `4f4c3843076c`

The audit treated the candidate artifacts as untrusted and compared them with
the original inputs.

## Formal meaning in plain language

`allowance-success` begins fixed-semantics execution at PC 0 of a symbolic
program constrained byte-for-byte to the supplied runtime. For arbitrary
160-bit owner, spender, and executing-account addresses and arbitrary storage,
a canonical zero-value ABI call must halt successfully with exactly 32 output
bytes containing the EVM storage lookup at Solidity's nested mapping location
for slot 2; the storage map is unchanged.

`allowance-nonpayable-failure` begins the same runtime call for every nonzero
256-bit call value. It must halt with `EVMC_REVERT`, empty output, and
unchanged storage.

This agrees with the implementation at `contract.sol:203-205`,
`return allowed[owner][spender]`, and with the compiler-generated
nonpayable guard in the supplied runtime. The source declaration order places
`totalSupply`, `balances`, and `allowed` at slots 0, 1, and 2
respectively.

## Gate B review

- **B1 input domain: PASS.** Both Solidity arguments cover their complete
  160-bit ABI domains symbolically. Storage is not concretized or finitely
  enumerated. The success/failure split covers zero versus every nonzero
  256-bit call value for canonical allowance calldata.
- **B2 model adequacy: PASS.** The theorem explicitly selects Byzantium, the
  earliest schedule supporting the runtime's `REVERT` opcode, and disables
  gas accounting. Those choices and the exclusions of malformed dispatcher
  inputs and resource exhaustion are recorded in `SCOPE.md`; no unrecorded
  model-boundary restriction was found.
- **B3 summary adequacy: PASS.** There are no candidate summary functions.
  The postcondition uses the bundled semantics' total `#lookup` and
  `#hashedLocation` directly, including the absent-key-to-zero behavior.
- **B4 implementation/intent: PASS.** The claims describe the supplied
  runtime's observable allowance behavior and do not import broader ERC-20
  assumptions.

## Mechanical and identity checks

1. Command:

   `kprover validate --project /app --session 547121a7-36d3-4228-9b32-a494d0d3ed15 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION`

   Exit status: 0. Backend task:
   `5a8388fe-3ee8-4f1a-a40a-c1c70e389df9`; status `completed`;
   `task.result.valid: true`; definition
   `7_1_337-haskell-evm-4f4c3843076c-8de2aa8e95f822c67b82152ab4108caea672b57b3d82ef2b3fe48239db915512`.
   Evidence:
   `/app/.kprover/sessions/547121a7-36d3-4228-9b32-a494d0d3ed15/validation-005/result.json`.

2. Command:

   `test "$(rg -o '0x[0-9a-f]+' /app/output/spec.k | sort -u | wc -l)" -eq 1 && test "$(rg -o '0x[0-9a-f]+' /app/output/spec.k | head -1 | cut -c3-)" = "$(od -An -v -tx1 /app/contract.bin | tr -d ' \\n')"`

   Exit status: 0. Both claims use the same literal, and that literal exactly
   equals all 2,091 bytes of `contract.bin`.

3. Command:

   `od -An -v -tx1 /app/contract.bin | tr -d ' \\n' | rg -o 'dd62ed3e'`

   Exit status: 0; output `dd62ed3e`, the
   `allowance(address,address)` selector.

4. Command:

   `rg -n 'function allowance|return allowed\\[owner\\]\\[spender\\]' /app/contract.sol`

   Exit status: 0; the concrete implementation is at lines 203-205.

5. Command:

   `cmp -s /app/output/spec.k /app/.kprover/sessions/547121a7-36d3-4228-9b32-a494d0d3ed15/inputs/spec.k && cmp -s /app/output/verification.k /app/.kprover/sessions/547121a7-36d3-4228-9b32-a494d0d3ed15/inputs/verification.k`

   Exit status: 0; the validated session inputs equal the audited outputs.

## Findings

No adequacy, summary-faithfulness, identifier-parsing, or mechanical finding
remains. Earlier construction validations 001-004 diagnosed and removed an
unneeded candidate bytecode rewrite; they are retained as partial evidence but
are not part of the approved theorem.

VERDICT: PASS
REASON: The symbolic success and nonpayable-failure claims faithfully cover the scoped runtime allowance behavior and validate against the pinned EVM semantics.
