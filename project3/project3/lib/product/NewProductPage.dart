import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 선택을 위해 추가
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase를 사용하기 위해 추가
import 'dart:io'; // File을 사용하기 위해 추가

class NewProductPage extends StatefulWidget {
  const NewProductPage({Key? key}) : super(key: key);

  @override
  _NewProductPageState createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final TextEditingController titleController = TextEditingController();
  String? selectedCategory;
  File? mainImage;
  File? detailImage;
  List<Map<String, dynamic>> options = [];

  final SupabaseClient supabase = Supabase.instance.client;

  // 대표 이미지 선택
  Future<void> selectMainImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        mainImage = File(pickedFile.path);
      });
    }
  }

  // 상세 이미지 선택
  Future<void> selectDetailImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        detailImage = File(pickedFile.path);
      });
    }
  }

  // 상품 등록
  Future<void> registerProduct() async {
    try {
      // 이미지 업로드 (대표 이미지와 상세 이미지)
      String? mainImageUrl;
      String? detailImageUrl;

      if (mainImage != null) {
        try {
          final mainImagePath = 'main/${mainImage!.path.split('/').last}';
          // Supabase storage upload에서 File 객체를 사용하여 업로드
          final String mainUploadResponse = await supabase.storage
              .from('product_main_img')
              .upload(mainImagePath, mainImage!);

          mainImageUrl = supabase.storage
              .from('product_main_img')
              .getPublicUrl(mainImagePath);
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('대표 이미지 업로드 실패: $error')),
          );
          return;
        }
      }

      if (detailImage != null) {
        try {
          final detailImagePath = 'detail/${detailImage!.path.split('/').last}';
          final String detailUploadResponse = await supabase.storage
              .from('product_main_img')
              .upload(detailImagePath, detailImage!);

          detailImageUrl = supabase.storage
              .from('product_main_img')
              .getPublicUrl(detailImagePath);
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('상세 이미지 업로드 실패: $error')),
          );
          return;
        }
      }

      // 데이터베이스에 데이터 삽입
      final insertResponse = await supabase.from('product').insert({
        'product_title': titleController.text,
        'categori_id': selectedCategory,
        'product_image': detailImageUrl,
        'main_image': mainImageUrl,
        'price': 0, // 임시로 가격을 0으로 설정
      });

      if (insertResponse.error != null) {
        throw insertResponse.error!.message;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('상품이 등록되었습니다.')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('등록 중 오류 발생: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상품 등록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('상품 제목'),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: '상품 제목 입력',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('카테고리'),
            DropdownButtonFormField<String>(
              items: ['식품', '생활용품', '의류', '선물용품'].map((String category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              decoration: const InputDecoration(
                hintText: '카테고리 선택',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('대표 이미지'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: selectMainImage,
            ),
            if (mainImage != null)
              Text(mainImage!.path.split('/').last), // 파일 이름만 표시
            const SizedBox(height: 16.0),
            const Text('상세 이미지'),
            IconButton(
              icon: const Icon(Icons.upload),
              onPressed: selectDetailImage,
            ),
            if (detailImage != null)
              Text(detailImage!.path.split('/').last), // 파일 이름만 표시
            const SizedBox(height: 16.0),
            const Text('옵션'),
            // 옵션 관련 코드 (생략)
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.grey,
                  height: 56,
                  alignment: Alignment.center,
                  child: const Text(
                    '뒤로가기',
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
                onTap: registerProduct,
                child: Container(
                  color: Colors.orange,
                  height: 56,
                  alignment: Alignment.center,
                  child: const Text(
                    '등록',
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
