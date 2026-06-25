# Paper Notes: Low-Complexity Geometry-Based MIMO Channel Simulation

Paper: Florian Kaltenberger, Thomas Zemen, Christoph W. Ueberhuber, "Low-Complexity Geometry-Based MIMO Channel Simulation", EURASIP Journal on Advances in Signal Processing, 2007.

## Main problem

Geometry-based channel models compute the channel as a sum of many complex exponentials, one per multipath component (MPC). For time-variant wideband MIMO channels, this is expensive because the channel depends on time, frequency, transmit antenna index, and receive antenna index.

## Proposed method in the paper

The paper represents the sampled channel in a truncated multidimensional discrete prolate spheroidal (DPS/DPSS) subspace. The key observation is that the channel is band-limited in each dimension, so an index-limited block of samples has a small effective subspace dimension.

For multidimensional channels, the paper uses separable DPS bases when the band-limiting region and index set are Cartesian products. The multidimensional coefficients can then be formed from products of one-dimensional coefficients.

The paper further proposes an approximate DPS wave-function method for computing each one-dimensional coefficient from the MPC frequency location. This avoids first evaluating the complete SoCE channel block.

## MATLAB scripts currently available

### `mimo_dps_kaltenberger.m`

Baseline script. It compares:

- `H_soce`: reference channel computed directly by SoCE.
- `H_dps`: channel reconstructed from a truncated four-dimensional DPS subspace.

The DPS coefficients are computed by exact one-dimensional projection:

`Gamma = V' * E`

This validates subspace accuracy but is not the approximate wave-function coefficient algorithm.

### `tai lieu/mimo_dps_kaltenberger_approx.m`

Approximate script. It compares:

- SoCE reference channel.
- Exact DPS projection, used as a diagnostic reference.
- Approximate DPS wave-function projection in all four dimensions.
- Hybrid approximate method: approximate DPS in time/frequency and direct spatial exponentials in Tx/Rx.

This script is the primary source for writing the simulation-result chapter because it includes the approximation and hybrid method discussed in the paper.

## Input variables in the MATLAB scripts

- `M`: number of time samples.
- `Q`: number of frequency bins.
- `N_Tx`: number of transmit antennas.
- `N_Rx`: number of receive antennas.
- `P`: number of MPCs.
- `eta`: complex MPC weight.
- `nu`: normalized Doppler shift.
- `theta`: normalized delay.
- `zeta`: normalized angle of departure spatial frequency.
- `xi`: normalized angle of arrival spatial frequency.

## Key equations used

- Eq. (45): continuous time-variant wideband MIMO GCM.
- Eq. (47): sampled multidimensional SoCE representation.
- Eq. (48): maximum normalized Doppler shift.
- Eq. (51): band-limiting region in time, frequency, and spatial dimensions.
- Eq. (23)-(29): approximate DPS wave-function coefficient calculation.
- Eq. (61)-(63): multidimensional DPS subspace representation and projection.
- Theorem 3: multidimensional DPS basis/projection can be decomposed into one-dimensional bases/projections for Cartesian product regions.

## Simulation parameters currently used

- Carrier frequency: `fc = 2e9` Hz.
- Maximum velocity: `vmax = 100/3.6` m/s.
- Sampling time: `Ts = 1/3.84e6` s.
- Frequency bin width: `Fbin = 15e3` Hz.
- Maximum delay: `tau_max = 3.7e-6` s.
- Antenna spacing: `d_over_lambda = 0.5`.
- AoD and AoA ranges: `[-5, 5]` degrees.
- Simulation block: `M = 256`, `Q = 64`, `N_Tx = 4`, `N_Rx = 4`, `P = 80`.
- DPS dimensions: `D_t = 6`, `D_f = 9`, `D_tx = 4`, `D_rx = 4`.
- Resolution factors in approximate script: `r_t = 2`, `r_f = 512`, `r_tx = 512`, `r_rx = 512`.

## Current generated outputs

Baseline exact-projection output:

- `results/figures/mimo_dps_kaltenberger_tx1_rx1.png`
- `results/figures/mimo_dps_kaltenberger_tx1_rx1.fig`
- `results/tables/mimo_dps_kaltenberger_metrics.csv`

Approximate and hybrid output:

- `results/figures/mimo_dps_kaltenberger_approx_tx1_rx1.png`
- `results/figures/mimo_dps_kaltenberger_approx_tx1_rx1.fig`
- `results/tables/mimo_dps_kaltenberger_approx_metrics.csv`

## Latest approximate-script metrics

For `M = 256`, `Q = 64`, `N_Tx = 4`, `N_Rx = 4`, `P = 80`:

- Exact DPS vs SoCE: `NMSE = 8.53410711296342e-09`.
- Approximate DPS 4D vs SoCE: `NMSE = 1.99476804943589e-04`.
- Hybrid approximate TF + exact spatial vs SoCE: `NMSE = 4.28714349593195e-07`.
- Hybrid approximate vs exact DPS: `NMSE = 4.20180246065843e-07`.

The hybrid result is the most relevant approximation result for the thesis because it follows the paper's practical recommendation for wideband MIMO: apply DPS in time/frequency and evaluate spatial exponentials directly.

## Verification status

The approximate wideband-MIMO script implements a paper-style DPS wave-function coefficient approximation and a hybrid method, but its channel-error results have not yet been matched against a specific wideband-MIMO figure or table from the paper. Separately, an original MATLAB plot of DPS eigenvalue decay has been generated using the parameter set reported for the paper's Figure 4 and the DPS definition in Eq. (6).

## Four-method implementation benchmark

`scripts/mimo_four_method_benchmark.m` compares direct SoCE, recursive SoCE, CE-BEM, and exact 4D DPS on the same reproducible MPC realizations. It sweeps `P = [5, 10, 20, 40, 80, 160, 320]`, evaluates NMSE over 20 seeds, and measures runtime with 10 post-warm-up repetitions. CE-BEM and DPS use the same dimensions `(6,9,4,4)`. Basis setup is measured separately so Chapter 4 can distinguish the MPC break-even from the number of reused channel blocks needed to amortize preprocessing.

This benchmark is an implementation-level comparison under the thesis simulation assumptions; it is not a reproduction of a numerical table in Kaltenberger et al.

## DPS eigenvalue illustration using the paper's example parameters

Paper Figure 4 plots the first ten eigenvalues of the one-dimensional DPS concentration problem for `M0 = 0`, `M = 256`, and `M*nu_Dmax = 2`. The corresponding one-sided normalized half-bandwidth is `nu_Dmax = 2/256 = 0.0078125`, and the paper defines the essential dimension as `D_prime = ceil(2*M*nu_Dmax) + 1 = 5`.

MATLAB source:

- `scripts/reproduce_paper_figure4.m`

Generated outputs:

- `results/figures/paper_figure4_dps_eigenvalues.png`
- `results/figures/paper_figure4_dps_eigenvalues.fig`
- `results/tables/paper_figure4_dps_eigenvalues.csv`

Interpretation: `lambda_d` is the fraction of the energy of DPS sequence `d` concentrated in the target index interval. The rapid eigenvalue decay after the transition region shows that a length-256 band-limited sequence has only a small effective number of degrees of freedom for this narrow Doppler band. The plot is generated independently in MATLAB from the stated parameterization; it is not copied from the paper.

## Automatic DPS-dimension selection

Paper Eq. (35) expresses the one-dimensional exact-subspace square bias using the sum of omitted DPS eigenvalues. Paper Eq. (38) selects the smallest dimension whose square bias is below the maximum allowable error.

The script `scripts/mimo_dps_adaptive_dimension.m` applies this criterion independently to the time, frequency, Tx, and Rx dimensions. A total design target is divided equally among the four dimensions as an engineering assumption for the separable 4D implementation. Exact DPS projection is used for verification so that measured error represents subspace truncation rather than approximate wave-function coefficient error.

Verification uses 20 reproducible MPC realizations for total targets `1e-2`, `1e-4`, `1e-6`, and `1e-8`, plus the existing fixed `guard = 4` rule. Outputs are saved as:

- `results/tables/mimo_dps_kaltenberger_adaptive_dimension_metrics.csv`
- `results/figures/mimo_dps_kaltenberger_adaptive_dimension_nmse.png`
- `results/figures/mimo_dps_kaltenberger_adaptive_dimension_nmse.fig`
