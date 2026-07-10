# Script đọc thuyết trình bảo vệ đồ án khoảng 20 phút

## Slide 1. Tên đề tài

Em xin kính chào quý thầy cô trong hội đồng. Em xin trình bày đồ án tốt nghiệp với đề tài: "Mô phỏng kênh MIMO băng rộng biến thiên theo thời gian dựa trên mô hình hình học với độ phức tạp thấp bằng chuỗi DPS".

Nội dung trình bày của em gồm bối cảnh bài toán, mô hình kênh, ý tưởng sử dụng DPS, cách triển khai mô phỏng MATLAB, các kết quả chính, hạn chế và hướng phát triển.

## Slide 2. Mục lục trình bày

Phần trình bày của em gồm năm nội dung chính.

Thứ nhất là đặt vấn đề, trong đó em trình bày bối cảnh mô phỏng kênh MIMO băng rộng, mô hình SoCE và mục tiêu của đồ án.

Thứ hai là cơ sở phương pháp, gồm ý tưởng khai thác cấu trúc giới hạn băng, cơ sở DPS và mô hình MIMO băng rộng bốn chiều.

Thứ ba là triển khai mô phỏng, trong đó em trình bày các nhánh MATLAB, thuật toán DPS và cấu hình mô phỏng chính.

Thứ tư là phần kết quả, gồm hình đáp ứng kênh, chỉ tiêu NMSE, thời gian tính toán và một số kết quả bổ sung.

Cuối cùng, em trình bày hạn chế, kết luận và hướng phát triển. Mạch trình bày đi từ vấn đề độ phức tạp của SoCE đến cách dùng DPS và kiểm chứng bằng mô phỏng MATLAB.

## Slide 3. Bối cảnh nghiên cứu

Trong các hệ thống thông tin vô tuyến hiện đại, kênh truyền thường thay đổi theo nhiều chiều. Với hệ thống MIMO băng rộng, đáp ứng kênh không chỉ phụ thuộc vào thời gian mà còn phụ thuộc vào tần số, anten phát và anten thu.

Một cách mô tả có ý nghĩa vật lý là mô hình kênh dựa trên hình học, hay GCM. Trong mô hình này, kênh được xem là tổng đóng góp của nhiều thành phần đa đường. Mỗi thành phần đa đường có các tham số như trễ, Doppler, góc khởi hành, góc tới và trọng số phức.

Ưu điểm của mô hình này là liên hệ trực tiếp với cơ chế lan truyền vật lý. Tuy nhiên, khi mô phỏng với số mẫu lớn, nhiều điểm tần số, nhiều anten hoặc nhiều thành phần đa đường, chi phí tính toán có thể tăng rất nhanh. Đây là vấn đề chính mà đồ án tập trung xử lý.

## Slide 4. Vấn đề của phương pháp SoCE trực tiếp

Công thức trên slide là dạng rời rạc bốn chiều của mô hình SoCE. Trong đó, \(m\) là chỉ số thời gian, \(q\) là chỉ số tần số, \(s\) là chỉ số anten phát, \(r\) là chỉ số anten thu, còn \(p\) là chỉ số thành phần đa đường.

Mỗi MPC đóng góp một hàm mũ phức theo bốn chiều. Khi tính trực tiếp, chương trình phải cộng toàn bộ \(P\) thành phần đa đường tại từng phần tử của tensor kênh.

Do đó, độ phức tạp của SoCE trực tiếp tỷ lệ với \(M Q N_{\mathrm{Tx}}N_{\mathrm{Rx}}P\). Điều này có nghĩa là khi tăng số mẫu thời gian, số điểm tần số, số anten hoặc số MPC, khối lượng tính toán đều tăng. Vì vậy, SoCE trực tiếp tuy rõ về mặt mô hình nhưng có thể trở thành nút thắt khi mô phỏng quy mô lớn.

## Slide 5. Mục tiêu đồ án

Từ vấn đề trên, đồ án của em đặt ra bốn mục tiêu chính.

Thứ nhất là hệ thống hóa mô hình GCM và SoCE cho kênh MIMO băng rộng biến thiên theo thời gian. Thứ hai là trình bày cơ sở DPS cho tín hiệu giới hạn băng trên khối mẫu hữu hạn. Thứ ba là triển khai các nhánh mô phỏng trong MATLAB, bao gồm SoCE tham chiếu, DPS chính xác, DPS xấp xỉ bốn chiều và phương pháp hybrid. Thứ tư là đánh giá các nhánh này thông qua sai số NMSE và thời gian tính toán.

Em xin nhấn mạnh rằng đồ án không tuyên bố đề xuất một thuật toán DPS hoàn toàn mới. Đóng góp chính là hệ thống hóa mô hình, triển khai mô phỏng nhất quán và phân tích vai trò của DPS trong bài toán giảm độ phức tạp khi tạo kênh MIMO băng rộng.

## Slide 6. Ý tưởng chính: khai thác cấu trúc giới hạn băng

Ý tưởng chính của đồ án xuất phát từ nhận xét rằng kênh trong mô hình này không phải một tensor tùy ý.

Về mặt vật lý, vận tốc cực đại của thiết bị sẽ giới hạn Doppler. Trễ cực đại của kênh sẽ giới hạn biến thiên theo tần số. Miền góc và khoảng cách anten sẽ giới hạn tần số không gian ở phía phát và phía thu.

Vì vậy, sau khi rời rạc hóa, các thành phần tần số chuẩn hóa của kênh nằm trong một miền hữu hạn. Nói cách khác, kênh có cấu trúc giới hạn băng theo từng chiều.

DPS phù hợp với bài toán này vì DPS là cơ sở được thiết kế cho tín hiệu giới hạn băng trên một đoạn chỉ số hữu hạn. Thay vì xem kênh là một tensor bất kỳ có số chiều rất lớn, ta có thể biểu diễn nó trong một không gian con có số chiều nhỏ hơn.

## Slide 7. Cơ sở DPS

DPS, hay chuỗi prolate spheroidal rời rạc, là các chuỗi được sắp xếp theo mức độ tập trung năng lượng trong một miền tần số cho trước.

Các vector DPS đầu tiên thường có trị riêng gần một, nghĩa là phần lớn năng lượng của chúng nằm trong miền băng quan tâm. Khi trị riêng bắt đầu giảm nhanh, các vector tiếp theo đóng góp ít hơn cho không gian con thiết yếu.

Biểu diễn trên slide cho thấy véc-tơ kênh có thể được xấp xỉ bởi tích giữa ma trận cơ sở DPS và véc-tơ hệ số. Như vậy, thay vì làm việc trực tiếp với toàn bộ số mẫu ban đầu, ta làm việc với một số hệ số trong không gian con DPS.

Điểm quan trọng ở đây là DPS không thay đổi mô hình vật lý của kênh. DPS chỉ thay đổi cách biểu diễn và cách tính toán, dựa trên cấu trúc giới hạn băng của kênh.

## Slide 8. Mô hình MIMO băng rộng bốn chiều

Trong đồ án, tensor kênh có bốn chiều.

Chiều thời gian liên quan đến Doppler và được biểu diễn bằng tần số chuẩn hóa \(\nu_p\). Chiều tần số liên quan đến trễ và được biểu diễn bằng \(\theta_p\). Chiều anten phát liên quan đến góc khởi hành và được biểu diễn bằng \(\zeta_p\). Chiều anten thu liên quan đến góc tới và được biểu diễn bằng \(\xi_p\).

Các đại lượng chuẩn hóa này giúp đưa mô hình vật lý về dạng tổng các hàm mũ phức theo chỉ số rời rạc. Với giả thiết miền giới hạn băng có dạng tích theo bốn chiều, cơ sở DPS đa chiều có thể được xây dựng từ các cơ sở DPS một chiều.

Đây là lý do đồ án có thể áp dụng DPS cho kênh MIMO băng rộng bốn chiều một cách có cấu trúc, thay vì phải xây dựng trực tiếp một cơ sở bốn chiều rất lớn.

## Slide 9. Các nhánh mô phỏng MATLAB

Trong mô phỏng MATLAB, em triển khai bốn nhánh chính.

Nhánh thứ nhất là SoCE tham chiếu. Nhánh này tính trực tiếp tổng đóng góp của các MPC và được dùng làm chuẩn so sánh.

Nhánh thứ hai là DPS chính xác. Nhánh này tính hệ số bằng phép chiếu chính xác lên cơ sở DPS đã cắt. Vì vậy, nó chủ yếu dùng để kiểm tra sai số do cắt không gian con DPS. Từ "chính xác" ở đây không có nghĩa là kênh tái tạo không có sai số tuyệt đối, mà chỉ có nghĩa là hệ số chiếu được tính chính xác trên cơ sở đã chọn.

Nhánh thứ ba là DPS xấp xỉ bốn chiều. Nhánh này dùng công thức xấp xỉ hệ số DPS trên cả bốn chiều thời gian, tần số, anten phát và anten thu.

Nhánh thứ tư là hybrid. Nhánh này chỉ dùng DPS xấp xỉ cho hai chiều thời gian và tần số, còn hai chiều anten vẫn tính trực tiếp bằng hàm mũ. Trong cấu hình hiện tại, hai chiều anten chỉ có \(4 \times 4\), nên cách hybrid giúp tránh thêm sai số xấp xỉ ở phần không gian.

## Slide 10. Thuật toán DPS trong mô phỏng

Ở slide này, em trình bày rõ hơn quy trình thuật toán DPS được dùng trong mô phỏng.

Bước thứ nhất là tạo cơ sở DPS một chiều cho từng chiều của kênh, gồm thời gian, tần số, anten phát và anten thu. Việc tạo cơ sở này dựa trên miền giới hạn băng tương ứng của từng chiều.

Bước thứ hai là tính tensor hệ số \(\boldsymbol{\alpha}\) từ các MPC. Thay vì trực tiếp tính giá trị kênh tại mọi điểm mẫu như SoCE, phương pháp DPS chuyển thông tin của các MPC sang các hệ số trong không gian con DPS.

Bước thứ ba là tái tạo kênh \(\hat{\mathbf{H}}\) từ tensor hệ số bằng các phép nhân tensor theo từng mode. Kết quả thu được là tensor kênh MIMO bốn chiều có cùng kích thước với kênh SoCE tham chiếu.

Bước cuối cùng là so sánh kênh tái tạo với SoCE thông qua NMSE và thời gian tính toán.

Trong đồ án có ba cách tính hệ số DPS. Với DPS chính xác, hệ số được tính bằng phép chiếu chính xác lên cơ sở DPS đã cắt, nên nhánh này dùng để kiểm tra sai số cắt không gian con. Với DPS xấp xỉ 4D, hệ số được xấp xỉ từ tần số chuẩn hóa của MPC ở cả bốn chiều. Với hybrid, chương trình chỉ xấp xỉ DPS ở thời gian và tần số, còn hai chiều anten được giữ bằng hàm mũ trực tiếp.

Điểm cần nhấn mạnh là DPS không thay đổi tập MPC hay kịch bản truyền sóng. Phương pháp chỉ thay đổi cách biểu diễn và tái tạo cùng một kênh để giảm chi phí tính toán.

## Slide 11. Cấu hình mô phỏng chính

Cấu hình mô phỏng chính dùng \(M=256\) mẫu thời gian, \(Q=64\) điểm tần số, \(N_{\mathrm{Tx}}=4\) anten phát, \(N_{\mathrm{Rx}}=4\) anten thu và \(P=80\) thành phần đa đường.

Số chiều DPS được chọn là \(D_t=6\), \(D_f=9\), \(D_{\mathrm{Tx}}=4\) và \(D_{\mathrm{Rx}}=4\). Như vậy tổng số hệ số DPS bốn chiều là \(6 \times 9 \times 4 \times 4 = 864\).

Trong khi đó, tổng số phần tử của tensor kênh là \(256 \times 64 \times 4 \times 4 = 262144\). Điều này cho thấy số hệ số trong biểu diễn DPS nhỏ hơn đáng kể so với số mẫu kênh ban đầu.

Tuy nhiên, cần lưu ý rằng tỷ lệ giảm số hệ số không đồng nghĩa thời gian chạy giảm đúng cùng tỷ lệ, vì thời gian còn phụ thuộc vào tạo hệ số, tái tạo tensor, quản lý bộ nhớ và cách vector hóa trong MATLAB.

## Slide 12. Kết quả minh họa đáp ứng kênh

Hình trên slide minh họa đáp ứng kênh cho một cặp anten phát--thu trong cấu hình mô phỏng chính.

Mục đích của hình là giúp quan sát trực quan cấu trúc biến thiên theo thời gian và tần số của kênh. Các nhánh DPS tái tạo được xu hướng chính của kênh tham chiếu SoCE. Riêng bản đồ sai số tuyệt đối của hybrid cho thấy sai khác giữa hybrid và kênh tham chiếu trên mặt phẳng thời gian--tần số.

Tuy nhiên, em không dùng hình một cặp anten này để kết luận định lượng cho toàn bộ hệ thống. Kết luận định lượng được đưa ra dựa trên các chỉ tiêu như MSE, NMSE và sai số cực đại tính trên toàn bộ tensor kênh, tức là trên tất cả mẫu thời gian, điểm tần số và cặp anten.

## Slide 13. Chỉ tiêu sai số NMSE

Để đánh giá sai số, đồ án dùng chỉ tiêu NMSE. NMSE được tính bằng năng lượng sai số giữa kênh tham chiếu và kênh tái tạo, chia cho năng lượng của kênh tham chiếu.

Trong đó, \(H_{\mathrm{ref}}\) là kênh SoCE tham chiếu, còn \(H_{\mathrm{test}}\) là kênh từ nhánh DPS đang xét. Phép trung bình trong mô phỏng được tính trên toàn bộ tensor kênh.

Ưu điểm của NMSE là nó là sai số tương đối, không phụ thuộc trực tiếp vào mức công suất tuyệt đối của kênh. NMSE càng nhỏ thì kênh tái tạo càng gần với kênh tham chiếu.

Vì vậy, trong phần kết quả, NMSE được dùng làm chỉ tiêu chính để so sánh chất lượng tái tạo của DPS chính xác, DPS xấp xỉ 4D và hybrid so với SoCE.

## Slide 14. Kết quả NMSE

Kết quả NMSE trong cấu hình chính như sau.

DPS chính xác đạt NMSE khoảng \(8{,}53\times10^{-9}\) so với SoCE. Giá trị này rất nhỏ, cho thấy trong cấu hình hiện tại, không gian con DPS được chọn có sai số cắt thấp.

DPS xấp xỉ bốn chiều đạt NMSE khoảng \(1{,}99\times10^{-4}\), lớn hơn đáng kể. Nguyên nhân là nhánh này xấp xỉ hệ số ở cả bốn chiều. Sai số xấp xỉ của từng chiều có thể cộng hưởng khi ghép thành hệ số tensor bốn chiều.

Phương pháp hybrid đạt NMSE khoảng \(4{,}29\times10^{-7}\) so với SoCE. Giá trị này thấp hơn DPS xấp xỉ 4D hơn hai bậc độ lớn trong cấu hình hiện tại. Lý do là hybrid chỉ xấp xỉ ở hai chiều thời gian và tần số, trong khi giữ cách tính trực tiếp ở hai chiều anten.

Từ kết quả này, em kết luận thận trọng rằng hybrid là nhánh có cân bằng tốt hơn giữa sai số và triển khai trong cấu hình anten nhỏ hiện tại. Em không kết luận hybrid luôn tốt nhất cho mọi cấu hình.

## Slide 15. Kết quả thời gian tính toán

Về thời gian tính toán, SoCE trực tiếp mất khoảng \(0{,}222372\,\mathrm{s}\). DPS chính xác có tổng thời gian tạo hệ số và tái tạo khoảng \(0{,}045555\,\mathrm{s}\). DPS xấp xỉ 4D khoảng \(0{,}080983\,\mathrm{s}\). Hybrid đạt khoảng \(0{,}025322\,\mathrm{s}\).

Trong phép đo này, hybrid có thời gian nhỏ nhất. Điều này phù hợp với cấu hình hiện tại, vì hybrid giảm tính toán ở hai chiều lớn là thời gian và tần số, đồng thời không đưa thêm xấp xỉ ở hai chiều anten nhỏ.

Tuy nhiên, em xin nhấn mạnh rằng thời gian này chỉ nên xem là so sánh tương đối trong cùng môi trường MATLAB. Kết quả phụ thuộc vào phần cứng, phiên bản MATLAB, cách vector hóa và cấp phát bộ nhớ. Ngoài ra, phép đo chính chưa bao gồm đầy đủ chi phí tạo cơ sở DPS, nên không nên xem các giá trị này là cam kết tốc độ tuyệt đối của phương pháp.

## Slide 16. Kết quả bổ sung: số MPC và benchmark

Ngoài cấu hình chính, đồ án còn có các kết quả bổ sung.

Thứ nhất là sweep theo số MPC, với \(P\) thay đổi từ 10 đến 320. Kết quả cho thấy khi số MPC tăng, thời gian của SoCE trực tiếp tăng rõ rệt hơn. Trong khi đó, các nhánh DPS có xu hướng tăng chậm hơn vì sau khi có hệ số, bước tái tạo không phụ thuộc trực tiếp vào số MPC theo cùng cách như SoCE trực tiếp.

Thứ hai là benchmark bốn phương pháp, bao gồm SoCE trực tiếp, SoCE đệ quy, CE-BEM và DPS chính xác. Benchmark này giúp đặt DPS trong tương quan với các cách giảm độ phức tạp khác, thay vì chỉ so sánh với một cách cài đặt SoCE trực tiếp.

Trong cấu hình \(P=80\), CE-BEM và DPS đều nhanh hơn SoCE trực tiếp trong phép đo hiện tại. CE-BEM có thể nhanh hơn một chút, nhưng DPS đạt NMSE thấp hơn CE-BEM trong benchmark đã thực hiện.

Kết quả này không có nghĩa DPS luôn tốt hơn CE-BEM hoặc SoCE. Kết luận phù hợp hơn là DPS có lợi khi miền băng hẹp, số chiều cơ sở nhỏ và chi phí tạo cơ sở có thể được tái sử dụng qua nhiều khối kênh.

## Slide 17. Hạn chế của đồ án

Đồ án vẫn còn một số hạn chế.

Thứ nhất, mô phỏng chưa tái tạo đầy đủ một hình hoặc bảng cụ thể của bài báo Kaltenberger với toàn bộ tham số gốc khớp nhau. Vì vậy, kết quả hiện tại nên được xem là kiểm chứng triển khai và khảo sát nội bộ, chưa phải tái tạo hoàn chỉnh kết quả gốc.

Thứ hai, cấu hình mô phỏng chính còn hẹp. Các kết luận về hybrid, DPS xấp xỉ 4D và DPS chính xác mới được kiểm tra trong phạm vi cấu hình hiện tại.

Thứ ba, số chiều DPS và hệ số phân giải trong nhánh chính vẫn chủ yếu là lựa chọn thiết kế, chưa được tối ưu tự động theo một ngưỡng sai số hoặc ràng buộc bộ nhớ cụ thể.

Thứ tư, thời gian chạy phụ thuộc môi trường MATLAB và chưa bao gồm đầy đủ chi phí tạo cơ sở DPS. Do đó, các kết quả thời gian chỉ nên dùng để so sánh tương đối trong cùng điều kiện.

## Slide 18. Kết luận và hướng phát triển

Tóm lại, đồ án đã trình bày mô hình GCM/SoCE cho kênh MIMO băng rộng biến thiên theo thời gian, giải thích cơ sở lý thuyết của DPS cho tín hiệu giới hạn băng và triển khai các nhánh mô phỏng trong MATLAB.

Trong cấu hình hiện tại, DPS chính xác đạt sai số rất nhỏ so với SoCE, cho thấy không gian con DPS được chọn có khả năng biểu diễn tốt kênh. DPS xấp xỉ 4D có sai số lớn hơn do xấp xỉ hệ số ở cả bốn chiều. Phương pháp hybrid đạt cân bằng tốt hơn trong cấu hình anten nhỏ, với NMSE thấp hơn DPS xấp xỉ 4D và thời gian xử lý nhỏ nhất trong phép đo chính.

Hướng phát triển tiếp theo là quét thêm số anten, số MPC, miền băng, số chiều DPS và hệ số phân giải để xây dựng đường cong đánh đổi giữa NMSE, thời gian và bộ nhớ. Ngoài ra, cần tái tạo đầy đủ một kết quả định lượng cụ thể của bài báo gốc và mở rộng sang các mô hình kênh chuẩn thực tế hơn.

Em xin kết thúc phần trình bày. Em kính mong nhận được góp ý của quý thầy cô.

## Các câu cần nhớ khi trả lời phản biện

1. Không nên nói DPS luôn tốt hơn SoCE. Nên nói: trong cấu hình mô phỏng hiện tại, DPS và hybrid cho thấy tiềm năng giảm độ phức tạp với sai số nhỏ.

2. Không nên nói DPS chính xác là không sai số. Nên nói: DPS chính xác chỉ có nghĩa là hệ số chiếu được tính chính xác trên cơ sở đã chọn; sai số cắt không gian con vẫn tồn tại.

3. Không nên nói thời gian chạy đã phản ánh toàn bộ chi phí. Nên nói: thời gian hiện tại là so sánh tương đối trong cùng môi trường MATLAB và chưa bao gồm đầy đủ chi phí tạo cơ sở DPS.

4. Khi được hỏi về kết quả, nên mở đầu bằng cụm: "Trong cấu hình mô phỏng hiện tại".

5. Khi được hỏi về hạn chế, nên trả lời thẳng: cấu hình còn hẹp, chưa tái tạo đầy đủ một hình hoặc bảng cụ thể của bài báo gốc, và chưa tối ưu tự động số chiều DPS.
