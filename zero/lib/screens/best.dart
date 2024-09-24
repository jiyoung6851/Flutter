import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase 패키지 임포트
import 'package:intl/intl.dart';
import 'package:zero/models/product.dart';
import 'package:zero/screens/detailpage.dart';

class Best extends StatelessWidget {
  const Best({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), // AppBar의 높이를 60으로 설정
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          child: AppBar(
            backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // AppBar의 배경색
            centerTitle: true, // 타이틀을 중앙에 배치
            title: const Text(
              '베스트 셀러',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: const ItemListPage(), // ItemListPage를 메인 콘텐츠로 사용
    );
  }
}

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final NumberFormat numberFormat = NumberFormat('###,###,###,###');

  // Supabase에서 데이터를 가져오는 함수
  Future<List<Product>> fetchProducts() async {
    final List<dynamic> data = await Supabase.instance.client
        .from('book')
        .select('book_id, book_title, book_price'); // book_image_url 필드는 제외

    // 데이터를 Product 객체로 변환
    return data.map((item) {
      return Product(
        productNo: int.parse(item['book_id'].toString()), // 정수형 변환
        productName: item['book_title'].toString(), // 문자열 변환
        price: double.parse(item['book_price'].toString()), // 가격을 double로 변환
        productImageUrl: 'assets/images/ex.png', // 로컬 애셋 이미지 설정
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: fetchProducts(), // Supabase에서 데이터를 가져옴
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // 로딩 인디케이터
        } else if (snapshot.hasError) {
          return Center(child: Text('오류 발생: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('데이터가 없습니다.'));
        } else {
          final productList = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.zero, // 전체 리스트의 기본 패딩 제거
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // 클릭 시 상세 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        product: productList[index],
                      ),
                    ),
                  );
                },
                child: productContainer(
                  productName: productList[index].productName ?? "",
                  productImageUrl: productList[index].productImageUrl ?? "",
                  price: productList[index].price ?? 0,
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget productContainer({
    required String productName,
    required String productImageUrl,
    required double price,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 남는 공간 차지하지 않도록 설정
      children: [
        // 이미지 컨테이너
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.3, // 화면 높이의 30%로 설정
          width: double.infinity, // 가로로 화면 꽉 차게 설정
          child: Image.asset(
            productImageUrl, // 로컬 애셋 이미지를 사용
            fit: BoxFit.cover, // 이미지를 컨테이너에 맞춰 꽉 차게 설정
          ),
        ),
        // 텍스트와 가격 컨테이너
        Container(
          decoration: const BoxDecoration(
            color: Colors.white, // 배경색은 흰색
            border: Border(bottom: BorderSide(color: Colors.black, width: 2)),
          ),
          width: double.infinity, // 가로는 이미지와 맞춤
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 16), // 적절한 여백 추가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // 텍스트를 가운데 정렬
            children: [
              Text(
                productName,
                textAlign: TextAlign.center, // 텍스트 가운데 정렬
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22, // 폰트 크기 확대
                ),
              ),
              const SizedBox(height: 10), // 텍스트와 가격 사이에 간격 추가
              Text(
                "${numberFormat.format(price)}원",
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
