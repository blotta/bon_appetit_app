import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/providers/menupreselect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemDetails extends ConsumerWidget {
  const ItemDetails({super.key, required this.item});

  final DProduct item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(item.name),
      ),
      body: Column(
        children: [
          Image.network(
            item.imageUrl ?? Uri.https("placehold.co", "/600x400/png", { "text": item.name}).toString(),
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.name,
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('\$ ${item.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // ref.read(orderItemsProvider.notifier).addItem(item);
                    ref.read(menuPreselectProvider.notifier).addItem(item);

                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Item adicionado à lista de pedidos')),
                    );
                  },
                  child: const Text(
                    'Adicionar',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
