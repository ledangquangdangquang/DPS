# Kịch bản trình bày ngắn với giảng viên hướng dẫn

## Bản nói 3--5 phút

Em xin trình bày ngắn gọn tình trạng hiện tại của đồ án. Tên đề tài của em là: mô phỏng kênh MIMO băng rộng biến thiên theo thời gian dựa trên mô hình hình học với độ phức tạp thấp bằng chuỗi DPS.

Vấn đề chính em đang xử lý là độ phức tạp khi mô phỏng kênh MIMO băng rộng bằng mô hình hình học. Trong mô hình này, kênh được biểu diễn bằng tổng các hàm mũ phức, tức SoCE, của nhiều thành phần đa đường. SoCE có ý nghĩa vật lý rõ ràng vì mỗi thành phần đa đường gắn với Doppler, trễ, góc phát và góc thu. Tuy nhiên, nếu tính trực tiếp, chương trình phải cộng đóng góp của mọi MPC tại từng mẫu thời gian, từng điểm tần số và từng cặp anten phát--thu. Vì vậy chi phí tăng theo tích của số mẫu, số anten và số MPC.

Hướng tiếp cận của đồ án là khai thác cấu trúc giới hạn băng của kênh. Do Doppler, trễ và góc truyền bị giới hạn bởi tham số vật lý, kênh sau rời rạc hóa không phải một tensor tùy ý mà nằm trong một miền tần số chuẩn hóa hữu hạn. Chuỗi DPS phù hợp với bài toán này vì DPS là cơ sở tập trung năng lượng tốt cho tín hiệu giới hạn băng trên một khối mẫu hữu hạn. Vì vậy, thay vì tính từng MPC tại từng điểm mẫu, em biểu diễn kênh trong một không gian con DPS có số chiều nhỏ hơn.

Về cấu trúc đồ án, Chương 1 đặt vấn đề và giải thích vì sao cần giảm độ phức tạp cho SoCE. Chương 2 trình bày lợi thế của DPS so với SoCE, đồng thời so sánh thêm với SoCE đệ quy và CE-BEM để tránh kết luận chỉ dựa trên một cách cài đặt SoCE. Chương 3 trình bày mô hình kênh MIMO băng rộng, quá trình rời rạc hóa bốn chiều và cách triển khai trong MATLAB. Chương 4 trình bày kết quả mô phỏng, gồm sai số, thời gian chạy, sweep theo số MPC và benchmark bốn phương pháp.

Trong mô phỏng chính, em dùng SoCE làm kênh tham chiếu. Sau đó em so sánh ba nhánh DPS. Nhánh thứ nhất là DPS chính xác, tính hệ số bằng phép chiếu lên cơ sở DPS để kiểm tra sai số do cắt không gian con. Nhánh thứ hai là DPS xấp xỉ 4D, dùng công thức xấp xỉ hệ số trên cả bốn chiều. Nhánh thứ ba là phương pháp hybrid, chỉ dùng DPS xấp xỉ cho hai chiều thời gian và tần số, còn hai chiều anten vẫn tính trực tiếp bằng hàm mũ.

Kết quả chính trong cấu hình \(M=256\), \(Q=64\), \(N_{\mathrm{Tx}}=N_{\mathrm{Rx}}=4\), \(P=80\) cho thấy DPS chính xác đạt NMSE khoảng \(8{,}53\times10^{-9}\), tức sai số cắt không gian con rất nhỏ trong cấu hình này. DPS xấp xỉ 4D có NMSE khoảng \(1{,}99\times10^{-4}\), lớn hơn đáng kể do sai số xấp xỉ hệ số xuất hiện ở cả bốn chiều. Phương pháp hybrid đạt NMSE khoảng \(4{,}29\times10^{-7}\), thấp hơn xấp xỉ 4D hơn hai bậc độ lớn và có thời gian xử lý nhỏ nhất trong phép đo chính.

Em cũng có sweep theo số MPC từ 10 đến 320. Kết quả cho thấy NMSE điển hình của DPS chính xác và hybrid không tăng có hệ thống khi số MPC tăng, nếu miền băng và số chiều DPS giữ cố định. Ngược lại, thời gian SoCE tăng rõ theo số MPC, còn thời gian của các nhánh DPS tăng chậm hơn.

Ngoài ra, em có benchmark bốn phương pháp gồm SoCE trực tiếp, SoCE đệ quy, CE-BEM và DPS chính xác. Tại \(P=80\), CE-BEM và DPS đều nhanh hơn SoCE trực tiếp trong phép đo hiện tại. CE-BEM nhanh hơn một chút, nhưng DPS có NMSE thấp hơn CE-BEM, lần lượt khoảng \(3{,}33\times10^{-9}\) so với \(2{,}96\times10^{-8}\). Vì vậy em không kết luận DPS luôn tốt hơn mọi phương pháp, mà kết luận thận trọng hơn: DPS có lợi khi miền băng hẹp, số chiều cơ sở nhỏ và cơ sở có thể được tái sử dụng qua nhiều khối kênh.

Hạn chế hiện tại là mô phỏng chưa tái tạo đầy đủ một bảng hoặc hình cụ thể của bài báo Kaltenberger với toàn bộ tham số gốc. Cấu hình chính còn hẹp, số chiều DPS và hệ số phân giải vẫn chủ yếu theo quy tắc thiết kế trong chương trình. Thời gian chạy cũng phụ thuộc môi trường MATLAB, nên chỉ nên xem là so sánh tương đối trong cùng điều kiện.

Phần em muốn xin ý kiến thầy cô là: thứ nhất, mạch trình bày như hiện tại đã hợp lý chưa, đặc biệt là cách đặt Chương 2 thành chương phân tích lợi thế DPS so với SoCE. Thứ hai, với kết quả hiện tại, em nên nhấn mạnh phương pháp hybrid như hướng thực dụng chính hay nhấn mạnh DPS chính xác như phần kiểm chứng lý thuyết. Thứ ba, nếu còn thời gian, em nên ưu tiên quét thêm số chiều DPS và hệ số phân giải, hay nên tập trung rà soát bố cục và diễn đạt để hoàn thiện bản nộp.

## Bản nói 1 phút

Đồ án của em nghiên cứu mô phỏng kênh MIMO băng rộng biến thiên theo thời gian bằng mô hình hình học. Kênh tham chiếu được viết dưới dạng SoCE, tức tổng các hàm mũ phức của nhiều thành phần đa đường. Cách này rõ về mặt vật lý nhưng tốn chi phí vì phải cộng mọi MPC tại từng mẫu thời gian, tần số và cặp anten.

Ý tưởng chính của em là dùng DPS để khai thác cấu trúc giới hạn băng của kênh theo Doppler, trễ, góc phát và góc thu. Em triển khai MATLAB với SoCE tham chiếu, DPS chính xác, DPS xấp xỉ 4D và phương pháp hybrid. Trong cấu hình chính, DPS chính xác đạt NMSE \(8{,}53\times10^{-9}\), hybrid đạt \(4{,}29\times10^{-7}\), còn xấp xỉ 4D đạt \(1{,}99\times10^{-4}\). Hybrid là nhánh cân bằng hơn trong mô phỏng hiện tại vì chỉ xấp xỉ theo thời gian--tần số và giữ trực tiếp hai chiều anten.

Kết luận hiện tại của em là DPS có khả năng giảm độ phức tạp khi miền băng hẹp, số chiều cơ sở nhỏ và chi phí tạo cơ sở được tái sử dụng. Em không khẳng định DPS luôn tối ưu. Em muốn xin góp ý thầy cô về mạch trình bày, cách nhấn mạnh kết quả hybrid và việc nên ưu tiên quét thêm tham số hay hoàn thiện bản thuyết minh.

## Các ý cần nhớ khi bị hỏi

- SoCE là chuẩn tham chiếu vì tính trực tiếp từ tham số MPC.
- DPS chính xác không có nghĩa kênh tái tạo tuyệt đối chính xác; nó chỉ có nghĩa hệ số chiếu lên cơ sở đã chọn được tính chính xác.
- Sai số của DPS chính xác chủ yếu đến từ việc cắt không gian con.
- Sai số của DPS xấp xỉ 4D gồm cả sai số cắt và sai số xấp xỉ hệ số trên bốn chiều.
- Hybrid tốt hơn xấp xỉ 4D trong cấu hình này vì tránh xấp xỉ hệ số ở hai chiều anten, trong khi \(N_{\mathrm{Tx}}=N_{\mathrm{Rx}}=4\) vốn đã nhỏ.
- Thời gian trong Chương 4 không phải cam kết tốc độ tuyệt đối; nó chỉ dùng để so sánh trong cùng môi trường MATLAB.
- Điểm mạnh của đồ án là giữ được liên hệ giữa lý thuyết DPS, mô hình GCM và mã MATLAB.
- Điểm hạn chế cần nói thẳng là chưa khớp đầy đủ lại một kết quả định lượng cụ thể của bài báo gốc.

## Câu xin góp ý nên dùng

Thầy cô cho em xin góp ý xem với phạm vi kết quả hiện tại, em nên định vị đóng góp chính của đồ án là kiểm chứng biểu diễn DPS cho kênh MIMO băng rộng, hay nên nhấn mạnh hơn vào nhánh hybrid như một lựa chọn triển khai thực tế hơn cho cấu hình anten nhỏ?

Nếu cần rút gọn bản nộp, em nên giữ phần benchmark bốn phương pháp ở Chương 4 như một kết quả bổ sung, hay chỉ tập trung vào ba nhánh SoCE--DPS chính xác--hybrid để mạch đồ án gọn hơn?
