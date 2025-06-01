import 'package:flutter/material.dart';

class TermsPolicy extends StatefulWidget {
  const TermsPolicy({super.key});

  @override
  State<TermsPolicy> createState() => _TermsPolicyState();
}

class _TermsPolicyState extends State<TermsPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điều Khoản và Chính Sách'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text(
                'Điều Khoản Dịch Vụ',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Giới thiệu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Chào mừng bạn đến với ứng dụng đặt đồ ăn và đặt phòng khách sạn của chúng tôi. Bằng việc sử dụng ứng dụng, bạn đồng ý với các điều khoản dịch vụ này.\n',
              ),
              Text(
                '2. Sử dụng Ứng Dụng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Ứng dụng của chúng tôi chỉ dành cho mục đích cá nhân và phi thương mại. Bạn đồng ý không sử dụng ứng dụng cho bất kỳ mục đích bất hợp pháp hoặc trái phép nào.\n',
              ),
              Text(
                '3. Đặt Đồ Ăn',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Bạn có thể đặt đồ ăn từ các nhà hàng đối tác thông qua ứng dụng. Chúng tôi không đảm bảo chất lượng hoặc tính sẵn có của món ăn, cũng như thông tin hiển thị về nhà hàng. Mọi vấn đề liên quan đến món ăn nên được liên hệ trực tiếp với nhà hàng.\n',
              ),
              Text(
                '4. Đặt Phòng Khách Sạn',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Bạn có thể đặt trước phòng khách sạn thông qua ứng dụng. Chúng tôi không đảm bảo chất lượng hoặc tính sẵn có của phòng khách sạn, cũng như độ chính xác của thông tin hiển thị. Mọi vấn đề phát sinh nên liên hệ trực tiếp với khách sạn.\n',
              ),
              Text(
                '5. Nội Dung Người Dùng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Bạn chịu trách nhiệm hoàn toàn cho mọi nội dung đăng tải hoặc truyền tải qua ứng dụng. Bạn đồng ý không đăng tải nội dung vi phạm pháp luật, phỉ báng hoặc vi phạm quyền sở hữu trí tuệ của bên thứ ba.\n',
              ),
              Text(
                '6. Quyền Sở Hữu Trí Tuệ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Tất cả các quyền sở hữu trí tuệ liên quan đến ứng dụng, bao gồm nhãn hiệu, biểu tượng, bản quyền... đều thuộc về chúng tôi hoặc bên cấp phép. Bạn không được sử dụng các tài sản trí tuệ này nếu không có sự cho phép bằng văn bản.\n',
              ),
              Text(
                '7. Giới Hạn Trách Nhiệm',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Chúng tôi không chịu trách nhiệm với bất kỳ thiệt hại gián tiếp, ngẫu nhiên hoặc hệ quả nào phát sinh từ việc sử dụng ứng dụng, bao gồm nhưng không giới hạn ở mất lợi nhuận, mất dữ liệu hoặc gián đoạn kinh doanh.\n',
              ),
              Text(
                '8. Chấm Dứt',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Chúng tôi có thể chấm dứt quyền truy cập ứng dụng của bạn bất kỳ lúc nào mà không cần thông báo.\n',
              ),
              Text(
                '9. Luật Áp Dụng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Các điều khoản này được điều chỉnh theo luật pháp của Pakistan. Mọi tranh chấp sẽ được giải quyết tại tòa án Pakistan.\n',
              ),
              SizedBox(height: 16.0),
              Text(
                'Chính Sách Quyền Riêng Tư',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Giới thiệu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Chúng tôi cam kết bảo vệ quyền riêng tư của bạn. Chính sách này giải thích cách chúng tôi thu thập, sử dụng và chia sẻ thông tin cá nhân của bạn.\n',
              ),
              Text(
                '2. Thu Thập Thông Tin Cá Nhân',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Chúng tôi thu thập thông tin như tên, email, số điện thoại khi bạn đăng ký hoặc sử dụng các dịch vụ đặt đồ ăn/đặt phòng.\n',
              ),
              Text(
                '3. Sử Dụng Thông Tin Cá Nhân',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Chúng tôi sử dụng thông tin để cung cấp dịch vụ, xử lý đơn hàng và gửi thông báo khuyến mãi nếu bạn đồng ý.\n',
              ),
              Text(
                '4. Chia Sẻ Thông Tin Cá Nhân',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Chúng tôi có thể chia sẻ thông tin với đối tác hoặc nhà cung cấp dịch vụ hỗ trợ hoạt động của ứng dụng. Thông tin cũng có thể được chia sẻ nếu pháp luật yêu cầu.\n',
              ),
              Text(
                '5. Bảo Mật Thông Tin Cá Nhân',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Chúng tôi áp dụng các biện pháp hợp lý để bảo vệ thông tin cá nhân khỏi truy cập trái phép hoặc rò rỉ dữ liệu.\n',
              ),
              Text(
                '6. Lưu Trữ Thông Tin Cá Nhân',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Chúng tôi lưu trữ thông tin cá nhân trong thời gian cần thiết để cung cấp dịch vụ hoặc theo yêu cầu pháp luật.\n',
              ),
              Text(
                '7. Thay Đổi Chính Sách',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Chúng tôi có thể thay đổi chính sách này mà không cần thông báo trước. Vui lòng kiểm tra thường xuyên để cập nhật.\n',
              ),
              Text(
                '8. Sử Dụng Thông Tin Cá Nhân',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Bằng việc sử dụng ứng dụng, bạn đồng ý để chúng tôi sử dụng thông tin cá nhân theo nội dung mô tả ở trên. Chúng tôi luôn tôn trọng và bảo vệ quyền lợi của bạn trong mọi trường hợp.\n',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
