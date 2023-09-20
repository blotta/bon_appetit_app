import 'package:bon_appetit_app/models/partner_models.dart';
import 'package:bon_appetit_app/screens/profile/restaurant_details.dart';
import 'package:bon_appetit_app/screens/profile/restaurant_edit.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:flutter/material.dart';

class RestaurantsScreen extends StatelessWidget {
  const RestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToRestaurantDetails(String restaurantId) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => RestaurantDetailsScreen(restaurantId: restaurantId)));
    }

    void navigateToRestaurantEdit() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => const RestaurantEditScreen(restaurant: null)));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Meus Restaurantes'),
        actions: [
          IconButton(
            onPressed: () => navigateToRestaurantEdit(),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: FutureBuilder<List<BriefPartnerRestaurant>>(
          future: BonAppetitApiService().getPartnerRestaurants(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Erro ao carregar restaurantes"),
              );
            }

            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        onTap: () =>
                            navigateToRestaurantDetails(snapshot.data![index].id),
                        title: Text(snapshot.data![index].title),
                        trailing: const Icon(Icons.arrow_right_alt, size: 40));
                  });
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
