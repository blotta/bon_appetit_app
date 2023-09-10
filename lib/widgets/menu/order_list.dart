import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  const OrderList({super.key, required this.orderItems, required this.title});

  final String title;
  final List<DOrderItem> orderItems;

  double _getTotal() {
    return orderItems.fold(0.0, (previousValue, orderItem) {
      double val = orderItem.quantity * orderItem.item.price;
      return val + previousValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        for (final orderItem in orderItems)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(orderItem.item.name),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('${orderItem.quantity.toString()}x'),
                ),
                Text('\$ ${(orderItem.item.price).toStringAsFixed(2)}'),
              ],
            ),
          ),
        const Divider(thickness: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: Theme.of(context).textTheme.titleLarge),
            Text('\$ ${_getTotal().toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge)
          ],
        ),
      ],
    );
  }
}
