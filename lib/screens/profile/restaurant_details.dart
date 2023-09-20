import 'package:bon_appetit_app/models/partner_models.dart';
import 'package:bon_appetit_app/screens/profile/menus.dart';
import 'package:bon_appetit_app/screens/profile/orders.dart';
import 'package:bon_appetit_app/screens/profile/restaurant_edit.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:bon_appetit_app/utils/info.dart';
import 'package:bon_appetit_app/utils/input.dart';
import 'package:flutter/material.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  PartnerRestaurant? _restaurant;
  bool restaurantEnable = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var r =
        await BonAppetitApiService().getPartnerRestaurant(widget.restaurantId);
    setState(() {
      _restaurant = r;
      restaurantEnable = r.enable;
    });
  }

  @override
  Widget build(BuildContext context) {
    void navigateToRestaurantEdit(PartnerRestaurant? r) async {
      var changed = await Navigator.of(context).push<bool>(MaterialPageRoute(
          builder: (ctx) => RestaurantEditScreen(restaurant: r)));
      if (changed != null && changed == true) {
        var r = await BonAppetitApiService()
            .getPartnerRestaurant(widget.restaurantId);
        setState(() {
          _restaurant = r;
        });
      }
    }

    void navigateToMenusScreen() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => MenusScreen(restaurantId: widget.restaurantId)));
    }

    void navigateToOrdersScreen() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => OrdersScreen(restaurantId: widget.restaurantId)));
    }

    Future<bool> toggleRestaurantActive(bool activating) async {
      bool success = false;
      setState(() {
        restaurantEnable = activating;
      });

      if (activating) {
        loadingDialog(context, "Ativando");
        success = await BonAppetitApiService()
            .patchPartnerActivate(widget.restaurantId);
      } else {
        loadingDialog(context, "Desativando");
        success = await BonAppetitApiService()
            .patchPartnerDeactivate(widget.restaurantId);
      }
      if (context.mounted) {
        Navigator.of(context).pop(); // loadingDialog

        if (!success) {
          showErrorSnackbar(context, "Não foi possível realizar a operação");
          setState(() {
            restaurantEnable = !restaurantEnable;
          });
        }
      }

      return success;
    }

    if (_restaurant == null) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.surface,
          backgroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurante'),
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => navigateToRestaurantEdit(_restaurant),
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nome',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      _restaurant!.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Switch(
                    value: restaurantEnable,
                    activeColor: Colors.green,
                    onChanged: toggleRestaurantActive,
                  ),
                  Text(
                    restaurantEnable ? 'ATIVO' : 'INATIVO',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 30),
          Text(
            'Especialidade',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            _restaurant!.specialty,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 30),
          Text(
            'Descrição',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            _restaurant!.description,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Cardápios'),
                  leading: Icon(Icons.menu_book,
                      color: Theme.of(context).colorScheme.surface),
                  trailing: const Icon(Icons.arrow_right_alt, size: 40),
                  onTap: navigateToMenusScreen,
                ),
                ListTile(
                  title: const Text('Pedidos'),
                  leading: Icon(Icons.fastfood,
                      color: Theme.of(context).colorScheme.surface),
                  trailing: const Icon(Icons.arrow_right_alt, size: 40),
                  onTap: navigateToOrdersScreen,
                ),
                // ListTile(
                //   title: const Text('Itens'),
                //   leading: Icon(Icons.fastfood,
                //       color: Theme.of(context).colorScheme.surface),
                //   trailing: const Icon(Icons.arrow_right_alt, size: 40),
                //   onTap: navigateToItemsScreen,
                // ),
                // ListTile(
                //   title: const Text('Atendentes'),
                //   leading: Icon(Icons.people,
                //       color: Theme.of(context).colorScheme.surface),
                //   trailing: const Icon(Icons.arrow_right_alt, size: 40),
                //   onTap: () => {},
                // ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
