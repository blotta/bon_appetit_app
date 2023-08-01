import 'package:bon_appetit_app/data/dummy_data.dart';
import 'package:bon_appetit_app/models/menu.dart';
import 'package:bon_appetit_app/providers/order.dart';
import 'package:bon_appetit_app/screens/menu/item_details.dart';
import 'package:bon_appetit_app/screens/menu/purchase.dart';
import 'package:bon_appetit_app/widgets/menu/item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  Menu? _menu;
  MenuSection? _activeSection;

  void _selectSection(MenuSection section) {
    setState(() {
      _activeSection = section;
    });
  }

  void _selectItem(MenuItem item) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => ItemDetails(item: item)));
  }

  void _purchaseResume() {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => const Purchase()));
  }

  @override
  void initState() {
    super.initState();
    // ref.read(orderItemsProvider.notifier).clear();
    _menu = dataMenus.first;
    _activeSection = _menu!.sections.first;
  }

  @override
  Widget build(BuildContext context) {
    final orderItems = ref.watch(orderItemsProvider);

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.,
        title: Text(
          _menu!.name,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: [
          IconButton(
            onPressed: _purchaseResume,
            icon: const Icon(Icons.receipt, color: Colors.white,),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final section in _menu!.sections)
                  TextButton(
                    onPressed: () => _selectSection(section),
                    style: TextButton.styleFrom(
                      foregroundColor: _activeSection == section
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      backgroundColor: _activeSection == section
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.primaryContainer,
                      shape: const BeveledRectangleBorder(),
                      textStyle: const TextStyle(fontSize: 22),
                    ),
                    child: Text(section.name),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ItemList(
                items: _activeSection!.items,
                onSelectItem: _selectItem,
              ),
            ),
          )
        ],
      ),
    );
  }
}
