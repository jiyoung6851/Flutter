import 'package:flutter/material.dart';
import 'package:project3/DiaryPage.dart';
import 'package:project3/login/login.dart';
import 'package:project3/mshop.dart';
import 'package:project3/screens/best.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project3/product/NewProductPage.dart';
import 'package:project3/diary/diarylist.dart';
import 'package:project3/product/productFind.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final storage = const FlutterSecureStorage();
  String userMile = '로딩 중...';
  bool showProductButtons = false; // 상품 등록/조회 버튼을 보여줄지 결정하는 변수

  @override
  void initState() {
    super.initState();
    _fetchUserMileAndGubun();
  }

  Future<void> _fetchUserMileAndGubun() async {
    // SecureStorage에서 user_id를 가져옴
    String? userId = await storage.read(key: 'user_id');

    if (userId != null) {
      // Supabase에서 해당 user_id의 user_mile 및 user_gubun 값 쿼리
      final response = await Supabase.instance.client
          .from('users')
          .select('user_mile, user_gubun')
          .eq('user_id', userId)
          .single();

      if (response != null && response['user_mile'] != null) {
        setState(() {
          userMile = response['user_mile'].toString();
          // user_gubun이 3인 경우에만 상품 등록/조회 버튼 표시
          if (response['user_gubun'] == 3) {
            showProductButtons = true;
          }
        });
      } else {
        setState(() {
          userMile = '마일리지 가져오기 오류';
        });
      }
    } else {
      setState(() {
        userMile = '로그인 필요';
      });
    }
  }

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
                                        builder: (context) =>
                                            const DiaryListPage(), // 일기 게시판 페이지로 이동
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color:
                                          const Color(0xFFFF7F50), // 일기 게시판 색상
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 1), // 테두리 추가
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
                                        builder: (context) => const Best(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                          0xFFFF7F50), // 베스트셀러 구매 색상
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
                          // user_gubun 값이 3일 때만 상품등록/조회 버튼을 보여줌
                          if (showProductButtons)
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
                                        color: const Color(
                                            0xFFFF7F50), // 베스트셀러 구매 색상
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
                                              const ProductFind(),
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
              child: Text(
                '내 마일리지 : $userMile',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
