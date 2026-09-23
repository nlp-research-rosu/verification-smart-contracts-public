# Verification metrics

The published proof packages cover 15 selected function targets and 50 proved
claims across four projects. All 14 packages have complete proofs and passing
independent KIT audits. [Verification status](STATUS.md) links each target to
its proof package.

| Project | Proved targets | Proved claims | Median minutes: proof / verification | Input tokens | Cached input | Output tokens | Estimated AI cost |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| HackerGold (HKG) | 6 / 6 | 15 / 15 | 37.7 / 63.0 | 157,550,964 | 154,774,528 | 422,205 | $81.46 |
| DSToken | 6 / 6 | 28 / 28 | 16.8 / 46.8 | 149,267,850 | 146,764,928 | 427,152 | $77.26 |
| DSValue | 2 / 2 | 5 / 5 | 22.5 / 39.0 | 12,624,914 | 12,379,136 | 55,618 | $7.05 |
| storagevar00 | 1 / 1 | 2 / 2 | 13.3 / 29.4 | 10,883,735 | 10,631,936 | 45,900 | $6.18 |
| **Total** | **15 / 15** | **50 / 50** | — | **330,327,463** | **324,550,528** | **950,875** | **$171.95** |

The proved target and claim counts describe the published proof packages. Time
and token counts are recorded GPT-5.6 Sol measurements for these targets. Proof time is
measured to the first complete candidate proof, while verification time covers
the whole measured activity. Proof-time medians include only completed candidate
proofs (five of six measured DSToken targets); verification-time medians include
all measured targets. DSValue's measurements cover `peek` and `read` together.
Input tokens include cached input; output tokens include reasoning tokens.
DSToken's 28 proved claims comprise 22 target claims and six auxiliary
`transfer` claims; the first-pass results count target claims separately.

Estimated AI cost uses the recorded input, cached input and output tokens at
[published GPT-5.6 Sol API prices](https://developers.openai.com/api/docs/models/gpt-5.6-sol).
It is an estimate for the measured activity, not a billed charge.
