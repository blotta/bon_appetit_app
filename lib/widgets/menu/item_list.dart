import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/widgets/menu/item.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key, required this.restaurantId, required this.items});

  final String restaurantId;
  final List<DProduct> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'Sem itens nesta seção',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        return Item(
          restaurantId: restaurantId,
          item: items[index],
        );
      },
    );
  }
}
