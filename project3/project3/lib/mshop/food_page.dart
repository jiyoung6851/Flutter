import 'package:flutter/material.dart';

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  List<dynamic> items = [];
  bool isLoading = true; // 로딩 상태를 나타내는 변수

  @override
  void initState() {
    super.initState();
    // _loadItems() 호출 제거
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false; // 데이터 로드 완료 후 로딩 상태 변경
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // 데이터 로딩 중일 때 로딩 표시
            : items.isNotEmpty
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 한 줄에 2개씩
                      crossAxisSpacing: 8.0, // 좌우 간격
                      mainAxisSpacing: 8.0, // 상하 간격
                      childAspectRatio: 0.7, // 그리드 아이템 비율 조정
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildGridItem(item);
                    },
                  )
                : Center(
                    child: Text('No items available')), // 데이터가 없을 때 빈 상태 표시
      ),
    );
  }

  Widget _buildGridItem(dynamic item) {
    return Card(
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(color: Colors.grey[300]), // 더미 이미지
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Sample Item', // 더미 상품명
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '1000원', // 더미 가격
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
