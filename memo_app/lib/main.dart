import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<String> items = ["item1", "item2", "item3"];

    return MaterialApp(
        // Scaffold: 기본적인 레이아웃
        home: MyMemoAppWidget()
        /*
      Scaffold(
        // AppBar: 상단 앱 바
        appBar: AppBar(
          // 제목: Memo
          title: Text("Memo"),
          backgroundColor: Colors.amber,
          actions: [
            // IconButton: 아이콘이 있는 버튼
            IconButton(onPressed: (){
              // print("클릭");
              items.add("new item");
              print(items);
            }, 
            //create: 기본 제공되는 create 아이콘
            icon: Icon(Icons.create))
          ],
        ),
        // ListView.builder: 스크롤 가능한 위젯(목록을 동적으로 생성)
        // itemBuilder: 목록항목을 빌드
        // context: 위젯의 위치 정보
        // index: 항목의 인덱스 번호
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index){
          // 인덱스번호를 문자열로 출력
          // return Text("$index");
          return Text(items[index]);
        }),
      ),*/
        );
  }
}

class MyMemoAppWidget extends StatefulWidget {
  const MyMemoAppWidget({super.key});

  @override
  State<MyMemoAppWidget> createState() => _MyMemoAppWidgetState();
}

class MemoData {
  String content;
  final DateTime createAt;

  MemoData(this.content, this.createAt);
}

class _MyMemoAppWidgetState extends State<MyMemoAppWidget> {
  // List<String> items = ["item1", "item2", "item3"];
  List<MemoData> items = [
    MemoData("Memo 1", DateTime(2023, 8, 1)),
    MemoData("Memo 2", DateTime(2023, 8, 2)),
    MemoData("Memo 3", DateTime(2023, 8, 3)),
    MemoData("Memo 4", DateTime(2023, 8, 4)),
  ];

  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return Scaffold(
      // AppBar: 상단 앱 바
      appBar: AppBar(
        // 제목: Memo
        title: Text("Memo"),
        backgroundColor: Colors.amber,
        actions: [
          // IconButton: 아이콘이 있는 버튼
          IconButton(
              onPressed: () {
                // print("클릭");
                // items.add("new item");
                /*
                items.add(MemoData("new item", DateTime.now()));
                print(items);
                */

                setState(() {
                  items.add(MemoData("new item", DateTime.now()));
                  print(items);
                });
              },
              //create: 기본 제공되는 create 아이콘
              icon: Icon(Icons.create))
        ],
      ),

      // ListView.builder: 스크롤 가능한 위젯(목록을 동적으로 생성)
      // itemBuilder: 목록항목을 빌드
      // context: 위젯의 위치 정보
      // index: 항목의 인덱스 번호
      body: CustomListView(
          items: items,
          onDelete: (index) {
            setState(() {
              items.removeAt(index);
              print(items);
            });
            // items.removeAt(index);
            // print(items);
          }),
      // body: ListView.builder(
      /*
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            // 인덱스번호를 문자열로 출력
            // return Text("$index");
            return Text(items[index]);
          }),
          */
    );
  }
}

//상태변화 없는 위젯
class CustomListView extends StatelessWidget {
  final List<MemoData> items;
  final Function(int) onDelete;

  const CustomListView(
      {super.key, required this.items, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("아이템 $index"),
            subtitle: Text("${items[index].createAt}"),
            tileColor: Colors.amber[100],
            trailing: IconButton(
                onPressed: () {
                  onDelete(index);
                  // items.removeAt(index);
                  // print(items);
                },
                icon: Icon(Icons.delete)),
          );
        });
  }
}

// 상태관리하면서 상태 변화되면 UI 재빌드
// class MyMemoAppWidget extends StatefulWidget{}
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
