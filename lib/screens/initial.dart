
import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:flutter/material.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Image.asset('images/bonappetit_logo.png'),
          const SizedBox(height: 24),
          const Text(
            'Leia o QR code para visualizar o cardápio ou escolha um restaurante disponível da lista abaixo',
            // 'Leia o QR code para visualizar o cardápio',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Restaurantes Disponíveis',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          FutureBuilder<List<DiscoveryRestaurant>>(
            future: BonAppetitApiService().getDiscoveryRestaurants(),
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
                        onTap: () {
                          
                        },
                        title: Text(snapshot.data![index].title),
                        subtitle: Text(snapshot.data![index].description),
                      );
                    });
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ],
      ),
    );
  }
}
