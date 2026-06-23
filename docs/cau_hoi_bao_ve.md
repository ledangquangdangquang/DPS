# Câu hỏi dự kiến khi bảo vệ đồ án

## Cách sử dụng tài liệu

Tài liệu này dùng để luyện trả lời miệng. Mỗi câu trả lời nên được trình bày trong khoảng 30--60 giây, sau đó mới mở rộng nếu hội đồng hỏi sâu hơn. Khi trả lời về kết quả, cần nhấn mạnh cụm từ **“trong cấu hình mô phỏng hiện tại”**.

Ba điều không nên khẳng định:

1. Không nói DPS luôn nhanh hơn hoặc luôn chính xác hơn SoCE.
2. Không nói đồ án đã tái tạo hoàn toàn kết quả của bài báo Kaltenberger.
3. Không nói thời gian chạy hiện tại đã bao gồm mọi chi phí, vì bước tạo cơ sở DPS chưa nằm trong phép đo.

## Tóm tắt đồ án trong một phút

Đồ án nghiên cứu cách giảm độ phức tạp khi mô phỏng kênh MIMO băng rộng dựa trên hình học. Cách tính SoCE trực tiếp cộng đóng góp của mọi thành phần đa đường tại từng mẫu thời gian, tần số và cặp anten, nên chi phí tăng theo tích của số mẫu và số MPC. Do các tần số Doppler, trễ, AoD và AoA đều bị giới hạn bởi tham số vật lý, khối kênh có cấu trúc giới hạn băng trên một miền chỉ số hữu hạn. DPS phù hợp với cấu trúc này và cho phép biểu diễn kênh trong một không gian con. Đồ án triển khai bốn nhánh MATLAB gồm SoCE tham chiếu, DPS chính xác, DPS xấp xỉ 4D và hybrid. Trong cấu hình hiện tại, hybrid đạt NMSE $$4{,}29\times10^{-7}$$ so với SoCE và có tổng thời gian tạo hệ số cùng tái tạo khoảng $$0{,}025322\,\mathrm{s}$$, nhưng kết quả mới được kiểm tra trên một cấu hình và thời gian chưa gồm bước tạo cơ sở DPS.

---

## A. Câu hỏi tổng quan

### 1. Bài toán chính của đồ án là gì?

Bài toán chính là giảm khối lượng tính toán của mô phỏng kênh MIMO băng rộng dựa trên hình học. SoCE có ý nghĩa vật lý rõ ràng nhưng phải tính tổng của $$P$$ MPC tại từng phần tử trong khối kênh bốn chiều. Đồ án khảo sát cách dùng DPS để thay biểu diễn theo từng MPC--mẫu bằng biểu diễn trong một không gian con có số chiều nhỏ hơn.

### 2. Vì sao bài toán này quan trọng?

Khi số mẫu thời gian, số điểm tần số, số anten hoặc số MPC tăng, chi phí SoCE tăng rất nhanh. Mô phỏng kênh thường phải lặp lại cho nhiều cấu hình, nên giảm chi phí tạo khối kênh có thể giúp tăng quy mô hoặc số lần thử nghiệm.

### 3. Đóng góp của đồ án là gì? Có đề xuất thuật toán mới không?

Đồ án không tuyên bố đề xuất một thuật toán DPS mới. Đóng góp chính là hệ thống hóa mô hình của Kaltenberger, ánh xạ nhất quán từ phương trình sang MATLAB, triển khai và so sánh bốn nhánh trên cùng một tập MPC, đồng thời phân tích sai số, thời gian và giới hạn của từng nhánh.

### 4. Kết luận quan trọng nhất của đồ án là gì?

Trong cấu hình đang xét, không gian con DPS đã chọn biểu diễn kênh với sai số cắt rất nhỏ. Xấp xỉ hệ số trên cả bốn chiều làm sai số tăng, còn hybrid tránh xấp xỉ ở hai chiều anten nên đạt sự cân bằng phù hợp hơn giữa sai số và thời gian quan sát được. Kết luận này chưa được khái quát cho mọi cấu hình.

### 5. Vì sao SoCE được chọn làm tham chiếu?

SoCE tính trực tiếp đúng mô hình GCM đã đặt ra: mỗi MPC đóng góp một hàm mũ phức theo bốn chiều. Các nhánh DPS sử dụng cùng tham số MPC và chỉ thay cách biểu diễn hoặc tính hệ số, nên SoCE là mốc phù hợp để đo sai số tái tạo.

## B. Mô hình kênh và ký hiệu

### 6. GCM là gì?

GCM là mô hình kênh dựa trên hình học, trong đó kênh được tạo bởi nhiều đường truyền có trễ, Doppler, góc khởi hành, góc tới và trọng số phức khác nhau. Mỗi đường được biểu diễn bằng một MPC.

### 7. MPC là gì và chứa những tham số nào?

MPC là một thành phần đa đường. Trong đồ án, MPC thứ $$p$$ có trọng số phức $$\eta_p$$, Doppler $$\omega_p$$, trễ $$\tau_p$$, góc khởi hành $$\phi_p$$ và góc tới $$\psi_p$$. Sau lấy mẫu, các đại lượng này được chuyển thành các tần số chuẩn hóa $$\nu_p,\theta_p,\zeta_p,\xi_p$$.

### 8. Vì sao kênh có bốn chiều?

Kênh thay đổi theo thời gian do Doppler, theo điểm tần số do trễ đa đường, và theo chỉ số anten ở hai phía do pha không gian. Vì vậy, một phần tử $$h_{m,q,s,r}$$ được xác định bởi mẫu thời gian $$m$$, điểm tần số $$q$$, anten phát $$s$$ và anten thu $$r$$.

### 9. Tần số chuẩn hóa có ý nghĩa gì?

Tần số chuẩn hóa biểu thị số chu kỳ pha trên một bước chỉ số lấy mẫu và không có đơn vị. Ví dụ, $$\nu_p=\omega_pT_s$$ là Doppler chuẩn hóa theo bước thời gian, còn $$\theta_p=\tau_pF_s$$ là trễ chuẩn hóa theo bước tần số.

### 10. Vì sao dấu pha của chiều tần số và chiều thu là dấu âm?

Đây là quy ước của mô hình đang triển khai:

$$
\nu_p m-\theta_p q+\zeta_p s-\xi_p r.
$$

Vì vậy, cơ sở ở chiều tần số phải bao phủ miền của $$-\theta_p$$, còn chiều thu phải bao phủ miền của $$-\xi_p$$. Quy ước này được giữ giống nhau trong phương trình và mã MATLAB.

### 11. Vì sao dùng mảng ULA và khoảng cách $$D_s/\lambda=0{,}5$$?

ULA giúp mô tả pha không gian bằng một chỉ số anten và một tần số không gian đơn giản. Khoảng cách nửa bước sóng là cấu hình phổ biến, đồng thời hạn chế hiện tượng nhập nhằng không gian trong miền góc đang xét. Đây là giả thiết của cấu hình mô phỏng, không phải điều kiện bắt buộc duy nhất của phương pháp DPS.

### 12. Vì sao kênh được xem là giới hạn băng?

Vận tốc cực đại giới hạn Doppler, trễ cực đại giới hạn biến thiên theo tần số, còn miền góc và khoảng cách anten giới hạn tần số không gian. Do mọi MPC đều nằm trong các khoảng đó, tổng các MPC cũng chỉ chứa tần số trong miền giới hạn tương ứng.

## C. Lý thuyết DPS và SoCE

### 13. DPS là gì?

DPS là các chuỗi rời rạc được sắp xếp theo khả năng tập trung năng lượng trong một miền tần số xác định khi chỉ quan sát trên một đoạn chỉ số hữu hạn. Các vector đầu có mức tập trung cao nhất, nên tín hiệu giới hạn băng có thể được xấp xỉ bằng một số vector đầu thay vì toàn bộ $$N$$ chiều.

### 14. Vì sao đồ án chọn DPS thay vì cơ sở DFT?

DFT trực giao trên các tần số lưới cố định và có thể xuất hiện rò rỉ phổ khi tần số MPC không trùng lưới. DPS được thiết kế cho toàn bộ một khoảng tần số và một cửa sổ chỉ số hữu hạn, nên phù hợp trực tiếp với bài toán tập trung năng lượng trong miền băng. Tuy nhiên, đồ án chưa so sánh định lượng DPS với DFT, vì vậy chỉ nên nêu đây là lý do lý thuyết chứ không tuyên bố DPS luôn tốt hơn DFT.

### 15. Trị riêng DPS có ý nghĩa gì?

Trị riêng cho biết mức năng lượng của vector DPS được tập trung trong miền băng quan tâm. Trị riêng gần một tương ứng với vector tập trung tốt. Khi trị riêng giảm mạnh, các vector tiếp theo đóng góp ít hơn cho không gian con thiết yếu.

### 16. Tích $$2NW$$ có ý nghĩa gì?

Với $$N$$ mẫu và nửa băng thông chuẩn hóa $$W$$, $$2NW$$ xấp xỉ số bậc tự do thiết yếu của tín hiệu trong đoạn hữu hạn. Đây là cơ sở trực giác để chọn số vector DPS, nhưng chương trình hiện tại còn cộng thêm một số vector dự phòng.

### 17. Số chiều DPS được chọn như thế nào?

Mỗi chiều dùng ước lượng số chiều thiết yếu dựa trên độ dài và băng thông, sau đó cộng $$1$$ và hệ số dự phòng $$G=4$$, rồi chặn trên bởi số mẫu của chiều đó. Đây là quy tắc kinh nghiệm có tính bảo thủ; chương trình chưa tự động chọn $$D$$ từ một ngưỡng NMSE hoặc bias cho trước.

### 18. Vì sao phải thêm $$G=4$$?

Các vector dự phòng giúp giữ thêm thành phần ở vùng chuyển tiếp của phổ trị riêng và giảm sai số cắt không gian con. Giá trị $$4$$ là giả thiết thiết kế trong mô phỏng hiện tại, chưa được chứng minh là tối ưu. Muốn kết luận chắc hơn cần quét $$G$$ hoặc $$D$$ và đo đánh đổi sai số--chi phí.

### 19. Tại sao gọi là “DPS chính xác” trong khi NMSE không bằng không?

Từ “chính xác” chỉ nói đến cách tính hệ số chiếu bằng tích vô hướng chính xác trên cơ sở đã chọn. Vì cơ sở bị cắt còn $$D$$ vector, phần năng lượng ngoài không gian con vẫn tạo ra sai số. Do đó, đây không phải là kênh chính xác tuyệt đối.

### 20. Nhánh DPS chính xác có thật sự giảm độ phức tạp không?

Nhánh này chủ yếu là nhánh chẩn đoán chất lượng không gian con. Nó vẫn tạo vector hàm mũ cho từng MPC rồi thực hiện phép chiếu, nên chưa thể hiện đầy đủ lợi ích của công thức hệ số xấp xỉ. Giá trị của nhánh là tách sai số cắt không gian con khỏi sai số xấp xỉ hệ số.

### 21. Hệ số xấp xỉ DPS được tính như thế nào?

Thay vì tạo đầy đủ vector hàm mũ và nhân với cơ sở, chương trình đánh giá hàm sóng DPS trên một lưới độ phân giải cao tại vị trí tần số của MPC. Kết quả được dùng để xấp xỉ vector hệ số một chiều, sau đó các vector của bốn chiều được ghép bằng tích ngoài.

### 22. Hệ số phân giải $$r$$ có vai trò gì?

$$r$$ điều khiển độ phân giải của cơ sở dùng để xấp xỉ hàm sóng DPS. Giá trị lớn có thể giảm sai số lượng tử hóa vị trí tần số nhưng làm tăng bộ nhớ và chi phí tiền xử lý. Trong mô phỏng hiện tại, $$r_t=2$$, còn $$r_f=r_{\mathrm{Tx}}=r_{\mathrm{Rx}}=512$$; các giá trị này là lựa chọn thực nghiệm, chưa được tối ưu tự động.

### 23. Vì sao cơ sở DPS bốn chiều có thể tách thành các cơ sở một chiều?

Miền chỉ số và miền giới hạn băng trong đồ án đều được giả thiết có dạng tích Descartes. Khi đó, cơ sở đa chiều có thể xây dựng từ tích tensor của các cơ sở một chiều, và hệ số của mỗi MPC có thể ghép từ bốn vector hệ số một chiều.

### 24. Khi nào DPS không còn lợi thế?

Khi miền băng rộng, số chiều giữ lại $$D$$ tiến gần số mẫu $$N$$, hoặc chi phí tạo cơ sở, tính hệ số và tái tạo quá lớn, lợi thế có thể giảm hoặc mất. DPS cũng kém hấp dẫn nếu chỉ cần rất ít mẫu kênh thay vì tái tạo cả một khối lớn.

## D. Các nhánh MATLAB

### 25. Bốn nhánh mô phỏng khác nhau như thế nào?

- SoCE tính trực tiếp tổng MPC tại từng mẫu và làm tham chiếu.
- DPS chính xác chiếu chính xác từng hàm mũ lên cơ sở DPS đã cắt.
- DPS xấp xỉ 4D xấp xỉ hệ số DPS ở cả bốn chiều.
- Hybrid chỉ xấp xỉ DPS theo thời gian và tần số, còn hai chiều anten dùng hàm mũ trực tiếp.

### 26. Vì sao cần nhánh DPS xấp xỉ 4D nếu kết quả kém hơn hybrid?

Nhánh này giúp đánh giá trực tiếp ảnh hưởng của việc áp dụng công thức xấp xỉ hệ số trên toàn bộ bốn chiều. Nó cho thấy sai số không chỉ đến từ cắt không gian con mà còn từ xấp xỉ hệ số, đặc biệt khi các sai số một chiều được ghép trong tích tensor.

### 27. Vì sao hybrid phù hợp với cấu hình hiện tại?

Hai chiều thời gian và tần số có kích thước $$256$$ và $$64$$, nên có khả năng giảm chiều bằng DPS. Hai chiều anten chỉ có $$4\times4$$, và $$D_{\mathrm{Tx}}=D_{\mathrm{Rx}}=4$$, tức là thực tế không có nén số chiều không gian. Giữ hàm mũ không gian trực tiếp giúp tránh sai số xấp xỉ ở hai chiều này.

### 28. rng(1) có tác dụng gì?

rng(1) cố định trạng thái bộ sinh số ngẫu nhiên, giúp tạo lại cùng tập MPC và cùng kết quả. Nó hỗ trợ kiểm chứng và so sánh mã, nhưng một seed duy nhất không đủ để đánh giá phân bố thống kê của sai số.

### 29. Các MPC được sinh theo phân bố nào?

Doppler, trễ, AoD và AoA được sinh đều trong các miền giới hạn đã đặt. Trọng số MPC là Gauss phức tròn và được chuẩn hóa để tổng công suất kỳ vọng xấp xỉ một. Đây là kịch bản kiểm tra biểu diễn DPS, không phải một mô hình kênh chuẩn hóa hoàn chỉnh.

### 30. Vì sao chỉ số tần số chạy từ $$0$$ đến $$Q-1$$ thay vì lấy tâm tại không?

Đây là quy ước triển khai đơn giản của chương trình. Việc dịch tập chỉ số làm thay đổi quy ước pha nhưng không thay đổi mục tiêu kiểm tra không gian con nếu dấu pha và miền băng được xử lý nhất quán. Bài báo cũng có cách trình bày với chỉ số tần số lấy tâm; đồ án đã ghi rõ khác biệt này là một giả thiết triển khai.

## E. Kết quả mô phỏng

### 31. Cấu hình mô phỏng chính là gì?

Khối kênh có $$M=256$$, $$Q=64$$, $$N_{\mathrm{Tx}}=N_{\mathrm{Rx}}=4$$ và $$P=80$$. Số chiều DPS là $$D_t=6$$, $$D_f=9$$, $$D_{\mathrm{Tx}}=D_{\mathrm{Rx}}=4$$, nên $$D_{\mathrm{total}}=864$$. Tổng số mẫu kênh là $$256\times64\times4\times4=262144$$.

### 32. NMSE là gì và vì sao dùng NMSE?

NMSE là trung bình năng lượng sai số chia cho công suất trung bình của kênh SoCE. Nó không có đơn vị và cho biết sai số tương đối so với mức năng lượng của kênh, nên dễ so sánh hơn MSE tuyệt đối. Trong đồ án, phép trung bình được lấy trên toàn bộ tensor kênh của một lần mô phỏng.

### 33. Kết quả NMSE chính là bao nhiêu?

- DPS chính xác so với SoCE: $$8{,}53\times10^{-9}$$.
- DPS xấp xỉ 4D so với SoCE: $$1{,}99\times10^{-4}$$.
- Hybrid so với SoCE: $$4{,}29\times10^{-7}$$.
- Hybrid so với DPS chính xác: $$4{,}20\times10^{-7}$$.

Các giá trị này chỉ áp dụng cho cấu hình và seed hiện tại.

### 34. Vì sao DPS xấp xỉ 4D có sai số lớn nhất?

Nhánh này xấp xỉ hệ số ở cả thời gian, tần số, anten phát và anten thu. Sai số của từng vector hệ số cùng tham gia vào tích tensor, nên sai số tổng có thể tăng. Hybrid loại bỏ hai nguồn xấp xỉ ở các chiều anten và vì vậy có NMSE thấp hơn trong cấu hình hiện tại.

### 35. Hình đáp ứng chỉ vẽ một cặp anten có đủ thuyết phục không?

Hình của cặp anten thứ nhất chỉ có vai trò minh họa cấu trúc biến thiên theo thời gian--tần số và vị trí sai số. Kết luận định lượng không dựa riêng vào hình đó; MSE, NMSE và sai số cực đại được tính trên toàn bộ các mẫu và mọi cặp anten.

### 36. Kết quả thời gian chạy là bao nhiêu?

SoCE mất $$0{,}222372\,\mathrm{s}$$. Tổng thời gian tạo hệ số và tái tạo lần lượt khoảng $$0{,}045555\,\mathrm{s}$$ cho DPS chính xác, $$0{,}080983\,\mathrm{s}$$ cho DPS xấp xỉ 4D và $$0{,}025322\,\mathrm{s}$$ cho hybrid. Đây là kết quả của cùng một lần chạy MATLAB.

### 37. So sánh thời gian hiện tại có công bằng không?

So sánh này chỉ công bằng ở mức tham khảo trong cùng môi trường và cùng mã. Thời gian DPS chưa gồm bước tạo cơ sở thường và cơ sở độ phân giải cao. Ngoài ra, kết quả phụ thuộc cách vector hóa, cấp phát bộ nhớ, phiên bản MATLAB và phần cứng. Vì vậy, không thể dùng các số này để bảo đảm một hệ số tăng tốc chung.

### 38. Tại sao số hệ số giảm khoảng 303 lần nhưng thời gian không giảm 303 lần?

Tỉ lệ $$262144/864\approx303$$ chỉ so sánh số mẫu kênh với số hệ số DPS 4D. Thời gian còn gồm tạo hệ số, các tích tensor, tái tạo toàn bộ $$262144$$ mẫu, quản lý bộ nhớ và các phần chi phí cố định. Nén số hệ số không đồng nghĩa thời gian chạy giảm theo đúng cùng tỉ lệ.

### 39. Kết quả có chứng minh hybrid luôn tốt nhất không?

Không. Hybrid cho cân bằng sai số--thời gian tốt hơn trong một cấu hình với hai chiều anten nhỏ. Khi số anten, miền góc, số chiều DPS hoặc môi trường thực thi thay đổi, kết quả có thể khác. Cần quét tham số và nhiều seed trước khi kết luận tổng quát.

## F. Câu hỏi phản biện và giới hạn

### 40. Đồ án đã tái tạo đúng hình hoặc bảng nào của bài báo chưa?

Chưa. Mã đã triển khai mô hình và công thức xấp xỉ theo bài báo, đồng thời sinh kết quả tái lập được, nhưng chưa khớp toàn bộ tham số với một hình hoặc bảng cụ thể của bài báo. Vì vậy, đây là kiểm chứng triển khai và khảo sát nội bộ, chưa phải tái tạo hoàn chỉnh kết quả gốc.

### 41. Vì sao chưa dùng mô hình kênh chuẩn như 3GPP?

Mục tiêu hiện tại là tách và kiểm tra sai số của biểu diễn DPS, nên MPC được sinh trong miền băng đơn giản, có kiểm soát. Dùng mô hình 3GPP sẽ thực tế hơn nhưng bổ sung nhiều lớp tham số và phân bố. Đây là hướng mở rộng hợp lý sau khi phần biểu diễn cơ sở đã được kiểm chứng.

### 42. Vì sao mô phỏng không có nhiễu?

Đồ án nghiên cứu mô phỏng và biểu diễn đáp ứng kênh, không phải bài toán ước lượng kênh từ tín hiệu thu. Nhiễu sẽ cần thiết nếu đánh giá bộ ước lượng, BER hoặc hiệu năng hệ thống, nhưng không cần để đo sai số giữa hai cách tạo cùng một kênh lý tưởng.

### 43. Có thể khẳng định phương pháp đáp ứng thời gian thực không?

Chưa thể. Đồ án mới đo thời gian trong MATLAB trên một cấu hình, chưa tính mọi chi phí và chưa triển khai trên phần cứng mục tiêu. Có thể nói kết quả cho thấy tiềm năng giảm thời gian, nhưng chưa chứng minh khả năng thời gian thực.

### 44. Nếu miền băng hoặc vận tốc tăng thì điều gì xảy ra?

Băng thông chuẩn hóa tăng làm tích thời gian--băng thông tăng, nên cần giữ nhiều vector DPS hơn. Khi $$D$$ tiến gần $$N$$, khả năng nén và lợi thế tính toán giảm. Sai số cũng có thể tăng nếu vẫn giữ nguyên số chiều cũ.

### 45. Nếu số MPC tăng thì điều gì xảy ra?

Chi phí tạo SoCE tăng theo $$P$$ nhân với số mẫu toàn khối. Chi phí tạo hệ số DPS cũng tăng theo $$P$$, nhưng sau khi có tensor hệ số, bước tái tạo không còn phụ thuộc trực tiếp vào $$P$$. Mức lợi thực tế còn phụ thuộc kích thước cơ sở và cách triển khai.

### 46. Nếu số anten tăng thì hybrid còn tốt không?

Chưa thể kết luận từ kết quả hiện tại. Khi số anten tăng, tính trực tiếp các hàm mũ không gian trong hybrid cũng tốn hơn; đồng thời DPS không gian có thể bắt đầu tạo lợi ích nếu miền góc đủ hẹp. Cần quét số anten và miền góc để tìm điểm chuyển giữa hybrid và DPS 4D.

### 47. Hạn chế lớn nhất của đồ án là gì?

Ba hạn chế chính là chỉ đánh giá một cấu hình với một seed, chưa chọn $$D$$ và $$r$$ tự động theo ngưỡng sai số, và chưa tái tạo một kết quả cụ thể của bài báo với toàn bộ tham số khớp nhau. Phép đo thời gian cũng chưa gồm chi phí tạo cơ sở DPS.

### 48. Nếu có thêm thời gian, bước tiếp theo quan trọng nhất là gì?

Ưu tiên thứ nhất là quét $$D$$, $$r$$, số anten và nhiều seed để xây dựng đường cong đánh đổi NMSE--thời gian--bộ nhớ. Sau đó, cần khớp toàn bộ tham số để tái tạo một hình hoặc bảng cụ thể của bài báo. Cuối cùng mới mở rộng sang phân bố MPC hoặc mô hình kênh chuẩn thực tế hơn.

## G. Câu hỏi ngắn cần trả lời ngay

### 49. SoCE viết tắt của gì?

Sum of Complex Exponentials, tức tổng các hàm mũ phức.

### 50. DPS viết tắt của gì?

Discrete Prolate Spheroidal sequences, tức chuỗi prolate spheroidal rời rạc.

### 51. NMSE càng lớn hay càng nhỏ thì tốt?

Càng nhỏ càng tốt; bằng không tương ứng với không có sai số so với tham chiếu.

### 52. $$D_{\mathrm{total}}$$ bằng bao nhiêu?

$$D_{\mathrm{total}}=6\times9\times4\times4=864$$.

### 53. Khối kênh có bao nhiêu phần tử?

$$256\times64\times4\times4=262144$$ phần tử phức.

### 54. Nhánh nào có NMSE nhỏ nhất?

DPS chính xác, với NMSE $$8{,}53\times10^{-9}$$ so với SoCE.

### 55. Nhánh xấp xỉ nào phù hợp nhất trong cấu hình hiện tại?

Hybrid, vì NMSE thấp hơn DPS xấp xỉ 4D và tổng thời gian đo được cũng thấp hơn trong lần chạy hiện tại.

### 56. Một câu kết thúc an toàn khi bị hỏi ngoài phạm vi là gì?

“Kết quả hiện tại chưa đủ để kết luận cho trường hợp đó. Dựa trên mô hình, em dự đoán xu hướng như trên, nhưng cần bổ sung quét tham số hoặc mô phỏng tương ứng để kiểm chứng.”

---

## Những con số cần nhớ

| Đại lượng | Giá trị |
|---|---:|
| $$M,Q,N_{\mathrm{Tx}},N_{\mathrm{Rx}}$$ | $$256,64,4,4$$ |
| Số MPC $$P$$ | $$80$$ |
| $$D_t,D_f,D_{\mathrm{Tx}},D_{\mathrm{Rx}}$$ | $$6,9,4,4$$ |
| $$D_{\mathrm{total}}$$ | $$864$$ |
| Số mẫu toàn khối | $$262144$$ |
| NMSE DPS chính xác | $$8{,}53\times10^{-9}$$ |
| NMSE DPS xấp xỉ 4D | $$1{,}99\times10^{-4}$$ |
| NMSE hybrid | $$4{,}29\times10^{-7}$$ |
| Thời gian SoCE | $$0{,}222372\,\mathrm{s}$$ |
| Tổng thời gian DPS chính xác | $$0{,}045555\,\mathrm{s}$$ |
| Tổng thời gian DPS xấp xỉ 4D | $$0{,}080983\,\mathrm{s}$$ |
| Tổng thời gian hybrid | $$0{,}025322\,\mathrm{s}$$ |

## Cách xử lý khi không biết chắc câu trả lời

1. Nêu rõ phần nào là kết quả đã kiểm chứng và phần nào là suy luận.
2. Giới hạn câu trả lời trong cấu hình mô phỏng hiện tại.
3. Không tự tạo số liệu hoặc viện dẫn một kết quả chưa có trong đồ án.
4. Đề xuất phép thử cần làm để trả lời chắc chắn hơn.

Ví dụ:

> Trong cấu hình hiện tại, hybrid cho kết quả tốt hơn DPS xấp xỉ 4D. Với số anten lớn hơn, em chưa có dữ liệu để kết luận; cần quét $$N_{\mathrm{Tx}},N_{\mathrm{Rx}}$$ và miền góc để xác định khi nào DPS không gian bắt đầu có lợi.
