import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/screens/profile/menu_edit.dart';
import 'package:bon_appetit_app/screens/profile/menu_new.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:flutter/material.dart';

class MenusScreen extends StatelessWidget {
  const MenusScreen({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    void navigateToMenuEdit(DMenu menu) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => MenuEditScreen(menu: menu)));
    }

    void navigateToMenuNew() async {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => MenuNewScreen(restaurantId: restaurantId)));
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Colors.white,
        title: const Text('Cardápios'),
        actions: [
          IconButton(
              onPressed: navigateToMenuNew,
              icon: const Icon(Icons.add))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: FutureBuilder<List<DMenu>>(
          future: BonAppetitApiService().getPartnerMenus(restaurantId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Erro ao carregar cardápios"),
              );
            }

            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("Não há cardápios para este restaurante"),
                );
              }
              return ListView.builder(
                  // shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        onTap: () => navigateToMenuEdit(snapshot.data![index]),
                        title: Text(snapshot.data![index].name),
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
