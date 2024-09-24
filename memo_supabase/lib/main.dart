import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async {
  // 비동기방식 초기화
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      // url: supabase 서비스와 통신할수 있는 url 설정
      url: "https://hxudbvuwuytlrlzvdxdy.supabase.co",
      // 보안키
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh4dWRidnV3dXl0bHJsenZkeGR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjUyMzYzNTEsImV4cCI6MjA0MDgxMjM1MX0.FIaBjvn-KLf10YSBKlyMCZJkqzJ7yZcrrjCdUPDaOqc");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _noteStream =
      // from: 테이블 선택
      // stream: pk 컬럼의 데이터를 스트림 형태로 지속적으로 받아옴
      Supabase.instance.client.from("notes").stream(primaryKey: ["id"]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // title: Text(widget.title),
        title: const Text("My Notes"),
      ),
      // StreamBuilder: 스트림에서 새로운 데이터가 수신될때마다 UI 재빌드
      body: StreamBuilder<List<Map<String, dynamic>>>(
        // _noteStream 에서 데이터를 받아옴
        stream: _noteStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // 데이터가 없는 상태일때 빙글빙글 도는 화면 출력
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final notes = snapshot.data!;

          // 데이터가 수신되면 ListView.builder 를 통해서 노트를 리스트로 출력
          return ListView.builder(
              // 리스트에 출력할 항목의 갯수
              itemCount: notes.length,
              itemBuilder: (context, index) {
                // ListTile 위젯: 노트의 내용을 출력
                return ListTile(
                  title: Text(notes[index]["body"]),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 다이얼로그 출력
          showDialog(
            context: context,
            builder: ((context) {
              // 노트를 추가하기 위한 간단한 입력 다이얼로그
              return SimpleDialog(
                title: const Text("Add a Note"),
                contentPadding: const EdgeInsets.symmetric(
                    // 가로 방향의 패딩을 16으로 설정
                    horizontal: 16),
                //  다이얼로그(대화상자)의 내부에 들어갈 위젯 목록
                children: [
                  // 텍스트를 입력할수 있는 입력 필드
                  TextFormField(
                    // 텍스트 입력후 제출(Enter 키 입력)했을때 호출됨
                    onFieldSubmitted: (value) async {
                      // notes 테이블에 body 컬럼에 value 데이터를 insert
                      await Supabase.instance.client
                          .from("notes")
                          .insert({"body": value});
                      // 현재 위젯이 존재할 경우
                      if (context.mounted) {
                        // 다이얼로그를 닫음
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            }),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
