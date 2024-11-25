import 'package:flutter/material.dart';

class SaintsPage extends StatelessWidget {
  const SaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Información de Santos del Día aquí',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
