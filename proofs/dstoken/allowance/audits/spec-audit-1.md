# Specification audit 1

## Inputs examined

- Original task request and complete source: `/app/contract.sol` (SHA-256 `f4bcfc92c70fc8196e8802abb9dbff0ebbc05cb6f18a1e6621ad63362d90cf0e`).
- Runtime target: `/app/contract.bin` (6,955 bytes; SHA-256 `65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82`).
- Candidate artifacts: `/app/output/spec.k`, `verification.k`, `runtime.k`, and `SCOPE.md`.
- Construction session `f0df5f9e-5a29-4f02-b383-b202d5972853`, pinned to `evm` commit `4f4c3843076c`.

## Formal theorem restatement

`allowance-success` starts the supplied runtime at PC 0 with empty stack and memory, canonical ABI calldata for arbitrary 160-bit `src` and `guy`, zero call value, disabled gas accounting, BYZANTIUM schedule, and an arbitrary storage map for an arbitrary well-formed contract account. If execution reaches its stated terminal configuration, it must halt successfully, preserve storage, and return one 32-byte word equal to the EVM storage lookup at `#hashedLocation("Solidity", 2, SRC GUY)`.

`allowance-nonpayable-reverts` has the same symbolic addresses, calldata, runtime, and storage but quantifies over every call value in `[1, 2^256 - 1]`. Its terminal configuration must be `EVMC_REVERT` with empty output and unchanged storage.

## Adequacy checks

### B1 — input-domain alignment

PASS. Both Solidity address arguments cover their full 160-bit domains and storage remains symbolic rather than being reduced to examples. The successful canonical call has the source-required zero value. The failure claim covers the complete nonzero uint256 call-value domain of the generated nonpayable guard. The stated exclusions concern different entry contracts (malformed calldata, gas bounds, and transaction validation) and are explicit in `SCOPE.md`.

### B2 — language-model adequacy

PASS. The claims execute the exact runtime under the pinned EVM definition. BYZANTIUM is sufficient for the bytecode’s `REVERT` opcode, and disabling gas is explicitly part of the theorem rather than an unstated model substitution. Address and word ranges use semantics-provided predicates. Missing storage entries are correctly interpreted through the fixed semantics’ `#lookup` function as zero.

### B3 — summary-to-property adequacy

PASS. `VERIFICATION-SUMMARIES` defines no result summary. The postcondition uses the fixed EVM storage-location and lookup functions directly. The only candidate definition is the runtime byte constant; independent decoding produced 6,955 bytes identical byte-for-byte to `contract.bin` with the same SHA-256.

### B4 — implementation-to-intent alignment

PASS. The source returns `_approvals[src][guy]`. Runtime inspection at dispatcher selector `0xdd62ed3e` routes through entry PC `0x62c`; its nonpayable guard reverts on nonzero `CALLVALUE`. The body at PC `0x11bc` pushes base slot 2, hashes it with `src`, hashes that result with `guy`, then performs `SLOAD`. This agrees with the nested-mapping term in the successful postcondition and the stated failure behavior.

## Chosen readings

All material choices are recorded in `SCOPE.md`: canonical ABI calls, nonzero-value rejection as the unsuccessful allowance call, nested mapping base slot 2, BYZANTIUM schedule, disabled gas, direct non-static call context, and partial-correctness scope. No unrecorded model boundary or domain restriction was found.

## Mechanical checks

Command:

`kprover validate --project /app --session f0df5f9e-5a29-4f02-b383-b202d5972853 --semantics evm --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/runtime.k`

Exit status: 0. Backend task `9dbf59ef-9b35-47b2-aa86-ef7c4724e7cd` completed with `valid: true`; evidence is retained in `validation-002/result.json`.

The session-input copies of `spec.k`, `verification.k`, and `runtime.k` compare byte-for-byte equal to the audited output copies. Symbol names parse correctly after replacing the initially reserved token `CALLER` with `MSGSENDER`.

No adequacy or summary-faithfulness findings remain.

VERDICT: PASS
REASON: The symbolic claims faithfully cover canonical allowance success and its complete nonzero-value rejection branch while executing the exact supplied runtime and preserving storage.

