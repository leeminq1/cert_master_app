import 'package:flutter/material.dart';

class MockExamResultScreen extends StatelessWidget {
  final String certId;
  const MockExamResultScreen({super.key, required this.certId});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('모의고사 결과')),
        body: const Center(child: Text('P2에서 구현')),
      );
}
