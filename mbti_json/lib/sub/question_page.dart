import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:mbti_json/detail/detail_page.dart';

class QuestionPage extends StatefulWidget {
  final String question;
  const QuestionPage({super.key, required this.question});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  String title = "";
  int selectNumber = -1;

  Future<String> loadAsset(String fileName) async {
    return rootBundle.loadString("res/api/$fileName.json");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // future: 데이터를 가져옴
        future: loadAsset(widget.question),
        // 데이터를 가지고 UI 구성
        // snapshot: 비동기 작업 현재 상태와 데이터를 포함하는 객체
        builder: (context, snapshot) {
          // 데이터가 아직 로드되지 않은 상태
          if (snapshot.hasData == false) {
            return const CircularProgressIndicator();
            // 데이터가 로드 중 오류 발생시
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            );
            // 데이터가 성공적으로 로드되면
          } else {
            Map<String, dynamic> questions = jsonDecode(snapshot.data!);
            title = questions["title"].toString();
            List<Widget> widgets;

            // 질문 항목을 담은 위젯 리스트
            widgets = List<Widget>.generate(
                (questions["selects"] as List<dynamic>).length,
                (int index) => SizedBox(
                      height: 100,
                      child: Column(
                        children: [
                          Text(questions["selects"][index]),
                          Radio(
                              // value: 라디오버튼이 나타내는 값
                              value: index,
                              // groupValue: 현재 선택된 버튼의 값
                              groupValue: selectNumber,
                              // onChanged: 라디오버튼 선택했을때 호출
                              // value: 사용자가 선택한 라디오버튼의 값
                              onChanged: (value) {
                                setState(() {
                                  // 선택된 항목을 selectNumber에 저장
                                  selectNumber = index;
                                });
                              })
                        ],
                      ),
                    ));
            return Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              body: Column(
                children: [
                  // 질문텍스트를 출력
                  Text(questions["question"].toString()),
                  Expanded(
                      child: ListView.builder(
                          itemCount: widgets.length,
                          itemBuilder: (context, index) {
                            final item = widgets[index];
                            return item;
                          })),
                  selectNumber == -1
                      // 선택항목이 없을때 버튼 표시 안함
                      ? Container()
                      : ElevatedButton(
                          onPressed: () {
                            // Navigator.of(context).pushReplacement : 버튼을 누르면 이동
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              // 리턴되는 페이지로 이동
                              return DetailPage(
                                  // 선택된 항목의 데이터를 전달
                                  question: questions["question"],
                                  answer: questions["answer"][selectNumber]);
                            }));
                          },
                          child: const Text("성격 보기"))
                ],
              ),
            );
          }
        });
  }
}
