import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final DOrder order;

  @override
  Widget build(BuildContext context) {
    Widget getOrderStatus(DOrder order) {
      return Text('Em andamento',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.amber.shade800));
      return Text('Finalizado',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.green));
      return Text('Cancelado',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.red.shade600));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido'),
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pedido #${order.number}",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(DateFormat("dd/MM/yyyy HH:mm").format(order.createdAt),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.grey)),
            const SizedBox(height: 12),
            getOrderStatus(order),
            const SizedBox(height: 24),
            Text("Itens",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            for (final orderItem in order.itens)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(orderItem.name),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('${orderItem.quantity.toString()}x'),
                    ),
                    Text('\$ ${(orderItem.price).toStringAsFixed(2)}'),
                  ],
                ),
              ),
            const Divider(thickness: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: Theme.of(context).textTheme.titleLarge),
                Text('\$ ${order.total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
