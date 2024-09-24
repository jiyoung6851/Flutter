import 'package:flutter/material.dart';
// 무작위 영어 단어를 생성하는 도구 제공
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
// 상태관리를 위한 도구
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider: 상태관리
    return ChangeNotifierProvider(
      // create 속성: MyAppState(상태관리하는 클래스) 인스턴스를 생성
      create: (context) => MyAppState(),
      // MaterialApp: 애플리케이션 기본 구조 위젯
      child: MaterialApp(
        title: "Namer App",
        // 테마 설정
        theme: ThemeData(
          // Material3 디자인을 사용
          useMaterial3: true,
          // 기본색상을 deepOrange 사용
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// 상태관리 클래스 상속받음
class MyAppState extends ChangeNotifier {
  // 무작위 단어 생성
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    // MyAppState 를 보고 있는 곳으로 알림을 보냄
    notifyListeners();
  }

  // favorites: WordPair 객체를 저장하는 리스트(빈리스트로 초기화)
  var favorites = <WordPair>[];

  void toggleFavorite() {
    // favorites 리스트에 현재 항목이 있는지 확인
    if (favorites.contains(current)) {
      // 있으면 현재 항목 삭제
      favorites.remove(current);
    } else {
      // 없으면 현재 항목 추가
      favorites.add(current);
    }
    // 상태 변경시 알림(변경되면 UI 재빌드)
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  // createState() 메소드: _MyHomePageState() 를 생성하고 반환
  State<MyHomePage> createState() => _MyHomePageState();
}

// class MyHomePage extends StatelessWidget {
// State 클래스는 위젯의 상태를 관리, 상태 변경시 setState를 호출해서 UI 재빌드
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        print("a01");
        page = GeneratorPage();
        break;
      case 1:
        print("a02");
        // Placeholder 위젯: 교차 사각형 출력
        // page = Placeholder();
        page = FavoritesPage();
        break;
      default:
        // selectedIndex 에 해당하는 위젯이 없다고 예외 처리
        throw UnimplementedError("no widget for $selectedIndex");
    }
    // return Builder(builder: (context) {
    // LayoutBuilder: 기본적인 디자인 구조(앱바, 네비게이션바, 플로팅 액션 버튼)
    // context: 위젯의 위치 정보 포함
    // constraints: 크기와 배치를 결정
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        // 가로배치
        body: Row(
          children: [
            // SafeArea: 안전한 영역으로 화면의 가장자리에 위치(네비게이션 바, 상태 바)
            // NavigationRail 위젯: 화면의 좌측 또는 우측에 배치
            SafeArea(
                child: NavigationRail(
              // 너비가 600 픽셀 이상이면 extended가 참
              // 화면이 넓을 때는 텍스트 라벨과 함께 출력(좁을때는 아이콘만 출력)
              extended: constraints.maxWidth >= 600,
              // destinations 속성: 네비게이션 아이템들을 정의
              destinations: [
                // NavigationRailDestination: 개별 아이템들을 정의
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text("Home")),
                NavigationRailDestination(
                    icon: Icon(Icons.favorite), label: Text("Favorites")),
              ],
              // selectedIndex 속성: 현재 선택된 아이템의 인덱스 설정
              // selectedIndex: 0,
              selectedIndex: selectedIndex,
              // onDestinationSelected 속성: 아이템 선택했을 때 실행된다
              onDestinationSelected: (value) {
                // print("selected: $value");
                // setState 메소드: 상태관리하면서 상태 변경되면 UI 재빌드
                setState(() {
                  print("selected: $value");
                  // value는 onDestinationSelected 함수의 매개변수로서 선택된 인덱스 값
                  selectedIndex = value;
                });
              },
            )),
            // Expanded: 자식위젯이 남은 모든 공간을 차지
            Expanded(
              // Container 위젯: 꾸미기, 위치 지정, 크기 조정
              child: Container(
                // 테마 색상 중에서 주요 컨테이너 색상
                color: Theme.of(context).colorScheme.primaryContainer,
                // Container의 자식 위젯
                // child: GeneratorPage(),
                child: page,
              ),
            )
          ],
        ),
      );
    });
  }
}

// 상태가 없는 위젯
// class MyHomePage extends StatelessWidget {
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// watch 메소드: ChangeNotifier 로부터 상태를 읽고, 변경되면 UI 재빌드
// MyAppState의 현재 상태를 가져옴
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    // IconData: 아이콘 데이터 변수
    IconData icon;

    // appState.favorites 목록에 pair가 포함 여부에 따라 아이콘 설정
    if (appState.favorites.contains(pair)) {
      // 하트 아이콘으로 설정
      icon = Icons.favorite;
    } else {
      // 빈하트 아이콘으로 설정
      icon = Icons.favorite_border;
    }

    // 디자인 구조 (앱바, 네비게이션, 플로팅 액션 버튼)
    // return Scaffold(
    return Center(
      // 세로로 배치
      // body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text("A random idea:"),
          // 큰 카드 위젯 생성
          BigCard(pair: pair),
          SizedBox(
            height: 10,
          ),
          // Row: 가로 배치
          Row(
            // mainAxisSize: 주축 크기 설정
            // MainAxisSize.min: 최소 공간만큼 row 크기를 가짐
            mainAxisSize: MainAxisSize.min,
            children: [
              // 아이콘과 라벨이 있는 버튼 생성
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                // 위에서 받은 icon 으로 아이콘 출력
                icon: Icon(icon),
                label: Text("Like"),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text("Next")),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    // Theme.of(context): 현재 테마 정보
    final theme = Theme.of(context);
    // textTheme: 텍스트 스타일을 모음
    // displayMedium: 중간 크기 텍스트 스타일
    // copyWith: 기존 스타일을 복사한 후에 onPrimary 색상으로 변경
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      // theme.colorScheme.primary: 앱에서 정의하는 가장 두드러진 색상
      color: theme.colorScheme.primary,
      child: Padding(
        // padding: const EdgeInsets.all(20.0)
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
        ),
      ),
    );
  }
}

// 상태가 변경되지 않는 위젯
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text("No favorites yet."),
      );
    }
    // 스크롤 가능한 위젯
    return ListView(
      children: [
        // 모든 방향에 20 픽셀의 여백 설정
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text("You have ${appState.favorites.length} favorites: "),
        ),
        for (var pair in appState.favorites)
          // ListTile 위젯을 사용하여 좋아요 항목 출력
          ListTile(
            // 좋아요 아이콘을 앞에 추가
            leading: Icon(Icons.favorite),
            // pair 의 소문자로 출력
            title: Text(pair.asLowerCase),
          )
      ],
    );
  }
}
