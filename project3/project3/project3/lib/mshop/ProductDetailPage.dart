import 'package:flutter/material.dart';
import 'package:project3/models/product.dart';
import 'package:intl/intl.dart'; // 가격 포맷을 위해 필요
import 'package:project3/mshop.dart';
import 'package:project3/mshop/ShoppingCart.dart';
import 'package:project3/mshop/mshoppayment.dart'; // PaymentPage를 임포트

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final NumberFormat numberFormat = NumberFormat('###,###,###,###');

  ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Mshop()), // Mshop 페이지로 이동
            );
          },
          child: Image.asset(
            'assets/mshop.png', // 이미지 파일 경로
            height: 30, // 이미지의 높이를 30으로 설정
            fit: BoxFit.contain, // 이미지가 상하로 잘리지 않도록 설정
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Shoppingcart 페이지로 이동
                  builder: (context) => const Shoppingcart(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 대표 이미지
              Image.network(
                product.productImageUrl!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                product.productName!,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "${numberFormat.format(product.price)}원",
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // 상세 이미지
              if (product.productDetails != null)
                Image.network(
                  product.productDetails!,
                  width: double.infinity, // 가로에 맞추기
                  fit: BoxFit.fitWidth, // 가로에 맞추되 세로는 이미지 비율에 맞추기
                ),
            ],
          ),
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
                      builder: (context) =>
                          MshopPaymentPage(product: product), // PaymentPage로 이동
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
