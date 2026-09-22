# Bytecode dispatch evidence

Source artifact: `/app/contract.bin` (2,091 raw bytes).

Reproducible command:

```sh
od -An -v -tx1 -N128 /app/contract.bin
```

The dispatcher prefix contains these `PUSH4` selector constants:

```text
095ea7b3  approve(address,uint256)
23b872dd  transferFrom(address,address,uint256)
70a08231  balanceOf(address)
a9059cbb  transfer(address,uint256)
dd62ed3e  allowance(address,address)
```

It contains no `18160ddd` (`totalSupply()`). After the last failed comparison,
the bytes at offsets `0x006d`--`0x0071` are `5b 60 00 80 fd`, namely
`JUMPDEST PUSH1 0 DUP1 REVERT`.

The exact runtime embedding can be checked byte-for-byte with:

```sh
cmp -s /app/contract.bin <( \
  sed -n 's/.*#parseByteStack("\([0-9a-f]*\)").*/\1/p' /app/output/spec.k \
    | head -n 1 | tr -d '\n' \
    | perl -pe 's/([0-9a-f]{2})/chr(hex($1))/ge' \
)
```

This command exited 0. `sha256sum /app/contract.bin` is
`71204113356f7543f06b867ef7e7eeacfb6d512f8f7c5eb5166a2f3022d46d73`.

The formal validation and proof use the embedded bytes in `spec.k`; no bundled
semantics source is copied into the candidate.
