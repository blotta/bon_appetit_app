import 'package:bon_appetit_app/models/payment.dart';
import 'package:bon_appetit_app/providers/comanda.dart';
import 'package:bon_appetit_app/providers/menupreselect.dart';
import 'package:bon_appetit_app/screens/menu/creditcard.dart';
import 'package:bon_appetit_app/screens/menu/payment.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:bon_appetit_app/widgets/menu/order_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Purchase extends ConsumerWidget {
  const Purchase({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final orderItems = ref.watch(orderItemsProvider);
    final menuPreselect = ref.watch(menuPreselectProvider);
    final comanda = ref.watch(comandaProvider);

    void resetOrder() {
      // ref.read(orderItemsProvider.notifier).clear();
      ref.read(menuPreselectProvider.notifier).clear();
    }

    void makeOrder() async {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enviando pedido...')),
      );

      var orderNumber = await BonAppetitApiService().postMakeOrder(restaurantId, menuPreselect);

      var msg = "Erro ao realizar pedido";
      if (orderNumber >= 0) {
        ref.read(comandaProvider.notifier).addItems(menuPreselect);
        // ref.read(orderItemsProvider.notifier).clear();
        ref.read(menuPreselectProvider.notifier).clear();
        msg = "Pedido realizado!";
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }

    void makePayment() async {
      var creditCard = await Navigator.of(context).push<CreditCard?>(
          MaterialPageRoute(builder: (ctx) => CreditCardScreen()));

      if (creditCard != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => PaymentScreen()));
      }
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
              // orderItems: orderItems,
              orderItems: menuPreselect,
            ),
            const SizedBox(height: 20),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: menuPreselect.isEmpty ? null : resetOrder,
                    child: const Text('Remover Itens')),
                ElevatedButton(
                  onPressed: menuPreselect.isEmpty ? null : makeOrder,
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
