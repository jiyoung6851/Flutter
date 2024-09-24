// hmain.dart 파일
import 'package:flutter/material.dart';

class HMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Text('This is the main page!'),
      ),
    );
  }
}
