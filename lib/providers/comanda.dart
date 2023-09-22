import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComandaNotifier extends StateNotifier<DComanda> {
  ComandaNotifier() : super(DComanda(null, []));

  void clear() {
    state = DComanda(null, []);
  }

  void addItems(int? orderNumber, List<DOrderItem> items) {
    List<DOrderItem> currItems = [...state.items];

    for (final newItem in items) {
      if (currItems.any((i) => i.item.name == newItem.item.name)) {
        currItems.firstWhere((i) => i.item.name == newItem.item.name).quantity += newItem.quantity;
      } else {
        currItems.add(newItem);
      }
    }

    var newComanda = DComanda(orderNumber, currItems);
    state = newComanda;
  }
}

final comandaProvider =
    StateNotifierProvider<ComandaNotifier, DComanda>(
        (ref) => ComandaNotifier());
