import 'package:bon_appetit_app/models/menu.dart';
import 'package:bon_appetit_app/widgets/menu/item.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key, required this.items, required this.onSelectItem});

  final List<MenuItem> items;

  final Function(MenuItem item) onSelectItem;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        return Item(
          item: items[index],
          onSelectItem: onSelectItem,
        );
      },
    );
  }
}
