# Kịch bản tổng thể đồ án tốt nghiệp

## Tên đồ án đề xuất

**Mô phỏng kênh MIMO đa đường dựa trên hình học có độ phức tạp thấp sử dụng chuỗi DPS**

## Vai trò của kịch bản

Tệp này là định hướng chính khi viết lại hoặc chỉnh sửa các chương của đồ án. Trước khi viết nội dung LaTeX, cần đọc kịch bản này cùng với `docs/progress_log.md`, `docs/TODO.md`, `docs/paper_notes.md`, `docs/equations.md` và `docs/assumptions.md`.

Mục tiêu của kịch bản là giữ mạch lập luận thống nhất:

1. Chương 1 đặt vấn đề và trả lời vì sao bài toán cần một phương pháp như DPS.
2. Chương 2 phân tích lợi thế của DPS so với SoCE về mặt lý thuyết và độ phức tạp.
3. Chương 3 mới trình bày mô hình hệ thống và cách triển khai mô phỏng trong MATLAB.
4. Chương 4 trình bày kết quả mô phỏng đã có, không tự tạo số liệu.
5. Chương 5 kết luận, nêu hạn chế và hướng phát triển.

## Nguồn nội dung chính

Nguồn kỹ thuật cần dùng khi viết đồ án:

1. Bài báo `Kaltenberger_LowComplexGeometryMIMO.pdf`.
2. Ghi chú nghiên cứu trong `docs/paper_notes.md`, `docs/equations.md` và `docs/assumptions.md`.
3. Script nền `mimo_dps_kaltenberger.m`, dùng để kiểm chứng biểu diễn DPS bằng phép chiếu chính xác.
4. Script chính `tai lieu/mimo_dps_kaltenberger_approx.m`, dùng để so sánh SoCE, DPS chính xác, DPS xấp xỉ 4D và phương pháp hybrid.
5. Kết quả trong:

```text
results/figures/
results/tables/
```

Khi viết chương kết quả, ưu tiên dùng:

```text
results/figures/mimo_dps_kaltenberger_approx_tx1_rx1.png
results/tables/mimo_dps_kaltenberger_approx_metrics.csv
```

## Thông điệp chính của đồ án

Mô hình kênh dựa trên hình học (Geometry-based Channel Model, GCM) biểu diễn kênh vô tuyến như tổng đóng góp của nhiều thành phần đa đường (Multipath Component, MPC). Với kênh MIMO băng rộng biến thiên theo thời gian, đáp ứng kênh phụ thuộc đồng thời vào thời gian, tần số, chỉ số anten phát và chỉ số anten thu. Nếu tính trực tiếp theo tổng các hàm mũ phức (Sum of Complex Exponentials, SoCE), độ phức tạp tăng theo tích của số mẫu trong bốn chiều và số MPC.

Điểm mấu chốt trong bài báo Kaltenberger và cộng sự là kênh này không phải một tín hiệu tùy ý. Các thành phần Doppler, trễ, AoD và AoA làm cho kênh bị giới hạn băng trong từng chiều trên một khối mẫu hữu hạn. Chuỗi prolate spheroidal rời rạc (Discrete Prolate Spheroidal sequences, DPS) phù hợp với đúng cấu trúc đó vì chúng tạo thành cơ sở tập trung năng lượng tốt cho tín hiệu giới hạn băng trên tập chỉ số hữu hạn.

Vì vậy, đồ án không trình bày DPS như một công cụ toán học rời rạc, mà như câu trả lời cho nút thắt của SoCE: giảm số chiều biểu diễn kênh trong khi vẫn giữ sai số có thể kiểm soát.

## Mạch lập luận toàn đồ án

1. Mô phỏng kênh MIMO băng rộng bằng GCM là cần thiết trong đánh giá hệ thống vô tuyến.
2. SoCE mô tả trực tiếp kênh theo từng MPC nhưng chi phí lớn khi số mẫu, số anten và số MPC tăng.
3. Cấu trúc vật lý của kênh tạo ra miền giới hạn băng theo Doppler, trễ, AoD và AoA.
4. DPS là cơ sở phù hợp cho tín hiệu giới hạn băng trên khối mẫu hữu hạn.
5. So với SoCE trực tiếp, DPS chuyển bài toán từ tính từng MPC tại từng mẫu sang biểu diễn kênh trong không gian con có số chiều nhỏ hơn.
6. Với miền giới hạn băng dạng tích Descartes, DPS đa chiều có thể xây dựng từ các cơ sở DPS một chiều.
7. Trong mô phỏng, SoCE được dùng làm kênh tham chiếu.
8. Exact DPS kiểm tra sai số do cắt không gian con.
9. Approx DPS 4D kiểm tra công thức hệ số xấp xỉ trong cả bốn chiều.
10. Hybrid áp dụng DPS xấp xỉ cho thời gian/tần số và tính trực tiếp phần không gian; đây là nhánh chính để thảo luận cho MIMO băng rộng trong đồ án.

## Cấu trúc chương đề xuất

### Chương 1: Đặt vấn đề và lý do sử dụng DPS

Tên gợi ý:

```latex
\chaptercustom{1}{ĐẶT VẤN ĐỀ VÀ LÝ DO SỬ DỤNG DPS}
```

#### Mục tiêu chương

Chương 1 đóng vai trò đặt vấn đề, không đi sâu vào toàn bộ mô hình hệ thống. Câu hỏi trung tâm của chương là: vì sao cần dùng DPS thay cho cách tính SoCE trực tiếp?

#### Nội dung cần có

1. Bối cảnh mô phỏng kênh MIMO băng rộng.
2. GCM và SoCE là mô hình có ý nghĩa vật lý.
3. SoCE trực tiếp có độ phức tạp lớn vì phải cộng \(P\) MPC tại từng điểm mẫu.
4. Kênh có cấu trúc giới hạn băng theo Doppler, trễ, AoD và AoA.
5. DPS phù hợp vì tối ưu cho tín hiệu giới hạn băng trên khối hữu hạn.
6. Nêu định hướng đồ án: dùng SoCE làm chuẩn, dùng DPS để giảm độ phức tạp, kiểm chứng bằng MATLAB.

#### Công thức nên xuất hiện

Chỉ nên đưa công thức ở mức đủ để đặt vấn đề:

```latex
h_{\mathbf{m}}
= \sum_{p=0}^{P-1}\eta_p e^{j2\pi\mathbf{f}_p^T\mathbf{m}}.
```

và độ phức tạp trực tiếp:

```latex
C_{\mathrm{SoCE}}
= \mathcal{O}\!\left(MQN_{\mathrm{Tx}}N_{\mathrm{Rx}}P\right).
```

Không nên đưa quá nhiều chi tiết triển khai MATLAB trong Chương 1.

### Chương 2: Lợi thế của DPS so với SoCE

Tên gợi ý:

```latex
\chaptercustom{2}{LỢI THẾ CỦA BIỂU DIỄN DPS SO VỚI SOCE}
```

#### Mục tiêu chương

Chương 2 phân tích trực tiếp vì sao DPS có lợi thế so với SoCE. Đây là chương lý thuyết trọng tâm để chuyển từ “vấn đề” sang “phương pháp”.

#### Nội dung cần có

1. Nhắc lại SoCE trực tiếp:

```latex
h_m = \sum_{p=0}^{P-1}\eta_p e^{j2\pi\nu_p m}.
```

2. Phân tích chi phí của SoCE trong một chiều và nhiều chiều.
3. Giải thích tín hiệu giới hạn băng trên tập chỉ số hữu hạn.
4. Trình bày DPS một chiều qua bài toán trị riêng.
5. Giải thích ý nghĩa trị riêng và số chiều thiết yếu.
6. Trình bày biểu diễn không gian con:

```latex
\hat{\mathbf{h}}^D = \mathbf{V}\boldsymbol{\alpha}.
```

7. So sánh hai cách:

   - SoCE: tính từng hàm mũ tại từng mẫu.
   - DPS: tính hệ số trong không gian con rồi tái tạo từ cơ sở có số chiều nhỏ hơn.

8. Phân biệt ba mức hệ số:

   - hệ số chiếu chính xác;
   - hệ số xấp xỉ bằng hàm sóng DPS;
   - hệ số trong nhánh hybrid.

9. Nêu trade-off: giảm độ phức tạp nhưng phát sinh sai số cắt không gian con, sai số xấp xỉ hệ số và yêu cầu bộ nhớ cho cơ sở DPS độ phân giải cao.

#### Điểm cần nhấn mạnh

Chương 2 không chỉ định nghĩa DPS. Chương này phải trả lời câu hỏi:

```text
Trong điều kiện nào DPS có lợi hơn SoCE, và lợi thế đó đến từ đâu?
```

Các kết luận nên viết thận trọng:

```text
Khi miền tần số chuẩn hóa hẹp và số chiều thiết yếu nhỏ hơn đáng kể số mẫu, biểu diễn DPS có khả năng giảm số chiều tính toán so với SoCE trực tiếp.
```

Không viết:

```text
DPS luôn tốt hơn SoCE.
```

### Chương 3: Mô hình hệ thống và triển khai mô phỏng

Tên gợi ý:

```latex
\chaptercustom{3}{MÔ HÌNH HỆ THỐNG VÀ TRIỂN KHAI MÔ PHỎNG}
```

#### Mục tiêu chương

Chương 3 trình bày đầy đủ mô hình GCM MIMO băng rộng, cách rời rạc hóa bốn chiều và cách ánh xạ vào MATLAB. Đây là nơi đặt các công thức hệ thống chi tiết.

#### Nội dung cần có

1. Cấu hình MIMO băng rộng gồm \(N_{\mathrm{Tx}}\) anten phát và \(N_{\mathrm{Rx}}\) anten thu.
2. Mảng tuyến tính đều ULA và khoảng cách \(D_s/\lambda=0{,}5\).
3. Mô hình liên tục:

```latex
h(t,f,x,y) = \sum_{p=0}^{P-1} \eta_p
e^{j2\pi \omega_p t}
e^{-j2\pi \tau_p f}
e^{j\frac{2\pi}{\lambda}\sin(\phi_p)x}
e^{-j\frac{2\pi}{\lambda}\sin(\psi_p)y}.
```

4. Mô hình rời rạc bốn chiều:

```latex
h_{m,q,s,r}
= \sum_{p=0}^{P-1}
\eta_p e^{j2\pi(\nu_p m-\theta_p q+\zeta_p s-\xi_p r)}.
```

5. Giải thích chuẩn hóa:

```text
nu_p = omega_p T_s
theta_p = tau_p F_s
zeta_p = sin(phi_p)D_s/lambda
xi_p = sin(psi_p)D_s/lambda
```

6. Miền giới hạn băng:

```latex
\mathcal{W}
= \mathcal{W}_t \times \mathcal{W}_f
\times \mathcal{W}_{\mathrm{Tx}}
\times \mathcal{W}_{\mathrm{Rx}}.
```

7. Mô tả các nhánh mô phỏng:

   - SoCE tham chiếu;
   - Exact DPS;
   - Approx DPS 4D;
   - Hybrid.

8. Ánh xạ biến MATLAB với ký hiệu trong đồ án.

#### Liên hệ với code

Các biến chính:

```matlab
fc = 2e9;
vmax = 100/3.6;
Ts = 1/3.84e6;
nu_Dmax = vmax * fc * Ts / c;
Fbin = 15e3;
tau_max = 3.7e-6;
theta_max = tau_max * Fbin;
```

Kênh tham chiếu:

```matlab
H_soce = compute_mimo_soce(eta, nu, theta, zeta, xi, M, Q, N_Tx, N_Rx);
```

DPS chính xác:

```matlab
alpha_exact = build_alpha_exact(eta, nu, theta, zeta, xi, ...
    dim_t, dim_f, dim_tx, dim_rx);
```

DPS xấp xỉ 4D:

```matlab
alpha_approx_4d = build_alpha_approx_4d(eta, nu, theta, zeta, xi, ...
    dim_t, dim_f, dim_tx, dim_rx);
```

Hybrid:

```matlab
alpha_hybrid = build_alpha_approx_hybrid(eta, nu, theta, zeta, xi, ...
    dim_t, dim_f, N_Tx, N_Rx);
```

Trong hybrid, phần không gian được tính trực tiếp:

```matlab
e_tx = exp(1j*2*pi*zeta(p) * s);
e_rx = exp(-1j*2*pi*xi(p) * r);
```

### Chương 4: Kết quả mô phỏng và thảo luận

Tên gợi ý:

```latex
\chaptercustom{4}{KẾT QUẢ MÔ PHỎNG VÀ THẢO LUẬN}
```

#### Mục tiêu chương

Chương 4 chỉ dùng số liệu và hình đã được sinh ra từ MATLAB. Không tự tạo kết quả định lượng.

#### Nguồn kết quả chính

```text
results/tables/mimo_dps_kaltenberger_approx_metrics.csv
results/figures/mimo_dps_kaltenberger_approx_tx1_rx1.png
```

#### Cấu hình mô phỏng hiện tại

```text
M = 256
Q = 64
N_Tx = 4
N_Rx = 4
P = 80
D_t = 6
D_f = 9
D_tx = 4
D_rx = 4
D_total = 864
r_t = 2
r_f = 512
r_tx = 512
r_rx = 512
nu_Dmax = 4.82253086419753e-05
theta_max = 0.0555
```

#### Kết quả số hiện có

```text
Exact DPS vs SoCE:
MSE = 3.43343032230382e-09
NMSE = 8.53410711296342e-09
Max |error| = 2.0146451932739e-04

Approx DPS 4D vs SoCE:
MSE = 8.02532358246647e-05
NMSE = 1.99476804943589e-04
Max |error| = 2.2322542601751e-02

Hybrid approx TF + exact spatial vs SoCE:
MSE = 1.72479771816329e-07
NMSE = 4.28714349593195e-07
Max |error| = 1.67138116712813e-03

Hybrid approx vs exact DPS:
MSE = 1.69046341493923e-07
NMSE = 4.20180246065843e-07
Max |error| = 1.6399490919741e-03
```

#### Thời gian chạy hiện có

```text
Runtime SoCE = 0.222372 s
Runtime exact DPS alpha = 0.021346 s
Runtime exact DPS reconstruction = 0.024209 s
Runtime approx 4D alpha = 0.061662 s
Runtime approx 4D reconstruction = 0.019321 s
Runtime hybrid approx alpha = 0.022255 s
Runtime hybrid approx reconstruction = 0.003067 s
```

#### Cách phân tích kết quả

1. Exact DPS có NMSE rất nhỏ, cho thấy số chiều DPS đã chọn đủ để kiểm chứng không gian con trong cấu hình hiện tại.
2. Approx DPS 4D có sai số lớn hơn do áp dụng xấp xỉ hệ số cho cả bốn chiều.
3. Hybrid cho NMSE nhỏ hơn Approx DPS 4D và phù hợp hơn để thảo luận cho MIMO băng rộng.
4. Thời gian chạy MATLAB chỉ có ý nghĩa tham khảo, vì phụ thuộc máy và cách vector hóa.
5. Không dùng một cấu hình mô phỏng để kết luận tổng quát rằng phương pháp luôn tối ưu.

#### Hình chính nên chèn

```latex
Hình~\ref{fig:mimo_dps_kaltenberger_approx_tx1_rx1} so sánh biên độ đáp ứng kênh thu được từ SoCE, DPS chính xác, phương pháp hybrid và sai số tuyệt đối giữa SoCE với hybrid cho cặp anten phát--thu thứ nhất.

\begin{figure}[H]
    \centering
    \includegraphics[width=0.9\textwidth]{results/figures/mimo_dps_kaltenberger_approx_tx1_rx1.png}
    \caption{So sánh đáp ứng kênh giữa SoCE, DPS chính xác và phương pháp hybrid cho cặp anten phát--thu thứ nhất}
    \label{fig:mimo_dps_kaltenberger_approx_tx1_rx1}
\end{figure}
```

#### Bảng kết quả nên đưa vào đồ án

Bảng nên có các dòng:

1. Exact DPS.
2. Approx DPS 4D.
3. Hybrid approx TF + exact spatial.

Các cột nên có:

1. MSE.
2. NMSE.
3. Max \(|\mathrm{error}|\).
4. Runtime alpha.
5. Runtime reconstruction.

Không cần đưa quá nhiều chữ số trong luận văn; nên dùng dạng khoa học, ví dụ \(8{,}53\times 10^{-9}\).

### Chương 5: Kết luận và hướng phát triển

Tên gợi ý:

```latex
\chaptercustom{5}{KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN}
```

#### Nội dung cần có

1. Tổng kết vấn đề: SoCE chính xác về mặt mô hình nhưng có chi phí cao.
2. Tổng kết lý do dùng DPS: kênh giới hạn băng trên khối hữu hạn.
3. Tổng kết các nhánh MATLAB đã triển khai:

   - SoCE tham chiếu;
   - Exact DPS;
   - Approx DPS 4D;
   - Hybrid approx time/frequency + exact spatial.

4. Nêu kết quả chính dựa trên mô phỏng hiện tại: hybrid đạt NMSE \(4{,}2871\times 10^{-7}\) so với SoCE trong cấu hình hiện tại.
5. Nêu hạn chế:

   - chưa khớp lại một hình/bảng cụ thể của bài báo với đầy đủ tham số;
   - cấu hình hiện tại nhỏ hơn cấu hình lớn trong phân tích bài báo;
   - lựa chọn \(D\) và \(r\) còn theo kinh nghiệm, chưa tối ưu tự động theo \(E_{\max}\);
   - thời gian chạy MATLAB chưa đại diện cho triển khai phần cứng.

6. Hướng phát triển:

   - quét tham số \(D\) và \(r\);
   - tăng cấu hình mô phỏng nếu đủ bộ nhớ;
   - tái tạo hình độ phức tạp trong bài báo;
   - chuẩn hóa mã thành các hàm riêng;
   - khảo sát thêm các phân bố MPC không đều.

## Phụ lục đề xuất

### Phụ lục A: Tham số mô phỏng

Đưa bảng các tham số vật lý, kích thước mô phỏng, số chiều DPS và hệ số phân giải.

### Phụ lục B: Hàm MATLAB chính

Nên đưa các đoạn:

1. `compute_mimo_soce`.
2. `make_dps_dimension`.
3. `approximate_gamma_1d`.
4. `build_alpha_approx_4d`.
5. `build_alpha_approx_hybrid`.
6. `reconstruct_hybrid`.

### Phụ lục C: Hướng dẫn chạy lại mô phỏng

```text
1. Mở MATLAB tại thư mục gốc dự án.
2. Chạy `tai lieu/mimo_dps_kaltenberger_approx.m`.
3. Kiểm tra bảng `results/tables/mimo_dps_kaltenberger_approx_metrics.csv`.
4. Kiểm tra hình `results/figures/mimo_dps_kaltenberger_approx_tx1_rx1.png`.
```

## Các giả thiết phải nêu rõ khi viết

1. Dùng `rng(1)` để tái lập kết quả.
2. MPC được sinh đều trong miền giới hạn băng.
3. Trọng số MPC là Gaussian phức tròn và được chuẩn hóa theo số MPC.
4. Chỉ số tần số trong code là `q = 0, ..., Q-1`.
5. Số chiều DPS dùng quy tắc số chiều thiết yếu cộng `guard = 4`.
6. Hệ số phân giải đang cố định: `r_t = 2`, `r_f = r_tx = r_rx = 512`.
7. Hybrid là nhánh chính nên dùng để thảo luận cho MIMO băng rộng.
8. Kết quả hiện tại là mô phỏng kiểm chứng, chưa phải tái tạo đầy đủ một hình cụ thể trong bài báo.

## Checklist trước khi viết hoặc sửa chương

1. Đọc `kich_ban_do_an_tot_nghiep.md`.
2. Đọc `docs/progress_log.md` và `docs/TODO.md`.
3. Đọc chương `.tex` cần sửa.
4. Đọc `docs/equations.md` nếu có thêm hoặc sửa phương trình.
5. Đọc `docs/assumptions.md` nếu có thêm giả thiết.
6. Nếu viết chương kết quả, kiểm tra tệp hình/bảng trong `results/` trước khi nêu số liệu.
7. Phân biệt rõ SoCE, Exact DPS, Approx DPS 4D và Hybrid.
8. Không viết “kết quả chứng minh” nếu mới có một cấu hình mô phỏng.
9. Không đưa số liệu chưa có trong CSV hoặc kết quả MATLAB đã kiểm chứng.
