# Verification metrics

The five projects below cover 21 selected function targets and 70 proved
claims. [Verification status](STATUS.md) links each function to its proof
package and audit result.

| Project | Proved targets | Proved claims | Minutes: first proof / verification | Input tokens | Cached input | Output tokens | Estimated AI cost |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| HackerGold (HKG) | 6 / 6 | 15 / 15 | 37.7 / 63.0 | 157,550,964 | 154,774,528 | 422,205 | $81.46 |
| DSToken | 6 / 6 | 28 / 28 | 16.8 / 46.8 | 149,267,850 | 146,764,928 | 427,152 | $77.26 |
| DSValue | 2 / 2 | 5 / 5 | 22.5 / 39.0 | 12,624,914 | 12,379,136 | 55,618 | $7.05 |
| storagevar00 | 1 / 1 | 2 / 2 | 13.3 / 29.4 | 10,883,735 | 10,631,936 | 45,900 | $6.18 |
| Optimism L1 pausability | 6 / 6 | 20 / 20 | 149.1 / 521.2 | 180,719,796 | 178,968,064 | 188,646 | $82.37 |
| **Total** | **21 / 21** | **70 / 70** | — | **511,047,259** | **503,518,592** | **1,139,521** | **$254.32** |

Optimism used one agent across six functions and continued the same work after
feedback. HKG and DSToken used a fresh agent per function, repeatedly loading
the verification skill and contract context (input tokens) and repeating setup
and reasoning (output tokens); this helps explain their higher output totals.
The first four projects report time medians across their selected runs, while
Optimism reports 149.1 minutes to its first complete six-function proof and
521.2 minutes across its initial work and feedback continuations.
