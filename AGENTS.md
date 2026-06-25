# AGENTS.md

## Mục tiêu dự án

Dự án là đồ án tốt nghiệp viết bằng LaTeX về bài báo:

`Kaltenberger_LowComplexGeometryMIMO.pdf`

Dự án đồng thời có mã mô phỏng MATLAB:

`mimo_dps_kaltenberger.m`

Trợ lý AI phải hỗ trợ đồng thời hai phần:

1. Viết và chỉnh sửa nội dung đồ án bằng LaTeX.
2. Đọc, hiểu, sửa và cải thiện mã MATLAB để mô phỏng thống nhất với bài báo và với phần trình bày trong đồ án.

Không được xem báo cáo LaTeX và mã MATLAB là hai phần tách rời. Ký hiệu, phương trình, giả thiết, hình vẽ, bảng số liệu và nhận xét trong hai phần phải nhất quán.

---

## Các tệp quan trọng

Trước khi chỉnh sửa, đọc các tệp sau khi có liên quan.

### Bài báo và ghi chú

* `Kaltenberger_LowComplexGeometryMIMO.pdf`
* `kich_ban_do_an_tot_nghiep.md`
* `docs/paper_notes.md`
* `docs/equations.md`
* `docs/assumptions.md`
* `docs/progress_log.md`
* `docs/TODO.md`
* `NOTE.md`

### MATLAB

* `AGENTS_matlab.md`
* `mimo_dps_kaltenberger.m`
* `tai lieu/mimo_dps_kaltenberger_approx.m`
* `results/figures/`
* `results/tables/`

Khi công việc có liên quan đến đọc, phân tích, viết, sửa, chạy hoặc kiểm tra mã nguồn MATLAB, phải đọc và làm theo hướng dẫn trong `AGENTS_matlab.md` trước khi thực hiện. Nếu có khác biệt giữa hai tệp hướng dẫn, ưu tiên quy tắc cụ thể hơn cho MATLAB trong `AGENTS_matlab.md`, nhưng vẫn phải bảo đảm tính nhất quán giữa mã mô phỏng và nội dung đồ án theo `AGENTS.md` này.

### LaTeX

* `main.tex`
* `NoiDung/Chuong1.tex`
* `NoiDung/Chuong2.tex`
* `NoiDung/Chuong3.tex`
* `NoiDung/Chuong4.tex`
* `NoiDung/Chuong5.tex`
* `KetThuc/KetLuan.tex`
* `KetThuc/PhuLuc.tex`
* `KetThuc/TaiLieuThamKhao.bib`

---

## Quy tắc chính

Mã MATLAB, phần giải thích trong đồ án, phương trình, hình vẽ, bảng số liệu và giả thiết phải thống nhất với nhau.

`kich_ban_do_an_tot_nghiep.md` là kịch bản định hướng chính cho cấu trúc và mạch lập luận của đồ án. Trước khi viết mới hoặc chỉnh sửa nội dung chương, phải đọc tệp này để xác định vai trò của chương đang sửa và tránh viết lệch mạch toàn đồ án.

Mạch chương hiện tại ưu tiên:

1. Chương 1: đặt vấn đề và lý do sử dụng DPS.
2. Chương 2: phân tích lợi thế của DPS so với SoCE.
3. Chương 3: trình bày mô hình hệ thống và triển khai mô phỏng MATLAB.
4. Chương 4: trình bày kết quả mô phỏng và thảo luận dựa trên hình/bảng đã có.
5. Chương 5: kết luận, hạn chế và hướng phát triển.

Nếu nội dung một chương mâu thuẫn với kịch bản này, ưu tiên điều chỉnh chương theo kịch bản, trừ khi người dùng yêu cầu khác rõ ràng.

Nếu mã MATLAB dùng một giả thiết không được nêu rõ trong bài báo, ghi lại giả thiết đó trong:

`docs/assumptions.md`

Nếu đồ án thảo luận một kết quả sinh từ MATLAB, phải kiểm tra hình hoặc bảng tương ứng tồn tại trong:

* `results/figures/`
* `results/tables/`

Không được tự tạo số liệu, kết quả hoặc nhận xét định lượng nếu chưa có kết quả mô phỏng tương ứng.

---

## Ngôn ngữ và văn phong tiếng Việt

Toàn bộ nội dung đồ án phải viết bằng tiếng Việt trang trọng, phù hợp với đồ án tốt nghiệp kỹ thuật.

Văn phong cần:

* rõ ràng;
* khách quan;
* kỹ thuật;
* súc tích;
* thống nhất thuật ngữ giữa các chương;
* tránh giọng hội thoại.

Tránh các cách viết:

* khẳng định quá mức khi chưa có số liệu;
* cụm mơ hồ như "rất tốt", "hiệu quả cao", "vượt trội" nếu không có kết quả định lượng;
* câu cảm tính hoặc văn nói;
* lặp lại cùng một ý ở nhiều chương;
* dùng lẫn lộn thuật ngữ Anh - Việt nếu không cần thiết;
* nhắc tên thư mục, đường dẫn hoặc tên tệp kỹ thuật trong nội dung chính của đồ án nếu không thật sự cần thiết.

Khi viết nội dung chính của các chương, không dùng các câu kiểu:

```text
Chương này đã trình bày kết quả mô phỏng dựa trên hình và bảng đã sinh ra trong thư mục results/.
```

Thay vào đó, viết theo hướng học thuật và tập trung vào nội dung:

```text
Chương này đã trình bày các kết quả mô phỏng và phân tích sai số, thời gian tính toán của các nhánh biểu diễn kênh.
```

Tên thư mục, tên tệp và đường dẫn chỉ nên xuất hiện trong hướng dẫn làm việc, phụ lục mã nguồn, ghi chú kỹ thuật, hoặc khi cần kiểm chứng nguồn dữ liệu trong quá trình trao đổi với người dùng; không đưa chúng vào phần thuyết minh chính của đồ án.

Thuật ngữ tiếng Anh có thể đặt trong ngoặc ở lần xuất hiện đầu tiên, ví dụ:

```latex
mô hình kênh dựa trên hình học (Geometry-based Channel Model, GCM)
```

Sau lần đầu, ưu tiên dùng thuật ngữ viết tắt đã định nghĩa như `GCM`, `MPC`, `DPS`, `SoCE`, `NMSE`.

---

## Định dạng chương LaTeX tiếng Việt

Các chương trong `NoiDung/` đang dùng cấu trúc:

```latex
\chaptercustom{1}{MÔ HÌNH HỆ THỐNG}
\setcounter{section}{1}
```

Khi viết hoặc chỉnh nội dung chương, phải giữ định dạng hiện có:

* dùng `\chaptercustom{<số chương>}{<TÊN CHƯƠNG>}` ở đầu chương;
* dùng `\setcounter{section}{<số chương>}` ngay sau tiêu đề chương;
* dùng `\subsection{...}` cho các mục chính trong chương;
* dùng `\subsubsection{...}` cho mục con khi thật sự cần;
* không tự đổi sang `\chapter{}` hoặc `\section{}` nếu cấu trúc hiện tại không dùng;
* đặt `\label{...}` cho chương, hình, bảng và phương trình quan trọng;
* kết thúc chương bằng `\cleardoublepage` nếu các chương hiện có dùng mẫu đó;
* không chèn `\end{document}` vào các tệp chương được `main.tex` nhập vào.

Tên chương nên thống nhất kiểu viết. Nếu chương hiện tại dùng chữ hoa toàn bộ trong `\chaptercustom`, tiếp tục dùng kiểu đó khi tạo chương mới. Tiêu đề mục bằng tiếng Việt nên ngắn, rõ nghĩa, không dùng câu khẩu hiệu.

Ví dụ phần mở đầu chương:

```latex
\chaptercustom{3}{MÔ PHỎNG KÊNH MIMO BĂNG RỘNG SỬ DỤNG DPS ĐA CHIỀU}
\setcounter{section}{3}
\label{chap:mimo_dps}

\subsection{Mô hình kênh MIMO băng rộng dựa trên hình học}
\label{subsec:wideband_mimo_gcm}
```

---

## Quy tắc trình bày nội dung chương

Khi viết nội dung LaTeX:

1. Đọc tệp `.tex` cần chỉnh trước.
2. Tiếp nối nội dung hiện có, không viết lại toàn bộ chương nếu không được yêu cầu.
3. Giữ thống nhất ký hiệu, chỉ số và cách gọi thuật ngữ.
4. Tái sử dụng các nhãn `\label{}` và khóa trích dẫn `\cite{}` đã có nếu phù hợp.
5. Tránh giải thích trùng lặp giữa các chương.
6. Không chèn placeholder.
7. Không viết kết quả mô phỏng nếu chưa kiểm tra tệp hình/bảng tương ứng.
8. Sau mỗi lần viết thêm hoặc chỉnh sửa nội dung, phải đọc lại toàn bộ phần vừa sửa và phần văn bản liền trước, liền sau với góc nhìn của một người đọc chưa biết về đề tài. Chủ động chỉnh lại để mạch trình bày dễ hiểu: khái niệm và ký hiệu phải được giới thiệu trước khi sử dụng, các bước suy luận phải có câu chuyển ý phù hợp, thuật ngữ phải nhất quán, và không được giả định người đọc đã biết những nội dung chưa được trình bày. Việc đọc lại và chỉnh sửa này là một bước bắt buộc trước khi coi nội dung đã hoàn thành.

Không viết trong nội dung chính:

```text
TODO
Cần bổ sung
Lorem ipsum
Trình bày tại đây
...
```

Nếu thiếu thông tin, báo rõ cho người dùng thay vì chèn văn bản giả vào đồ án.

Trong các đoạn kết luận hoặc thảo luận, dùng cách diễn đạt thận trọng. Ví dụ:

```latex
Trong mô phỏng hiện tại, giá trị NMSE đạt mức ...
```

Không viết:

```latex
Kết quả chứng minh phương pháp luôn tối ưu ...
```

nếu chưa có cơ sở định lượng và phạm vi kiểm chứng rõ ràng.

---

## Quy tắc phương trình và ký hiệu

Luôn dùng LaTeX hợp lệ cho phương trình. Các phương trình quan trọng phải có `\label{...}` và được tham chiếu bằng `\ref{...}` hoặc `\eqref{...}`.

Khi chuyển công thức từ bài báo sang đồ án:

* kiểm tra chỉ số đang dùng trong chương, ví dụ `m`, `q`, `s`, `r`;
* kiểm tra dấu pha của từng chiều: Doppler, trễ, AoD, AoA;
* kiểm tra đơn vị và đại lượng chuẩn hóa;
* ghi rõ quan hệ với bài báo nếu công thức lấy từ một phương trình cụ thể;
* cập nhật `docs/equations.md` nếu thêm hoặc đổi ánh xạ phương trình quan trọng.

Ví dụ:

```latex
\begin{equation}
h_{\mathbf{m}} = \sum_{p=0}^{P-1} \eta_p e^{j2\pi(\mathbf{f}_p \cdot \mathbf{m})}.
\label{eq:4d_soc}
\end{equation}
```

---

## Quy tắc hình trong LaTeX

Hình sinh từ MATLAB phải lấy từ:

`results/figures/`

Ví dụ:

```latex
\begin{figure}[H]
    \centering
    \includegraphics[width=0.85\textwidth]{results/figures/mimo_dps_kaltenberger_tx1_rx1.png}
    \caption{So sánh đáp ứng kênh giữa phương pháp SoCE và biểu diễn DPS cho cặp anten phát--thu thứ nhất}
    \label{fig:mimo_dps_kaltenberger_tx1_rx1}
\end{figure}
```

Mỗi hình phải:

* được giới thiệu trước khi xuất hiện;
* được tham chiếu bằng `Hình~\ref{...}`;
* có caption tiếng Việt rõ nghĩa;
* được phân tích sau khi xuất hiện;
* không chèn nếu tệp hình chưa tồn tại;
* không dùng hình chỉ để trang trí.

---

## Quy tắc bảng trong LaTeX

Bảng kết quả mô phỏng phải dựa trên dữ liệu trong:

`results/tables/`

Mỗi bảng phải có:

* `\caption{...}` bằng tiếng Việt;
* `\label{...}`;
* tham chiếu trong phần văn bản trước hoặc sau bảng;
* giải thích ý nghĩa các cột và kết quả chính.

Không tự nhập số liệu nếu không có tệp kết quả hoặc nguồn rõ ràng.

---

## Quy tắc trích dẫn

Dùng BibTeX tại:

`KetThuc/TaiLieuThamKhao.bib`

Trước khi thêm trích dẫn mới:

1. Kiểm tra khóa trích dẫn đã tồn tại chưa.
2. Tái sử dụng khóa hiện có nếu phù hợp.
3. Không tạo tài liệu tham khảo giả.
4. Dùng `\cite{}` cho các khẳng định dựa trên bài báo hoặc tài liệu ngoài.

Các khẳng định về mô hình, phương trình và tham số lấy từ bài báo Kaltenberger phải trích dẫn bằng khóa tương ứng, ví dụ:

```latex
\cite{Kaltenberger2007}
```

---

## Quy tắc đọc mã MATLAB

Trước khi chỉnh `mimo_dps_kaltenberger.m`:

1. Đọc toàn bộ mã.
2. Xác định mục đích mô phỏng.
3. Xác định tham số đầu vào.
4. Xác định hình và bảng đầu ra.
5. Xác định phương trình hoặc mục nào trong bài báo được triển khai.
6. Kiểm tra đầu ra của mã có đang được dùng trong đồ án hay không.

Không viết lại toàn bộ mã nếu không được yêu cầu. Ưu tiên các chỉnh sửa nhỏ, có kiểm soát.

---

## Quy tắc chỉnh mã MATLAB

Khi chỉnh mã MATLAB:

* giữ mã chạy được từ thư mục gốc dự án;
* dùng đường dẫn tương đối;
* lưu hình vào `results/figures/`;
* lưu bảng vào `results/tables/`;
* không hardcode đường dẫn tuyệt đối;
* dùng `rng(1)` để tái lập kết quả;
* thêm chú thích ánh xạ khối mã quan trọng với bài báo.

Ví dụ:

```matlab
% Based on Eq. (47) in Kaltenberger et al.
```

Nếu chưa chắc số phương trình, viết:

```matlab
% Based on the system model described in Section II of the paper.
```

---

## Quy tắc đầu ra MATLAB

Khi chạy, mã MATLAB phải tạo đầu ra tái lập được.

Vị trí đầu ra kỳ vọng:

```text
results/
├── figures/
│   ├── mimo_dps_kaltenberger_tx1_rx1.fig
│   ├── mimo_dps_kaltenberger_tx1_rx1.png
│   ├── mimo_dps_kaltenberger_approx_tx1_rx1.fig
│   └── mimo_dps_kaltenberger_approx_tx1_rx1.png
└── tables/
    ├── mimo_dps_kaltenberger_metrics.csv
    └── mimo_dps_kaltenberger_approx_metrics.csv
```

Khi viết chương kết quả, ưu tiên dùng `tai lieu/mimo_dps_kaltenberger_approx.m` và `results/tables/mimo_dps_kaltenberger_approx_metrics.csv` vì file này có nhánh DPS xấp xỉ 4D và hybrid.

Trước khi sửa nội dung đồ án có thảo luận kết quả mô phỏng, kiểm tra các tệp đầu ra có tồn tại hay không.

Nếu đầu ra chưa tồn tại, không được tự tạo nhận xét định lượng.

---

## Checklist kiểm tra MATLAB

Sau khi chỉnh mã MATLAB, kiểm tra:

* lỗi cú pháp;
* kích thước mảng;
* chỉ số mảng;
* đơn vị;
* thang dB và thang tuyến tính;
* đơn vị trễ thời gian;
* đơn vị Doppler;
* góc dùng độ hay radian;
* chuẩn hóa công suất hoặc biên độ;
* khả năng tái lập với seed cố định.

Với giá trị công suất:

```matlab
linearPower = 10^(powerDb/10);
powerDb = 10*log10(linearPower);
```

Với giá trị biên độ:

```matlab
linearAmplitude = 10^(amplitudeDb/20);
amplitudeDb = 20*log10(linearAmplitude);
```

---

## Quy tắc tài liệu ghi chú

Duy trì các tệp sau:

### `docs/paper_notes.md`

Dùng để tóm tắt bài báo.

### `docs/equations.md`

Dùng để ánh xạ phương trình trong bài báo với phương trình trong đồ án và biến MATLAB.

Ví dụ:

```text
Paper Eq. (47)
Meaning: sampled multidimensional SoCE representation
MATLAB variable/function: H_soce, compute_mimo_soce(...)
Thesis location: Chapter 3, Eq. \ref{eq:4d_soc}
```

### `docs/assumptions.md`

Dùng để ghi mọi giả thiết không được nêu rõ trong bài báo.

Ví dụ:

```text
Assumption:
Initial phase is uniformly distributed in [0, 2*pi].

Reason:
The paper does not explicitly specify initial phase generation.

Used in:
mimo_dps_kaltenberger.m
```

### `docs/progress_log.md`

Sau thay đổi đáng kể, ghi lại tiến độ. Mỗi mục nên có:

* ngày;
* mục tiêu;
* tệp đã đọc;
* tệp đã sửa;
* nội dung đã hoàn thành;
* kết quả;
* vấn đề còn tồn tại;
* giả thiết đã dùng;
* bước tiếp theo.

### `docs/TODO.md`

Ghi các việc còn dang dở, không chèn TODO vào nội dung chính của đồ án.

---

## Quy trình làm việc trong mỗi phiên

Khi bắt đầu phiên:

1. Đọc `docs/progress_log.md`.
2. Đọc `docs/TODO.md`.
3. Đọc `kich_ban_do_an_tot_nghiep.md` nếu công việc liên quan đến viết/chỉnh nội dung đồ án, cấu trúc chương, phương trình, kết quả hoặc nhận xét.
4. Đọc tệp `.tex` hoặc `.m` cần chỉnh.
5. Đọc ghi chú liên quan trong `docs/`.
6. Tiếp tục từ trạng thái hiện tại của dự án.

Trước khi kết thúc phiên:

1. Cập nhật `docs/progress_log.md` nếu có thay đổi đáng kể.
2. Cập nhật `docs/TODO.md` nếu có việc mới hoặc việc đã hoàn thành.
3. Cập nhật `docs/assumptions.md` nếu có giả thiết mới.
4. Cập nhật `docs/equations.md` nếu thêm hoặc đổi ánh xạ phương trình.

Nếu người dùng yêu cầu chỉ sửa một tệp cụ thể, không sửa các tệp khác trừ khi thật sự cần để bảo toàn tính nhất quán hoặc người dùng đồng ý.

---

## Quy tắc nhất quán giữa MATLAB và đồ án

Trước khi viết một kết quả trong đồ án, phải xác minh:

* mã MATLAB nào sinh ra kết quả;
* tệp hình hoặc bảng nào chứa kết quả;
* tham số mô phỏng đã dùng;
* kết quả có khớp với nội dung văn bản hay không.

Việc xác minh tệp nguồn là bắt buộc trong quá trình làm việc, nhưng khi viết nội dung chính của đồ án thì ưu tiên diễn đạt bằng tên hình, tên bảng, nhánh mô phỏng và chỉ tiêu đánh giá; tránh nhắc trực tiếp đường dẫn như `results/figures/`, `results/tables/`, `docs/` hoặc các tên tệp cụ thể.

Nếu kết quả chưa được kiểm chứng đầy đủ, viết thận trọng:

```latex
Trong mô phỏng hiện tại, ...
```

Không viết:

```latex
Kết quả chứng minh ...
```

trừ khi dữ liệu thật sự hỗ trợ kết luận đó và phạm vi kết luận đã được nêu rõ.

---

## Định dạng phản hồi cho người dùng

Khi hỗ trợ người dùng, trả lời trực tiếp và thực tế, ưu tiên cấu trúc:

1. Đã kiểm tra những gì.
2. Nên thay đổi những gì.
3. Mã LaTeX hoặc MATLAB sẵn sàng dán nếu người dùng cần.
4. Giả thiết hoặc cảnh báo nếu có.

Nếu đã chỉnh tệp, nêu rõ:

* tệp đã sửa;
* nội dung chính đã sửa;
* có chạy kiểm tra hay không.

Giữ phản hồi ngắn gọn, đúng trọng tâm, bằng tiếng Việt.
