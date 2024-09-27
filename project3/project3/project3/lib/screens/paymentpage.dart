import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project3/models/product.dart';
import 'package:flutter/foundation.dart';

import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/stat_item.dart';
import 'package:bootpay/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final Product product;

  PaymentPage({super.key, required this.product});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final NumberFormat numberFormat = NumberFormat('###,###,###,###');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결제 페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 1. 주문자 정보
              const Text(
                '1. 주문자 정보',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7F50),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '이름',
                  labelStyle: TextStyle(fontSize: 25), // 라벨 텍스트 크기 설정
                ),
                style: const TextStyle(fontSize: 25), // 입력 필드 텍스트 크기 설정
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: '전화번호',
                  labelStyle: TextStyle(fontSize: 25), // 라벨 텍스트 크기 설정
                ),
                style: const TextStyle(fontSize: 25), // 입력 필드 텍스트 크기 설정
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '전화번호를 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: '주소',
                  labelStyle: TextStyle(fontSize: 25), // 라벨 텍스트 크기 설정
                ),
                style: const TextStyle(fontSize: 25), // 입력 필드 텍스트 크기 설정
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '주소를 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              // 2. 주문 내역
              const Text(
                '2. 주문 내역',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7F50),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${widget.product.productName}', // 상품 이름 자동 입력
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 40),
              // 3. 결제 금액
              const Text(
                '3. 결제 금액',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7F50),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${numberFormat.format(widget.product.price)}원', // 가격 표시
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 40),
              // 4. 결제 방법
              const Text(
                '4. 결제 방법',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF7F50),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 마일리지 결제 버튼
                    },
                    child: const Text('마일리지 결제'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentRoute(product: widget.product),
                        ),
                      );
                    },
                    child: const Text('신용/체크카드 결제'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

class PaymentRoute extends StatefulWidget {
  final Product product;

  PaymentRoute({required this.product});

  _PaymentRouteState createState() => _PaymentRouteState();
}

class _PaymentRouteState extends State<PaymentRoute> {
  Payload payload = Payload();
  String _data = ""; // 서버승인을 위해 사용되기 위한 변수

  String get applicationId {
    return Bootpay().applicationId('5b8f6a4d396fa665fdc2b5e7',
        '5b8f6a4d396fa665fdc2b5e8', '5b8f6a4d396fa665fdc2b5e9');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bootpayAnalyticsUserTrace(); //통계용 함수 호출
    bootpayAnalyticsPageTrace(); //통계용 함수 호출
    bootpayRequestDataInit(); //결제용 데이터 init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Container(
          child: Center(
              child: TextButton(
            onPressed: () => goBootpayTest(context),
            child: Text('부트페이로 결제하기'),
          )),
        );
      }),
    );
  }

  //통계용 함수
  bootpayAnalyticsUserTrace() async {
    String? ver;
    if (kIsWeb)
      ver =
          '1.0'; //web 일 경우 버전 지정, 웹이 아닌 android, ios일 경우 package_info 통해 자동으로 생성

    await Bootpay().userTrace(
        id: 'user_1234',
        email: 'user1234@gmail.com',
        gender: -1,
        birth: '19941014',
        area: '서울',
        applicationId: applicationId,);
  }

  //통계용 함수
  bootpayAnalyticsPageTrace() async {
    String? ver;
    if (kIsWeb)
      ver =
          '1.0'; //web 일 경우 버전 지정, 웹이 아닌 android, ios일 경우 package_info 통해 자동으로 생성

    StatItem item1 = StatItem();
    item1.itemName = "미키 마우스"; // 주문정보에 담길 상품명
    item1.unique = "ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
    item1.price = 500; // 상품의 가격
    item1.cat1 = '컴퓨터';
    item1.cat2 = '주변기기';

    // StatItem item2 = StatItem();
    // item2.itemName = "키보드"; // 주문정보에 담길 상품명
    // item2.unique = "ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
    // item2.price = 500; // 상품의 가격
    // item2.cat1 = '컴퓨터';
    // item2.cat2 = '주변기기';

    List<StatItem> items = [item1];

    await Bootpay().pageTrace(
        url: 'main_1234',
        pageType: 'sub_page_1234',
        applicationId: applicationId,
        userId: 'user_1234',
        items: items,);
  }

  //결제용 데이터 init
  bootpayRequestDataInit() {
    Item item1 = Item();
    item1.id = "ITEM_CODE_BOOK";
    item1.name = widget.product.productName; // Product 객체의 상품명 사용
    item1.qty = 1;
    item1.price = widget.product.price!.toDouble(); // Product 객체의 가격 사용

    payload.webApplicationId = '5b8f6a4d396fa665fdc2b5e7';
    payload.androidApplicationId = '5b8f6a4d396fa665fdc2b5e8';
    payload.iosApplicationId = '5b8f6a4d396fa665fdc2b5e9';

    payload.pg = 'danal';
    payload.method = 'card';
    payload.orderName = widget.product.productName; // Product 객체의 상품명 사용
    payload.price = widget.product.price!.toDouble(); // Product 객체의 가격 사용
    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();
    payload.items = [item1];

    // 주문자 정보
    User user = User();
    user.username = "사용자 이름"; // 고정된 사용자 이름
    user.email = "user1234@gmail.com"; // 고정된 이메일
    user.area = "서울"; // 고정된 지역
    user.phone = "010-4033-4678"; // 고정된 전화번호
    user.addr = '서울시 동작구 상도로 222'; // 고정된 주소

    Extra extra = Extra();
    extra.appScheme = 'bootpayFlutterExample';

    payload.user = user;
    payload.extra = extra;
  }

  //버튼클릭시 부트페이 결제요청 실행
  void goBootpayTest(BuildContext context) {
    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      // closeButton: Icon(Icons.close, size: 35.0, color: Colors.black54),
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onCancel: $data');
      },
      onClose: () {
        print('------- onClose');
        Bootpay().dismiss(context); //명시적으로 부트페이 뷰 종료 호출
        //TODO - 원하시는 라우터로 페이지 이동
      },
      // onCloseHardware: () {
      //   print('------- onCloseHardware');
      // },
      // onReady: (String data) {
      //   print('------- onReady: $data');
      // },
      onConfirm: (String data) {
        /**
        1. 바로 승인하고자 할 때
        return true;
        **/
        /***
        2. 비동기 승인 하고자 할 때
        checkQtyFromServer(data);
        return false;
        ***/
        /***
        3. 서버승인을 하고자 하실 때 (클라이언트 승인 X)
        return false; 후에 서버에서 결제승인 수행
         */
        checkQtyFromServer(data);
        return false;
      },
      onDone: (String data) {
        print('------- onDone: $data');
      },
    );
  }

  Future<void> checkQtyFromServer(String data) async {
    //TODO 서버로부터 재고파악을 한다
    print('checkQtyFromServer http call');

    //재고파악 후 결제를 승인한다. 아래 함수를 호출하지 않으면 결제를 승인하지 않게된다.
    Bootpay().transactionConfirm();
  }
}
