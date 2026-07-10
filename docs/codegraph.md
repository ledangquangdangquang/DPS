# Code Graph dự án

Tài liệu này mã hóa quan hệ giữa các phần chính của đồ án để hỗ trợ các lần chỉnh sửa sau. Khi sửa LaTeX hoặc MATLAB, dùng graph này như checklist nhất quán: một thay đổi ở node nguồn phải kéo theo kiểm tra các node phụ thuộc.

## Node trung tâm

```text
Kaltenberger_LowComplexGeometryMIMO.pdf
        |
        v
docs/paper_notes.md, docs/equations.md, docs/assumptions.md
        |
        +--> LaTeX thesis: main.tex -> NoiDung/*, KetThuc/*
        |
        +--> MATLAB simulations: *.m -> results/figures, results/tables
```

## Graph LaTeX

```text
main.tex
|-- MoDau/Bia.tex
|-- MoDau/NhiemVuDoAnTotNghiep.tex
|-- MoDau/PhieuDanhGiaCanBoPhanBien.tex
|-- MoDau/CamOnvaTomTat.tex
|-- MoDau/MucLuc.tex
|-- MoDau/DanhMucKyHieuVaChuVietTat.tex
|-- MoDau/DanhMucHinhVe.tex
|-- MoDau/DanhMucBangBieu.tex
|-- NoiDung/Chuong1.tex
|-- NoiDung/Chuong2.tex
|-- NoiDung/Chuong3.tex
|-- NoiDung/Chuong4.tex
|-- KetThuc/KetLuan.tex
|-- KetThuc/TaiLieuThamKhao.tex
`-- KetThuc/PhuLuc.tex
```

Vai trò các chương theo kịch bản hiện tại:

| Node | Vai trò | Node cần kiểm tra khi sửa |
|---|---|---|
| `NoiDung/Chuong1.tex` | Đặt vấn đề, lý do dùng DPS | `kich_ban_do_an_tot_nghiep.md`, `docs/equations.md`, tài liệu tham khảo |
| `NoiDung/Chuong2.tex` | Lợi thế DPS so với SoCE, lý thuyết và độ phức tạp | `docs/equations.md`, `results/figures/paper_figure4_dps_eigenvalues.png` |
| `NoiDung/Chuong3.tex` | Mô hình GCM MIMO, rời rạc hóa, ánh xạ MATLAB | `docs/equations.md`, `docs/assumptions.md`, các script MATLAB liên quan |
| `NoiDung/Chuong4.tex` | Kết quả mô phỏng và thảo luận | CSV/PNG trong `results/`, script sinh kết quả |
| `KetThuc/KetLuan.tex` | Tổng hợp kết quả, hạn chế, hướng phát triển | Chương 4, CSV đã kiểm chứng |
| `KetThuc/PhuLuc.tex` | Tham số, trích mã, trích kết quả thô | Script MATLAB, CSV thô |

## Graph kết quả mô phỏng

```text
scripts/reproduce_paper_figure4.m
|-- results/figures/paper_figure4_dps_eigenvalues.png
|-- results/figures/paper_figure4_dps_eigenvalues.fig
`-- results/tables/paper_figure4_dps_eigenvalues.csv
        `-- NoiDung/Chuong2.tex

mimo_dps_kaltenberger.m
|-- results/figures/mimo_dps_kaltenberger_tx1_rx1.png
|-- results/figures/mimo_dps_kaltenberger_tx1_rx1.fig
`-- results/tables/mimo_dps_kaltenberger_metrics.csv

tai lieu/mimo_dps_kaltenberger_approx.m
|-- results/figures/mimo_dps_kaltenberger_approx_tx1_rx1.png
|-- results/figures/mimo_dps_kaltenberger_approx_nmse_bar.png
|-- results/figures/mimo_dps_kaltenberger_approx_runtime_bar.png
`-- results/tables/mimo_dps_kaltenberger_approx_metrics.csv
        `-- NoiDung/Chuong4.tex

tai lieu/mimo_dps_kaltenberger_p_sweep.m
|-- results/figures/mimo_dps_kaltenberger_p_sweep_nmse.png
|-- results/figures/mimo_dps_kaltenberger_p_sweep_runtime.png
|-- results/tables/mimo_dps_kaltenberger_p_sweep_raw.csv
`-- results/tables/mimo_dps_kaltenberger_p_sweep_summary.csv
        `-- NoiDung/Chuong4.tex

scripts/mimo_four_method_benchmark.m
|-- results/figures/mimo_four_method_benchmark_runtime.png
|-- results/figures/mimo_four_method_benchmark_nmse.png
|-- results/tables/mimo_four_method_benchmark_runtime_raw.csv
|-- results/tables/mimo_four_method_benchmark_nmse_raw.csv
|-- results/tables/mimo_four_method_benchmark_summary.csv
`-- results/tables/mimo_four_method_benchmark_break_even.csv
        `-- NoiDung/Chuong4.tex

scripts/mimo_dps_adaptive_dimension.m
|-- results/figures/mimo_dps_kaltenberger_adaptive_dimension_nmse.png
`-- results/tables/mimo_dps_kaltenberger_adaptive_dimension_metrics.csv
        `-- Chưa đưa đầy đủ vào Chương 4, xem docs/TODO.md
```

## Graph phương trình và biến

| Khái niệm | LaTeX | MATLAB | Ghi chú kiểm tra |
|---|---|---|---|
| SoCE 4D rời rạc | `\ref{eq:ch3_discrete_soce}` | `compute_mimo_soce(...)`, `H_soce` | Dấu pha phải là `nu*m - theta*q + zeta*s - xi*r`. |
| Miền giới hạn băng | `\ref{eq:ch3_band_region}` | `W0`, `Wmax`, `nu_Dmax`, `theta_max`, `zeta_*`, `xi_*` | Kiểm tra quy ước dấu cho chiều tần số và Rx. |
| DPS reconstruction | `\ref{eq:ch3_4d_dps_reconstruction}` | `reconstruct_from_alpha(...)`, `mode_product(...)` | Kích thước tensor phải khớp thứ tự `M x Q x N_Tx x N_Rx`. |
| Exact DPS | `\ref{eq:ch3_exact_alpha}` | `build_alpha_exact(...)`, `H_exact` | Là nhánh chẩn đoán sai số cắt không gian con. |
| Approx DPS 4D | `\ref{eq:ch3_approx_alpha}` | `build_alpha_approx_4d(...)`, `H_approx_4d` | Phụ thuộc `r_t`, `r_f`, `r_tx`, `r_rx`. |
| Hybrid | `\ref{eq:ch3_hybrid_alpha}` | `build_alpha_approx_hybrid(...)`, `reconstruct_hybrid(...)`, `H_hybrid` | DPS cho thời gian/tần số, mũ trực tiếp cho không gian. |
| NMSE | `\ref{eq:ch4_nmse_definition}` | các cột `nmse_*` trong CSV | Không viết số mới nếu chưa đọc CSV nguồn. |
| Runtime amortized | `\ref{eq:ch4_amortized_runtime}` | benchmark setup/per-block columns | Phân biệt preprocessing và runtime mỗi block. |

## Checklist theo loại thay đổi

### Khi sửa mô hình hoặc ký hiệu

1. Kiểm tra `docs/equations.md`.
2. Kiểm tra `NoiDung/Chuong3.tex`.
3. Kiểm tra các hàm `compute_mimo_soce(...)`, `build_alpha_*`, `reconstruct_*`.
4. Nếu phát sinh giả thiết mới, cập nhật `docs/assumptions.md`.

### Khi sửa script MATLAB sinh kết quả

1. Đọc `AGENTS_matlab.md`.
2. Xác định script sinh hình/bảng nào.
3. Chạy lại script nếu thay đổi ảnh hưởng kết quả.
4. Kiểm tra CSV/PNG tồn tại và có header đúng.
5. Cập nhật Chương 4 nếu số liệu hoặc nhận xét thay đổi.
6. Cập nhật `docs/equations.md` hoặc `docs/assumptions.md` nếu thay đổi phương trình/giả thiết.

### Khi sửa Chương 4

1. Đọc CSV nguồn trước khi viết số liệu.
2. Kiểm tra hình được tham chiếu tồn tại.
3. Không dùng `mimo_dps_kaltenberger_p_sweep_metrics.csv` cho kết luận hiện tại; ưu tiên `mimo_dps_kaltenberger_p_sweep_summary.csv` và raw CSV.
4. Viết kết luận theo phạm vi mô phỏng hiện tại, tránh khẳng định tổng quát.

### Khi sửa phụ lục

1. Kiểm tra file được `\lstinputlisting` vẫn tồn tại.
2. Không sao chép số liệu thủ công nếu có thể trích trực tiếp từ CSV.
3. Giữ phụ lục là nơi được phép nhắc đường dẫn kỹ thuật.

## Node rủi ro cao

| Node | Rủi ro | Cách giảm rủi ro |
|---|---|---|
| `NoiDung/Chuong4.tex` | Dễ lệch số liệu với CSV | Luôn đọc CSV trước khi sửa nhận xét định lượng. |
| `tai lieu/mimo_dps_kaltenberger_approx.m` | Là script chính nhưng nằm trong thư mục có khoảng trắng | Khi chạy dùng dấu nháy hoặc đường dẫn tương đối cẩn thận. |
| `mimo_dps_kaltenberger_p_sweep_metrics.csv` | Kết quả legacy single-run | Không dùng làm nguồn chính cho xu hướng hiện tại. |
| `scripts/mimo_four_method_benchmark.m` | Runtime phụ thuộc môi trường | Chỉ diễn giải như kết quả đo trong môi trường MATLAB hiện tại. |
| `docs/equations.md` | Là cầu nối LaTeX-MATLAB | Cập nhật ngay khi thêm/đổi phương trình quan trọng. |

## Lệnh kiểm tra nhanh

```bash
rg -n -F "\\includegraphics" NoiDung KetThuc
rg -n "save(as|fig)|writetable|results/(figures|tables)" *.m "tai lieu" scripts
latexmk -pdf -interaction=nonstopmode main.tex
```

Với MATLAB, chạy từng script từ thư mục gốc dự án để bảo đảm đường dẫn tương đối hoạt động đúng.
