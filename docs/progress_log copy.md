# Progress Log

## 2026-06-25 add reviewer evaluation form to front matter

- Read the current progress/TODO records, thesis scenario, `main.tex`, front-matter files, and the LaTeX class configuration.
- Added `MoDau/PhieuDanhGiaCanBoPhanBien.tex`, a reviewer evaluation form matching the provided image content: reviewer name line, criteria table, total score rows, and reviewer signature block.
- Inserted the new form into the front matter after the graduation-thesis assignment page.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex` successfully; the new form compiles without table box warnings. Existing duplicate page-anchor warnings and two bibliography underfull warnings remain unrelated to this change.

## 2026-06-25 polish full thesis prose and front-matter layout

- Re-read `AGENTS.md`, current progress/TODO records, the thesis scenario, paper/equation/assumption notes, main thesis chapters, front matter, conclusion, appendix, and verified result file lists.
- Polished Vietnamese prose in Chapters 1, 3, 4, the final conclusion, and the appendix without changing equations, MATLAB code, simulation parameters, figures, tables, or numerical results.
- Standardized remaining prose uses of "vector" to "véc-tơ", softened several result interpretations to keep the claims scoped to the verified simulation configuration, and renamed the appendix benchmark section from "Script" to "Chương trình".
- Adjusted front-matter layout in the thesis assignment page, acknowledgement/signature block, and abbreviation table to remove avoidable overfull/underfull warnings.
- Verified that the Chapter 4 figures and result tables referenced in the text exist, and rechecked the main CSV values used in the prose.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex` successfully; `main.pdf` remains 71 pages. The avoidable front-matter box warnings were removed. The only remaining box warnings are two minor underfull lines in the generated bibliography, with no undefined references or citations.

## 2026-06-25 add Chapter 1 channel-model background

- Re-read `AGENTS.md`, progress/TODO records, the thesis scenario, Chapter 1, equation/assumption notes, glossary, and bibliography.
- Added three introductory Chapter 1 subsections covering wireless channel models, MIMO channel models for modern systems, and low-complexity channel-representation methods.
- Discussed Rayleigh, Rician, TDL, GCM, COST 2100, WINNER II, QuaDRiGa, 3GPP TR 38.901, CE-BEM/DFT, Karhunen--Loève, and DPS at overview level only, keeping Chapter 1 focused on motivation.
- Added bibliography entries for Goldsmith, COST 2100, WINNER II, QuaDRiGa, and 3GPP TR 38.901, and updated the abbreviation list.
- Updated the thesis scenario to reflect the broader Chapter 1 background.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex` successfully; citations resolved and `main.pdf` was regenerated at 71 pages. No MATLAB code, simulation result, equation mapping, or simulation assumption was changed.

## 2026-06-25 polish Chapter 3 prose and algorithm notation

- Re-read `AGENTS.md`, current progress/TODO records, the thesis scenario, Chapter 3, paper notes, equation mapping, and assumptions.
- Polished Chapter 3 wording in the opening, discretization, band-region, adaptive-dimension, MATLAB-branch, parameter-table, and simulation-flow sections.
- Corrected the algorithm update notation for direct SoCE and hybrid from plain text fragments to valid LaTeX `\leftarrow` and `\eta_p` expressions.
- Standardized thesis prose to use "chương trình MATLAB" instead of "script MATLAB" where appropriate.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex` successfully. No new Chapter 3 LaTeX error or Chapter 3 overfull/underfull warning was introduced.
- No MATLAB code, simulation result, equation mapping, or assumption was changed.

## 2026-06-25 add explicit SoCE, exact-DPS, and hybrid algorithms

- Re-read the Chapter 3 branch equations, simulation flow, MATLAB implementation, equation mapping, and thesis scenario.
- Added a dedicated Chapter 3 subsection with input, output, initialization, per-MPC update, reconstruction, and return steps for direct SoCE, exact DPS projection, and the hybrid method.
- Kept the effective frequency signs and tensor mode products consistent with the implemented MATLAB functions.
- Updated the thesis scenario. No MATLAB code, simulation parameter, assumption, or numerical result was changed.

## 2026-06-25 write appendices A1--A5

- Read the project/MATLAB instructions, progress/TODO records, thesis scenario, existing placeholder appendix, listing configuration, simulation scripts, assumptions, and generated CSV files.
- Replaced the placeholder appendix with five requested sections: complete simulation parameters, DPS-generation code, NMSE code, the full four-method benchmark script, and raw-result documentation/extracts.
- Added three parameter tables covering physical/band limits, main tensor/DPS configuration, and multi-seed/runtime experiment settings.
- Used `\lstinputlisting` so MATLAB and CSV excerpts are taken directly from the current source files; documented all 1,020 raw records across the three principal CSV datasets while printing representative extracts instead of hundreds of rows.
- Updated the thesis scenario to match the implemented A1--A5 appendix structure. No MATLAB algorithm, simulation result, equation, or assumption was changed.
- Compiled the document successfully; the appendix increases the document to 66 pages and introduces no unresolved reference or appendix overfull/underfull warning after layout correction.

## 2026-06-25 expand the Chapter 3 approximate-4D-DPS explanation

- Re-read the exact-projection equations, the surrounding MATLAB-branch discussion, the approximation implementation, and the paper-equation mapping.
- Replaced the brief approximate-4D-DPS paragraph with a stepwise explanation of the high-resolution DPS basis, frequency-to-grid mapping, coefficient construction, four effective frequency signs, and the distinction between the lookup basis and the original reconstruction basis.
- Added Eq. `\ref{eq:ch3_approx_alpha}` for the approximate four-dimensional coefficient tensor and recorded its mapping in `docs/equations.md`.
- Corrected the adjacent hybrid equation to use the newly defined approximate time/frequency coefficient notation `\widetilde{\boldsymbol{\gamma}}`, consistent with the MATLAB implementation.
- Explained the computational benefit, additional memory requirement, resolution-factor dependence, and approximation error without changing MATLAB code, parameters, assumptions, or numerical results.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex` successfully; references resolved after the automatic rerun, the document remains 51 pages, and no new Chapter 3 box warning was introduced.

## 2026-06-25 correct and regenerate Chapter 4 channel-response figure

- Read the project and MATLAB instructions, progress/TODO records, assumptions/equation notes, the complete approximate MATLAB script, and the surrounding Chapter 4 text.
- Verified that the four panels in Figure 4.1 use the intended SoCE, exact-DPS, hybrid, and absolute hybrid-error tensors for the first transmit--receive antenna pair.
- Corrected the diagnostic plot to display the mathematical zero-based sample indices, use one common color scale for the three channel responses, and use Vietnamese panel titles.
- Clarified in Chapter 4 that the weak variation along the time index is expected because the normalized Doppler product over the simulated block is small.
- Ran MATLAB R2025b successfully. The deterministic MSE/NMSE/max-error results remained unchanged; regenerated the PNG/FIG and synchronized the single-run timing values in the Chapter 4 table and discussion with the current CSV output.
- `checkcode` reported no issue. No simulation parameter, mathematical assumption, or equation mapping was changed.
- Forced a complete `latexmk` rebuild successfully; the document remains 51 pages, with no new Chapter 4 box, citation, or reference warning.

## 2026-06-24 expand thesis by two pages with substantive analysis

- Read the project instructions, progress/TODO records, thesis scenario, all four numbered chapters, and the final conclusion.
- Added a Chapter 1 subsection that states three research questions, separates fidelity/runtime/scalability/reuse criteria, and clarifies the empirical scope of the thesis.
- Added Chapter 4 equations for amortized total runtime and the reusable-basis break-even block count, followed by a method-selection discussion connecting exact DPS, approximate 4D DPS, hybrid DPS, CE-BEM, and SoCE.
- Read the inserted text together with its preceding and following paragraphs and removed an initially drafted Chapter 3 expansion to avoid unnecessary repetition.
- Updated the equation mapping; no MATLAB code, simulation parameters, assumptions, or numerical results were changed.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex` successfully. The compiled document increased from 49 to exactly 51 pages. No new overfull/underfull warning was introduced in Chapters 1--4.

## 2026-06-24 add four-method benchmark and break-even analysis

- Read the project/MATLAB instructions, progress/TODO records, thesis scenario, Chapters 2--4, MATLAB scripts, equation/assumption notes, and existing generated results.
- Added `scripts/mimo_four_method_benchmark.m` comparing direct SoCE, recursive SoCE, CE-BEM, and exact 4D DPS on identical MPC realizations.
- Used `P = [5,10,20,40,80,160,320]`, 20 seeds for NMSE, and 10 post-warm-up runtime repetitions; measured reusable CE-BEM/DPS basis setup separately.
- Saved raw/summary/break-even CSV files and runtime/NMSE PNG/FIG outputs.
- Extended Chapter 4 with the benchmark, a `P=80` comparison table, cautious interpretation of recursive SoCE, and break-even analysis by both MPC count and number of reused channel blocks.
- Updated Chapter 2 to point its theoretical recursive-SoCE/CE-BEM discussion to the implemented Chapter 4 benchmark.
- Recorded the CE-BEM grid, timing, and basis-reuse assumptions; no parameters or results were taken from an unavailable paper table.
- MATLAB R2025b completed the benchmark and `checkcode` successfully. At `P=80`, median per-block speedups relative to direct SoCE were approximately `10.57x` for CE-BEM and `9.12x` for exact DPS; exact DPS had the lower median NMSE (`3.33e-9` versus `2.96e-8`). CE-BEM and DPS were already faster at the smallest sampled value `P=5`, so the measured sweep only bounds the MPC break-even by `P_BE <= 5`; the amortized basis-setup break-even at `P=80` was 1 block for CE-BEM and 6 blocks for DPS.

## 2026-06-24 add automatic DPS-dimension selection

- Read the project and MATLAB instructions, current progress/TODO records, thesis scenario, Chapter 3, paper notes/equation/assumption records, the primary MATLAB scripts, and paper Eqs. (35), (38).
- Added `scripts/mimo_dps_adaptive_dimension.m`, which computes full DPS eigensystems and selects the smallest dimension in each of the four separable channel dimensions from an omitted-eigenvalue square-bias target.
- Divided the total design target equally among time, frequency, Tx, and Rx as an explicit engineering assumption for the 4D extension.
- Verified targets `1e-2`, `1e-4`, `1e-6`, and `1e-8` over 20 reproducible MPC seeds using exact DPS projection, with the existing fixed `guard = 4` rule retained as a comparator.
- The adaptive targets selected total dimensions `24`, `126`, `162`, and `480`; the corresponding median exact-DPS NMSE values were approximately `8.14e-4`, `8.92e-6`, `3.46e-7`, and `1.53e-10`, all below their respective total design targets in this experiment.
- Saved a metrics CSV with selected dimensions, eigenvalue-tail indicators, NMSE median/IQR, error, separate eigensystem/selection/coefficients/reconstruction runtimes, and PNG/FIG verification plots.
- Extended Chapter 3 with the one-dimensional bias equation, 4D error-budget allocation, automatic selection rule, implementation steps, MATLAB variable mapping, and updated simulation flow.
- Updated the thesis scenario, paper notes, equation mapping, assumptions, and TODO. The existing primary simulation scripts and their results were not changed.
- Ran MATLAB R2025b successfully, generated the CSV/PNG/FIG outputs, and ran `checkcode` with no reported issue.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex`; the build completed successfully with resolved references and no overfull or underfull box introduced in Chapter 3.

## 2026-06-24 add recursive SoCE and CE-BEM theory to Chapter 2

- Read the project and MATLAB instructions, current progress/TODO records, thesis scenario, Chapter 2 and adjacent chapters, equation/assumption notes, glossary, and bibliography.
- Added recursive SoCE as an exact-model implementation baseline that replaces repeated exponential evaluations with phasor updates while retaining `O(P N_s)` asymptotic complexity.
- Added CE-BEM as a Fourier-basis comparator, including scalar and matrix formulations, dense/FFT reconstruction conditions, coefficient-generation caveats, and off-grid error discussion.
- Added a symbolic comparison table covering direct SoCE, recursive SoCE, CE-BEM, exact 4D DPS, approximate 4D DPS, and hybrid DPS.
- Explicitly stated that recursive SoCE and CE-BEM are theoretical comparators only and have no Chapter 4 numerical results yet.
- Added verified bibliography entries for the BEM sources and corrected the Kaltenberger paper DOI from `10.1155/2007/19070` to `10.1155/2007/95281`.
- Updated the glossary, thesis scenario, equation mapping, and TODO. No MATLAB code, simulation data, or assumptions were changed.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex`; the build completed successfully with resolved citations/references and no overfull or underfull box introduced in Chapter 2.

## 2026-06-24 clarify source of DPS eigenvalue figure

- Revised Chapter 2 to state that the DPS eigenvalue figure was generated independently in MATLAB using an example parameter set from Kaltenberger et al., rather than calling it a reproduction of the paper's Figure 4.
- Simplified the Vietnamese caption and removed the paper-figure wording from the plot title generated by MATLAB.

## 2026-06-24 add paper Figure 4 to Chapter 2

- Read the thesis scenario, Chapter 2 context, generated Figure 4 output, and the corresponding numerical CSV.
- Inserted the reproduced eigenvalue plot after the one-dimensional DPS eigenvalue definition, with a Vietnamese caption and explicit reference in the surrounding text.
- Explained the logarithmic axes, the transition around `d = 4--5`, and why the example supports using a DPS subspace much smaller than the original 256-sample vector.
- Clarified that `D_prime = 5` is a configuration-specific essential dimension and that practical implementations may retain additional guard vectors according to the required truncation error.
- Updated the equation/result mapping and TODO status; no MATLAB code or simulation data were changed.

## 2026-06-24 reproduce paper Figure 4

- Read the MATLAB-specific instructions, paper notes, equation/assumption records, the paper text around Figure 4 and Eqs. (6), (8), and (11), and the existing DPS basis implementation.
- Added `scripts/reproduce_paper_figure4.m` using the paper parameters `M0 = 0`, `M = 256`, and `M*nu_Dmax = 2`.
- Implemented both the MATLAB `dpss` calculation and an Eq. (6) concentration-matrix fallback.
- Configured the logarithmic eigenvalue plot and CSV export for the first ten eigenvalues and the paper's essential dimension `D_prime = 5`.
- Ran the script successfully with MATLAB R2025b and generated the PNG, FIG, and CSV outputs. The eigenvalues decrease from `0.9999428` at `d = 0` to `2.3163e-7` at `d = 9`, matching the qualitative decay and scale shown in the paper.
- Updated paper notes, equation mapping, assumptions, and TODO status.

## 2026-06-24 merge Chapter 5 into final conclusion

- Read the current progress/TODO files, thesis scenario, `main.tex`, Chapter 5, the final conclusion, and the adjacent Chapter 4 text.
- Merged the distinct conclusions, verified numerical results, limitations, and future-work content from Chapter 5 into `KetThuc/KetLuan.tex` while removing repeated summary paragraphs.
- Removed the Chapter 5 input from `main.tex` and deleted `NoiDung/Chuong5.tex`.
- Updated cross-references in Chapters 1 and 4, the thesis scenario, README, and TODO to reflect the four-chapter structure followed by an unnumbered conclusion.
- No MATLAB code, simulation data, assumptions, or equation mappings were changed.

## 2026-06-24 update thesis title

- Updated the thesis title in `main.tex`, `README.md`, and `kich_ban_do_an_tot_nghiep.md` to: “Mô phỏng kênh MIMO băng rộng biến thiên theo thời gian dựa trên mô hình hình học với độ phức tạp thấp bằng chuỗi DPS”.
- Kept historical progress-log entries unchanged.

## 2026-06-23 strengthen MPC-count sweep statistics and reproducibility

- Read and followed the new MATLAB-specific instructions in `AGENTS_matlab.md`, then added an explicit rule in `AGENTS.md` requiring it for future MATLAB work.
- Revised `tai lieu/mimo_dps_kaltenberger_p_sweep.m` to summarize NMSE with the median and interquartile range over 20 seeds instead of mean and standard deviation.
- Added interquartile ranges to the repeated runtime measurements and runtime figure.
- Added the complete fixed configuration, DPS dimensions, normalized bandwidth parameters, seed/repetition counts, basis-runtime flag, and MATLAB version to the summary CSV.
- Ran MATLAB R2025b successfully; generated 180 raw rows (120 NMSE and 60 runtime observations), a six-row summary table, and updated PNG/FIG plots.
- Updated Chapter 4 with the verified median/IQR values and removed the obsolete single-run timing anomaly and missing-source warnings.
- Updated equation sources, assumptions, and TODO status. The legacy single-run sweep metrics file remains stored but is no longer used as an authoritative Chapter 4 source.

## 2026-06-23 add existing MPC-count sweep to Chapter 4

- Read the project instructions, progress/TODO files, thesis scenario, Chapter 4, MATLAB implementation notes, approximation script, sweep CSV, and both saved sweep figures.
- Verified that the two figures are internally consistent with `results/tables/mimo_dps_kaltenberger_p_sweep_metrics.csv` for `P = 10, 20, 40, 80, 160, 320`.
- Added a Chapter 4 subsection discussing the NMSE and runtime behavior of exact DPS and hybrid DPS as the number of MPCs changes.
- Kept the interpretation cautious: NMSE is not monotonic in a single random realization; the `P = 10` timing and reconstruction-time fluctuations indicate warm-up/JIT/allocation noise; runtime claims are limited to the current measurement environment.
- Reported that the dedicated sweep-generation script is absent from the repository, so the saved experiment is not yet fully reproducible.
- Updated `docs/equations.md` with the sweep result sources and `docs/TODO.md` with the required reproducibility and repeated-measurement work.

## 2026-06-22 rewrite repository README

- Replaced the original generic HUST thesis-template README with a project-specific Vietnamese README.
- Documented the research objective, SoCE/DPS model, four MATLAB branches, verified configuration and metrics, repository structure, requirements, MATLAB/LaTeX commands, reproducibility workflow, limitations, and future work.
- Added links to the research notes and defense-question document.
- Kept runtime claims scoped to the current environment and explicitly stated that DPS-basis generation is excluded.

## 2026-06-22 add thesis-defense question bank

- Read the current project progress/TODO, the five-chapter thesis content, equation mappings, assumptions, paper notes, and verified approximate metrics.
- Created docs/cau_hoi_bao_ve.md as a Vietnamese oral-defense preparation document.
- Added 56 anticipated questions with concise answers covering the thesis objective, GCM/SoCE model, DPS theory, MATLAB branches, numerical results, timing interpretation, limitations, and future work.
- Included a one-minute thesis summary, a table of values to memorize, explicit warnings against overclaiming, and a safe method for answering questions outside the verified scope.
- Kept all numerical answers tied to the existing metrics and explicitly stated that the current runtime excludes DPS-basis generation.

## 2026-06-22 revise Chapter 4 for first-time readers

- Read the current project progress/TODO, thesis scenario, Chapter 4, the ending of Chapter 3, the opening of Chapter 5, and the verified approximate metrics CSV.
- Re-read Chapter 4 from the perspective of a reader unfamiliar with how to interpret a channel-response heatmap, MSE/NMSE, logarithmic scales, DPS timing components, and the roles of the three DPS branches.
- Added a three-question chapter roadmap and clarified that all branches use the same MPC realization.
- Explained the simulation-dimension and resolution parameters, the axes and colors of the channel-response figure, and why a single antenna-pair plot must be supplemented by full-tensor metrics.
- Defined the complementary roles of MSE, NMSE, and maximum absolute error; clarified that the expectation in the NMSE equation is a finite average over the simulated channel tensor.
- Explained how to read the logarithmic NMSE plot and separated numerical ordering from branch-level interpretation to reduce repetition.
- Clarified the coefficient/reconstruction timing columns and stated that current runtime measurements exclude DPS-basis generation.
- Reframed the branch discussion around the diagnostic question answered by each branch and kept all quantitative claims tied to the verified CSV values.
- Changed the metrics table to use its flexible `tabularx` column correctly.
- Verified that all three Chapter 4 figure files exist.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex`; the build completed successfully, produced `main.pdf`, and reported no overfull or underfull box in Chapter 4.

## 2026-06-22 revise Chapter 3 for first-time readers

- Read `AGENTS.md`, `docs/progress_log.md`, `docs/TODO.md`, `kich_ban_do_an_tot_nghiep.md`, Chapter 3, the adjacent Chapter 2 and Chapter 4 text, the equation/assumption/paper notes, and the primary approximate MATLAB script.
- Re-read Chapter 3 from the perspective of a reader unfamiliar with four-dimensional MIMO channel tensors, normalized frequency, Cartesian band regions, multidimensional DPS reconstruction, outer products, and the four simulation branches.
- Added a chapter roadmap and explained the physical meaning of a MIMO subchannel, MPC parameters, the four continuous variables, and one sampled channel entry.
- Made the sampling substitutions explicit and defined normalized frequencies as dimensionless phase cycles per index step.
- Introduced the meaning of a four-dimensional tensor, DPS basis columns, reconstruction coefficients, and the outer product before relying on these terms.
- Clarified the physical origin of the band limits, the purpose of shifted DPS bands, the guard-dimension heuristic, and the distinction between exact coefficient projection and exact channel reconstruction.
- Clarified that all four simulation branches use the same MPC realization and that the approximate branch estimates coefficients from a high-resolution DPS basis.
- Preserved existing equations, labels, parameter values, simulation assumptions, and MATLAB sign conventions.
- Changed the simulation-parameter table to use the flexible `tabularx` column correctly, removing the Chapter 3 underfull-box warning.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex`; the build completed successfully and produced `main.pdf`.

## 2026-06-19 revise Chapter 2 for first-time readers

- Read `AGENTS.md`, `docs/progress_log.md`, `docs/TODO.md`, `kich_ban_do_an_tot_nghiep.md`, Chapter 2, the Chapter 1 conclusion, the Chapter 3 opening, and the related paper-note, equation, assumption, and bibliography files.
- Re-read Chapter 2 from the perspective of a reader unfamiliar with normalized frequency, effective dimension, eigenvalue problems, DPS projection, tensors, and operation-count analysis.
- Added an explicit chapter roadmap and explained the one-dimensional SoCE symbols, normalized Nyquist interval, effective degrees of freedom, and the meaning of the time--bandwidth product `2NW`.
- Expanded the DPS eigenvalue explanation, including the concentration matrix, eigenvalue ordering, orthonormal basis, basis dimension, and truncation tradeoff.
- Clarified the difference between projecting a complete channel vector, exact per-MPC separable projection, and approximate DPS wave-function coefficients.
- Explained that “exact DPS” refers to coefficient projection on the retained basis and does not eliminate subspace-truncation error.
- Added transitions and definitions for tensor coefficients, mode-wise reconstruction, and the four retained DPS dimensions before the complexity equations.
- Stated the current simulation dimensions before the operation-estimate table and clarified that coefficient compression does not imply an equal runtime speedup.
- Adjusted the table explanation column to remove the Chapter 2 underfull-box warning.
- Preserved all existing equations, labels, numerical estimates, and simulation assumptions; no equation mapping or result data changed.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex`; the build completed successfully, produced `main.pdf`, and reported no overfull or underfull box in Chapter 2.

## 2026-06-19 revise Chapter 1 for first-time readers

- Read `AGENTS.md`, `docs/progress_log.md`, `docs/TODO.md`, `kich_ban_do_an_tot_nghiep.md`, Chapter 1, the opening of Chapter 2, and the related equation, assumption, paper-note, and bibliography files.
- Re-read Chapter 1 from the perspective of a reader unfamiliar with MIMO, GCM, SoCE, and DPS.
- Revised Chapter 1 to introduce the channel response and four-dimensional MIMO context before using the compact SoCE model.
- Clarified the link from physical Doppler, delay, and angular bounds to the multidimensional band-limited region.
- Explained the compact SoCE notation, asymptotic-complexity notation, DPS subspace idea, and roles of the exact, approximate 4D, and hybrid branches.
- Made the complexity claims conditional on retained subspace dimension, coefficient calculation, and reconstruction cost.
- Preserved the Chapter 1 role as problem statement; no simulation results, assumptions, or equation mappings were changed.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex`; the build completed successfully and produced `main.pdf`.

## 2026-06-19 add Chapter 3 simulation flowchart

- Read `AGENTS.md`, `docs/progress_log.md`, `docs/TODO.md`, `kich_ban_do_an_tot_nghiep.md`, `main.tex`, and `NoiDung/Chuong3.tex`.
- Added a TikZ flowchart to the Chapter 3 simulation-flow subsection.
- The flowchart summarizes the MATLAB pipeline: reproducible setup, MPC generation, DPS basis creation, SoCE reference calculation, exact DPS, approximate 4D DPS, hybrid reconstruction, and metric/result generation.
- Placed the figure in Chapter 3 because it connects the mathematical model and MATLAB implementation before the Chapter 4 result discussion.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex`; build completed successfully and produced `main.pdf`.
- No new simulation assumptions, equations, or quantitative results were introduced.

## 2026-06-18 remove technical paths from thesis prose

- Read `AGENTS.md`, `docs/progress_log.md`, `docs/TODO.md`, `kich_ban_do_an_tot_nghiep.md`, Chapters 1--5, `KetThuc/KetLuan.tex`, and searched thesis prose for folder/file/path mentions.
- Updated Chapter 3 to remove prose references to technical directories while preserving the MATLAB implementation explanation.
- Updated Chapter 4 to remove the explicit list of result file paths and references to CSV/source directories from the thesis body.
- Updated the final conclusion to refer to verified figures and tables instead of a result directory.
- Updated `docs/equations.md` because the Chapter 4 result-source equation label was removed from the thesis body.

## 2026-06-18 reorder Chapter 4 result discussion

- Read `AGENTS.md`, `docs/progress_log.md`, `docs/TODO.md`, `kich_ban_do_an_tot_nghiep.md`, `NoiDung/Chuong4.tex`, and `results/tables/mimo_dps_kaltenberger_approx_metrics.csv`.
- Reordered the Chapter 4 error/runtime subsection so Hình 4.2 presents the NMSE comparison before Bảng 4.2 gives the detailed metrics.
- Added analysis paragraphs immediately below Hình 4.2 and Hình 4.3, and expanded the discussion after Bảng 4.2.
- Kept all quantitative values tied to the existing approximate metrics CSV; no new simulation assumptions were introduced.

## 2026-06-18 insert generated figures into chapters

- Read `AGENTS.md`, `docs/progress_log.md`, `docs/TODO.md`, `kich_ban_do_an_tot_nghiep.md`, `NoiDung/Chuong3.tex`, `NoiDung/Chuong4.tex`, and verified available PNG files in `results/figures/`.
- Inserted `results/figures/gcm_MIMO.png` into Chapter 3 as the GCM/MIMO system-model illustration.
- Inserted `results/figures/mimo_dps_kaltenberger_approx_nmse_bar.png` and `results/figures/mimo_dps_kaltenberger_approx_runtime_bar.png` into Chapter 4 with Vietnamese captions and discussion tied to the existing CSV metrics.
- Updated the Chapter 4 result-source equation to include the added figure files.
- No new simulation assumptions or quantitative results were introduced.

## 2026-06-18 acknowledgements and abstract rewrite

- Read `AGENTS.md`, `docs/progress_log.md`, `docs/TODO.md`, `kich_ban_do_an_tot_nghiep.md`, and `MoDau/CamOnvaTomTat.tex`.
- Rewrote `MoDau/CamOnvaTomTat.tex`:
  - replaced placeholder acknowledgement text with a concise formal acknowledgement;
  - replaced placeholder abstract text with a thesis-specific summary covering SoCE, DPS, MATLAB simulation branches, verified NMSE results, and future work.
- Used only quantitative results already reported in Chapter 4 and backed by `results/tables/mimo_dps_kaltenberger_approx_metrics.csv`.
- Ran `latexmk -g -pdf -interaction=nonstopmode main.tex`; build completed successfully and produced `main.pdf`.
- No new simulation assumptions were introduced.

## 2026-06-18 content consistency cleanup

- Read `AGENTS.md`, `kich_ban_do_an_tot_nghiep.md`, `main.tex`, `KetThuc/KetLuan.tex`, `MoDau/DanhMucKyHieuVaChuVietTat.tex`, and searched Chapters 1--5 for inconsistent terminology.
- Updated `main.tex` title from `DSP sequence` to `Mô phỏng kênh MIMO băng rộng sử dụng biểu diễn DPS`.
- Replaced the placeholder final conclusion in `KetThuc/KetLuan.tex` with a concise thesis-level conclusion, future work, and recommendation.
- Updated `MoDau/DanhMucKyHieuVaChuVietTat.tex` with the abbreviations used by the thesis: GCM, MPC, SoCE, DPS, MIMO, NMSE, MSE, AoD, AoA, ULA, Tx, and Rx.
- Standardized prose terminology in Chapters 2--5:
  - `DPS chính xác`;
  - `DPS xấp xỉ 4D`;
  - `phương pháp hybrid`.
- No new simulation assumptions or quantitative results were introduced.

## 2026-06-18 chapter 5 conclusion and future work

- Read `AGENTS.md`, `docs/progress_log.md`, `docs/TODO.md`, `kich_ban_do_an_tot_nghiep.md`, `main.tex`, `NoiDung/Chuong4.tex`, `docs/equations.md`, and `docs/assumptions.md`.
- Confirmed that `NoiDung/Chuong5.tex` was missing and `main.tex` only input Chapters 1--4.
- Created `NoiDung/Chuong5.tex` with the title `KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN`.
- Chapter 5 now summarizes:
  - the SoCE computational bottleneck;
  - the band-limited motivation for DPS;
  - the SoCE, exact DPS, approximate DPS 4D, and hybrid MATLAB branches;
  - the current verified NMSE/runtime observations from Chapter 4;
  - limitations of the current simulation;
  - future work on parameter sweeps, larger configurations, paper-result reproduction, MATLAB refactoring, and non-uniform MPC distributions.
- Updated `main.tex` to input `./NoiDung/Chuong5`.
- Updated `docs/TODO.md` to mark Chapter 5 as restored.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex`; build completed successfully and produced `main.pdf`.
- No new simulation assumptions were introduced.

## 2026-06-18 chapter 4 simulation results

- Read `AGENTS.md`, `docs/progress_log.md`, `docs/TODO.md`, `kich_ban_do_an_tot_nghiep.md`, current `main.tex`, and verified the generated files under `results/`.
- Confirmed that the primary Chapter 4 sources exist:
  - `results/tables/mimo_dps_kaltenberger_approx_metrics.csv`;
  - `results/figures/mimo_dps_kaltenberger_approx_tx1_rx1.png`.
- Created `NoiDung/Chuong4.tex` with the title `KẾT QUẢ MÔ PHỎNG VÀ THẢO LUẬN`.
- Chapter 4 now includes:
  - source and scope statement for generated results;
  - simulation-configuration table;
  - inserted and discussed `mimo_dps_kaltenberger_approx_tx1_rx1.png`;
  - NMSE definition;
  - metrics table based on the approximate CSV;
  - discussion of exact DPS, approximate DPS 4D, and hybrid branches;
  - limitations of the current single-configuration simulation.
- Updated `main.tex` to input `./NoiDung/Chuong4`.
- Updated `docs/equations.md` with Chapter 4 result-source and NMSE labels.
- Updated `docs/TODO.md` to mark Chapter 4 as restored and keep Chapter 5 as remaining work.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex`; build completed successfully and produced `main.pdf`.
- No new simulation assumptions were introduced.

## 2026-06-18 chapter 1/2 consistency and complexity comparison

- Re-read `AGENTS.md`, `kich_ban_do_an_tot_nghiep.md`, `NoiDung/Chuong1.tex`, `NoiDung/Chuong2.tex`, `docs/equations.md`, `docs/paper_notes.md`, and the current approximate metrics CSV.
- Revised `NoiDung/Chuong1.tex` so Chapter 1 only frames the SoCE bottleneck and points detailed operation-count comparison to Chapter 2.
- Expanded `NoiDung/Chuong2.tex` with a new subsection `So sánh độ phức tạp và số phép tính`.
- Added symbolic operation-count equations for:
  - total channel samples;
  - direct SoCE MPC-sample terms;
  - exact DPS one-dimensional projections;
  - 4D coefficient tensor update;
  - 4D DPS reconstruction;
  - approximate wave-function coefficient calculation;
  - hybrid reconstruction.
- Added an estimate table using the current MATLAB configuration:
  - `N_s = 262144`;
  - `D_total = 864`;
  - `N_s / D_total ≈ 303`;
  - `P N_s = 20971520`;
  - rough four-dimensional SoCE complex multiplication estimate `4 P N_s = 83886080`;
  - exact one-dimensional projection estimate `171520`;
  - coefficient tensor update estimate `69120`;
  - 4D reconstruction estimate `4677632`;
  - hybrid reconstruction estimate `2580480`.
- Updated `docs/equations.md` with the new Chapter 2 complexity labels.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex`; build completed successfully and produced `main.pdf`.

## 2026-06-18 chapter 3 system model and MATLAB implementation

- Read `AGENTS.md`, `docs/progress_log.md`, `docs/TODO.md`, `kich_ban_do_an_tot_nghiep.md`, `docs/paper_notes.md`, `docs/equations.md`, `docs/assumptions.md`, `main.tex`, `tai lieu/mimo_dps_kaltenberger_approx.m`, and `mimo_dps_kaltenberger.m`.
- Confirmed that `NoiDung/Chuong3.tex` was missing and `main.tex` only input Chapters 1--2.
- Created `NoiDung/Chuong3.tex` with the title `MÔ HÌNH HỆ THỐNG VÀ TRIỂN KHAI MÔ PHỎNG`.
- Chapter 3 now covers:
  - continuous wideband MIMO GCM;
  - four-dimensional sampled SoCE;
  - normalized Doppler, delay, AoD, and AoA spatial frequencies;
  - band-limiting region and shifted DPS band mapping;
  - multidimensional DPS reconstruction;
  - DPS dimension rule used by the MATLAB scripts;
  - SoCE, exact DPS, approximate 4D DPS, and hybrid simulation branches;
  - MATLAB parameter and variable mapping tables.
- Updated `main.tex` to input `./NoiDung/Chuong3` after Chapter 2.
- Updated `docs/equations.md` with the new Chapter 3 equation labels and MATLAB mappings.
- Updated `docs/TODO.md` to mark Chapter 3 as restored and keep Chapters 4--5 as remaining work.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex`; build completed successfully and produced `main.pdf`.
- No new simulation assumptions were introduced.

## 2026-06-18 chapter 2 DPS advantage chapter

- Read `AGENTS.md`, `docs/progress_log.md`, `docs/TODO.md`, `kich_ban_do_an_tot_nghiep.md`, `docs/paper_notes.md`, `docs/equations.md`, `docs/assumptions.md`, `main.tex`, `NoiDung/Chuong1.tex`, and `KetThuc/TaiLieuThamKhao.bib`.
- Confirmed that `NoiDung/Chuong2.tex` was missing from the workspace.
- Created `NoiDung/Chuong2.tex` with the title `LỢI THẾ CỦA BIỂU DIỄN DPS SO VỚI SOCE`.
- Chapter 2 now covers:
  - one-dimensional SoCE and its direct complexity;
  - band-limited signals on finite index blocks;
  - the one-dimensional DPS eigenvalue problem;
  - truncated DPS subspace reconstruction;
  - comparison between sample-wise SoCE and DPS coefficient-based reconstruction;
  - distinction between exact DPS projection, approximate 4D wave-function coefficients, and the hybrid branch.
- Updated `main.tex` to input `./NoiDung/Chuong2` after Chapter 1.
- Updated `docs/equations.md` with the new Chapter 2 equation labels.
- Updated `docs/TODO.md` to mark Chapter 2 as restored and keep Chapters 3--5 as remaining work.
- Ran `latexmk -C main.tex && latexmk -pdf -interaction=nonstopmode main.tex`; build completed successfully and produced `main.pdf`.
- No new MATLAB assumptions were introduced.

## 2026-06-18 chapter 1 aligned with scenario

- Re-read `kich_ban_do_an_tot_nghiep.md` and `NoiDung/Chuong1.tex` after user feedback that Chapter 1 still did not match the thesis scenario.
- Rewrote `NoiDung/Chuong1.tex` to match the scenario more closely:
  - title changed to `ĐẶT VẤN ĐỀ VÀ LÝ DO SỬ DỤNG DPS`;
  - removed detailed continuous system model, normalization equations, simulation-parameter table, and MATLAB parameter discussion from Chapter 1;
  - kept only compact SoCE, direct SoCE complexity, band-limited structure, and the motivation for DPS;
  - deferred the full system model and MATLAB mapping to Chapter 3.
- Updated `docs/equations.md` so the full continuous GCM is mapped to Chapter 3, while Chapter 1 only motivates the compact sampled SoCE form.
- Verified Chapter 1 labels and local equation references. Full LaTeX build was not rerun because `NoiDung/` currently contains only `Chuong1.tex`, while `main.tex` still inputs Chapters 2--5.

## 2026-06-18 thesis scenario update

- Updated `kich_ban_do_an_tot_nghiep.md` at the user's request.
- New thesis structure:
  - Chapter 1: problem statement and why DPS is needed;
  - Chapter 2: advantages of DPS over SoCE;
  - Chapter 3: system model and MATLAB simulation implementation;
  - Chapter 4: simulation results and discussion;
  - Chapter 5: conclusion and future work.
- Updated `AGENTS.md` so future writing/editing work must read `kich_ban_do_an_tot_nghiep.md` when touching thesis content, chapter structure, equations, results, or discussion.
- Added the new chapter-flow priority directly to `AGENTS.md`.

## 2026-06-18 chapter 1 problem-statement revision

- Revised `NoiDung/Chuong1.tex` after user feedback that Chapter 1 should focus on the problem statement and answer why DPS is used.
- Changed the chapter title to `ĐẶT VẤN ĐỀ VÀ MÔ HÌNH HỆ THỐNG`.
- Reorganized the chapter flow:
  - simulation context for wideband MIMO GCM;
  - SoCE as the direct physical model;
  - computational bottleneck of direct SoCE;
  - band-limited structure of Doppler, delay, AoD, and AoA dimensions;
  - explanation of why DPS is suitable for this structure;
  - current MATLAB simulation scope and thesis objectives.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex`. Chapter 1 parsed through to the end, but the build stopped at `\input{./NoiDung/Chuong2}` because `NoiDung/` currently contains only `Chuong1.tex`; `Chuong2.tex` through `Chuong5.tex` were not present at verification time.

## 2026-06-17 chapter 1 rewrite

- Rewrote `NoiDung/Chuong1.tex` from scratch at the user's request.
- Read current project state from `docs/progress_log.md`, `docs/TODO.md`, `docs/paper_notes.md`, `docs/equations.md`, `docs/assumptions.md`, and nearby thesis files.
- New Chapter 1 now focuses on:
  - wideband MIMO GCM system model;
  - continuous Kaltenberger-style channel expression;
  - normalized Doppler, delay, AoD, and AoA spatial frequencies;
  - four-dimensional sampled SoCE model;
  - band-limited region motivating DPS;
  - MATLAB simulation parameter scope currently used by the scripts.
- Updated `docs/equations.md` with the new Chapter 1 equation labels.
- Ran `latexmk -pdf -interaction=nonstopmode main.tex`; PDF generation completed, but bibliography/citation resolution is blocked by an existing `\end{document}` in `NoiDung/Chuong4.tex` before Chapter 5 and the bibliography are reached.

## 2026-06-17

- Read `AGENTS.md` and followed the MATLAB research workflow.
- Read the Kaltenberger et al. 2007 paper PDF available in the project.
- Updated `docs/paper_notes.md`, `docs/equations.md`, and `docs/assumptions.md`.
- Optimized `tai lieu/mimo_dps_kaltenberger.m`:
  - set reproducible seed with `rng(1)`;
  - precomputed one-dimensional exponential/projection matrices for all MPCs;
  - replaced nested reconstruction loops with tensor mode products;
  - saved figures and metrics under project-level `results/`.
- Verified the script with MATLAB outside the sandbox.

Latest run:

- `M = 256`, `Q = 64`, `N_Tx = 4`, `N_Rx = 4`, `P = 80`.
- `D_t = 6`, `D_f = 9`, `D_tx = 4`, `D_rx = 4`, `D_total = 864`.
- `MSE = 3.43343032230382e-09`.
- `NMSE = 8.53410711296342e-09`.
- `Max |error| = 2.01464519327390e-04`.
- Runtime: SoCE `0.254343 s`, DPS alpha `0.032611 s`, DPS reconstruction `0.024878 s`.

Generated outputs:

- `results/figures/mimo_dps_kaltenberger_tx1_rx1.png`
- `results/figures/mimo_dps_kaltenberger_tx1_rx1.fig`
- `results/tables/mimo_dps_kaltenberger_metrics.csv`

Unresolved issue at this stage:

- The implementation used exact projection onto DPS bases. This issue was later addressed by adding `tai lieu/mimo_dps_kaltenberger_approx.m`.

## 2026-06-17 follow-up

- Rechecked user MATLAB output. Numerical metrics are consistent with the saved CSV and the expected deterministic seed.
- Fixed MATLAB export warning caused by visible axes toolbars in the saved PNG.
- Added `grid on` to all diagnostic subplots to satisfy project plot rules.
- Re-ran MATLAB successfully; no export warning appeared and `checkcode` reported no messages.

Latest run after plot/export fix:

- `MSE = 3.43343032230382e-09`.
- `NMSE = 8.53410711296342e-09`.
- `Max |error| = 2.01464519327390e-04`.
- Runtime: SoCE `0.246022 s`, DPS alpha `0.036006 s`, DPS reconstruction `0.018527 s`.

## 2026-06-17 report script

- Created `script.md` as a Vietnamese thesis-report writing script for the requested LaTeX folder structure.
- Included suggested content for `main.tex`, opening pages, five thesis chapters, conclusion, appendix, bibliography, image placement, build commands, and submission checklist.
- The script is written as a planning document, not as compiled LaTeX source files.

## 2026-06-17 report script revision

- Rewrote `script.md` as an agent-facing instruction file.
- Restricted the agent scope to thesis content writing: chapters, abstract, symbols, conclusion, appendix, and bibliography entries.
- Added explicit rules not to modify LaTeX package setup, `thesis-config.cls`, personal metadata, or build artifacts.
- Added the provided `main.tex` structure as reference and clarified that `main.tex` should only be edited when adding a new chapter input.

## 2026-06-17 approximate DPS writing prep

- Read `tai lieu/mimo_dps_kaltenberger_approx.m` and confirmed it implements:
  - exact DPS projection as a diagnostic reference;
  - approximate DPS wave-function coefficients in 4D;
  - hybrid approximation with DPS in time/frequency and direct spatial exponentials.
- Updated writing-preparation documents:
  - `docs/paper_notes.md`;
  - `docs/equations.md`;
  - `docs/assumptions.md`;
  - `docs/TODO.md`;
  - `AGENTS.md`;
  - `kich_ban_do_an_tot_nghiep.md`.
- Re-ran `tai lieu/mimo_dps_kaltenberger_approx.m` with MATLAB.

Latest approximate run:

- `M = 256`, `Q = 64`, `N_Tx = 4`, `N_Rx = 4`, `P = 80`.
- `D_t = 6`, `D_f = 9`, `D_tx = 4`, `D_rx = 4`, `D_total = 864`.
- `r_t = 2`, `r_f = 512`, `r_tx = 512`, `r_rx = 512`.
- Exact DPS vs SoCE: `NMSE = 8.53410711296342e-09`.
- Approximate DPS 4D vs SoCE: `NMSE = 1.99476804943589e-04`.
- Hybrid approximate TF + exact spatial vs SoCE: `NMSE = 4.28714349593195e-07`.
- Hybrid approximate vs exact DPS: `NMSE = 4.20180246065843e-07`.
- Runtime: SoCE `0.222372 s`, exact DPS alpha `0.021346 s`, exact DPS reconstruction `0.024209 s`, approximate 4D alpha `0.061662 s`, approximate 4D reconstruction `0.019321 s`, hybrid alpha `0.022255 s`, hybrid reconstruction `0.003067 s`.

Generated outputs:

- `results/figures/mimo_dps_kaltenberger_approx_tx1_rx1.png`
- `results/figures/mimo_dps_kaltenberger_approx_tx1_rx1.fig`
- `results/tables/mimo_dps_kaltenberger_approx_metrics.csv`

Writing direction:

- Use the approximate script and approximate metrics CSV as the primary basis for the result chapter.
- Present exact DPS as a reference, approximate 4D as a diagnostic branch, and hybrid as the main practical MIMO result.
