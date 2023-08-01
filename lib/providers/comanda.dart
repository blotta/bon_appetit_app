import 'package:bon_appetit_app/models/comanda.dart';
import 'package:bon_appetit_app/models/menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComandaNotifier extends StateNotifier<Comanda> {
  ComandaNotifier() : super(Comanda([]));

  void clear() {
    state = Comanda([]);
  }

  void addItems(List<OrderItem> items) {
    List<OrderItem> currItems = [...state.items];

    for (final newItem in items) {
      if (currItems.any((i) => i.item.name == newItem.item.name)) {
        currItems.firstWhere((i) => i.item.name == newItem.item.name).quantity += newItem.quantity;
      } else {
        currItems.add(newItem);
      }
    }

    var newComanda = Comanda(currItems);
    state = newComanda;
  }
}

final comandaProvider =
    StateNotifierProvider<ComandaNotifier, Comanda>(
        (ref) => ComandaNotifier());
