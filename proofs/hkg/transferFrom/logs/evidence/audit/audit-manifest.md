# Proof-audit evidence manifest

Audit session: `2579e61c-a36a-4955-8f43-da6c9ce35ffb`

Construction session supplied for pin comparison only: `b35c50df-236f-408a-864d-02f003f9759e`

Both sessions report semantics ID `evm`, repository
`https://github.com/nlp-research-rosu/semantics-evm`, commit
`4f4c3843076c`.

## Candidate hashes

```text
af2fe1549c5e54a93edcdc84ad82ec102e90ccda05c52e6770442bee244011c6  /app/output/spec.k
ff7dc0f5ab11bdacd889f5392db48d1427e3666d3f7c9509001ceb6c98aa8c19  /app/output/verification.k
51b557e32ddcf2ba16f2da32c1dc94f1f1b777eb931a8a4904539f52fe545541  /app/output/hkg-bin-runtime.k
243b09b3926640db60db8bbea7e0921dfdfd9386cc5298088afe6e2a2b6ec5fe  /app/output/SCOPE.md
05a23942c055e11d7a1ea79290f772f2c939243fa93301c528e5a7cd2dcb0035  /app/output/prove.sh
cee59f7cb8d3245e61fab5bb037753500cf71e19be40184acb1a8306dc05106b  /app/contract.sol
71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73  /app/contract.bin
90d4e9d2e7b3d3bb183f36a59badc79bc709c254fa4f847a02c71b5a83649c90  /app/output/audits/spec-audit-1.md
```

The three clean-room input copies compare byte-for-byte equal to their
candidate sources. Reconstructing every `\\xNN` byte in
`hkg-bin-runtime.k` produced 2,091 bytes and SHA-256
`71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`,
identical to the 2,091-byte `/app/contract.bin`.

## Retained client evidence

- `positive-validation-result.json`: validation task
  `4341e9aa-f4d2-4b02-ae7c-295c81419e5f`, valid, K exit 0.
- `positive-proof-result.json`: unfiltered positive task
  `7c658e49-b3e2-498d-a8ea-cd6a41319767`, outcome `proved`, K exit 0;
  stdout lists all four claims as `PROOF PASSED` and stderr contains only the
  non-booster equation-option warning.
- `spec-mutation.k`: independently authored false-output mutation, SHA-256
  `e67f1a048b1f410c983284de47b9abf182cb51bcc2b33b3041b6a37419abf051`.
- `mutation-validation-result.json`: mutation validation task
  `4ce9476c-f8e4-4acc-ba2c-4d753833e50b`, valid, K exit 0.
- `mutation-proof-result.json`: mutation proof task
  `abf25e0f-c41d-4577-85d2-55899348a2d7`, outcome `notProved`, K exit 1;
  stdout records the actual output word ending in `01`, the demanded all-zero
  output word, and path condition `#Top`. Stderr records fail-fast termination
  after the failing node was found.

## Semantics-source check

`kprover semantics fetch evm` returned the repository and commit above at
`/home/node/.config/kprover/semantics/nlp-research-rosu/semantics-evm/4f4c3843076c`.
`diff -qr` against `/app/semantics` produced no differences. The candidate
uploads no semantics sources; `LEMMAS` and `EDSL` therefore resolve from this
immutable bundled revision.
