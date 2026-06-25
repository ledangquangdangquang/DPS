# Equation Mapping

## Chapter 2 DPS theory equations

Meaning: Chapter 2 introduces the theoretical comparison between direct SoCE and truncated DPS subspace representation before the full MIMO MATLAB model is presented in Chapter 3.

Thesis labels:

- `\ref{eq:ch2_1d_soce}`: one-dimensional SoCE used to explain the direct sample-wise computational cost.
- `\ref{eq:ch2_1d_soce_complexity}`: one-dimensional SoCE complexity order `O(NP)`.
- `\ref{eq:ch2_sample_vector}`: finite sample vector used for the band-limited block interpretation.
- `\ref{eq:ch2_dps_eigen}` and `\ref{eq:ch2_dps_kernel}`: one-dimensional DPS eigenvalue problem and kernel matrix.
- `\ref{eq:ch2_dps_basis}`: truncated DPS basis matrix.
- `\ref{eq:ch2_dps_reconstruction}`: DPS subspace reconstruction `h_hat^D = V alpha`.
- `\ref{eq:ch2_exact_projection}`: exact DPS projection `alpha_exact = V^H h`.
- `\ref{eq:ch2_soce_samplewise}` and `\ref{eq:ch2_dps_samplewise}`: sample-wise comparison between SoCE and DPS reconstruction.
- `\ref{eq:ch2_essential_dimension}`: one-dimensional essential DPS dimension based on the time-bandwidth product.
- `\ref{eq:ch2_dps_total_dimension}`: total number of multidimensional DPS coefficients.
- `\ref{eq:ch2_dps_total_dimension_approx}`: approximate multidimensional essential DPS dimension from the product of one-dimensional essential dimensions.
- `\ref{eq:ch2_recursive_phasor}` and `\ref{eq:ch2_recursive_soce}`: recursive phasor update for a SoCE baseline; mathematically equivalent to direct SoCE while retaining `O(P N_s)` complexity.
- `\ref{eq:ch2_ce_bem}` and `\ref{eq:ch2_ce_bem_vector}`: one-dimensional complex-exponential BEM and its matrix form, used as a theoretical Fourier-basis comparator for DPS.
- `\ref{eq:ch2_total_samples}`: total number of MIMO channel samples in one simulation block.
- `\ref{eq:ch2_soce_operation_count}`: number of MPC-sample terms required by direct SoCE.
- `\ref{eq:ch2_exact_gamma_complexity}`: exact one-dimensional DPS projection complexity.
- `\ref{eq:ch2_alpha_4d_complexity}`: 4D DPS coefficient tensor update complexity.
- `\ref{eq:ch2_4d_reconstruction_complexity}`: 4D DPS tensor reconstruction complexity.
- `\ref{eq:ch2_approx_gamma_complexity}`: approximate wave-function coefficient complexity, excluding high-resolution basis preprocessing.
- `\ref{eq:ch2_hybrid_reconstruction_complexity}`: hybrid time/frequency DPS reconstruction complexity.

MATLAB mapping:

- Exact projection: `build_alpha_exact(...)`.
- Approximate wave-function coefficients: `build_alpha_approx_4d(...)`.
- Hybrid coefficient structure: `build_alpha_approx_hybrid(...)`.

Notes:

- Chapter 2 intentionally does not report numerical NMSE or runtime values; those belong to Chapter 4 after checking `results/figures/` and `results/tables/`.
- Chapter 2 distinguishes exact DPS projection, approximate 4D DPS, and hybrid time/frequency DPS with direct spatial exponentials.
- Chapter 2 includes an operation-count estimate table based on current simulation dimensions. This is a complexity estimate, not a measured runtime result.
- Recursive SoCE and CE-BEM are theoretical comparators only. They are not yet MATLAB branches and no Chapter 4 numerical result is attributed to them.

Paper Figure 4 mapping:

- Paper Eq. (6): DPS concentration matrix implemented by `dps_eigenvalues_by_kernel(...)` in `scripts/reproduce_paper_figure4.m`.
- Paper Eq. (8): the plotted `lambda_d` is the energy-concentration ratio of DPS sequence `d`.
- Paper Eq. (11): `D_prime = ceil(2*M*nu_Dmax) + 1 = 5` for `M = 256` and `M*nu_Dmax = 2`.
- Generated values: `results/tables/paper_figure4_dps_eigenvalues.csv`.
- Thesis location: Chapter 2, Figure `\ref{fig:ch2_paper_figure4_dps_eigenvalues}`.

## Eq. (45): Continuous wideband MIMO GCM

Meaning: the continuous channel transfer function is a sum of MPCs over time, frequency, transmit antenna position, and receive antenna position.

MATLAB mapping:

- `eta(p)`: complex path weight.
- `nu(p)`: normalized Doppler term after sampling.
- `theta(p)`: normalized delay term after frequency sampling.
- `zeta(p)`: normalized AoD spatial frequency.
- `xi(p)`: normalized AoA spatial frequency.

Thesis location:

- Chapter 3 Eq. `\ref{eq:ch3_continuous_gcm}`.
- Chapter 1 only motivates the compact sampled SoCE form; it does not present the full continuous model.

## Eq. (47): Sampled multidimensional SoCE

Meaning:

`h(m,q,s,r) = sum_p eta_p exp(j*2*pi*(nu_p*m - theta_p*q + zeta_p*s - xi_p*r))`

MATLAB mapping:

- `compute_mimo_soce(...)` computes `H_soce`.
- `m`, `q`, `s`, `r` are zero-based index vectors inside the scripts and local functions.
- `tai lieu/mimo_dps_kaltenberger_approx.m` uses this as the SoCE reference for exact, approximate 4D, and hybrid comparisons.

Thesis location:

- Chapter 1 problem statement, compact SoCE Eq. `\ref{eq:ch1_soc_compact}`.
- Chapter 3 Eq. `\ref{eq:ch3_discrete_soce}` for four-dimensional SoCE.

## Chapter 3 system and simulation equations

Meaning: Chapter 3 presents the full system model, normalization, DPS subspace implementation, and MATLAB branch mapping.

Thesis labels:

- `\ref{eq:ch3_continuous_gcm}`: continuous wideband MIMO GCM over time, frequency, Tx position, and Rx position.
- `\ref{eq:ch3_normalized_variables}`: normalized Doppler, delay, AoD spatial frequency, and AoA spatial frequency.
- `\ref{eq:ch3_discrete_soce}`: sampled four-dimensional SoCE reference channel.
- `\ref{eq:ch3_band_region}`: Cartesian product band-limiting region.
- `\ref{eq:ch3_time_frequency_bands}` and `\ref{eq:ch3_spatial_bands}`: band intervals used for time, frequency, Tx, and Rx dimensions.
- `\ref{eq:ch3_doppler_delay_bounds}` and `\ref{eq:ch3_spatial_bounds}`: physical parameter bounds mapped to normalized frequencies.
- `\ref{eq:ch3_dps_band_mapping}`: shifted DPS band-center and half-bandwidth mapping used by `make_dps_dimension(...)`.
- `\ref{eq:ch3_4d_dps_reconstruction}`: four-dimensional DPS tensor reconstruction.
- `\ref{eq:ch3_total_dps_dimension}` and `\ref{eq:ch3_dps_dimension_rule}`: selected DPS dimensions in the MATLAB scripts.
- `\ref{eq:ch3_dimension_bias}`: one-dimensional omitted-eigenvalue square-bias estimate adapted from paper Eq. (35).
- `\ref{eq:ch3_dimension_error_allocation}`: equal allocation of the total design square-bias target across the four separable dimensions; this is a simulation design assumption, not a paper equation.
- `\ref{eq:ch3_adaptive_dimension_rule}`: smallest retained dimension whose omitted-eigenvalue bias meets its allocated target, following the selection principle in paper Eq. (38).
- `\ref{eq:ch3_exact_projection_coefficients}` and `\ref{eq:ch3_exact_alpha}`: exact DPS coefficient calculation.
- `\ref{eq:ch3_hybrid_alpha}`: hybrid coefficient structure with time/frequency DPS and direct spatial exponentials.

MATLAB mapping:

- `H_soce = compute_mimo_soce(...)`.
- `dim_t`, `dim_f`, `dim_tx`, `dim_rx` store DPS dimensions and bases.
- `alpha_exact = build_alpha_exact(...)`.
- `alpha_approx_4d = build_alpha_approx_4d(...)`.
- `alpha_hybrid = build_alpha_approx_hybrid(...)`.
- `H_exact`, `H_approx_4d`, and `H_hybrid` are reconstructed channels.
- `scripts/mimo_dps_adaptive_dimension.m` computes full one-dimensional eigensystems, selects `D_t`, `D_f`, `D_tx`, and `D_rx` automatically, and verifies exact-DPS truncation error over 20 seeds.

Notes:

- Chapter 3 includes parameter tables and variable mappings, but does not discuss numerical NMSE/runtime conclusions.
- The numerical results remain reserved for Chapter 4 and must be based on `results/figures/` and `results/tables/`.

## Chapter 4 result equations and sources

Meaning: Chapter 4 reports simulation results from generated MATLAB outputs only.

Thesis labels:

- Chapter 4 source statement: the prose now refers to verified tables and figures without listing technical file paths in the thesis body.
- `\ref{eq:ch4_nmse_definition}`: NMSE definition used to interpret the saved metrics.
- `\ref{eq:ch4_amortized_runtime}`: total runtime for multiple channel blocks, separating reusable setup from per-block processing.
- `\ref{eq:ch4_break_even_blocks}`: smallest integer number of reused blocks needed to amortize setup relative to direct SoCE.

Result sources:

- `results/tables/mimo_dps_kaltenberger_approx_metrics.csv`
- `results/figures/mimo_dps_kaltenberger_approx_tx1_rx1.png`
- `results/tables/mimo_dps_kaltenberger_p_sweep_metrics.csv`
- `results/tables/mimo_dps_kaltenberger_p_sweep_raw.csv`
- `results/tables/mimo_dps_kaltenberger_p_sweep_summary.csv`
- `results/figures/mimo_dps_kaltenberger_p_sweep_nmse.png`
- `results/figures/mimo_dps_kaltenberger_p_sweep_runtime.png`
- `results/tables/mimo_four_method_benchmark_summary.csv`
- `results/tables/mimo_four_method_benchmark_runtime_raw.csv`
- `results/tables/mimo_four_method_benchmark_nmse_raw.csv`
- `results/tables/mimo_four_method_benchmark_break_even.csv`
- `results/figures/mimo_four_method_benchmark_runtime.png`
- `results/figures/mimo_four_method_benchmark_nmse.png`

Notes:

- Numerical values in Chapter 4 are rounded from the CSV file.
- Runtime values are reported as MATLAB run results for the current environment and are not treated as hardware-independent complexity guarantees.
- The sweep over `P = [10, 20, 40, 80, 160, 320]` keeps the channel and DPS dimensions fixed. NMSE is summarized by the median and interquartile range over 20 seeds. Runtime is summarized by the median and interquartile range over 10 post-warm-up measurements on fixed data; DPS-basis construction is excluded.
- The authoritative sweep sources are the raw and summary CSV files. The older `mimo_dps_kaltenberger_p_sweep_metrics.csv` is retained only as a legacy single-run output and is not used for current Chapter 4 values.
- The four-method benchmark compares direct SoCE, recursive SoCE, CE-BEM, and exact 4D DPS on the same MPC realizations. CE-BEM and DPS use equal dimensions `(6,9,4,4)`. Runtime excludes reusable basis setup from per-block measurements and reports setup separately for the amortized break-even calculation.
- Chapter 4 labels `\ref{fig:ch4_four_method_runtime}`, `\ref{fig:ch4_four_method_nmse}`, and `\ref{tab:ch4_four_method_p80}` map to this benchmark.

## Eq. (48): Maximum normalized Doppler shift

Meaning:

`nu_Dmax = vmax * fc * Ts / c`

MATLAB mapping:

- `nu_Dmax = vmax * fc * Ts / c;`

Used in:

- DPS time-band selection.
- MPC Doppler sampling.
- Resolution-factor discussion for time dimension.

## Eq. (51): Band-limiting region

Meaning: the channel is band-limited in normalized Doppler, delay, AoD, and AoA spatial frequencies.

MATLAB mapping:

- Time DPS: `W0 = 0`, `Wmax = nu_Dmax`.
- Frequency DPS for `exp(-j*2*pi*theta*q)`: `W0 = -theta_max/2`, `Wmax = theta_max/2`.
- Tx spatial DPS: `W0 = (zeta_min + zeta_max)/2`, `Wmax = (zeta_max - zeta_min)/2`.
- Rx spatial DPS for `exp(-j*2*pi*xi*r)`: `W0 = -(xi_min + xi_max)/2`, `Wmax = (xi_max - xi_min)/2`.

MATLAB functions:

- `make_dps_dimension(...)`
- `shifted_dpss(...)`

## Eq. (23)-(29): Approximate DPS wave-function coefficient

Meaning: the one-dimensional projection coefficient `gamma_d(f)` can be approximated by evaluating a DPS wave-function on a higher-resolution grid, with a resolution factor `r`.

MATLAB mapping:

- `approximate_gamma_1d(frequency, dim)` computes a vector of approximate coefficients for one dimension.
- `dim.V_r` stores the high-resolution DPS basis.
- `dim.lambda_r` stores the corresponding eigenvalues.
- `dim.r` is the resolution factor.
- `mp` is the high-resolution grid index corresponding to the normalized frequency.
- `epsilon` implements the even/odd phase factor.
- `phase`, `scale`, and `v_mp` implement the adapted coefficient formula.

Important sign mapping:

- Time: `approximate_gamma_1d(nu(p), dim_t)`.
- Frequency: `approximate_gamma_1d(-theta(p), dim_f)`.
- Tx spatial: `approximate_gamma_1d(zeta(p), dim_tx)`.
- Rx spatial: `approximate_gamma_1d(-xi(p), dim_rx)`.

Thesis location:

- Chapter 2 approximate DPS wave-function subsection.
- Chapter 3 Eq. `\ref{eq:ch3_approx_alpha}` and the surrounding approximate-coefficient implementation subsection.
- Chapter 4 simulation-result discussion.

## Eq. (61)-(63): Multidimensional DPS subspace

Meaning: the channel block is approximated by a truncated DPS basis with coefficients found by projection or approximation.

MATLAB mapping:

- `dim_t.V`, `dim_f.V`, `dim_tx.V`, `dim_rx.V`: one-dimensional shifted DPS bases.
- `alpha_exact`: coefficient tensor from exact one-dimensional projections.
- `alpha_approx_4d`: coefficient tensor from approximate DPS wave-function coefficients in all four dimensions.
- `alpha_hybrid`: coefficient tensor using approximate DPS in time/frequency and direct spatial exponentials.
- `H_exact`, `H_approx_4d`, `H_hybrid`: reconstructed channels.

MATLAB functions:

- `build_alpha_exact(...)`
- `build_alpha_approx_4d(...)`
- `build_alpha_approx_hybrid(...)`
- `reconstruct_from_alpha(...)`
- `reconstruct_hybrid(...)`

## Theorem 3: Product of one-dimensional projections

Meaning: for Cartesian product regions, the multidimensional coefficient for each MPC is the tensor product of its one-dimensional coefficients.

MATLAB mapping:

- `outer4(...)` forms the tensor product of four one-dimensional coefficient vectors.
- `build_alpha_exact(...)` uses exact one-dimensional projections.
- `build_alpha_approx_4d(...)` uses approximate one-dimensional DPS wave-function coefficients.
- `build_alpha_approx_hybrid(...)` uses approximate time/frequency coefficients and exact spatial exponentials.

Thesis interpretation:

- The exact DPS branch validates the subspace representation.
- The approximate 4D branch evaluates direct application of the paper-style wave-function approximation in all dimensions.
- The hybrid branch is the practical MIMO variant emphasized for writing results.
