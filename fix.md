| Tiêu chí | SoCE trực tiếp | DPS chính xác | DPS xấp xỉ 4D | Hybrid DPS |
|---|---|---|---|---|
| **Cách tính** | Cộng trực tiếp đóng góp của từng MPC vào tensor kênh | Chiếu chính xác véc-tơ số mũ của từng MPC lên cơ sở DPS 4D | Xấp xỉ hệ số DPS của từng MPC ở cả bốn chiều | Xấp xỉ DPS ở thời gian–tần số; tính trực tiếp số mũ không gian |
| **Vai trò** | Kênh tham chiếu để đánh giá NMSE | Đánh giá khả năng biểu diễn của không gian con DPS | Tránh tạo trực tiếp toàn bộ tensor SoCE | Hạn chế sai số xấp xỉ không gian và giảm chi phí so với SoCE |
| **Nguồn sai số** | Không có sai số xấp xỉ so với kênh tham chiếu | Sai số cắt không gian con DPS 4D | Sai số cắt và sai số xấp xỉ hệ số ở bốn chiều | Sai số cắt và xấp xỉ hệ số ở hai chiều thời gian–tần số |
| **Hạn chế** | Chi phí tăng theo kích thước tensor và số MPC | Phải tính phép chiếu chính xác cho từng MPC; cần lưu cơ sở DPS 4D | Tính hệ số xấp xỉ ở bốn chiều còn phức tạp | Vẫn tính trực tiếp hai chiều anten |