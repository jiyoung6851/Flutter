import 'package:flutter/material.dart';

class LivingSuppliesPage extends StatelessWidget {
  const LivingSuppliesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('생활용품'),
      ),
      body: const Center(
        child: Text('생활용품 관련 내용'),
      ),
    );
  }
}
