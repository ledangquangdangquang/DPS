# KỊCH BẢN THUYẾT TRÌNH BẢO VỆ ĐỒ ÁN

**Tệp trình chiếu:** `presentation.pdf`  
**Thời lượng mục tiêu:** khoảng 18--20 phút  
**Người trình bày:** Lê Đăng Quang -- MSSV 20224113

## Slide 1 -- Trang chờ (không tính thời gian)

Giữ trang này khi chờ đến lượt trình bày. Khi được hội đồng cho phép, chuyển sang slide tiêu đề.

## Slide 2 -- Tiêu đề (30 giây)

Kính thưa thầy cô trong hội đồng. Em là Lê Đăng Quang, mã số sinh viên 20224113. Hôm nay, em xin trình bày đồ án tốt nghiệp với đề tài: “Mô phỏng kênh MIMO băng rộng biến thiên theo thời gian dựa trên mô hình hình học với độ phức tạp thấp bằng chuỗi DPS”. Đồ án được thực hiện dưới sự hướng dẫn của TS. Nguyễn Hồng Anh.

Mục tiêu chính của đồ án là khảo sát cách dùng chuỗi DPS để biểu diễn kênh MIMO băng rộng trong một không gian con có số chiều nhỏ hơn, từ đó giảm chi phí mô phỏng nhưng vẫn duy trì độ chính xác phù hợp.

## Slide 3 -- Mục lục (20 giây)

Phần trình bày gồm năm nội dung. Đầu tiên, em nêu bối cảnh và mục tiêu của bài toán. Tiếp theo là cơ sở lý thuyết của DPS. Phần thứ ba trình bày mô hình và quy trình mô phỏng trên MATLAB. Sau đó, em phân tích các kết quả về sai số và thời gian chạy. Cuối cùng là kết luận và các đóng góp chính của đồ án.

## Slide 4 -- Bối cảnh bài toán (45 giây)

Trong môi trường vô tuyến, tín hiệu đến máy thu qua nhiều đường truyền, gọi là các thành phần đa đường hay MPC. Mỗi MPC được đặc trưng bởi bốn tham số chính: tần số Doppler, độ trễ, góc phát và góc thu.

Khi lấy mẫu theo thời gian, tần số, anten phát và anten thu, đáp ứng kênh trở thành một tensor bốn chiều. Nếu số mẫu và số MPC lớn, việc tính trực tiếp toàn bộ tensor đòi hỏi nhiều phép toán. Vì vậy, bài toán đặt ra là tìm một biểu diễn gọn hơn nhưng vẫn giữ được thông tin quan trọng của kênh.

## Slide 5 -- Biểu diễn SoCE liên tục (50 giây)

Biểu thức trên slide là mô hình tổng các số mũ phức, hay SoCE. Đáp ứng kênh được tạo bằng cách cộng đóng góp của từng MPC. Mỗi đóng góp gồm hệ số phức \(\eta_p\) và bốn thành phần pha tương ứng với Doppler, độ trễ, góc phát và góc thu.

Ưu điểm của SoCE là bám trực tiếp vào các tham số vật lý và được dùng làm kênh tham chiếu trong đồ án. Tuy nhiên, với mỗi phần tử của tensor, ta phải cộng qua toàn bộ số MPC. Vì thế, chi phí tăng nhanh khi kích thước tensor hoặc số MPC tăng.

## Slide 6 -- Rời rạc hóa mô hình (50 giây)

Để triển khai trên máy tính, bốn biến liên tục được rời rạc hóa thành các chỉ số mẫu thời gian, tần số, anten phát và anten thu. Đồng thời, các tham số vật lý được chuẩn hóa thành tần số rời rạc ở từng chiều.

Sau bước này, mỗi MPC tạo ra một số mũ phức bốn chiều. Tensor kênh vẫn là tổng đóng góp của tất cả MPC, nhưng biểu thức rời rạc cho phép xây dựng trực tiếp trong MATLAB và cũng là cơ sở để chiếu kênh lên không gian DPS.

## Slide 7 -- Câu hỏi nghiên cứu (35 giây)

Tensor bốn chiều có thể rất lớn, nhưng các tham số vật lý không phân bố trên toàn bộ miền tần số chuẩn hóa. Từ đó, câu hỏi chính của đồ án là: liệu thông tin của tensor kênh có tập trung trong một không gian con nhỏ hơn hay không?

Nếu câu trả lời là có, ta chỉ cần lưu và xử lý một số hệ số trong không gian con, thay vì tính toàn bộ tensor bằng SoCE ở mọi lần mô phỏng.

## Slide 8 -- Ý tưởng dùng DPS (55 giây)

Quan sát quan trọng là Doppler, độ trễ, góc phát và góc thu đều bị giới hạn trong các miền hữu hạn. Với một tín hiệu có độ dài hữu hạn và miền tần số hữu hạn, chuỗi DPS tạo ra một cơ sở có khả năng tập trung năng lượng tốt.

Do đó, ở mỗi chiều của tensor, em xây dựng một cơ sở DPS thích hợp. Cơ sở bốn chiều được hình thành từ tích tensor của bốn cơ sở một chiều. Nếu năng lượng chỉ tập trung ở một số véc-tơ đầu, tensor kênh có thể được biểu diễn bằng ít hệ số hơn đáng kể.

## Slide 9 -- Ma trận tập trung DPS (50 giây)

Ma trận trên slide mô tả toán tử tập trung năng lượng trong một dải tần hữu hạn. Các phần tử của ma trận có dạng sinc; trên đường chéo, giá trị bằng hai lần độ rộng nửa dải. Các véc-tơ riêng của ma trận chính là các chuỗi DPS, còn trị riêng cho biết mức năng lượng được tập trung trong miền đã chọn.

Trong mô phỏng, cơ sở được dịch đến tâm dải của từng chiều để phù hợp với miền Doppler, trễ hoặc góc đang xét. Số véc-tơ giữ lại quyết định trực tiếp sự đánh đổi giữa độ chính xác và kích thước biểu diễn.

## Slide 10 -- Phổ trị riêng (45 giây)

Đồ thị cho thấy các trị riêng được sắp xếp giảm dần. Khoảng bốn đến năm trị riêng đầu gần bằng một, sau đó các trị riêng giảm rất nhanh về gần không.

Điều này cho thấy phần lớn năng lượng nằm trong một số ít véc-tơ DPS đầu tiên. Đây là cơ sở để cắt giảm số chiều: ta giữ các véc-tơ ứng với trị riêng lớn và bỏ các thành phần đóng góp năng lượng rất nhỏ.

## Slide 11 -- Thuật toán tạo cơ sở DPS (50 giây)

Thuật toán đầu tiên tạo cơ sở DPS một chiều. Đầu vào gồm số mẫu, miền tần số chuẩn hóa và số véc-tơ cần giữ. Trước hết, ma trận tập trung được xây dựng từ độ rộng dải. Sau đó, bài toán trị riêng được giải và các véc-tơ được sắp xếp theo trị riêng giảm dần.

Cuối cùng, các véc-tơ được dịch đến tần số trung tâm của dải. Quy trình này được thực hiện độc lập cho bốn chiều, tạo ra các ma trận cơ sở cho thời gian, tần số, anten phát và anten thu.

## Slide 12 -- Thuật toán SoCE trực tiếp (45 giây)

Đây là nhánh tham chiếu. Tensor kênh được khởi tạo bằng không. Với từng MPC, thuật toán tạo bốn véc-tơ số mũ phức từ các tham số Doppler, độ trễ, góc phát và góc thu, sau đó lấy tích ngoài bốn chiều, nhân với hệ số đường truyền và cộng vào tensor.

Nhánh này không có sai số xấp xỉ mô hình, nhưng phải cập nhật toàn bộ tensor cho từng MPC nên có thời gian chạy lớn khi số MPC tăng.

## Slide 13 -- Thuật toán DPS chính xác (55 giây)

Với DPS chính xác, trước hết tensor SoCE được tạo như nhánh tham chiếu. Sau đó, tensor được chiếu lần lượt lên bốn cơ sở DPS để thu tensor hệ số có kích thước nhỏ hơn. Kênh được tái tạo bằng các phép nhân tensor theo từng mode.

Sai số của nhánh này chủ yếu là sai số cắt không gian con. Vì hệ số được lấy từ phép chiếu chính xác của tensor SoCE, nhánh này phù hợp để kiểm chứng rằng cơ sở DPS đã chọn có biểu diễn tốt kênh hay không. Tuy nhiên, nó vẫn cần tạo SoCE trước nên chưa loại bỏ hoàn toàn chi phí tham chiếu.

## Slide 14 -- Thuật toán DPS xấp xỉ 4D (60 giây)

Nhánh DPS xấp xỉ 4D không tạo toàn bộ tensor SoCE trước. Với từng MPC, thuật toán xấp xỉ trực tiếp hệ số DPS ở cả bốn chiều từ các tham số vật lý, sau đó lấy tích ngoài các hệ số một chiều để cập nhật tensor hệ số bốn chiều.

Sau khi xử lý tất cả MPC, tensor kênh được tái tạo từ cơ sở DPS. Cách này hướng đến giảm việc tính SoCE trực tiếp, nhưng phải xấp xỉ hệ số ở cả bốn chiều. Vì vậy, sai số gồm cả sai số cắt và sai số xấp xỉ hệ số.

## Slide 15 -- Thuật toán hybrid DPS (60 giây)

Phương pháp hybrid sử dụng DPS ở hai chiều thời gian và tần số, trong khi hai chiều không gian anten vẫn dùng trực tiếp các véc-tơ số mũ phức.

Ý tưởng là chỉ xấp xỉ ở những chiều mà DPS đem lại hiệu quả rõ rệt, đồng thời tránh tích lũy sai số xấp xỉ ở cả bốn chiều. Sau khi cộng đóng góp của các MPC trong miền hệ số, kênh được tái tạo theo hai cơ sở DPS thời gian và tần số. Nhánh này tạo điểm cân bằng giữa DPS xấp xỉ 4D và cách tính trực tiếp.

## Slide 16 -- Xấp xỉ hệ số DPS một chiều (55 giây)

Slide này trình bày thủ tục tính gần đúng một hệ số DPS tại một tần số bất kỳ. Thuật toán dùng một lưới tần số có độ phân giải cao, xác định các điểm lưới lân cận và nội suy giá trị của hàm sóng DPS.

Thủ tục một chiều này được gọi lặp lại cho các tham số của từng MPC. Trong nhánh xấp xỉ 4D, nó được áp dụng ở cả bốn chiều; trong nhánh hybrid, nó chỉ được áp dụng ở chiều thời gian và tần số. Vì thế, chất lượng của bước này ảnh hưởng trực tiếp đến NMSE của hai nhánh xấp xỉ.

## Slide 17 -- Bốn nhánh mô phỏng (55 giây)

Để đánh giá công bằng, đồ án triển khai bốn nhánh. SoCE trực tiếp là kênh tham chiếu. Với DPS chính xác, các véc-tơ số mũ của từng MPC được chiếu chính xác lên cơ sở DPS ở cả bốn chiều. DPS xấp xỉ 4D thay các phép chiếu này bằng công thức xấp xỉ hệ số ở cả bốn chiều. Hybrid DPS chỉ dùng hệ số DPS xấp xỉ ở thời gian và tần số, còn hai chiều anten vẫn được tính bằng các véc-tơ số mũ trực tiếp.

Như vậy, ba phương pháp khác nhau tại bước tạo hệ số và số chiều được nén. DPS chính xác nén cả bốn chiều nhưng phải thực hiện phép chiếu chính xác. DPS xấp xỉ 4D cũng nén cả bốn chiều và hướng đến giảm chi phí phép chiếu, nhưng phát sinh sai số xấp xỉ ở cả bốn chiều. Hybrid chỉ nén hai chiều thời gian--tần số, nhờ đó hạn chế sai số xấp xỉ nhưng vẫn phải xử lý trực tiếp phần anten.

Tensor SoCE được tính riêng để làm chuẩn đánh giá NMSE; nó không phải đầu vào bắt buộc của ba thuật toán DPS.

## Slide 18 -- Pipeline MATLAB (50 giây)

Quy trình mô phỏng bắt đầu bằng việc khởi tạo tham số và sinh ngẫu nhiên các MPC với seed cố định để bảo đảm khả năng tái lập. Cùng một tập MPC được đưa vào các nhánh SoCE, DPS chính xác, DPS xấp xỉ 4D và hybrid.

Sau khi tái tạo tensor kênh, chương trình đo thời gian chạy và tính NMSE của từng nhánh DPS so với SoCE. Cuối cùng, các kết quả được tổng hợp thành hình và bảng để phân tích.

## Slide 19 -- Tham số cấu hình (50 giây)

Mô phỏng sử dụng tốc độ ánh sáng \(3\times10^8\) mét trên giây, tần số sóng mang 2 GHz, vận tốc 100 km/h và số MPC mặc định là 80. Tensor kênh có kích thước \(64\times10\times4\times4\), tương ứng với thời gian, tần số, anten phát và anten thu.

Số véc-tơ DPS được chọn lần lượt là 6, 9, 4 và 4. Seed ngẫu nhiên được cố định bằng 1. Ngoài cấu hình đơn, đồ án còn khảo sát số MPC từ 10 đến 320 để đánh giá khả năng mở rộng.

## Slide 20 -- Minh họa đáp ứng kênh (45 giây)

Bốn hình minh họa biên độ của kênh SoCE, DPS chính xác, hybrid và bản đồ sai số giữa SoCE với hybrid tại một lát cắt anten. Các dạng đáp ứng chính của kênh được giữ lại trong các biểu diễn DPS.

Hình sai số cho thấy khác biệt tồn tại nhưng có biên độ nhỏ so với đáp ứng kênh. Đánh giá định lượng không chỉ dựa vào quan sát hình ảnh mà được thực hiện bằng NMSE ở các slide tiếp theo.

## Slide 21 -- NMSE khi thay đổi số MPC (70 giây)

Đồ thị trình bày NMSE theo số MPC. Kết quả cho thấy sai số của các phương pháp tương đối ổn định khi số MPC thay đổi. DPS chính xác đạt NMSE xấp xỉ \(10^{-9}\), tức gần với SoCE nhất.

Hybrid đạt khoảng \(10^{-7}\), tốt hơn DPS xấp xỉ 4D, có NMSE khoảng \(10^{-5}\), xấp xỉ hai bậc độ lớn trong cấu hình khảo sát. Kết quả này cho thấy việc chỉ xấp xỉ hai chiều trong phương pháp hybrid giúp hạn chế sự tích lũy sai số so với xấp xỉ cả bốn chiều.

Các con số này là kết quả trong cấu hình mô phỏng hiện tại, không phải giới hạn đúng cho mọi mô hình kênh.

## Slide 22 -- Thời gian chạy theo số MPC (70 giây)

Thời gian chạy tăng khi số MPC tăng. SoCE trực tiếp là nhánh chậm nhất và có tốc độ tăng rõ nhất, vì từng MPC phải cập nhật toàn bộ tensor bốn chiều.

Trong nhóm DPS, DPS chính xác có thời gian phần biểu diễn và tái tạo thấp nhất; hybrid nhanh hơn SoCE nhưng chậm hơn DPS chính xác; còn DPS xấp xỉ 4D chậm nhất trong nhóm DPS do phải xấp xỉ hệ số ở cả bốn chiều.

Khi diễn giải kết quả này, cần lưu ý cách đo của từng nhánh và chi phí tiền xử lý cơ sở. Kết quả cho thấy tiềm năng giảm chi phí bằng biểu diễn DPS, đồng thời cũng chỉ ra rằng xấp xỉ nhiều chiều chưa chắc đã nhanh hơn nếu khâu tính hệ số còn phức tạp.

## Slide 23 -- Đánh đổi NMSE và runtime tại 80 MPC (70 giây)

Biểu đồ này đặt thời gian chạy trên trục ngang và NMSE trên trục dọc tại \(P=80\), nên điểm càng gần góc dưới bên trái càng thuận lợi.

SoCE là tham chiếu nên không có NMSE nhưng có thời gian chạy lớn nhất. DPS chính xác đạt sai số khoảng \(10^{-9}\) với thời gian thấp, nên cho điểm đánh đổi tốt nhất trong phép đo hiện tại. Hybrid duy trì NMSE khoảng \(10^{-7}\) và giảm thời gian đáng kể so với SoCE. DPS xấp xỉ 4D có sai số lớn hơn nhưng lợi ích thời gian chưa tương xứng.

Từ kết quả hiện tại, DPS chính xác đồng thời nhanh hơn và chính xác hơn hai nhánh xấp xỉ, nên đây là phương pháp nên ưu tiên cho cấu hình đã khảo sát. Hybrid là phương án thứ hai khi muốn giới hạn việc dùng DPS ở hai chiều thời gian--tần số và chấp nhận xử lý trực tiếp phần anten. DPS xấp xỉ 4D hiện chưa phải lựa chọn triển khai phù hợp vì sai số lớn hơn trong khi thời gian tính hệ số chưa đem lại lợi ích tương xứng.

Cần phân biệt kết luận thực nghiệm với mục tiêu lý thuyết: công thức xấp xỉ hệ số được đề xuất để giảm chi phí phép chiếu khi kích thước tăng, nhưng triển khai MATLAB hiện tại chưa được tối ưu đủ để thể hiện lợi thế đó. Vì vậy, hướng thực tế trước mắt là dùng DPS chính xác; hướng nghiên cứu tiếp theo là tối ưu phép tính hệ số xấp xỉ, sau đó mới đánh giá lại hybrid và DPS xấp xỉ 4D ở quy mô lớn hơn.

## Slide 24 -- Kết luận (70 giây)

Đồ án đã xây dựng mô phỏng kênh MIMO băng rộng dựa trên mô hình hình học SoCE, đồng thời triển khai và đánh giá ba cách biểu diễn DPS: DPS chính xác, DPS xấp xỉ 4D và hybrid.

Trong cấu hình khảo sát, DPS chính xác đạt NMSE khoảng \(10^{-9}\), gần tương đương SoCE. Hybrid đạt NMSE khoảng \(10^{-7}\) và giảm đáng kể thời gian tính toán. Các kết quả theo số MPC cũng cho thấy các nhánh DPS có khả năng mở rộng tốt hơn SoCE trong phạm vi đã kiểm chứng.

Về lựa chọn phương pháp, kết quả MATLAB hiện tại cho thấy DPS chính xác có điểm đánh đổi tốt nhất giữa NMSE và runtime, nên là phương án được ưu tiên. Hybrid đứng thứ hai nhờ hạn chế xấp xỉ ở hai chiều, nhưng vẫn phải xử lý trực tiếp phần anten. DPS xấp xỉ 4D có ý nghĩa nghiên cứu về tính hệ số không cần phép chiếu đầy đủ, tuy nhiên chưa phù hợp để ưu tiên triển khai khi phiên bản hiện tại vừa có sai số lớn hơn vừa chưa nhanh hơn hai phương pháp còn lại.

Hạn chế hiện tại là hiệu quả còn phụ thuộc vào cách chọn số chiều DPS, độ phân giải dùng để xấp xỉ hệ số và cấu hình mô phỏng. Hướng phát triển tiếp theo là lựa chọn số chiều thích nghi, tối ưu thủ tục tính hệ số và đánh giá trên các mô hình kênh có quy mô lớn hơn.

## Slide 25 -- Tài liệu tham khảo (15 giây)

Đồ án dựa chủ yếu trên mô hình mô phỏng kênh hình học độ phức tạp thấp của Kaltenberger và cộng sự, cùng với lý thuyết DPS của Slepian. Các tài liệu còn lại được dùng để xây dựng bối cảnh về mô hình kênh MIMO và các mô hình kênh hiện đại.

## Slide 26 -- Cảm ơn (15 giây)

Phần trình bày của em xin kết thúc tại đây. Em xin chân thành cảm ơn thầy cô trong hội đồng đã lắng nghe. Em kính mong nhận được các câu hỏi và ý kiến góp ý của thầy cô.

---

## Ghi nhớ khi trình bày

- Không đọc nguyên văn phương trình hoặc giả mã; chỉ nêu đầu vào, ý nghĩa và điểm khác nhau giữa các nhánh.
- Nhấn mạnh SoCE là kênh tham chiếu; DPS chính xác vẫn cần tạo SoCE trước trong triển khai hiện tại.
- Khi nói về số liệu, dùng cụm “trong cấu hình mô phỏng hiện tại” để tránh khẳng định quá phạm vi kiểm chứng.
- Phân biệt rõ: DPS chính xác có sai số cắt; DPS xấp xỉ 4D có sai số cắt và xấp xỉ hệ số ở bốn chiều; hybrid chỉ xấp xỉ hệ số ở hai chiều thời gian--tần số.
- Nếu bị giới hạn còn 15 phút, rút gọn các slide 9 và 11--16 xuống khoảng 20--25 giây mỗi slide; dành thời gian cho các slide 21--24.
