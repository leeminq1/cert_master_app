import 'package:flutter/material.dart';

class MockExamSetupScreen extends StatelessWidget {
  final String certId;
  const MockExamSetupScreen({super.key, required this.certId});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('모의고사')),
        body: const Center(child: Text('P2에서 구현')),
      );
}
