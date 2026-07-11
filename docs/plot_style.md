# Quy ước màu biểu đồ MATLAB

Các biểu đồ so sánh phương pháp phải dùng cùng một màu cho cùng một nhánh:

| Phương pháp | RGB MATLAB | Màu |
|---|---:|---|
| SoCE trực tiếp | `[0.25 0.25 0.25]` | Xám đậm |
| SoCE đệ quy | `[0.49 0.18 0.56]` | Tím |
| CE-BEM | `[0.64 0.08 0.18]` | Đỏ sẫm |
| DPS chính xác | `[0.00 0.45 0.74]` | Xanh dương |
| DPS xấp xỉ 4D | `[0.93 0.69 0.13]` | Cam |
| Hybrid | `[0.47 0.67 0.19]` | Xanh lá |

Ngoài màu, các đường trong cùng một biểu đồ nên dùng marker khác nhau để vẫn
phân biệt được khi in thang xám. Biểu đồ trường kênh và trị riêng dùng thang màu
theo đại lượng vật lý, do đó không áp dụng bảng màu phân loại phương pháp này.
