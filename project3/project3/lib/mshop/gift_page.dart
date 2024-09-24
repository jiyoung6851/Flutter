import 'package:flutter/material.dart';
import 'package:project3/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase 패키지 임포트
import 'package:project3/screens/ProductDetailPage.dart'; // ProductDetailPage 임포트
import 'package:intl/intl.dart';

class GiftPage extends StatelessWidget {
  const GiftPage({super.key});

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
            automaticallyImplyLeading: false,
            backgroundColor:
                const Color.fromARGB(255, 255, 255, 255), // AppBar의 배경색
            centerTitle: true, // 타이틀을 중앙에 배치
            title: Row(
              children: [
                Image.asset(
                  'assets/logo.png', // 로고 이미지 경로
                  height: 50, // 로고의 높이
                ),
                const Spacer(),
                const Text(
                  '선물용', // 상단 제목
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
              ],
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
        .from('product') // 'product' 테이블에서 데이터 가져오기
        .select(
            'product_id, product_title, main_image, product_image, price'); // 필요한 컬럼 선택

    // 데이터가 리스트인 경우 처리
    return data.map((item) {
      return Product(
        productNo: item['product_id'],
        productName: item['product_title'],
        price: item['price'].toDouble(),
        productImageUrl: item['main_image'], // 대표 이미지 URL 사용
        productDetails: item['product_image'], // 상세페이지 URL 사용
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
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
          return GridView.builder(
            padding: EdgeInsets.zero, // 전체 그리드의 기본 패딩 제거
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 한 행에 2개의 항목
              crossAxisSpacing: 0, // 항목 간의 가로 간격
              mainAxisSpacing: 0, // 항목 간의 세로 간격
              childAspectRatio: 0.85, // 항목의 가로 세로 비율 조정
            ),
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // 클릭 시 상세 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1), // 얇은 선으로 테두리 설정
      ),
      child: Column(
        children: [
          // 이미지 컨테이너
          Container(
            height: MediaQuery.of(context).size.height * 0.2, // 화면 높이의 20%로 설정
            width: double.infinity, // 가로로 화면 꽉 차게 설정
            child: Image.network(
              productImageUrl, // 네트워크 이미지 사용
              fit: BoxFit.cover, // 이미지를 컨테이너에 맞춰 꽉 차게 설정
            ),
          ),
          // 텍스트와 가격 컨테이너
          Container(
            padding: const EdgeInsets.only(top: 8.0), // 상단 여백만 8.0으로 설정
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // 텍스트를 가운데 정렬
              children: [
                Text(
                  productName,
                  textAlign: TextAlign.center, // 텍스트 가운데 정렬
                  overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 때 '...'으로 표시
                  maxLines: 1, // 최대 1줄로 제한
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15, // 폰트 크기 축소
                  ),
                ),
                const SizedBox(height: 0), // 텍스트와 가격 사이에 간격 없앰
                Text(
                  "${numberFormat.format(price)}원",
                  textAlign: TextAlign.center, // 텍스트 가운데 정렬
                  style: const TextStyle(
                    fontSize: 15, // 폰트 크기 축소
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
