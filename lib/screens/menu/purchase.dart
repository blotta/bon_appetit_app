import 'package:bon_appetit_app/providers/comanda.dart';
import 'package:bon_appetit_app/providers/order.dart';
import 'package:bon_appetit_app/screens/menu/payment.dart';
import 'package:bon_appetit_app/widgets/menu/order_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Purchase extends ConsumerWidget {
  const Purchase({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderItems = ref.watch(orderItemsProvider);
    final comanda = ref.watch(comandaProvider);

    void resetOrder() {
      ref.read(orderItemsProvider.notifier).clear();
    }

    void makeOrder() {
      ref.read(comandaProvider.notifier).addItems(orderItems);
      ref.read(orderItemsProvider.notifier).clear();

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido realizado!')),
      );
    }

    void makePayment() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => PaymentScreen()));
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Pedidos"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            OrderList(
              title: "Itens do Pedido",
              orderItems: orderItems,
            ),
            const SizedBox(height: 20),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: orderItems.isEmpty ? null : resetOrder,
                    child: const Text('Remover Itens')),
                ElevatedButton(
                  onPressed: orderItems.isEmpty ? null : makeOrder,
                  child: const Text(
                    'Adicionar à comanda',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))),
              padding: const EdgeInsets.all(8.0),
              child: OrderList(
                title: "Comanda",
                orderItems: comanda.items,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: makePayment,
                  child: const Text(
                    'PAGAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
