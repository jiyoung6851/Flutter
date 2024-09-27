import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project3/models/product.dart';
import 'package:project3/main.dart';

class MshopPaymentPage extends StatefulWidget {
  final Product product;

  MshopPaymentPage({super.key, required this.product});

  @override
  _MshopPaymentState createState() => _MshopPaymentState();
}

class _MshopPaymentState extends State<MshopPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final NumberFormat numberFormat = NumberFormat('###,###,###,###');
  final storage = const FlutterSecureStorage();
  int userMile = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    String? userId = await storage.read(key: 'user_id');

    if (userId != null) {
      final response = await Supabase.instance.client
          .from('users')
          .select('user_name, user_phone, user_address, user_mile')
          .eq('user_id', userId)
          .single();

      if (response != null) {
        setState(() {
          _nameController.text = response['user_name'] ?? '';
          _phoneController.text = response['user_phone']?.toString() ?? '';
          _addressController.text = response['user_address'] ?? '';
          userMile = (response['user_mile'] ?? 0).toInt();
        });
      }
    }
  }

  Future<void> _payWithMileage() async {
    String? userId = await storage.read(key: 'user_id');
    if (userId != null) {
      final price = (widget.product.price ?? 0).toInt(); // 변환 추가

      if (userMile >= price) {
        final newMile = userMile - price;

        // 마일리지 업데이트
        await Supabase.instance.client
            .from('users')
            .update({'user_mile': newMile}).eq('user_id', userId);

        // 마일리지 업데이트 성공 후 상태 업데이트
        setState(() {
          userMile = newMile;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('마일리지 결제가 완료되었습니다.')),
        );

        // 결제 후 Main 화면으로 이동
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Main()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('마일리지가 부족합니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.product.price ?? 0;
    final remainingMile = userMile - price;

    return Scaffold(
      appBar: AppBar(
        title: const Text('결제 페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                '1. 주문자 정보',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7F50),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '이름',
                  labelStyle: TextStyle(fontSize: 25),
                ),
                style: const TextStyle(fontSize: 25),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: '전화번호',
                  labelStyle: TextStyle(fontSize: 25),
                ),
                style: const TextStyle(fontSize: 25),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '전화번호를 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: '주소',
                  labelStyle: TextStyle(fontSize: 25),
                ),
                style: const TextStyle(fontSize: 25),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '주소를 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              const Text(
                '2. 주문 내역',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7F50),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${widget.product.productName}',
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 40),
              const Text(
                '3. 결제 금액 및 마일리지',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7F50),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${numberFormat.format(price)}원',
                    style: const TextStyle(fontSize: 25),
                  ),
                  Text(
                    '현재 마일리지: ${numberFormat.format(userMile)}점',
                    style: const TextStyle(fontSize: 25),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                '결제 후 예상 마일리지',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                remainingMile >= 0
                    ? '${numberFormat.format(remainingMile)}점'
                    : '마일리지 부족',
                style: TextStyle(
                  fontSize: 25,
                  color: remainingMile >= 0 ? Colors.black : Colors.red,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: _payWithMileage,
          child: Container(
            color: const Color(0xFFFF7F50),
            height: 56,
            alignment: Alignment.center,
            child: const Text(
              '마일리지 결제',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
