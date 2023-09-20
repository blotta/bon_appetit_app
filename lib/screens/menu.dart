import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/screens/menu/item_details.dart';
import 'package:bon_appetit_app/screens/menu/purchase.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:bon_appetit_app/widgets/menu/item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  DMenu? _menu;
  DMenuSection? _activeSection;

  DiscoveryRestaurant? _restaurant;

  void _selectSection(DMenuSection section) {
    setState(() {
      _activeSection = section;
    });
  }

  void _selectItem(DProduct item) {
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => ItemDetails(item: item)));
  }

  void _purchaseResume() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => Purchase(restaurantId: widget.restaurantId)));
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    var r = await BonAppetitApiService()
        .getDiscoveryRestaurant(widget.restaurantId);
    setState(() {
      _restaurant = r;
      _menu = _restaurant!.menu;
      _activeSection = (_menu == null || _menu!.sections.isEmpty) ? null : _menu?.sections.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_restaurant == null) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            "Carregando",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_menu == null || _activeSection == null) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            _menu?.name ?? _restaurant!.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        body: const Center(
          child: Text('Este cardápio não contém itens para visualizar'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
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
            icon: const Icon(
              Icons.receipt,
              color: Colors.white,
            ),
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
                items: _activeSection!.products,
                onSelectItem: _selectItem,
              ),
            ),
          )
        ],
      ),
    );
  }
}
