import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  // 질문 텍스트
  final String question;
  // 답변 텍스트
  final String answer;

  const DetailPage({super.key, required this.question, required this.answer});

  @override
  State<DetailPage
  > createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          // MainAxisAlignment.center => 세로축에서 중앙 정렬
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 질문내용을 출력
            Text(widget.question),
            // 답변내용을 출력
            Text(widget.answer),
            ElevatedButton(
                onPressed: () {
                  // 버튼 누르면 현재 페이지 닫고 이전페이지로 돌아감
                  Navigator.of(context).pop();
                },
                // 버튼의 텍스트로 출력
                child: const Text("돌아가기"))
          ],
        ),
      ),
    );
  }
}
