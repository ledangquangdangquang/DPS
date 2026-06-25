# Assumptions

## Current assumptions in the MATLAB simulations

| Item | Assumed value/detail | Reason | Used in |
|---|---:|---|---|
| Random seed | `rng(1)` | Required for reproducibility. | `mimo_dps_kaltenberger.m`, `tai lieu/mimo_dps_kaltenberger_approx.m` |
| MPC distribution | Uniform within bounded Doppler, delay, AoD, and AoA regions | The scripts test the DPS representation and approximation, not a standardized channel scenario. | Both MATLAB scripts |
| MPC weight distribution | Circular complex Gaussian with total expected power near 1 | Common Rayleigh-style assumption; not a full reproduction of one specific paper figure. | Both MATLAB scripts |
| Frequency index set | `q = 0, ..., Q-1` | Simpler implementation; the paper also discusses centered frequency indices in Eq. (60). This changes phase convention but not the basic subspace test. | Both MATLAB scripts |
| DPS dimension rule | Essential dimension plus `guard = 4` | The paper selects dimensions from a target bias/precision. The scripts use a conservative heuristic for current experiments. | Both MATLAB scripts |
| Adaptive DPS error allocation | The total square-bias target is divided equally among time, frequency, Tx, and Rx dimensions | Paper Eq. (35) and Eq. (38) provide a one-dimensional criterion but do not prescribe a single error-budget allocation for the separable four-dimensional implementation. | `scripts/mimo_dps_adaptive_dimension.m` |
| Adaptive DPS verification | MPC frequencies are independently uniform inside each band and NMSE is summarized by median/IQR over 20 seeds | The uniform-band assumption matches the condition for paper Eq. (35); multiple seeds reduce dependence on one realization. | `scripts/mimo_dps_adaptive_dimension.m` |
| Resolution factors | `r_t = 2`, `r_f = 512`, `r_tx = 512`, `r_rx = 512` | The paper uses resolution factors to reduce wave-function approximation error. Wider normalized-bandwidth dimensions require larger values. | `tai lieu/mimo_dps_kaltenberger_approx.m` |
| Exact DPS branch | Exact one-dimensional projection by matrix multiplication | Used as a diagnostic reference for subspace accuracy and for comparison with approximate coefficients. | Both MATLAB scripts |
| Approximate DPS 4D branch | DPS wave-function approximation is applied to time, frequency, Tx, and Rx dimensions | Tests direct multidimensional use of the paper-style approximation. | `tai lieu/mimo_dps_kaltenberger_approx.m` |
| Hybrid branch | Approximate DPS is applied in time/frequency; spatial dimensions are evaluated by direct exponentials | Matches the paper's practical recommendation that spatial DPS often gives limited complexity reduction in wideband MIMO. | `tai lieu/mimo_dps_kaltenberger_approx.m` |
| Hardware precision target | Discussed theoretically but not used as an automatic design constraint | The current scripts do not automatically choose `D` and `r` from `Emax`; they use fixed heuristic values. | Both MATLAB scripts |
| MPC-count sweep | For each of 20 seeds, the first `P` entries of a pool with `P_max = 320` are reused and the complex weights are renormalized by `sqrt(2*P)` | This creates power-normalized nested scenarios for comparing the effect of `P`; it is not an exact incremental addition of MPCs to an otherwise unchanged channel. | `tai lieu/mimo_dps_kaltenberger_p_sweep.m` |
| Sweep runtime measurement | One fixed data realization, 10 post-warm-up repetitions, median and interquartile range; DPS-basis construction excluded | Separates runtime variability from random-channel variability and reduces JIT/start-up effects. | `tai lieu/mimo_dps_kaltenberger_p_sweep.m` |
| Paper Figure 4 plotting style | MATLAB markers, title, legend, and grid are added while preserving the paper's stated parameters and logarithmic eigenvalue scale | The paper provides the curve and caption but not its original plotting source or numerical data. | `scripts/reproduce_paper_figure4.m` |
| Four-method CE-BEM grid | The CE-BEM frequencies are uniformly spaced over each physical band, with dimensions `(6,9,4,4)` equal to the fixed DPS dimensions; coefficients are obtained by one-dimensional least-squares projection | This isolates the effect of the Fourier and DPS bases at the same coefficient count; the paper does not prescribe a CE-BEM comparator. | `scripts/mimo_four_method_benchmark.m` |
| Four-method timing | Runtime uses one fixed realization, 10 post-warm-up repetitions and median/IQR; basis construction is measured separately | This separates reusable preprocessing from per-block work and permits an amortized break-even calculation. | `scripts/mimo_four_method_benchmark.m` |
| Break-even reuse | The band limits and block dimensions remain unchanged while CE-BEM or DPS bases are reused across channel blocks | A basis must be rebuilt when these parameters change, so the reported block-count break-even would no longer apply. | `scripts/mimo_four_method_benchmark.m` |

## Verification status

The approximate script implements a paper-style wave-function coefficient approximation and a hybrid method. It has reproducible outputs, but it has not yet been validated against one selected figure/table from the paper with all parameters matched exactly.
