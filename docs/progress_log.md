# Progress Log

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
