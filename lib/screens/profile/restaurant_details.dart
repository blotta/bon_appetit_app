import 'package:bon_appetit_app/models/menu.dart';
import 'package:bon_appetit_app/screens/profile/menus.dart';
import 'package:bon_appetit_app/screens/profile/restaurant_edit.dart';
import 'package:flutter/material.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  const RestaurantDetailsScreen({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    void navigateToRestaurantEdit(Restaurant? r) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => RestaurantEditScreen(restaurant: r)));
    }

    void navigateToMenusScreen() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => const MenusScreen()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurante'),
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => navigateToRestaurantEdit(restaurant),
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Nome',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            restaurant.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 30),
          Text(
            'Endereço',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            restaurant.address,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Cardápios'),
                  leading: const Icon(Icons.menu_book),
                  trailing: const Icon(Icons.arrow_right_alt, size: 40),
                  onTap: navigateToMenusScreen,
                ),
                ListTile(
                  title: const Text('Itens'),
                  leading: const Icon(Icons.fastfood),
                  trailing: const Icon(Icons.arrow_right_alt, size: 40),
                  onTap: () => {},
                ),
                ListTile(
                  title: const Text('Atendentes'),
                  leading: const Icon(Icons.people),
                  trailing: const Icon(Icons.arrow_right_alt, size: 40),
                  onTap: () => {},
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
