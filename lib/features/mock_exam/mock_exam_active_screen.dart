import 'package:flutter/material.dart';

class MockExamActiveScreen extends StatelessWidget {
  final String certId;
  const MockExamActiveScreen({super.key, required this.certId});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('모의고사 진행')),
        body: const Center(child: Text('P2에서 구현')),
      );
}
