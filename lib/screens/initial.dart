import 'package:flutter/material.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/bonappetit_logo.png'),
          const SizedBox(height: 24),
          const Text('Leia o QR code para visualizar o cardápio'),
        ],
      ),
    );
  }
}
