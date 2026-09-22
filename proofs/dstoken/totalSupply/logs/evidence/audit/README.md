# Proof-audit evidence manifest

Audit session: `c9daec22-c065-4961-a57f-e2633a3988cc`.

Construction and audit sessions both pin semantics ID `evm`, repository
`https://github.com/nlp-research-rosu/semantics-evm`, commit
`4f4c3843076c`. The fetched bundled sources remained in the shared kprover
cache and were not copied into this evidence tree.

## Layout

- `artifacts/output/` and `artifacts/project/` are the audit snapshots of the
  supplied on-disk artifacts.
- `session-c9daec22-c065-4961-a57f-e2633a3988cc/inputs/` contains the three
  clean-room positive proof sources and the audit-authored mutation sources.
- `validation-NNN/result.json` and `proof-NNN/result.json` are the unmodified
  Prover evidence files. Each contains the task ID, typed result, final K tool
  exit code, stdout, and stderr.

## Artifact checksums

```text
eb1dbf5f7c3e7e875b5bac50baca4513a7dc0de573afe94f86c494d109c08893  output/spec.k
ce17116341d12b53b73f3647b5ca0d47d4ed585e616f17da1fd7ba82aaa5c958  output/verification.k
7517f1cc63f9f3ac2cbdc4d5d28823f7e7d6fe663e6ab63fc1437d870b4d52d3  output/dstoken-bin.k
5699524fc13b07d9859ba3211de6a5bad5981ba775587d5ac89af7630dbfb674  output/SCOPE.md
7a87e2809e485ade2b837f8c3ce443a5ea1356ad5c3417148405da33b8aa8c2a  output/prove.sh
bf0c92c2f49ef6ffa855c6aa5e955b7558dcdb527f83116e8d83dfcc3a0ad2ba  output/audits/spec-audit-1.md
f4bcfc92c70fc8196e8802abb9dbff0ebbc05cb6f18a1e6621ad63362d90cf0e  contract.sol
65b311134fbf066c074dfd609dc8e1048629e20e885636da2ea3b52932231a82  contract.bin
```

The extracted `#parseByteStack` payload in `dstoken-bin.k` was compared to
`od -An -v -tx1 contract.bin | tr -d ' \n'`; the comparison exited 0. The
binary size is 6,955 bytes. Static byte windows were:

```text
000060 c2 57 80 63 18 16 0d dd 14 61 01 fb 57 80 63 23
000070 b8 72 dd 14 61 02 24 57
0001fb 5b 34 15 61 02 06 57 60 00 80 fd 5b 61 02 0e 61
00020b 09 57 56 5b 60 40 51 80 82 81 52 60 20 01 91 50
000957 5b 60 00 80 54 90 50 90 56 5b 60 00 60 04 60 14
```

The body-sensitivity mutation changes exactly byte offset `0x959` from `00`
to `01`, turning the body prefix `PUSH1 0; DUP1; SLOAD` into
`PUSH1 1; DUP1; SLOAD`. The source-file `cmp -l` reports only:

```text
5071  60  61
```

## Task index

| Evidence | Task | Result |
|---|---|---|
| `validation-001/result.json` | `5a11bbd3-bbee-4ae7-b10d-68f24ca8a77a` | valid, exit 0 |
| `validation-002/result.json` | `dce46b69-b159-4c73-a647-3b9119227ad6` | mutation valid, exit 0 |
| `validation-003/result.json` | `d70f75fe-d0f4-43fb-8241-93c7acdd7057` | path-layout preparation failure; no K tool run |
| `validation-004/result.json` | `b5cb4fd9-344b-421d-bd56-647cc4d302e6` | relocated body mutation valid, exit 0 |
| `proof-001/result.json` | `ab5cd61b-0ac6-4dcd-9432-16f8a90e0b79` | proved, exit 0, `PROOF PASSED: SPEC.totalSupply-success` |
| `proof-002/result.json` | `4e623e8b-9f3f-4925-aa9e-38b3bd0086d6` | proved, exit 0, `PROOF PASSED: SPEC.totalSupply-nonzero-value-reverts` |
| `proof-003/result.json` | `7b946812-c2a2-4fc2-8312-a00985f733a8` | notProved, exit 1, result mismatch |
| `proof-004/result.json` | `52008ac3-6228-4e80-97ff-dc21c6d463a9` | notProved, exit 1, body-sensitivity mismatch |

The audit session ended with four validations and four proof attempts. No
submission used `--trusted` or `--depth`.
