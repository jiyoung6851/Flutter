import 'package:flutter/material.dart';
// 로컬 저장소와 관련된 클래스
import 'local_storage.dart';
// ToDo 데이터 정의
import 'todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ToDo App',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const ToDoListPage(),
    );
  }
}

// 할 일 목록을 관리하는 class
class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  // LocalStorage 클래스의 인스턴스를 생성
  final LocalStorage localStorage = LocalStorage();
  // 텍스트 필드를 제어하기 위한 컨트롤러(텍스트를 입력받음)
  final TextEditingController controller = TextEditingController();
  // 할일목록을 저장하는 리스트
  List<ToDo> todos = [];

  @override
  // 위젯 라이프사이클에서 위젯이 처음 생성될때 호출
  void initState() {
    super.initState();
    // 저장된 할일목록을 불러옴
    _loadToDos();
  }

  // 비동기 방식으로 로컬 저장소에 있는 할일 목록을 불러옴
  Future<void> _loadToDos() async {
    todos = await localStorage.readToDos();
    // 화면 갱신
    setState(() {});
  }

  // 비동기 방식으로 할일 목록을 추가
  Future<void> _addToDo() async {
    if (controller.text.isNotEmpty) {
      setState(() {
        //할 일 목록을 추가
        todos.add(ToDo(title: controller.text));
      });
    }
    // 로컬 저장소에 저장
    await localStorage.wirteToDos(todos);
    // 텍스트 필드를 비움
    controller.clear();
  }

  // 비동기 방식으로 할일 목록을 삭제
  Future<void> _deleteToDo(int index) async {
    setState(() {
      todos.removeAt(index);
    });
    // 삭제된 할일 목록을 로컬 저장소에 저장
    await localStorage.wirteToDos(todos);
  }

  @override
  Widget build(BuildContext context) {
    // 기본 레이아웃
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter ToDo App"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            // 할 일 목록을 입력받음
            child: TextField(
              // 입력된 텍스트를 제어
              controller: controller,
              decoration: InputDecoration(
                labelText: "Enter a ToDo",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addToDo,
            child: Text("Add ToDo"),
          ),
          // Expanded: 남은 공간을 꽉 차게 사용
          Expanded(
            // 할 일 목록을 출력
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                // 할 일 목록을 출력(제목, 삭제 버튼)
                return ListTile(
                  title: Text(todo.title),
                  trailing: IconButton(
                      onPressed: () => _deleteToDo(index),
                      icon: Icon(Icons.delete)),
                );
              },
            ),
          ),
        ],
      ),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
