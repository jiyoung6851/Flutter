import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 가격 포맷을 위해 필요
import 'package:project3/mshop/ShoppingCart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project3/models/product.dart';
import 'package:project3/screens/paymentpage.dart'; // Supabase 패키지 임포트

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
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Shoppingcart 페이지로 이동
                      builder: (context) => Shoppingcart(),
                    ),
                  );
                },
                child: Container(
                  color: Colors.grey,
                  height: 56,
                  alignment: Alignment.center,
                  child: const Text(
                    '장바구니 담기',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 56,
              color: Colors.black,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        product: product, // Product 객체 전달
                      ), // PaymentPage로 이동
                    ),
                  );
                },
                child: Container(
                  color: Colors.orange,
                  height: 56,
                  alignment: Alignment.center,
                  child: const Text(
                    '구매하기',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
