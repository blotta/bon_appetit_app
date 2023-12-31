import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/providers/auth_provider.dart';
import 'package:bon_appetit_app/providers/menupreselect.dart';
import 'package:bon_appetit_app/screens/menu/item_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

class Item extends ConsumerWidget {
  const Item({super.key, required this.item, required this.restaurantId});

  final String restaurantId;
  final DProduct item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var auth = ref.watch(authProvider);

    navigateToItemDetails() {
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => ItemDetails(restaurantId: restaurantId, item: item)));
    }

    addProductToMenuPreselect() {
      ref.read(menuPreselectProvider.notifier).addItem(item);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item adicionado à lista de pedidos')),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: navigateToItemDetails,
        child: Column(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(item.imageUrl ??
                  Uri.https("placehold.co", "/600x400/png", {"text": item.name})
                      .toString()),
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
                  onPressed: auth.loggedIn ? addProductToMenuPreselect : null,
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
