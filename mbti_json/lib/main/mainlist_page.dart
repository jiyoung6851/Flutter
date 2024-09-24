import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:mbti_json/sub/question_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 비동기 방식으로 String 타입 값을 반환
  // loadAsset() : json 파일을 비동기 방식으로 읽어서 문자열로 반환
  Future<String> loadAsset() async {
    // rootBundle 을 사용해서 리소스 폴더에 있는 json 파일을 읽어옴
    return await rootBundle.loadString("res/api/list.json");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          // future: 데이터를 가져옴
          future: loadAsset(),
          // 데이터를 가지고 UI 구성
          // snapshot: 비동기 작업 현재 상태와 데이터를 포함하는 객체
          builder: (context, snapshot) {
            // connectionState: future 의 현재 상태
            switch (snapshot.connectionState) {
              // 데이터 스트림이 활성 상태일때
              case ConnectionState.active:
                return const Center(
                  // CircularProgressIndicator: 빙글빙글 도는 로딩 위젯
                  child: CircularProgressIndicator(),
                );
              // 데이터 연산이 완료되었을때
              case ConnectionState.done:
                // snapshot.data 데이터를 json으로 디코딩해서 list 로 받음
                // ! 느낌표: null check 안하고 null 이 아닐것이다 가정하고 실행
                Map<String, dynamic> list = jsonDecode(snapshot.data!);
                return ListView.builder(
                  // itemBuilder: 어떤 View 를 그린다.
                  // value 번째 해당하는 항목을 그린다.
                  itemBuilder: (context, value) {
                    // InkWell: 사용자의 동작을 감지하는 위젯
                    return InkWell(
                      child: SizedBox(
                        height: 50,
                        child: Card(
                          child: Text(
                              list["questions"][value]["title"].toString()),
                        ),
                      ),
                      // 눌러질때 실행
                      onTap: () {
                        // Navigator.of(context).push => 새로운 페이지 이동
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return QuestionPage(
                              question:
                                  list["questions"][value]["file"].toString());
                        }));
                      },
                    );
                  },
                  itemCount: list["count"],
                );
              // 로드할 데이터가 없을때 no data 출력
              case ConnectionState.none:
                return const Center(
                  child: Text("No Data"),
                );
              // 데이터가 반환하지 않고 연산이 진행중일때
              case ConnectionState.waiting:
                return const Center(
                  // CircularProgressIndicator: 빙글빙글 도는 로딩 위젯
                  child: CircularProgressIndicator(),
                );
            }
          }),
    );
  }
}
