import 'package:flutter/material.dart';
// import 'package:project3/main.dart';
import 'package:project3/mshop/ShoppingCart.dart';
import 'package:project3/mshop/clothing_page.dart';
import 'package:project3/mshop/food_page.dart';
import 'package:project3/mshop/gift_page.dart';
import 'package:project3/mshop/living_supplies_page.dart';
import 'package:project3/main.dart';

class Mshop extends StatelessWidget {
  const Mshop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false, // 자동 뒤로가기 버튼 비활성화
        title: Row(
          children: [
            Expanded(
              flex: 2, // 전체 너비의 20%
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Main(), // MyHomePage 페이지로 이동
                    ),
                  );
                },
                child: Image.asset(
                  'assets/logo.png', // 이미지 파일 경로
                  fit: BoxFit.contain, // 이미지가 상하로 잘리지 않도록 설정
                ),
              ),
            ),
            Expanded(
              flex: 8, // 전체 너비의 80%
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Mshop(), // Mshop 페이지로 이동
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/mshop.png', // 이미지 파일 경로
                    fit: BoxFit.contain, // 이미지가 상하로 잘리지 않도록 설정
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2, // 전체 너비의 20%
              child: Align(
                alignment: Alignment.centerRight,
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
                  child: const Icon(Icons.shopping_cart, size: 35),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white, // AppBar의 배경색을 흰색으로 설정
        toolbarHeight: 100, // AppBar의 높이 조정
      ),
      body: Column(
        children: [
          // 첫 번째 행
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildGridItem(
                      Icons.food_bank, '식품', context, FoodPage()),
                ),
                SizedBox(width: 10), // 열 사이의 간격
                Expanded(
                  child: _buildGridItem(
                      Icons.house, '생활용품', context, LivingSuppliesPage()),
                ),
              ],
            ),
          ),
          SizedBox(height: 10), // 행 사이의 간격
          // 두 번째 행
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildGridItem(
                      Icons.dry_cleaning, '의류', context, ClothingPage()),
                ),
                SizedBox(width: 10), // 열 사이의 간격
                Expanded(
                  child: _buildGridItem(
                      Icons.card_giftcard, '선물용', context, GiftPage()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(
      IconData icon, String label, BuildContext context, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 16, // 2열을 고려한 너비 조정
        height: MediaQuery.of(context).size.height / 4 - 16, // 높이 설정
        color: Color(0xFFFFAD8F), // 임의의 색상
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
