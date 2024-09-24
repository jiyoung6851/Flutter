import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zero/models/product.dart';

class PaymentPage extends StatefulWidget {
  final Product product;

  PaymentPage({super.key, required this.product});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final NumberFormat numberFormat = NumberFormat('###,###,###,###');

  @override
  Widget build(BuildContext context) {
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
              // 1. 주문자 정보
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
                  labelStyle: TextStyle(fontSize: 25), // 라벨 텍스트 크기 설정
                ),
                style: const TextStyle(fontSize: 25), // 입력 필드 텍스트 크기 설정
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
                  labelStyle: TextStyle(fontSize: 25), // 라벨 텍스트 크기 설정
                ),
                style: const TextStyle(fontSize: 25), // 입력 필드 텍스트 크기 설정
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
                  labelStyle: TextStyle(fontSize: 25), // 라벨 텍스트 크기 설정
                ),
                style: const TextStyle(fontSize: 25), // 입력 필드 텍스트 크기 설정
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '주소를 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              // 2. 주문 내역
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
                '${widget.product.productName}', // 상품 이름 자동 입력
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 40),
              // 3. 결제 금액
              const Text(
                '3. 결제 금액',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7F50),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${numberFormat.format(widget.product.price)}원', // 가격 표시
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 40),
              // 4. 결제 방법
              const Text(
                '4. 결제 방법',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7F50),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 마일리지 결제 버튼
                    },
                    child: const Text('마일리지 결제'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // 신용/체크카드 결제 버튼
                    },
                    child: const Text('신용/체크카드 결제'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
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