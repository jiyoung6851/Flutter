import 'package:flutter/material.dart';

void main() {
  // runApp(const MyApp());
  // MaterialApp : 애플리케이션의 전반적인 설정을 하는 위젯
  runApp(const MaterialApp(
    title: "Shopping App",
    // 시작될떄 출력되는 위젯
    home: ShoppingList(
        // 세가지 제품이 리스트로 전달
        products: [
          // 제품이름
          Product(name: "Eggs"),
          Product(name: "Flour"),
          Product(name: "Chocolate chips"),
        ]),
  ));
}

class Product {
  const Product({required this.name});
  final String name;
}

// 상태를 변경할수 있고, 변경되면 UI가 재빌드
class ShoppingList extends StatefulWidget {
  const ShoppingList({required this.products, super.key});
  // 제품들 리스트
  final List<Product> products;

  @override
  // createState() 메소드는 _ShoppingListState() 라는 상태 객체를 반환
  State<StatefulWidget> createState() => _ShoppingListState(); // 람다식
}

// _밑줄은 이 파일내에서만 사용되는 비공개 클래스(private)
// State<ShoppingList>: ShoppingList 상태를 관리
class _ShoppingListState extends State<ShoppingList> {
  // Product 타입의 집합(Set)
  final _shoppingCart = <Product>{};

  // 장바구니 상태 관리
  void _handleCartChanged(Product product, bool inCart) {
    // 상태를 변경하고, 변경된 상태를 UI로 재빌드
    setState(() {
      if (!inCart) {
        // 제품을 장바구니에 추가
        _shoppingCart.add(product);
      } else {
        // 제품을 장바구니에서 제거
        _shoppingCart.remove(product);
      }
    });
  }

  @override
  // 위젯의 UI를 구성
  Widget build(BuildContext context) {
    // 기본적인 구조와 시각적인 요소를 제공하는 위젯
    return Scaffold(
      // AppBar: 상단의 제목 표시줄을 정의
      appBar: AppBar(
        title: const Text("Shopping List"),
      ),
      // 스크롤 가능한 리스트를 출력하는 위젯
      body: ListView(
        // 위아래 8픽셀 패딩을 추가
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: widget.products.map((product) {
          return ShoppingListItem(
            // 현재 제품을 ShoppingListItem에 전달
            product: product,
            // 장바구니에 있는지 여부
            inCart: _shoppingCart.contains(product),
            // 장바구니 상태가 변경될 때 호출
            onCartChanged: _handleCartChanged,
          );
          // 제품리스트를 반복해서 제품에 대한 ShoppingListItem 위젯을 생성
        }).toList(),
      ),
    );
  }
}

// CartChangedCallback 함수: Product 객체와 bool 값을 매개변수로 가짐
// 제품이 장바구니에 있는지 여부를 변경할때 사용
typedef CartChangedCallback = Function(Product product, bool inCart);

// 상태가 없는 위젯으로 쇼핑리스트 개별 항목
class ShoppingListItem extends StatelessWidget {
  final Product product; //제품
  final bool inCart; //장바구니에 있는지 여부
  final CartChangedCallback onCartChanged; //장바구니 상태변경때 호출

  Color _getColor(BuildContext context) {
    return inCart
        // 장바구니에 있으면 검정색
        ? Colors.black54
        // 장바구니에 없으면 현재 테마의 기본색상
        : Theme.of(context).primaryColor;
  }

  // ?물음표 : null 을 반환할 수 있음 (Dart 문법)
  TextStyle? _getTextStyle(BuildContext context) {
    // 장바구니에 없으면 null 반환
    if (!inCart) return null;

    return const TextStyle(
        // 색상이 검정색
        color: Colors.black54,
        // TextDecoration.lineThrough : 텍스트에 취소선
        decoration: TextDecoration.lineThrough);
  }

  ShoppingListItem({
    required this.product,
    required this.inCart,
    required this.onCartChanged,
    // 부모 클래스인 StatelessWidget의 생성자를 호출
    // ObjectKey: 제품 객체에 고유한 키를 부여해서 리스트 항목을 식별
  }) : super(key: ObjectKey(product));

  @override
  Widget build(BuildContext context) {
    // 목록 항목을 출력하는 위젯
    return ListTile(
      // 탭할때 호출
      onTap: () {
        // 제품이 장바구니에 있는지 상태를 변경
        onCartChanged(product, inCart);
      },
      // leading: ListTile 시작 부분에 출력
      // CircleAvatar: 원형 아바타를 출력
      leading: CircleAvatar(
        // 아바타의 색상
        backgroundColor: _getColor(context),
        // 제품이름의 첫글자를 원형 아바타에 출력
        child: Text(product.name[0]),
      ),
      // title: ListTitle의 중앙에 텍스트 위젯으로 출력
      title: Text(
        // 제품 이름
        product.name,
        // 장바구니 상태에 따라서 스타일(취소선 여부) 적용
        style: _getTextStyle(context),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
