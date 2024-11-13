import 'package:flutter/material.dart';

class LectioDetailPage extends StatelessWidget {
  final String lectio;

  const LectioDetailPage({super.key, required this.lectio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Lectio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(lectio, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
