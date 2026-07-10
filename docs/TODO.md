# TODO

## Highest priority

- Review compiled PDF layout for overfull/underfull boxes before final submission.

## Next

- Add the verified adaptive-dimension NMSE/dimension results to Chapter 4 if a full result comparison with the fixed rule is desired.
- Extend the four-method benchmark with separate coefficient/reconstruction timing and measured peak memory if a finer implementation profile is required.
- Add a parameter sweep over DPS dimensions and resolution factors to compare NMSE/runtime tradeoffs.
- Consider moving the approximate script from `tai lieu/` into the project root or `src/` if it becomes the main simulation file.

## Done

- Added DPS xấp xỉ 4D to the MPC-count sweep figures, raw/summary CSV files, Chapter 4 discussion, conclusion, appendix notes, and result mapping.

- Replaced the previous Chapter 4.6 method-selection discussion with a `P=80` runtime-versus-NMSE result comparison for SoCE, exact DPS, hybrid, and approximate 4D DPS.

- Added `docs/codegraph.md` as a lightweight code graph for the LaTeX/MATLAB/result dependencies of the project.

- Added a reviewer evaluation form as a separate front-matter file and inserted it after the graduation-thesis assignment page.

- Added explicit input--output pseudocode for direct SoCE, exact DPS projection, and the hybrid method to Chapter 3.

- Replaced the placeholder appendix with A1--A5 covering complete parameters, DPS code, NMSE code, the full benchmark script, and documented extracts of raw CSV results.

- Expanded the Chapter 3 approximate-4D-DPS implementation explanation and added the corresponding four-dimensional coefficient-tensor equation.

- Rechecked and corrected Chapter 4 Figure 4.1: zero-based sample axes, common response color scale, Vietnamese panel titles, regenerated MATLAB outputs, and synchronized the surrounding interpretation and current timing values.

- Expanded the thesis from 49 to 51 pages with substantive additions on research questions/evaluation criteria and the general amortized-runtime/break-even formulation; no filler text or new unverified numerical results were added.

- Implemented a reproducible four-method benchmark for direct SoCE, recursive SoCE, CE-BEM, and exact DPS; added NMSE/runtime figures, raw and summary CSV files, and both MPC-based and preprocessing-amortization break-even analysis to Chapter 4.

- Inserted an independently generated DPS eigenvalue plot into Chapter 2, using the paper's example parameters, and explained how eigenvalue decay permits a DPS subspace dimension much smaller than the number of channel samples.
- Added and verified `scripts/reproduce_paper_figure4.m` for the first ten one-dimensional DPS eigenvalues at `M = 256` and `M*nu_Dmax = 2`; saved PNG/FIG and CSV outputs.
- Merged the former Chapter 5 into `KetThuc/KetLuan.tex`, removed the separate Chapter 5 file and updated the four-chapter document structure.
- Added and verified the MATLAB source for the MPC-count sweep; NMSE now uses 20 seeds and median/IQR statistics, while runtime uses 10 post-warm-up repetitions with median/IQR statistics and explicit exclusion of DPS-basis construction.
- Added the sweep over `P = 10, 20, 40, 80, 160, 320` to Chapter 4 with NMSE/runtime figures and cautious trend analysis; the initial single-run discussion was subsequently replaced by the verified multi-seed, repeated-measurement results.

- Updated `kich_ban_do_an_tot_nghiep.md` and `AGENTS.md` so Chapter 2 focuses on DPS advantages over SoCE and Chapter 3 covers the system/MATLAB implementation.
- Read project instructions and paper notes.
- Rewrote `NoiDung/Chuong1.tex` as a coherent system-model chapter aligned with the MATLAB simulation scope and Kaltenberger SoCE notation.
- Revised `NoiDung/Chuong1.tex` to act as a problem-statement chapter answering why DPS is used.
- Created `NoiDung/Chuong2.tex` as the DPS-versus-SoCE theory chapter and linked it from `main.tex`.
- Created `NoiDung/Chuong3.tex` as the system-model and MATLAB-implementation chapter and linked it from `main.tex`.
- Created `NoiDung/Chuong4.tex` as the simulation-result chapter, inserted the approximate-result figure, and added a metrics table based on the generated CSV.
- Consolidated the former Chapter 5 content into the unnumbered final conclusion.
- Restored Chapters 1--4 and the final conclusion according to the updated `kich_ban_do_an_tot_nghiep.md` structure.
- Used `tai lieu/mimo_dps_kaltenberger_approx.m` and `results/tables/mimo_dps_kaltenberger_approx_metrics.csv` as the primary basis for the simulation-result chapter.
- Distinguished exact DPS projection, approximate DPS wave-function projection in 4D, and hybrid approximate time/frequency DPS with direct spatial exponentials across the restored chapters.
- Replaced the placeholder final conclusion in `KetThuc/KetLuan.tex` with a concise thesis-level conclusion.
- Updated `MoDau/DanhMucKyHieuVaChuVietTat.tex` with terminology used in the thesis.
- Corrected the thesis title in `main.tex` from `DSP sequence` to DPS.
- Standardized the prose names of the simulation branches as DPS chính xác, DPS xấp xỉ 4D, and phương pháp hybrid.
- Created core research docs.
- Implemented and verified baseline exact DPS projection.
- Added approximate DPS wave-function projection script.
- Added hybrid approximate time/frequency DPS with exact spatial exponentials.
- Saved approximate metrics and diagnostic figures to `results/`.
- Created `kich_ban_do_an_tot_nghiep.md` as the thesis writing scenario.
