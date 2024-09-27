// import 'package:bootpay/bootpay.dart';
// import 'package:bootpay/model/extra.dart';
// import 'package:bootpay/model/item.dart';
// import 'package:bootpay/model/payload.dart';
// import 'package:bootpay/model/stat_item.dart';
// import 'package:bootpay/model/user.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// class SecondRoute extends StatefulWidget {
//   _SecondRouteState createState() => _SecondRouteState();
// }
//
// class _SecondRouteState extends State<SecondRoute> {
//   Payload payload = Payload();
//   String _data = "";
//
//   String get applicationId {
//     return Bootpay().applicationId(
//         '5b8f6a4d396fa665fdc2b5e7',
//         '5b8f6a4d396fa665fdc2b5e8',
//         '5b8f6a4d396fa665fdc2b5e9'
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     bootpayAnalyticsUserTrace();
//     bootpayAnalyticsPageTrace();
//     bootpayRequestDataInit(); // 함수명 수정
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: TextButton(
//             onPressed: () => goBootpayTest(context),
//             child: Text('부트페이 결제 테스트'),
//           )
//       ),
//     );
//   }
//
//   // 사용자 통계용 함수
//   bootpayAnalyticsUserTrace() async {
//     String? ver;
//     if (kIsWeb) ver = '1.0';
//     await Bootpay().userTrace(
//       id: 'user_1234',
//       email: 'user1234@gmail.com',
//       gender: -1,
//       birth: '19941014',
//       area: '서울',
//       applicationId: applicationId,
//     );
//   }
//
//   // 페이지 통계용 함수
//   bootpayAnalyticsPageTrace() async {
//     String? ver;
//     if (kIsWeb) ver = '1.0';
//
//     StatItem item1 = StatItem();
//     item1.itemName = "미키 마우스";
//     item1.unique = "ITEM_CODE_MOUSE";
//     item1.price = 500;
//     item1.cat1 = '컴퓨터';
//     item1.cat2 = '주변기기';
//
//     StatItem item2 = StatItem();
//     item2.itemName = "키보드";
//     item2.unique = "ITEM_CODE_KEYBOARD";
//     item2.price = 500;
//     item2.cat1 = '컴퓨터';
//     item2.cat2 = '주변기기';
//
//     await Bootpay().pageTrace(
//       url: 'main_1234',
//       pageType: 'sub_page_1234',
//       applicationId: applicationId,
//       userId: 'user_1234',
//       items: [item1, item2],
//     );
//   }
//
//   // 결제용 데이터 초기화 함수
//   bootpayRequestDataInit() {
//     Item item1 = Item();
//     item1.id="ITEM_CODE_MOUSE";
//     item1.name = "미키 마우스";
//     item1.qty = 1;
//     item1.price = 50;
//
//     Item item2 = Item();
//     item2.id="ITEM_CODE_KEYBOARD";
//     item2.name = "키보드";
//     item2.qty = 1;
//     item2.price = 50;
//
//     payload.webApplicationId = '5b8f6a4d396fa665fdc2b5e7';
//     payload.androidApplicationId = '5b8f6a4d396fa665fdc2b5e8';
//     payload.iosApplicationId = '5b8f6a4d396fa665fdc2b5e9';
//
//     payload.pg = 'danal';
//     payload.method = 'card';
//     payload.orderName = "project3 테스트 상품";
//     payload.price = 100.0;
//     payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();
//     payload.items = [item1, item2];
//
//     User user = User();
//     user.username = "사용자 이름";
//     user.email = "user1234@gmail.com";
//     user.area = "서울";
//     user.phone = "010-4033-4678";
//     user.addr = '서울시 동작구 상도로 222';
//
//     Extra extra = Extra();
//     extra.appScheme = 'bootpayFlutterExample';
//     // extra.quota = '0,2,3';
//     // extra.popup = 1;
//     // extra.quickPopup = 1;
//
//     payload.user = user;
//     payload.extra = extra;
//   }
//
//   // 재고 확인 후 결제 승인 함수
//   Future<void> checkQtyFromServer(String data) async {
//     print('checkQtyFromServer http call');
//     Bootpay().transactionConfirm();
//   }
//
//   // 부트페이 결제 실행 함수
//   void goBootpayTest(BuildContext context) {
//     Bootpay().requestPayment(
//       context: context,
//       payload: payload,
//       showCloseButton: false,
//       onCancel: (String data) {
//         print('------- onCancel: $data');
//       },
//       onError: (String data) {
//         print('------- onError: $data');
//       },
//       onClose: () {
//         print('------- onClose');
//         Bootpay().dismiss(context); // 명시적으로 부트페이 뷰 종료 호출
//       },
//       onConfirm: (String data) {
//         checkQtyFromServer(data);
//         return false;
//       },
//       onDone: (String data) {
//         print('------- onDone: $data');
//       },
//     );
//   }