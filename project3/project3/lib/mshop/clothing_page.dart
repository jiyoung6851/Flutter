import 'package:flutter/material.dart';

class ClothingPage extends StatefulWidget {
  @override
  _ClothingPageState createState() => _ClothingPageState();
}

class _ClothingPageState extends State<ClothingPage> {
  List<Map<String, dynamic>> items = [
    {
      'name': 'Sample Item 1',
      'image_url':
          'https://rtgmnhdcwuacmvlwxqoz.supabase.co/storage/v1/object/sign/product_main_img/100002.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJwcm9kdWN0X21haW5faW1nLzEwMDAwMi5qcGciLCJpYXQiOjE3MjU4NjIzNjgsImV4cCI6MjA0MTIyMjM2OH0.6JGb6Ybax6rrh4_u8hQigxUFzP-FsJ6EgBYONlcv6DM',
      'price': 1000,
    },
    {
      'name': 'Sample Item 2',
      'image_url': 'https://example.com/sample2.jpg',
      'price': 2000,
    },
  ];
  bool isLoading = false; // 로딩 상태를 설정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clothing Items'),
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

  Widget _buildGridItem(Map<String, dynamic> item) {
    return Card(
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              item['image_url'], // 이미지 경로
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item['name'], // 상품명
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${item['price']}원', // 가격
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
