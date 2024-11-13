import 'package:flutter/material.dart';

class SaintsPage extends StatelessWidget {
  const SaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Santos del Día')),
      body: const Center(
        child: Text(
          'Información de Santos del Día aquí',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
