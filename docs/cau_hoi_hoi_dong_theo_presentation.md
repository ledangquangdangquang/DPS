# CÂU HỎI HỘI ĐỒNG CÓ THỂ ĐẶT TỪ `presentation.pdf`

Tài liệu này tập trung vào các câu hỏi có khả năng xuất hiện trực tiếp khi hội đồng nhìn vào 26 slide hiện tại. Câu trả lời được viết theo dạng nói trong khoảng 30--60 giây.

## Nhóm 1 -- Những câu có khả năng được hỏi cao nhất

### 1. Đề tài nói “độ phức tạp thấp”, vậy phương pháp nào thực sự làm giảm độ phức tạp?

**Trả lời:**

SoCE trực tiếp có chi phí tăng theo số MPC nhân với số phần tử của tensor, tức tỷ lệ với

$$
P M Q N_{\mathrm{Tx}}N_{\mathrm{Rx}}.
$$

DPS khai thác việc kênh chỉ chiếm một miền tần số hữu hạn ở từng chiều và biểu diễn kênh bằng tensor hệ số nhỏ hơn. Chi phí được tách thành tạo hệ số theo từng MPC và tái tạo tensor từ không gian con. Trong cấu hình hiện tại, số phần tử tensor là $$262144$$, còn tensor hệ số DPS chính xác chỉ có $$864$$ phần tử. Tuy nhiên, tỷ lệ giảm số hệ số không đồng nghĩa runtime giảm đúng cùng tỷ lệ vì vẫn có chi phí tạo hệ số, tái tạo và tạo cơ sở. Vì vậy, em chỉ kết luận DPS có tiềm năng giảm độ phức tạp trong cấu hình đã khảo sát, không khẳng định luôn nhanh hơn trong mọi trường hợp.

### 2. Ba phương pháp DPS khác nhau chính xác ở đâu?

**Trả lời:**

DPS chính xác tính hệ số của từng MPC bằng tích vô hướng chính xác với cơ sở DPS ở cả bốn chiều. DPS xấp xỉ 4D thay bốn phép chiếu đó bằng công thức đánh giá gần đúng hệ số từ cơ sở phân giải cao. Hybrid chỉ dùng hệ số DPS xấp xỉ ở hai chiều thời gian và tần số; hai chiều anten phát và thu được giữ dưới dạng hàm mũ không gian trực tiếp. Do đó, ba nhánh khác nhau ở cách tạo hệ số và số chiều được biểu diễn bằng DPS, chứ không khác mô hình MPC đầu vào.

### 3. Vì sao gọi là “DPS chính xác” khi NMSE vẫn khác không?

**Trả lời:**

Từ “chính xác” chỉ có nghĩa là hệ số trên cơ sở DPS đã chọn được tính bằng phép chiếu chính xác. Cơ sở chỉ giữ một số véc-tơ đầu nên vẫn có sai số cắt không gian con. Vì vậy, DPS chính xác không có sai số xấp xỉ hệ số nhưng vẫn có sai số cắt, dẫn đến NMSE khoảng $$10^{-9}$$ trong cấu hình hiện tại.

### 4. DPS chính xác có cần tạo tensor SoCE trước không?

**Trả lời:**

Không. Trong mã MATLAB, DPS chính xác tính trực tiếp các véc-tơ hệ số từ tham số MPC bằng $$V^H e(f_p)$$ rồi ghép chúng thành tensor hệ số. Tensor SoCE được tính riêng để làm kênh tham chiếu khi đo NMSE. Về toán học có thể xem đây là chiếu kênh SoCE lên không gian DPS, nhưng về triển khai không cần tạo toàn bộ tensor SoCE trước khi tính DPS chính xác.

### 5. Vì sao hybrid áp dụng DPS ở thời gian–tần số mà không áp dụng ở hai chiều anten?

**Trả lời:**

Trong cấu hình hiện tại, chiều thời gian và tần số có kích thước $$256$$ và $$64$$ nhưng chỉ giữ $$6$$ và $$9$$ véc-tơ DPS, nên có lợi ích giảm chiều rõ rệt. Hai chiều anten chỉ có $$4$$ phần tử và cũng giữ đủ $$4$$ véc-tơ, nên DPS không gian không làm giảm số chiều. Giữ hàm mũ không gian trực tiếp giúp tránh thêm sai số xấp xỉ. Đây là lựa chọn phù hợp với cấu hình anten nhỏ hiện tại; nếu chuyển sang massive MIMO và miền góc hẹp thì cần đánh giá lại DPS không gian.

### 6. Phương pháp nào nên được lựa chọn trong thực tế?

**Trả lời:**

Không có một phương pháp tốt nhất cho mọi cấu hình. Trong kết quả hiện tại, DPS chính xác có NMSE thấp nhất, khoảng $$10^{-9}$$, và runtime cạnh tranh, nên phù hợp khi ưu tiên độ chính xác. Hybrid có NMSE khoảng $$10^{-7}$$ và tránh xấp xỉ ở hai chiều anten, nên là phương án đánh đổi khi chấp nhận sai số nhỏ để đơn giản hóa phần thời gian–tần số. DPS xấp xỉ 4D hiện chưa được ưu tiên vì có sai số lớn hơn trong khi lợi ích runtime chưa tương xứng. Với dữ liệu hiện có, em ưu tiên DPS chính xác; hybrid là hướng thực dụng cần đánh giá thêm ở quy mô lớn.

### 7. Tại sao DPS xấp xỉ 4D có độ phức tạp lý thuyết thấp nhưng trong kết quả lại chậm?

**Trả lời:**

Về lý thuyết, mỗi hệ số xấp xỉ được đánh giá từ một mẫu của cơ sở phân giải cao thay vì tính tích vô hướng dài $$N$$ phần tử. Tuy nhiên, mã hiện tại phải thực hiện ánh xạ chỉ số, truy xuất cơ sở phân giải cao, hiệu chỉnh pha và chuẩn hóa cho từng MPC ở cả bốn chiều. Các vòng lặp này chưa được tối ưu và véc-tơ hóa hoàn toàn trong MATLAB. Do đó, lợi thế số phép toán lý thuyết chưa chuyển thành lợi thế runtime. Đây là hạn chế của triển khai hiện tại, không phải bằng chứng rằng công thức xấp xỉ luôn kém hiệu quả.

### 8. Cách đo runtime có công bằng không?

**Trả lời:**

Runtime SoCE gồm thời gian tạo tensor trực tiếp. Runtime mỗi nhánh DPS gồm thời gian tạo hệ số và tái tạo tensor. Thời gian tạo SoCE tham chiếu không được cộng vào DPS vì SoCE chỉ dùng để tính NMSE, không phải đầu vào của thuật toán DPS. Tuy nhiên, phép đo chính chưa gồm đầy đủ chi phí tạo cơ sở DPS và kết quả còn phụ thuộc phần cứng, phiên bản MATLAB, cấp phát bộ nhớ và cách véc-tơ hóa. Vì vậy, em xem runtime là so sánh tương đối trong cùng môi trường, không phải cam kết tăng tốc tổng quát.

### 9. Tại sao slide nói Exact DPS nhanh nhất nhưng có kết quả cho thấy hybrid nhanh hơn?

**Trả lời:**

Kết quả runtime có dao động theo lần đo. Ở phép đo đơn tại $$P=80$$, hybrid khoảng $$0{,}018231\,\mathrm{s}$$ và DPS chính xác khoảng $$0{,}034033\,\mathrm{s}$$. Trong phép đo lặp sau warm-up, median của hai nhánh gần như bằng nhau, khoảng $$0{,}010156\,\mathrm{s}$$ cho hybrid và $$0{,}010166\,\mathrm{s}$$ cho DPS chính xác. Vì vậy, cách nói chính xác là hai nhánh có runtime gần nhau trong phép đo lặp; DPS chính xác có ưu thế rõ hơn về NMSE. Em không nên khẳng định chắc chắn Exact DPS luôn nhanh nhất.

### 10. Vì sao NMSE gần như không tăng khi số MPC tăng?

**Trả lời:**

Số MPC làm tăng số thành phần được cộng nhưng không làm thay đổi miền giới hạn băng hoặc số chiều DPS. Các MPC vẫn nằm trong cùng miền Doppler, trễ và góc, đồng thời trọng số được chuẩn hóa công suất. Vì vậy, sai số tương đối chủ yếu do cắt không gian con và xấp xỉ hệ số, không nhất thiết tăng theo số MPC. Kết quả sweep chỉ cho thấy không có xu hướng tăng rõ trong phạm vi $$P=10$$ đến $$320$$ và cấu hình hiện tại; không có nghĩa NMSE luôn độc lập với số MPC.

## Nhóm 2 -- Câu hỏi về cơ sở lý thuyết

### 11. Vì sao DPS phù hợp hơn DFT cho bài toán này?

**Trả lời:**

DFT dùng các tần số lưới cố định, trong khi tần số của MPC có thể nằm lệch lưới và gây rò rỉ phổ. DPS được thiết kế để tập trung năng lượng của mọi tín hiệu nằm trong một khoảng tần số khi chỉ quan sát trên một khối mẫu hữu hạn. Vì bài toán có các miền Doppler, trễ và góc hữu hạn, DPS phù hợp trực tiếp với cấu trúc giới hạn băng. Tuy nhiên, đồ án chưa benchmark định lượng với DFT nên em chỉ nêu ưu điểm lý thuyết, không khẳng định DPS luôn tốt hơn DFT.

### 12. Trị riêng DPS trên slide có ý nghĩa gì, và tại sao giữ 6 hoặc 9 véc-tơ thay vì 4--5?

**Trả lời:**

Trị riêng cho biết mức năng lượng của từng véc-tơ DPS được tập trung trong miền băng. Hình minh họa cho thấy một số trị riêng đầu gần một rồi giảm nhanh, nhưng đây chỉ là một cấu hình một chiều minh họa. Trong mô phỏng bốn chiều, số véc-tơ còn phụ thuộc độ dài mẫu, băng thông của từng chiều và số véc-tơ dự phòng. Chương trình dùng quy tắc dựa trên tích thời gian–băng thông rồi cộng biên dự phòng để giảm sai số cắt, nên thu được $$D_t=6$$ và $$D_f=9$$. Các giá trị này chưa được chứng minh tối ưu và cần sweep thêm.

### 13. Phép chiếu DPS là gì?

**Trả lời:**

Phép chiếu là lấy tích vô hướng giữa véc-tơ số mũ của MPC và từng véc-tơ cơ sở DPS. Ví dụ $$\gamma=V^H e(f_p)$$. Các phần tử của $$\gamma$$ là tọa độ của véc-tơ MPC trong không gian con DPS. Sau đó, tín hiệu được tái tạo bằng $$\widehat e=V\gamma$$. Vì chỉ giữ một số cột của $$V$$ nên phần nằm ngoài không gian con tạo ra sai số cắt.

### 14. DPS xấp xỉ giảm phép chiếu như thế nào?

**Trả lời:**

Chiếu chính xác một chiều cần khoảng $$ND$$ phép nhân–cộng cho mỗi MPC. Phương pháp xấp xỉ chuẩn bị trước cơ sở DPS phân giải cao rồi ánh xạ tần số MPC đến một vị trí lưới, lấy các giá trị tương ứng và hiệu chỉnh pha, biên độ. Vì vậy, chi phí đánh giá lý thuyết giảm từ bậc $$ND$$ xuống gần bậc $$D$$ cho mỗi MPC và mỗi chiều, đổi lại xuất hiện sai số xấp xỉ và chi phí tiền xử lý.

### 15. Dấu âm ở chiều tần số và anten thu đến từ đâu?

**Trả lời:**

Đó là quy ước pha của mô hình SoCE đang sử dụng:

$$
e^{j2\pi(\nu_p m-\theta_p q+\zeta_p s-\xi_p r)}.
$$

Do đó, tần số hiệu dụng khi tạo hệ số DPS là $$\nu_p$$, $$-\theta_p$$, $$\zeta_p$$ và $$-\xi_p$$. Các dấu này phải nhất quán giữa phương trình, miền băng DPS và mã MATLAB.

## Nhóm 3 -- Câu hỏi về mô phỏng và độ tin cậy

### 16. Vì sao chỉ dùng bốn anten phát và bốn anten thu?

**Trả lời:**

Đây là cấu hình kiểm chứng ban đầu giúp giữ kích thước tensor và thời gian mô phỏng ở mức có thể kiểm soát, đồng thời tách rõ sai số của các nhánh. Nó chưa đại diện cho massive MIMO. Vì hai chiều anten còn nhỏ nên kết luận có lợi cho hybrid; khi số anten tăng, lợi ích của DPS không gian có thể thay đổi. Vì vậy, quét số anten là một hướng mở rộng quan trọng.

### 17. Một seed có đủ để kết luận không?

**Trả lời:**

Một seed chỉ dùng để tạo hình minh họa và bảo đảm khả năng tái lập. Để khảo sát theo số MPC, đồ án dùng nhiều seed và thống kê median cùng khoảng tứ phân vị. Tuy vậy, phạm vi kịch bản vẫn còn hạn chế; muốn kết luận tổng quát cần thêm nhiều cấu hình miền băng, số anten, số chiều DPS và phân bố MPC.

### 18. NMSE được tính trên hình một cặp anten hay toàn bộ tensor?

**Trả lời:**

NMSE được tính trên toàn bộ tensor thời gian, tần số, anten phát và anten thu. Hình của cặp anten thứ nhất chỉ dùng để minh họa trực quan. Kết luận định lượng dựa trên sai số của toàn bộ tensor, không dựa riêng vào một lát cắt.

### 19. Kết quả đã tái tạo đúng bài báo Kaltenberger chưa?

**Trả lời:**

Mã đã triển khai mô hình và công thức xấp xỉ theo bài báo, đồng thời kiểm tra tính nhất quán giữa phương trình và MATLAB. Tuy nhiên, đồ án chưa khớp toàn bộ tham số để tái tạo một hình hoặc bảng wideband-MIMO cụ thể của bài báo. Vì vậy, em gọi đây là triển khai và khảo sát theo phương pháp của bài báo, không tuyên bố đã tái tạo hoàn chỉnh kết quả gốc.

### 20. Vì sao không xét nhiễu, BER hoặc ước lượng kênh?

**Trả lời:**

Đối tượng của đồ án là bộ mô phỏng và cách biểu diễn đáp ứng kênh, không phải bộ thu hoặc thuật toán ước lượng kênh. Do đó, chỉ tiêu phù hợp là sai số giữa các cách tạo cùng một tensor kênh và thời gian tính toán. Nhiễu, BER và ước lượng kênh thuộc lớp đánh giá hệ thống tiếp theo và có thể được bổ sung sau khi mô hình kênh đã được kiểm chứng.

## Nhóm 4 -- Câu hỏi kết luận và phản biện

### 21. Đóng góp mới của đồ án là gì nếu phương pháp đã có trong bài báo?

**Trả lời:**

Đồ án không tuyên bố phát minh một thuật toán DPS mới. Đóng góp là hệ thống hóa mô hình SoCE bốn chiều, ánh xạ nhất quán từ tham số vật lý sang phương trình và MATLAB, triển khai trên cùng dữ liệu ba nhánh DPS để tách sai số cắt khỏi sai số xấp xỉ hệ số, và đánh giá NMSE–runtime theo số MPC. Phần giá trị của đồ án nằm ở triển khai, kiểm chứng và phân tích giới hạn của từng nhánh.

### 22. Hạn chế lớn nhất của đồ án là gì?

**Trả lời:**

Ba hạn chế chính là chưa tái tạo một kết quả wideband-MIMO cụ thể của bài báo với toàn bộ tham số khớp nhau; số chiều DPS và hệ số phân giải vẫn được chọn theo quy tắc kinh nghiệm; và đánh giá thực nghiệm chưa bao phủ nhiều cấu hình anten, miền băng và mô hình kênh chuẩn. Ngoài ra, runtime chưa bao gồm đầy đủ chi phí tạo cơ sở DPS.

### 23. Nếu được làm tiếp, em ưu tiên việc gì?

**Trả lời:**

Em ưu tiên quét đồng thời số chiều DPS, hệ số phân giải, số anten và miền góc để xây dựng đường cong đánh đổi NMSE–runtime–bộ nhớ. Tiếp theo là tối ưu và véc-tơ hóa hàm tạo hệ số xấp xỉ, rồi tái đo runtime có tính cả chi phí tiền xử lý và khả năng tái sử dụng cơ sở. Sau đó, em sẽ khớp một cấu hình cụ thể của bài báo và mở rộng sang mô hình kênh chuẩn như 3GPP.

### 24. Một câu kết luận ngắn nhất của đồ án là gì?

**Trả lời:**

Trong cấu hình đã khảo sát, không gian con DPS biểu diễn tốt kênh MIMO băng rộng với sai số cắt nhỏ; DPS chính xác cho điểm đánh đổi NMSE–runtime tốt nhất, còn hybrid giảm sai số đáng kể so với xấp xỉ 4D bằng cách giữ trực tiếp hai chiều anten. Kết quả cho thấy tiềm năng của DPS nhưng chưa đủ để khẳng định một phương pháp luôn tối ưu cho mọi cấu hình.

---

## Ba lỗi diễn đạt cần tránh khi trả lời

1. Không nói DPS chính xác phải tạo tensor SoCE trước; SoCE chỉ là chuẩn tính NMSE.
2. Không nói hybrid luôn tối ưu hoặc luôn nhanh nhất; runtime của hybrid và DPS chính xác gần nhau trong phép đo lặp.
3. Không nói DPS xấp xỉ 4D đã nhanh hơn nhờ giảm phép chiếu; đây mới là lợi thế lý thuyết, chưa thể hiện trong triển khai MATLAB hiện tại.
