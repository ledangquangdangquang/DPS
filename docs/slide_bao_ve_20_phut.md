# Slide bảo vệ đồ án tốt nghiệp khoảng 20 phút

## Slide 1. Tên đề tài

**Mô phỏng kênh MIMO băng rộng biến thiên theo thời gian dựa trên mô hình hình học với độ phức tạp thấp bằng chuỗi DPS**

- Sinh viên thực hiện: ...
- Giảng viên hướng dẫn: ...
- Ngành/Lớp: ...

Gợi ý trình bày:

- Nền đơn giản, chữ rõ.
- Có thể đặt một hình minh họa nhỏ về hệ thống MIMO hoặc mô hình kênh.

---

## Slide 2. Mục lục trình bày

Lộ trình 20 phút:

1. **Đặt vấn đề**
   Bối cảnh, SoCE và mục tiêu đồ án.

2. **Cơ sở phương pháp**
   Cấu trúc giới hạn băng, cơ sở DPS và mô hình MIMO bốn chiều.

3. **Triển khai mô phỏng**
   Các nhánh MATLAB, thuật toán DPS và cấu hình mô phỏng chính.

4. **Kết quả**
   Đáp ứng kênh, NMSE, thời gian tính toán và benchmark bổ sung.

5. **Kết luận**
   Hạn chế, kết luận và hướng phát triển.

Thông điệp chính:

**Mạch trình bày đi từ vấn đề độ phức tạp của SoCE đến cách dùng DPS và kiểm chứng bằng mô phỏng MATLAB.**

---

## Slide 3. Bối cảnh nghiên cứu

- Kênh vô tuyến MIMO băng rộng thay đổi theo:
  - thời gian;
  - tần số;
  - anten phát;
  - anten thu.
- Mô hình kênh dựa trên hình học (GCM) mô tả kênh bằng các thành phần đa đường (MPC).
- Mỗi MPC có trễ, Doppler, góc khởi hành, góc tới và trọng số phức.

Thông điệp chính:

**GCM có ý nghĩa vật lý rõ ràng, nhưng mô phỏng trực tiếp có thể tốn chi phí khi kích thước hệ thống tăng.**

---

## Slide 4. Vấn đề của phương pháp SoCE trực tiếp

Công thức SoCE bốn chiều:

```latex
h_{m,q,s,r}
= \sum_{p=0}^{P-1}
\eta_p e^{j2\pi(\nu_p m-\theta_p q+\zeta_p s-\xi_p r)}.
```

Trong đó:

- \(m\): chỉ số thời gian.
- \(q\): chỉ số tần số.
- \(s\): anten phát.
- \(r\): anten thu.
- \(P\): số thành phần đa đường.

Độ phức tạp:

```latex
C_{\mathrm{SoCE}}
= \mathcal{O}(M Q N_{\mathrm{Tx}}N_{\mathrm{Rx}}P).
```

Thông điệp chính:

**SoCE phải cộng đóng góp của mọi MPC tại từng điểm mẫu của tensor kênh.**

---

## Slide 5. Mục tiêu đồ án

Đồ án tập trung vào bốn mục tiêu:

1. Hệ thống hóa mô hình GCM/SoCE cho kênh MIMO băng rộng biến thiên theo thời gian.
2. Trình bày cơ sở DPS cho tín hiệu giới hạn băng trên khối mẫu hữu hạn.
3. Triển khai mô phỏng MATLAB gồm SoCE, DPS chính xác, DPS xấp xỉ 4D và hybrid.
4. Đánh giá sai số NMSE và thời gian tính toán của các nhánh mô phỏng.

Lưu ý:

**Đồ án không tuyên bố đề xuất thuật toán DPS mới, mà kiểm chứng và phân tích cách áp dụng DPS cho bài toán mô phỏng kênh.**

---

## Slide 6. Ý tưởng chính: khai thác cấu trúc giới hạn băng

Các tham số vật lý tạo miền giới hạn:

- Vận tốc cực đại giới hạn Doppler.
- Trễ cực đại giới hạn biến thiên theo tần số.
- Miền góc và khoảng cách anten giới hạn tần số không gian.

Suy ra:

- Kênh không phải tensor tùy ý.
- Kênh có cấu trúc giới hạn băng theo bốn chiều.
- Có thể biểu diễn bằng một không gian con có số chiều nhỏ hơn.

Thông điệp chính:

**DPS phù hợp vì được thiết kế cho tín hiệu giới hạn băng trên đoạn chỉ số hữu hạn.**

---

## Slide 7. Cơ sở DPS

Ý nghĩa của DPS:

- DPS là các chuỗi rời rạc tập trung năng lượng tốt trong một miền tần số cho trước.
- Các vector DPS đầu tiên có trị riêng gần 1.
- Khi trị riêng giảm nhanh, số chiều thiết yếu nhỏ hơn nhiều so với số mẫu ban đầu.

Biểu diễn không gian con:

```latex
\hat{\mathbf{h}}^{D} = \mathbf{V}\boldsymbol{\alpha}.
```

Trong đó:

- \(\mathbf{V}\): ma trận cơ sở DPS đã cắt.
- \(\boldsymbol{\alpha}\): vector hệ số trong không gian DPS.

Thông điệp chính:

**DPS chuyển bài toán từ tính từng MPC tại từng mẫu sang biểu diễn trong không gian con.**

---

## Slide 8. Mô hình MIMO băng rộng bốn chiều

Bốn chiều của tensor kênh:

| Chiều | Đại lượng vật lý | Tần số chuẩn hóa |
|---|---|---|
| Thời gian | Doppler | \(\nu_p\) |
| Tần số | Trễ | \(\theta_p\) |
| Anten phát | AoD | \(\zeta_p\) |
| Anten thu | AoA | \(\xi_p\) |

Quan hệ chuẩn hóa:

```latex
\nu_p = \omega_p T_s,\quad
\theta_p = \tau_p F_s,\quad
\zeta_p = \sin(\phi_p)D_s/\lambda,\quad
\xi_p = \sin(\psi_p)D_s/\lambda.
```

Thông điệp chính:

**Mỗi chiều của kênh có một miền băng riêng, nên cơ sở DPS đa chiều có thể xây dựng từ các cơ sở một chiều.**

---

## Slide 9. Các nhánh mô phỏng MATLAB

Bốn nhánh chính:

| Nhánh | Vai trò |
|---|---|
| SoCE tham chiếu | Tính trực tiếp từ MPC |
| DPS chính xác | Kiểm tra sai số do cắt không gian con |
| DPS xấp xỉ 4D | Xấp xỉ hệ số DPS trên cả bốn chiều |
| Hybrid | Xấp xỉ DPS theo thời gian--tần số, tính trực tiếp hai chiều anten |

Thông điệp chính:

**SoCE là chuẩn so sánh; ba nhánh DPS giúp tách riêng sai số cắt, sai số xấp xỉ hệ số và lợi ích của cách triển khai hybrid.**

---

## Slide 10. Thuật toán DPS trong mô phỏng

Quy trình DPS trong mô phỏng:

| Bước | Nội dung | Ý nghĩa |
|---|---|---|
| 1 | Tạo cơ sở DPS một chiều cho thời gian, tần số, Tx và Rx | Khai thác miền giới hạn băng từng chiều |
| 2 | Tính tensor hệ số \(\boldsymbol{\alpha}\) từ từng MPC | Chuyển từ biểu diễn theo mẫu sang biểu diễn theo hệ số |
| 3 | Tái tạo \(\hat{\mathbf{H}}\) bằng nhân tensor theo từng mode | Sinh lại khối kênh MIMO bốn chiều |
| 4 | So sánh với SoCE bằng NMSE và thời gian | Đánh giá sai số và chi phí tính toán |

Ba cách tính hệ số:

- **DPS chính xác**: hệ số được tính bằng phép chiếu chính xác lên cơ sở DPS đã cắt.
- **DPS xấp xỉ 4D**: hệ số được xấp xỉ từ tần số chuẩn hóa của MPC ở cả bốn chiều.
- **Hybrid**: chỉ xấp xỉ DPS ở thời gian--tần số, còn hai chiều anten dùng hàm mũ trực tiếp.

Thông điệp chính:

**DPS không thay đổi tập MPC; phương pháp chỉ thay đổi cách biểu diễn và tái tạo cùng một kênh.**

---

## Slide 11. Cấu hình mô phỏng chính

| Tham số | Giá trị |
|---|---:|
| \(M\) | 256 |
| \(Q\) | 64 |
| \(N_{\mathrm{Tx}}\) | 4 |
| \(N_{\mathrm{Rx}}\) | 4 |
| \(P\) | 80 |
| \(D_t\) | 6 |
| \(D_f\) | 9 |
| \(D_{\mathrm{Tx}}\) | 4 |
| \(D_{\mathrm{Rx}}\) | 4 |
| \(D_{\mathrm{total}}\) | 864 |

Tổng số mẫu kênh:

```latex
256 \times 64 \times 4 \times 4 = 262144.
```

Thông điệp chính:

**Số hệ số DPS nhỏ hơn đáng kể số phần tử kênh, nhưng tỉ lệ này không đồng nghĩa thời gian chạy giảm đúng cùng tỉ lệ.**

---

## Slide 12. Kết quả minh họa đáp ứng kênh

Hình nên dùng:

```text
results/figures/mimo_dps_kaltenberger_approx_tx1_rx1.png
```

Nội dung trình bày:

- Hình minh họa đáp ứng kênh cho một cặp anten phát--thu.
- So sánh SoCE, DPS chính xác, hybrid và sai số tuyệt đối của hybrid.
- Hình cho thấy cấu trúc biến thiên theo thời gian--tần số được tái tạo tương đối tốt.

Lưu ý khi nói:

**Không kết luận định lượng chỉ từ hình một cặp anten; kết luận định lượng dựa trên NMSE toàn tensor.**

---

## Slide 13. Chỉ tiêu sai số NMSE

Định nghĩa:

```latex
\mathrm{NMSE}
=
\frac{\mathbb{E}\{|H_{\mathrm{ref}}-H_{\mathrm{test}}|^2\}}
{\mathbb{E}\{|H_{\mathrm{ref}}|^2\}}.
```

Ý nghĩa:

- \(H_{\mathrm{ref}}\): kênh tham chiếu SoCE.
- \(H_{\mathrm{test}}\): kênh tái tạo từ nhánh DPS.
- NMSE càng nhỏ thì sai số tương đối càng thấp.
- Phép trung bình được tính trên toàn bộ tensor kênh.

Thông điệp chính:

**NMSE cho phép so sánh sai số tương đối giữa các nhánh trên cùng cấu hình mô phỏng.**

---

## Slide 14. Kết quả NMSE

Hình nên dùng:

```text
results/figures/mimo_dps_kaltenberger_approx_nmse_bar.png
```

Kết quả chính:

| Nhánh | NMSE |
|---|---:|
| DPS chính xác so với SoCE | \(8{,}53\times10^{-9}\) |
| DPS xấp xỉ 4D so với SoCE | \(1{,}99\times10^{-4}\) |
| Hybrid so với SoCE | \(4{,}29\times10^{-7}\) |
| Hybrid so với DPS chính xác | \(4{,}20\times10^{-7}\) |

Nhận xét:

- DPS chính xác có sai số rất nhỏ trong cấu hình hiện tại.
- DPS xấp xỉ 4D có sai số lớn hơn do xấp xỉ hệ số ở cả bốn chiều.
- Hybrid giảm sai số so với xấp xỉ 4D vì tránh xấp xỉ ở hai chiều anten.

---

## Slide 15. Kết quả thời gian tính toán

Hình nên dùng:

```text
results/figures/mimo_dps_kaltenberger_approx_runtime_bar.png
```

Kết quả chính:

| Nhánh | Thời gian |
|---|---:|
| SoCE | \(0{,}222372\,\mathrm{s}\) |
| DPS chính xác | \(0{,}045555\,\mathrm{s}\) |
| DPS xấp xỉ 4D | \(0{,}080983\,\mathrm{s}\) |
| Hybrid | \(0{,}025322\,\mathrm{s}\) |

Lưu ý:

- Thời gian là kết quả trong cùng môi trường MATLAB.
- Chưa nên xem là cam kết tốc độ tuyệt đối.
- Phép đo hiện tại chưa bao gồm đầy đủ chi phí tạo cơ sở DPS.

Thông điệp chính:

**Trong cấu hình hiện tại, hybrid có thời gian xử lý nhỏ nhất trong các nhánh được so sánh.**

---

## Slide 16. Kết quả bổ sung: số MPC và benchmark

Các kết quả bổ sung:

- Sweep theo số MPC \(P = 10,20,40,80,160,320\).
- Benchmark bốn phương pháp:
  - SoCE trực tiếp;
  - SoCE đệ quy;
  - CE-BEM;
  - DPS chính xác.

Nhận xét chính:

- Khi số MPC tăng, thời gian SoCE trực tiếp tăng rõ hơn.
- CE-BEM và DPS có thể nhanh hơn SoCE trực tiếp trong phép đo hiện tại.
- Tại \(P=80\), DPS có NMSE thấp hơn CE-BEM trong benchmark đã thực hiện.

Lưu ý:

**Không kết luận DPS luôn tốt hơn CE-BEM hoặc SoCE; kết quả phụ thuộc cấu hình, miền băng và cách triển khai.**

---

## Slide 17. Hạn chế của đồ án

Các hạn chế chính:

1. Chưa tái tạo đầy đủ một hình hoặc bảng cụ thể của bài báo gốc với toàn bộ tham số khớp nhau.
2. Cấu hình mô phỏng chính còn hẹp.
3. Số chiều DPS và hệ số phân giải chưa được tối ưu tự động trong nhánh chính.
4. Thời gian chạy phụ thuộc môi trường MATLAB, cách vector hóa và phần cứng.
5. Chi phí tạo cơ sở DPS chưa được tính đầy đủ trong phép đo thời gian chính.

Thông điệp chính:

**Kết quả cần được hiểu trong phạm vi cấu hình mô phỏng hiện tại.**

---

## Slide 18. Kết luận và hướng phát triển

Kết luận:

- Đồ án đã trình bày mô hình GCM/SoCE cho kênh MIMO băng rộng biến thiên theo thời gian.
- Đồ án đã triển khai và so sánh các nhánh SoCE, DPS chính xác, DPS xấp xỉ 4D và hybrid.
- Trong cấu hình hiện tại, DPS chính xác có sai số cắt nhỏ.
- Hybrid đạt cân bằng tốt hơn giữa sai số và thời gian so với xấp xỉ 4D.

Hướng phát triển:

- Quét thêm số anten, số MPC, miền băng và số chiều DPS.
- Chọn số chiều DPS và hệ số phân giải theo ngưỡng sai số.
- Tái tạo đầy đủ một kết quả định lượng cụ thể của bài báo Kaltenberger.
- Mở rộng sang mô hình kênh chuẩn thực tế hơn.

Câu kết:

**Em xin kết thúc phần trình bày và kính mong nhận được góp ý của quý thầy cô.**
