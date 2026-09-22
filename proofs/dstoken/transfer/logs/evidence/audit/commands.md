# Exact audit client invocations

All operations below used the same retained audit session and the caller-provided `XDG_CONFIG_HOME`. The private `*-invocation.json` files retain its exact resolved value, process IDs, and client timestamps. No command used claim filtering, trusted claims, or a depth bound.

```sh
: "${XDG_CONFIG_HOME:?Set the retained isolated configuration}"
export XDG_CONFIG_HOME
```

## replay-validation

```sh
kprover validate --session 1780f457-da0a-48bc-b9fe-eaf832efe9fb --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k
```

Task `4bff38cf-6ae2-4e9d-88e9-2e955c893b31`; CLI exit `0`; K/tool exits `[0]`.

Evidence: [validation-001/result.json](session-1780f457-da0a-48bc-b9fe-eaf832efe9fb/validation-001/result.json).

## replay

```sh
kprover prove --session 1780f457-da0a-48bc-b9fe-eaf832efe9fb --spec inputs/spec.k --spec-module SPEC --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k
```

Task `487c0300-1608-4ca7-a68e-f0a7cc13e39f`; CLI exit `0`; K/tool exits `[0]`.

Evidence: [proof-001/result.json](session-1780f457-da0a-48bc-b9fe-eaf832efe9fb/proof-001/result.json).

## witness-validation

```sh
kprover validate --session 1780f457-da0a-48bc-b9fe-eaf832efe9fb --spec inputs/witness.k --spec-module AUDIT-WITNESS --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k
```

Task `f03306ab-d5e7-45ae-aeea-8b29db7379f0`; CLI exit `0`; K/tool exits `[0]`.

Evidence: [validation-002/result.json](session-1780f457-da0a-48bc-b9fe-eaf832efe9fb/validation-002/result.json).

## witness

```sh
kprover prove --session 1780f457-da0a-48bc-b9fe-eaf832efe9fb --spec inputs/witness.k --spec-module AUDIT-WITNESS --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k
```

Task `fca12717-e5a1-401a-89f2-ee935a1a712b`; CLI exit `0`; K/tool exits `[0]`.

Evidence: [proof-002/result.json](session-1780f457-da0a-48bc-b9fe-eaf832efe9fb/proof-002/result.json).

## false-validation

```sh
kprover validate --session 1780f457-da0a-48bc-b9fe-eaf832efe9fb --spec inputs/false.k --spec-module AUDIT-FALSE --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k
```

Task `a08038f3-8dbd-4018-b444-0864254d49ad`; CLI exit `0`; K/tool exits `[0]`.

Evidence: [validation-003/result.json](session-1780f457-da0a-48bc-b9fe-eaf832efe9fb/validation-003/result.json).

## false

```sh
kprover prove --session 1780f457-da0a-48bc-b9fe-eaf832efe9fb --spec inputs/false.k --spec-module AUDIT-FALSE --verification inputs/verification.k --verification-module VERIFICATION --source inputs/dstoken-bin.k
```

Task `a6f79d35-ae0f-425d-89e3-5f7f871512af`; CLI exit `1`; K/tool exits `[1]`.

Evidence: [proof-003/result.json](session-1780f457-da0a-48bc-b9fe-eaf832efe9fb/proof-003/result.json).

## body-validation

```sh
kprover validate --session 1780f457-da0a-48bc-b9fe-eaf832efe9fb --spec inputs/body/spec.k --spec-module AUDIT-BODY --verification inputs/body/verification.k --verification-module VERIFICATION --source inputs/body/dstoken-bin.k
```

Task `80175f9c-91a2-486a-9ec4-39e52bc5e5a6`; CLI exit `1`; K/tool exits `[]`.

Evidence: [validation-004/result.json](session-1780f457-da0a-48bc-b9fe-eaf832efe9fb/validation-004/result.json).

## body-root-validation

```sh
kprover validate --session 1780f457-da0a-48bc-b9fe-eaf832efe9fb --spec inputs/body-spec.k --spec-module AUDIT-BODY --verification inputs/body-verification.k --verification-module VERIFICATION --source inputs/body-dstoken-bin.k
```

Task `a13ee45e-2af9-4b69-9e88-80646110ae2f`; CLI exit `0`; K/tool exits `[0, 0]`.

Evidence: [validation-005/result.json](session-1780f457-da0a-48bc-b9fe-eaf832efe9fb/validation-005/result.json).

## body

```sh
kprover prove --session 1780f457-da0a-48bc-b9fe-eaf832efe9fb --spec inputs/body-spec.k --spec-module AUDIT-BODY --verification inputs/body-verification.k --verification-module VERIFICATION --source inputs/body-dstoken-bin.k
```

Task `e7de0ffb-acbe-4f90-b592-edbdab05c743`; CLI exit `1`; K/tool exits `[1]`.

Evidence: [proof-004/result.json](session-1780f457-da0a-48bc-b9fe-eaf832efe9fb/proof-004/result.json).

## Independent file inspection

```sh
python3 audit/inspect.py
python3 audit/collect-evidence.py
python3 audit/finalize-reports.py
```

The inspection and collection commands exited 0. This report generator requires all positive outcomes and the exact two output mismatches before writing a verdict. It submits no task.
