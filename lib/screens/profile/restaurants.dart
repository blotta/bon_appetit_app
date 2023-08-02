import 'package:bon_appetit_app/data/dummy_data.dart';
import 'package:bon_appetit_app/models/menu.dart';
import 'package:bon_appetit_app/screens/profile/restaurant_details.dart';
import 'package:bon_appetit_app/screens/profile/restaurant_edit.dart';
import 'package:flutter/material.dart';

class RestaurantsScreen extends StatelessWidget {
  const RestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    void navigateToRestaurantDetails(Restaurant r) {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => RestaurantDetailsScreen(restaurant: r)));
    } 

    void navigateToRestaurantEdit(Restaurant? r) {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => RestaurantEditScreen(restaurant: r)));
    } 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Meus Restaurantes'),
        actions: [
          IconButton(
            onPressed: () => navigateToRestaurantEdit(null),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: ListView.builder(
          itemCount: dataRestaurants.length,
          itemBuilder: (ctx, index) {
            return ListTile(
              onTap: () => navigateToRestaurantDetails(dataRestaurants[index]),
              title: Text(dataRestaurants[index].name),
              trailing: Icon(Icons.arrow_right_alt, size: 40),
            );
          },
        ),
      ),
    );
  }
}
