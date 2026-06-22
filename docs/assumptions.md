# Assumptions

## Current assumptions in the MATLAB simulations

| Item | Assumed value/detail | Reason | Used in |
|---|---:|---|---|
| Random seed | `rng(1)` | Required for reproducibility. | `mimo_dps_kaltenberger.m`, `tai lieu/mimo_dps_kaltenberger_approx.m` |
| MPC distribution | Uniform within bounded Doppler, delay, AoD, and AoA regions | The scripts test the DPS representation and approximation, not a standardized channel scenario. | Both MATLAB scripts |
| MPC weight distribution | Circular complex Gaussian with total expected power near 1 | Common Rayleigh-style assumption; not a full reproduction of one specific paper figure. | Both MATLAB scripts |
| Frequency index set | `q = 0, ..., Q-1` | Simpler implementation; the paper also discusses centered frequency indices in Eq. (60). This changes phase convention but not the basic subspace test. | Both MATLAB scripts |
| DPS dimension rule | Essential dimension plus `guard = 4` | The paper selects dimensions from a target bias/precision. The scripts use a conservative heuristic for current experiments. | Both MATLAB scripts |
| Resolution factors | `r_t = 2`, `r_f = 512`, `r_tx = 512`, `r_rx = 512` | The paper uses resolution factors to reduce wave-function approximation error. Wider normalized-bandwidth dimensions require larger values. | `tai lieu/mimo_dps_kaltenberger_approx.m` |
| Exact DPS branch | Exact one-dimensional projection by matrix multiplication | Used as a diagnostic reference for subspace accuracy and for comparison with approximate coefficients. | Both MATLAB scripts |
| Approximate DPS 4D branch | DPS wave-function approximation is applied to time, frequency, Tx, and Rx dimensions | Tests direct multidimensional use of the paper-style approximation. | `tai lieu/mimo_dps_kaltenberger_approx.m` |
| Hybrid branch | Approximate DPS is applied in time/frequency; spatial dimensions are evaluated by direct exponentials | Matches the paper's practical recommendation that spatial DPS often gives limited complexity reduction in wideband MIMO. | `tai lieu/mimo_dps_kaltenberger_approx.m` |
| Hardware precision target | Discussed theoretically but not used as an automatic design constraint | The current scripts do not automatically choose `D` and `r` from `Emax`; they use fixed heuristic values. | Both MATLAB scripts |

## Verification status

The approximate script implements a paper-style wave-function coefficient approximation and a hybrid method. It has reproducible outputs, but it has not yet been validated against one selected figure/table from the paper with all parameters matched exactly.
