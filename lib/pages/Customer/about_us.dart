import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Về Chúng Tôi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Center(
              child: Text(
                'Chào mừng đến với HomeFood',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Chào mừng bạn đến với ứng dụng đặt đồ ăn và đặt bàn trước của chúng tôi! Sứ mệnh của chúng tôi là giúp bạn dễ dàng và tiện lợi hơn trong việc đặt món ăn và đặt phòng khách sạn ngay trên thiết bị của mình.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Chúng tôi tin rằng ẩm thực và du lịch là những thú vui tuyệt vời trong cuộc sống, và ứng dụng của chúng tôi được thiết kế để nâng cao trải nghiệm ăn uống và nghỉ dưỡng của bạn. Dù bạn đang thèm món ăn yêu thích từ nhà hàng gần đó hay đang tìm kiếm một khách sạn lý tưởng cho kỳ nghỉ sắp tới, ứng dụng của chúng tôi sẽ hỗ trợ bạn.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Ứng dụng của chúng tôi được vận hành bởi một đội ngũ chuyên nghiệp, đầy đam mê với ẩm thực và du lịch. Chúng tôi luôn nỗ lực mỗi ngày để đảm bảo ứng dụng thân thiện với người dùng, đáng tin cậy và an toàn. Mục tiêu của chúng tôi là mang đến cho bạn trải nghiệm mượt mà và thú vị từ lúc mở ứng dụng đến khi bạn nhận được món ăn hoặc nhận phòng khách sạn.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Chúng tôi luôn lắng nghe ý kiến đóng góp từ bạn và không ngừng cải thiện ứng dụng. Nếu bạn có bất kỳ góp ý, câu hỏi hay đề xuất nào, hãy liên hệ với chúng tôi. Chúng tôi luôn sẵn sàng hỗ trợ bạn và cam kết mang đến dịch vụ tốt nhất có thể.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Cảm ơn bạn đã lựa chọn ứng dụng của chúng tôi! Chúng tôi hy vọng bạn sẽ có trải nghiệm tuyệt vời với các món ăn và dịch vụ khách sạn.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Trân trọng,',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Đội ngũ HomeFood',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
