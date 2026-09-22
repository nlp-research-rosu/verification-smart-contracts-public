# Specification audit 1

## Artifacts examined

- `/app/contract.sol`
- `/app/contract.bin`
- `/app/output/spec.k`
- `/app/output/verification.k` (`VERIFICATION-SUMMARIES`)
- `/app/output/SCOPE.md`
- Construction session `00599ca4-f253-4bff-8222-619c376a46e8`, semantics `evm` at `4f4c3843076c`

## Commands and mechanical evidence

- `wc -c /app/contract.bin`: exit 0; reported 161 bytes.
- `od -An -v -tx1 /app/contract.bin | tr -d ' \n'`: exit 0; byte-for-byte hex equals the argument of `#parseByteStack` in `#storageVar00Runtime`.
- `sha256sum /app/contract.bin`: exit 0; `d4f641117a2c9887cd8788c822a2b80852c6664e52f60f2b27e5e6300dbf2172`.
- `kprover validate --session 00599ca4-f253-4bff-8222-619c376a46e8 --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION`: exit 0; `validation-002`, backend `valid: true`.

## Plain-language restatement

The success claim starts the exact runtime at PC 0 with canonical `execute()` calldata, zero value, disabled gas, and a symbolic account whose storage explicitly contains slot 0 mapped to uint256 `N`. It requires successful termination, ABI word `N`, and the same complete storage. The failure claim uses the same state with a symbolic nonzero uint256 call value and requires an empty revert with storage unchanged.

## Findings

### A1 — input storage is silently narrowed

The task asks for symbolic storage and the source reads Solidity slot 0, whose EVM meaning is zero when the key is absent. Both formal LHSs require `<storage> (0 |-> N) STORAGE </storage>`, while `SCOPE.md` claims the entire uint256 storage-value domain. Concrete witness: the valid empty map `.Map` represents an uninitialized contract and `SLOAD 0` returns zero, but it cannot match a map pattern that explicitly contains key 0. The theorem therefore omits an implemented execution state. The repair is to quantify the complete map directly and specify the return as `#lookup(STORAGE, 0)`.

### A2 — scope records the wrong byte length

`SCOPE.md` calls the supplied runtime “128 bytes,” but `wc -c` witnesses 161 bytes. The formal helper contains all 161 bytes, so this is a scope-record defect rather than an incorrect program term.

## Summary faithfulness

The only candidate summary is the nullary `#storageVar00Runtime`. Its single unconditional equation is total, non-overlapping, terminating, and byte-for-byte faithful to `/app/contract.bin`. It has no input boundaries or worked examples to differential-test. The function selector `61461954` visible in the runtime agrees with the canonical `execute()` calldata used by the claims.

VERDICT: FAIL
TARGET: writing-spec
REASON: The claims exclude the valid absent-slot-zero storage representation, and the scope misstates the runtime length.
