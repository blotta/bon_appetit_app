import 'package:bon_appetit_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:bon_appetit_app/models/menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

class Item extends ConsumerWidget {
  const Item({super.key, required this.item, required this.onSelectItem});

  final MenuItem item;
  final Function(MenuItem item) onSelectItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () => onSelectItem(item),
        child: Column(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              color: Colors.white,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.name,
                        style: Theme.of(context).textTheme.titleLarge!),
                    Text('\$ ${item.price.toStringAsFixed(2)}'),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    ref.read(orderItemsProvider.notifier).addItem(item);

                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Item adicionado à lista de pedidos')),
                    );
                  },
                  child: const Text('Adicionar'),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
