import 'package:flutter/material.dart';

class OneMinCoreScreen extends StatelessWidget {
  final String certId;
  const OneMinCoreScreen({super.key, required this.certId});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('1분 핵심')),
        body: const Center(child: Text('P2에서 구현')),
      );
}
