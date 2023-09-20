import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/providers/auth_provider.dart';
import 'package:bon_appetit_app/providers/comanda.dart';
import 'package:bon_appetit_app/providers/menupreselect.dart';
import 'package:bon_appetit_app/screens/menu/purchase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemDetails extends ConsumerWidget {
  const ItemDetails(
      {super.key, required this.restaurantId, required this.item});

  final String restaurantId;
  final DProduct item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var auth = ref.watch(authProvider);
    var comanda = ref.watch(comandaProvider);
    var menuPreselectItems = ref.watch(menuPreselectProvider);

    void navigateToPurchaseResume() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (ctx) => Purchase(restaurantId: restaurantId)));
    }

    var menuPreselectItemsCount = menuPreselectItems.fold(
        0, (previousValue, element) => previousValue + element.quantity);
    var comandaCount = comanda.items
        .fold(0, (previousValue, element) => previousValue + element.quantity);
    var itemCount =
        menuPreselectItemsCount > 0 ? menuPreselectItemsCount : comandaCount;

    List<Widget> appBarActions = [];
    if (auth.loggedIn) {
      appBarActions.add(
        Badge(
          label: Text(itemCount.toString()),
          isLabelVisible: itemCount > 0,
          alignment: Alignment.bottomLeft,
          backgroundColor: Colors.white,
          textColor: Theme.of(context).colorScheme.surface,
          child: IconButton(
            onPressed: navigateToPurchaseResume,
            icon: const Icon(
              Icons.receipt,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    addProductToMenuPreselect() {
      ref.read(menuPreselectProvider.notifier).addItem(item);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item adicionado à lista de pedidos')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(item.name),
        actions: appBarActions,
      ),
      body: Column(
        children: [
          Image.network(
            item.imageUrl ??
                Uri.https("placehold.co", "/600x400/png", {"text": item.name})
                    .toString(),
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
                  onPressed: auth.loggedIn ? addProductToMenuPreselect : null,
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
