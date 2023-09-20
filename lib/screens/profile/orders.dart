import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/screens/profile/order_details.dart';
import 'package:bon_appetit_app/services/bonappetit_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    navigateToOrderDetailsScreen(DOrder order) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => OrderDetailsScreen(order: order)));
    }

    Widget getOrderStatus(DOrder order) {
      return Text('Em andamento',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.amber.shade800));
      return Text('Finalizado',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.green));
      return Text('Cancelado',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.red.shade600));
    }

    int getTotalItenCount(List<DOrderProduct> itens) {
      return itens.fold(
          0, (previousValue, element) => previousValue + element.quantity);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: FutureBuilder<List<DOrder>>(
          future: BonAppetitApiService().getRestaurantOrders(restaurantId),
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
                    return Card(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () =>
                            navigateToOrderDetailsScreen(snapshot.data![index]),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "#${snapshot.data![index].number.toString()}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  getOrderStatus(snapshot.data![index])
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                      DateFormat('dd/MM/yyyy HH:mm').format(
                                          snapshot.data![index].createdAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: Colors.grey)),
                                  Column(
                                    children: [
                                      Text(
                                        "${getTotalItenCount(snapshot.data![index].itens)} itens",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "\$ ${snapshot.data![index].total.toStringAsFixed(2)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
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
