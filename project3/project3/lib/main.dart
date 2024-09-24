import 'package:flutter/material.dart';
import 'package:project3/DiaryPage.dart';
import 'package:project3/login/login.dart';
import 'package:project3/mshop.dart';
import 'package:project3/screens/bestseller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project3/product/NewProductPage.dart';
import 'package:project3/diary/diarylist.dart';

void main() async {
  // Flutter 프레임워크가 플랫폼 채널을 초기화할 수 있도록 보장
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase 초기화
  await Supabase.initialize(
    url: "https://rtgmnhdcwuacmvlwxqoz.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0Z21uaGRjd3VhY212bHd4cW96Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0Mjk4MzEsImV4cCI6MjA0MTAwNTgzMX0.Cq5zNfZ8AKJmrR0VQlJuH2v5P5U-RAT0tK7piH_EKN4",
  );
  // Flutter 애플리케이션 실행
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '화담',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}

// 아래는 MyHomePage 클래스 정의로 그대로 유지
class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Stack(
          children: [
            // 배경 컨테이너
            Container(
              width: 768, // 고정된 너비
              height: 1500, // 고정된 높이
              decoration: BoxDecoration(
                color: Colors.white, // 흰색 배경
                border: Border.all(color: Colors.black, width: 1), // 테두리 추가
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 80), // 상단 여백

                    // 메인 화면 컨테이너
                    Container(
                      width:
                          MediaQuery.of(context).size.width * 0.9, // 화면 너비의 90%
                      height: 200,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFAD8F), // 메인화면 색상
                        border:
                            Border.all(color: Colors.black, width: 1), // 테두리 추가
                      ),
                      child: const Center(
                        child: Text(
                          '메인화면:\n로고, 앱 간단소개 및 배너',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40), // 메인 화면과 네 개의 박스 간격

                    // 네 개의 박스를 감싸는 컨테이너
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0), // 양옆 여백 추가
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const DiaryPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color:
                                          const Color(0xFFFF7F50), // 일기 쓰기 색상
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 1), // 테두리 추가
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '일기 쓰기',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16), // 간격 조정
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const DiaryListPage(), // 일기 게시판 페이지로 이동
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 250,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF7F50), // 일기 게시판 색상
                                      border: Border.all(color: Colors.black, width: 1), // 테두리 추가
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '일기 게시판',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16), // 간격 조정
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BestsellerPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF7F50), // 베스트셀러 구매 색상
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 1), // 테두리 추가
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '베스트셀러 구매',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16), // 간격 조정
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Mshop(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                          0xFFFF7F50), // 마일리지 shop 색상
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 1), // 테두리 추가
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '마일리지 shop',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16), // 간격 조정
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const NewProductPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF7F50), // 베스트셀러 구매 색상
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 1), // 테두리 추가
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '상품등록',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16), // 간격 조정
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const NewProductPage(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                          0xFFFF7F50), // 마일리지 shop 색상
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 1), // 테두리 추가
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '상품조회',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 좌측 상단 화담
            Positioned(
              left: 16,
              top: 16,
              child: const Text(
                '화담',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // 우측 상단 마일리지
            Positioned(
              right: 16,
              top: 16,
              child: const Text(
                '내 마일리지 : 15,657',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
