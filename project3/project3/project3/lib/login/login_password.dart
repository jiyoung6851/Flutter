import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project3/signup/signup.dart'; // signup.dart 파일을 import하여 사용
import 'login.dart';
import 'package:project3/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://rtgmnhdcwuacmvlwxqoz.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0Z21uaGRjd3VhY212bHd4cW96Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0Mjk4MzEsImV4cCI6MjA0MTAwNTgzMX0.Cq5zNfZ8AKJmrR0VQlJuH2v5P5U-RAT0tK7piH_EKN4",
  );
  runApp(const MyApp());
}

const MaterialColor customSwatch = MaterialColor(
  0xFFEA5550,
  <int, Color>{
    50: Color(0xFFFFEDEE),
    100: Color(0xFFFFD0D1),
    200: Color(0xFFFFB1B3),
    300: Color(0xFFFF9194),
    400: Color(0xFFFF7C7F),
    500: Color(0xFFEA5550),
    600: Color(0xFFD84948),
    700: Color(0xFFC53C3A),
    800: Color(0xFFB12E2C),
    900: Color(0xFF9E2020),
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'login',
      theme: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: customSwatch,
      ),
      home: const LoginPassword(id: ''), // 초기 아이디 값을 전달해줍니다.
    );
  }
}

class LoginPassword extends StatefulWidget {
  final String id; // 아이디 변수를 final로 선언

  const LoginPassword({Key? key, required this.id}) : super(key: key); // 생성자에서 id를 required로 명시

  @override
  State<LoginPassword> createState() => _LoginPasswordState();
}

class _LoginPasswordState extends State<LoginPassword> {
  final TextEditingController _passwordController = TextEditingController(); // 비밀번호 입력 컨트롤러
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(); // Secure storage 인스턴스 생성

  Future<void> _checkCredentials() async {
    final id = widget.id; // 전달된 아이디
    final password = _passwordController.text; // 사용자가 입력한 비밀번호

    try {
      
      // 관리자 아이디
      
      if (id == 'admin' && password == '1234') {
        print('관리자 로그인 성공');
        // Secure storage에 데이터 저장
        await secureStorage.write(key: 'isLoggedIn', value: 'true');
        await secureStorage.write(key: 'user_id', value: id); // user_id 저장

        // 로그인 성공 시 페이지 이동
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Main(),
          ),
        );
      } else {
        // Supabase를 사용하여 user_ID와 user_password가 일치하는지 확인하는 쿼리
        final response = await Supabase.instance.client
            .from('users') // 'users'는 테이블 이름
            .select()
            .eq('user_id', id)
            .eq('user_password', password)
            .maybeSingle(); // 단일 결과를 기대하는 경우에 사용

        // 오류가 발생했거나 데이터가 없는 경우
        if (response == null || response.isEmpty) {
          print('로그인 실패');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('알림'),
                content: const Text('아이디 또는 비밀번호가 올바르지 않습니다.'),
                actions: [
                  TextButton(
                    child: const Text('닫기'),
                    onPressed: () {
                      Navigator.of(context).pop(); // 팝업을 닫습니다.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(), // 닫기를 누르면 login.dart로 이동
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          print('로그인 성공');
          // Secure storage에 데이터 저장
          await secureStorage.write(key: 'isLoggedIn', value: 'true');
          await secureStorage.write(key: 'user_id', value: id); // user_id 저장

          // 로그인 성공 시 페이지 이동
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Main(), 
            ),
          );
        }
      }
    } catch (e) {
      // 예외가 발생한 경우 처리
      print('오류가 발생했습니다: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 입력'),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 50)),
            Form(
              child: Theme(
                data: ThemeData(
                  primaryColor: Colors.grey,
                  inputDecorationTheme: const InputDecorationTheme(
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '비밀번호 입력해주세요 :)',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        InkWell(
                          onTap: () {
                            // 회원가입 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupPage(),
                              ),
                            );
                          },
                          child: const Text(
                            '혹시 회원이 아니신가요?',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Color.fromARGB(100, 48, 48, 48),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _passwordController, // 비밀번호 입력 컨트롤러 연결
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: customSwatch),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: customSwatch),
                                  ),
                                ),
                                obscureText: true, // 비밀번호 입력 시 텍스트 숨김 처리
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            ElevatedButton(
                              onPressed: _checkCredentials, // 버튼 클릭 시 _checkCredentials 호출
                              style: ElevatedButton.styleFrom(
                                backgroundColor: customSwatch,
                                minimumSize: const Size(100, 50),
                              ),
                              child: const Text('확인'),
                            ),
                          ],
                        ),
                      ],
                    ),
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