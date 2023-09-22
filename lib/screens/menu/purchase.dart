import 'package:bon_appetit_app/models/payment.dart';
import 'package:bon_appetit_app/providers/auth_provider.dart';
import 'package:bon_appetit_app/providers/comanda.dart';
import 'package:bon_appetit_app/providers/menupreselect.dart';
import 'package:bon_appetit_app/screens/menu/creditcard.dart';
import 'package:bon_appetit_app/screens/menu/payment.dart';
import 'package:bon_appetit_app/screens/menu/payment_process.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:bon_appetit_app/utils/info.dart';
import 'package:bon_appetit_app/widgets/menu/order_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Purchase extends ConsumerStatefulWidget {
  const Purchase({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PurchaseState();
}

class _PurchaseState extends ConsumerState<Purchase> {

  @override
  Widget build(BuildContext context) {
    final menuPreselect = ref.watch(menuPreselectProvider);
    final comanda = ref.watch(comandaProvider);

    void resetOrder() {
      ref.read(menuPreselectProvider.notifier).clear();
    }

    void makeOrder() async {
      showInfoSnackbar(context, "Enviando pedido...");

      var orderNumber = await BonAppetitApiService().postMakeOrder(
          widget.restaurantId, menuPreselect,
          token: ref.read(authProvider).token);

      if (orderNumber >= 0) {
        ref.read(comandaProvider.notifier).addItems(orderNumber, menuPreselect);
        ref.read(menuPreselectProvider.notifier).clear();
        if (context.mounted) {
          showInfoSnackbar(context, "Pedido realizado!");
        }
        return;
      }

      if (context.mounted) {
        showErrorSnackbar(context, "Erro ao realizar o pedido");
      }
    }

    void makePayment() async {
      var creditCard = await Navigator.of(context).push<CreditCard?>(
          MaterialPageRoute(builder: (ctx) => const CreditCardScreen()));

      if (creditCard != null) {
        if (context.mounted) {
          var ok = await Navigator.of(context).push<bool>(MaterialPageRoute(
              builder: (ctx) => PaymentProcessScreen(
                  orderNumber: comanda.number!, creditCard: creditCard)));

          if (ok ?? false) {
            ref.read(comandaProvider.notifier).clear();
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => const PaymentScreen()));
              return;
            }
          }
          if (context.mounted) {
            showErrorSnackbar(context, "Erro no pagamento");
          }
        }
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
                title: comanda.number != null
                    ? "Comanda #${comanda.number}"
                    : "Comanda",
                orderItems: comanda.items,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: comanda.items.isNotEmpty ? makePayment : null,
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
