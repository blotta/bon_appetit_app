import 'package:bon_appetit_app/providers/comanda.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void returnToMenu() {
      ref.read(comandaProvider.notifier).clear();
      Navigator.of(context).pop();
    }

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.task_alt, color: Colors.green, size: 100),
            const SizedBox(height: 24),
            const Text(
              'Pagamento realizado com sucesso!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: returnToMenu,

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
              ),
              child: const Text('CONTINUAR'),
            )
          ],
        ),
      ),
    );
  }
}
