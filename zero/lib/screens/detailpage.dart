import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 가격 포맷을 위해 필요
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zero/models/product.dart';
import 'package:zero/screens/paymentpage.dart'; // Supabase 패키지 임포트

class DetailPage extends StatelessWidget {
  final Product product;
  final NumberFormat numberFormat = NumberFormat('###,###,###,###');

  DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName ?? '제품 상세'), // null 처리
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              product.productImageUrl ?? 'assets/images/ex.png', // null 처리
              width: 500,
              height: 250,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 16),
            Text(
              product.productName ?? '상품명 없음', // null 처리
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            Text(
              "할머니, 할아버지의\n1년의 이야기를 담았습니다.",
              style: const TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "C ${numberFormat.format(product.price)}원",
                  style: const TextStyle(fontSize: 25, color: Colors.black),
                ),
                const SizedBox(width: 16),
                Text(
                  "M ${numberFormat.format(product.price)}원",
                  style: const TextStyle(fontSize: 25, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 60),
            // 장바구니와 바로구매 버튼 추가
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await addToCart(
                        context, product.productNo.toString()); // 장바구니에 추가
                  },
                  child: const Text('장바구니'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Payment 페이지로 product 객체를 전달하며 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PaymentPage(product: product), // 수정된 부분
                      ),
                    );
                  },
                  child: const Text('바로구매'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 장바구니에 제품 추가하는 함수
Future<void> addToCart(BuildContext context, String bookId) async {
  try {
    final response = await Supabase.instance.client.from('cart').insert({
      'cart_id': '1', // 임시 cart_id
      'product_id': null, // product_id는 null
      'book_id': bookId, // book_id는 현재 product의 book_id
      'user_id': 'a', // 임시 user_id
    }).select();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('장바구니에 담았습니다!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('장바구니에 추가하는 중 오류가 발생했습니다: $e')),
    );
  }
}
