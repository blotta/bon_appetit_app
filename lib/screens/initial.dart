import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/screens/menu.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:bon_appetit_app/widgets/initial/restaurant_list_item.dart';
import 'package:flutter/material.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  Future<List<DiscoveryRestaurant>> _getRestaurants() async {
    var restaurants = await BonAppetitApiService().getDiscoveryRestaurants();
    return restaurants;
  }

  void _selectRestaurant(String restaurantId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => MenuScreen(restaurantId: restaurantId)));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Image.asset('images/bonappetit_logo.png'),
          const SizedBox(height: 24),
          const Text(
            'Leia o QR code para visualizar o cardápio ou escolha um restaurante da lista abaixo',
            // 'Leia o QR code para visualizar o cardápio',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Restaurantes Disponíveis',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DiscoveryRestaurant>>(
              future: _getRestaurants(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Erro ao carregar restaurantes",
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 20),
                        IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: const Icon(Icons.refresh, size: 40),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return RefreshIndicator(
                    onRefresh: () {
                      return Future(() {
                        setState(() {});
                      });
                    },
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RestaurantListItem(
                                restaurant: snapshot.data![index],
                                onSelectRestaurant: _selectRestaurant),
                          );
                        }),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
