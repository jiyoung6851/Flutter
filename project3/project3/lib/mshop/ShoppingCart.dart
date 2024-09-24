import 'package:flutter/material.dart';
import 'package:project3/mshop.dart';

class Shoppingcart extends StatelessWidget {
  const Shoppingcart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('장바구니'),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          // BottomAppBar 클릭 시 이동할 페이지
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Mshop()), // TargetPage로 이동
          );
        },
        child: BottomAppBar(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16), // 상하 패딩 조정
            child: Center(
              child: Text(
                '구매하기',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
