import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuPreselectNotifier extends StateNotifier<List<DOrderItem>> {
  MenuPreselectNotifier() : super([]);

  void clear() {
    state = [];
  }

  void addItem(DProduct item) {
    if (state.any((i) => i.item.name == item.name)) {
      var orderItem = state.firstWhere((i) => i.item.name == item.name);
      orderItem.quantity += 1;
      state = [...(state.where((i) => i.item.name != item.name)), orderItem];
    } else {
      state = [...state, DOrderItem(item, 1)];
    }
  }
}

final menuPreselectProvider =
    StateNotifierProvider<MenuPreselectNotifier, List<DOrderItem>>(
        (ref) => MenuPreselectNotifier());
