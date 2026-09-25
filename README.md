# From intent to verified software

The Formal Verification Kit helps AI produce software with evidence that it does what people intend. The aim is a coherent deliverable: **code, a precise specification of its behavior, and machine-checked proofs**, developed together. People review the specification against their intent. The prover checks whether the code satisfies that specification under the stated runtime rules and assumptions.

![Human intent guides AI and KIT in developing code, specifications and proofs. Specifications return to people for review; the prover checks formal claims against runtime rules and returns verification feedback to AI.](assets/intent-to-verified-software.png)

This repository measures one part of that vision: using the kit to recover specifications and obtain proofs for **existing code**. The archived experiments do not yet measure joint generation from intent. They give us a concrete starting point for measuring how much work AI can complete, what still needs specification feedback, and how quickly a revised deliverable can be checked.

## Why smart contracts?

Smart contracts are a demanding case study: software can control assets, and mistakes can be costly. Runtime Verification's earlier work also gives us reference specifications against which to compare new results. The case study uses the Ethereum Virtual Machine, the runtime that executes these programs. Its precise execution rules give the prover a shared basis for checking claims across many programs. The broader approach concerns software correctness, beyond this application domain.

The archived references give us traceable historical targets for testing how much formal work AI can complete. RV's tools have advanced since those specifications were written: [Kontrol accepts formal specifications as Solidity tests in Foundry](https://docs.runtimeverification.com/kontrol), and RV uses that workflow in its [current verification services](https://runtimeverification.com/smartcontract). The experiments here concern the historical targets; a comparison with current Kontrol workflows and harder contemporary projects remains to be measured.

## First pass and feedback pass

| Case study | First pass: function targets with complete candidate proofs | First pass: all claims checked | After human specification feedback: complete function targets | After feedback: all claims checked | Estimated AI cost |
| --- | ---: | ---: | ---: | ---: | ---: |
| HKG | 6 / 6 | 15 / 15 | 6 / 6 | 15 / 15 | $81.46 |
| DSToken | 5 / 6 | 18 / 28 | 6 / 6 | 28 / 28 | $77.26 |
| DSValue | 2 / 2 | 5 / 5 | 2 / 2 | 5 / 5 | $7.05 |
| storagevar00 | 1 / 1 | 2 / 2 | 1 / 1 | 2 / 2 | $6.18 |
| Optimism L1 pausability | 6 / 6 | 6 / 20 | 6 / 6 | 20 / 20 | $82.37 |
| **Total** | **20 / 21** | **46 / 70** | **21 / 21** | **70 / 70** | **$254.32** |

Across five case studies, the first pass proved 20 of 21 selected functions and
46 of 70 claims. After feedback, the published packages prove all 21 functions
and 70 claims. Each proof covers its stated claim and assumptions; see
[verification status](STATUS.md) for per-function evidence and
[metrics](METRICS.md) for time, tokens, and estimated cost.

## Proof packages

| Case study | Evidence |
| --- | --- |
| HKG | [Proof packages](proofs/hkg/) |
| DSToken | [Proof packages](proofs/dstoken/) |
| DSValue | [Proof package](proofs/dsvalue/peek-read/) |
| storagevar00 | [Proof package](proofs/storagevar00/execute/) |
| Optimism L1 pausability | [Proof packages](proofs/optimism-pause/) |

Each package contains its specification, scope, proof result, and reproduction
command.
