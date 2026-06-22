# TODO

## Highest priority

- Review compiled PDF layout for overfull/underfull boxes before final submission.

## Next

- Reproduce or approximate one selected figure/table from Kaltenberger et al. after matching all simulation parameters.
- Add a parameter sweep over DPS dimensions and resolution factors to compare NMSE/runtime tradeoffs.
- Consider moving the approximate script from `tai lieu/` into the project root or `src/` if it becomes the main simulation file.

## Done

- Updated `kich_ban_do_an_tot_nghiep.md` and `AGENTS.md` so Chapter 2 focuses on DPS advantages over SoCE and Chapter 3 covers the system/MATLAB implementation.
- Read project instructions and paper notes.
- Rewrote `NoiDung/Chuong1.tex` as a coherent system-model chapter aligned with the MATLAB simulation scope and Kaltenberger SoCE notation.
- Revised `NoiDung/Chuong1.tex` to act as a problem-statement chapter answering why DPS is used.
- Created `NoiDung/Chuong2.tex` as the DPS-versus-SoCE theory chapter and linked it from `main.tex`.
- Created `NoiDung/Chuong3.tex` as the system-model and MATLAB-implementation chapter and linked it from `main.tex`.
- Created `NoiDung/Chuong4.tex` as the simulation-result chapter, inserted the approximate-result figure, and added a metrics table based on the generated CSV.
- Created `NoiDung/Chuong5.tex` as the conclusion and future-work chapter and linked it from `main.tex`.
- Restored Chapters 1--5 according to the updated `kich_ban_do_an_tot_nghiep.md` structure.
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
